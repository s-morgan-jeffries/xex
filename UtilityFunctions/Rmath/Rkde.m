
function [xvals,xsmooth,upC,lowC]=Rkde(x,xvals,alpha,type)

%	function to carry out kde analysis in R
%    if R hasnt been started, starts it. based judgement on RPROCESSHANDLE global variable
%	[xvals,xsmooth,upC,lowC]=Rkde(x,xvals,alpha,type)


global RPROCESSHANDLE;

if isempty(RPROCESSHANDLE), 
    fprintf('%s\n','Starting R first using startR');
    startR(1);
    startedR=1;
else startedR=0;
end

Nanlen=length(find(isnan(x)));
Oldx=x;
x=x(~isnan(x));
NormFactor=length(x)/length(Oldx);

setinR('x',x);
setinR('xvals',xvals);
% keyboard;

evalinR([...
    'x=as.vector(x);'...
    'xvals=as.vector(xvals);'...
]);

switch(type),
    case 'locfit',
        fprintf('Smoothing alpha is %2.2f\n',alpha);
        
evalinR([...
    'library(locfit);'...
    'y=locfit(~x,alpha=' num2str(alpha) ',family=''dens'');'...
    'yp=predict(y,xvals,se.fit=T);'...
    'pred=as.vector(yp$fit);'...
    'predse=as.vector(yp$se.fit);'...
    'temp=!(is.nan(pred)|is.nan(predse));'...
    'pred=pred[temp];'...
    'predse=predse[temp];'...
    'xvals=xvals[temp];'...
    ]);

    xsmooth=getfromR('pred');
    upC=exp( log(xsmooth) + 2*getfromR('predse') );
    lowC=exp(log(xsmooth) - 2*getfromR('predse'));
    xvals=getfromR('xvals');
%     keyboard;
    
    case 'sm',
        
        fprintf('SD of kernel is %6.2f\n',alpha*(max(xvals)-min(xvals))/20);
        
evalinR([...
    'library(sm);'...
    'y=sm.density(x,h=' num2str(alpha*(max(xvals)-min(xvals))/20) ',display=''none'',eval.points=xvals);'...
    'pred=as.vector(y$estimate);'...
    'upperc=as.vector(y$upper);'...
    'lowerc=as.vector(y$lower);'...
    'temp=!(is.nan(pred)|is.nan(upperc)|is.nan(lowerc));'...
    'pred=pred[temp];'...
    'upperc=upperc[temp];'...
    'lowerc=lowerc[temp];'...
        'xvals=xvals[temp];'...
    ]);

     xsmooth=getfromR('pred');
upC=getfromR('upperc');
lowC=getfromR('lowerc');
    xvals=getfromR('xvals');

end

% if startedR==1, endR;end

xsmooth=NormFactor*xsmooth;
upC=NormFactor*upC;
lowC=NormFactor*lowC;
if NormFactor~=1, fprintf('%s\n','Dubious CI correction here');end