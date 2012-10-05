
function CurrentVariables=QuickAnalysis(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes trials for a quick analysis
%	CurrentVariables=QuickAnalysis(Trials,klugestring,UseAx,SacOpts)


MyVariableList={'numTrials','numGoodTrials','numPhotoBad','unitNumbers','FPx','FPy','RFx','RFy'};
MyResponseVariableList={'GoodTrial'};

numTrials=length(Trials);
numGoodTrials=0;
numPhotoBad=0;

unitNumbers=[];

FPx=nan*ones(1,numTrials); FPy=FPx;

RFx=repmat(FPx,1,10);
RFy=RFx;
RFIndex=1;

for ind=1:length(Trials)
    CurrentEvents=Trials(ind).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
    
    if ~isempty(find(CurrentCodes==1012)) numGoodTrials=numGoodTrials+1;end
    if ~isempty(find(CurrentCodes==1092)) numPhotoBad=numPhotoBad+1;end
    
        
    uni=[Trials(ind).Units];
    if ~isempty(uni)
        curcodes=[uni.Code];
        unitNumbers=union(unitNumbers,curcodes);
    end
 
    is_rf=find(CurrentCodes==1007);

    if ~isempty(is_rf), 
        
         for TempVar=1:length(is_rf) 
            
          RFOnTime=CurrentTimes(is_rf(TempVar));
          %assuming max of 100 ms duration & min of 100 ms ISI

                 FindResult=find(abs(CurrentTimes-RFOnTime)<5 & CurrentCodes<=6850&CurrentCodes>=5650);

%           FindResult=find(CurrentCodes>6250 & CurrentCodes<6750 & (CurrentTimes-RFOnTime)==0);
          if length(FindResult)>=2, RFx(RFIndex)=(CurrentCodes(FindResult(1))-6000)/10; RFy(RFIndex)=(CurrentCodes(FindResult(2))-6500)/10;          end
%           FindResult=find(CurrentCodes<6250 & CurrentCodes>5750 & (CurrentTimes-RFOnTime)==0 );
%           if length(FindResult)~=0, end
          RFIndex=RFIndex+1;
%              if RFIndex==2, keyboard;end
         end

    end
    
    
    
    is_fp=find(CurrentCodes==1003);
    if ~isempty(is_fp)
        XCode=find(CurrentCodes>=10700);
        if length(XCode)>=4   %have changes this to 4. remember that some earlier codes have only 3, as one drop was missing (2nd i think). could shift 3 and 4 to 2 and 3 in that case, but havent done that yet ! WATCH OUT
            FPx(ind)=(CurrentCodes(XCode(3))-11000)/10;
            FPy(ind)=(CurrentCodes(XCode(4))-11000)/10;
        end
    end

%     if(FPx(ind)~=0), keyboard;end

end

summaryString=[sprintf('%s\n','***********Analysis****************')];
summaryString=[summaryString sprintf('%s\t%d\n','Number of Trials=',numTrials)];
summaryString=[summaryString sprintf('%s\t%d\n','Number of Good Trials=',numGoodTrials)];
summaryString=[summaryString sprintf('%s\t%d\n','Number of Photobads=',numPhotoBad)];
summaryString=[summaryString sprintf('%s\n',['Unique Unit Numbers are    ' num2str(unique(unitNumbers))])];
if exist('UseAx','var')&&UseAx~=0, axes(UseAx); 
    plot(RFx,RFy,'bo');
end

FPmat=[FPx;FPy]';
FPmat=FPmat(~isnan(FPx),:);
FPmat=unique(FPmat,'rows');
if length(FPmat)<10
    summaryString=[summaryString sprintf('%s\n','FPx     FPy')];
    for ii=1:size(FPmat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([FPmat(ii,1) FPmat(ii,2)],'%6.2f'))];
    end
    summaryString=[summaryString sprintf('%s\n','********')];
end


RFmat=[RFx;RFy]';
RFmat=unique(RFmat,'rows');
if length(RFmat)<10
    summaryString=[summaryString sprintf('%s\n','RFx     RFy')];
    for ii=1:size(RFmat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([RFmat(ii,1) RFmat(ii,2)],'%6.2f'))];
    end
end


fprintf('%s\n',summaryString);
attachvars;