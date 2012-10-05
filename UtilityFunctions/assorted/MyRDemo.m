%	Connecting MATLAB to R 
% 	The statistical programming language R has a COM interface. We can use
% 	this to execute R commands from within MATLAB.
%	This is a demo.

%% Connect to an R Session
openR

%% Push data into R
x=linspace(0,3*pi,1000);
y=3*x+4;
putRdata('x',x)
putRdata('y',y)

evalR('library(stats)')
[k,status,msg]=evalR('z=lm(y~x)')
 
% [sl,status,msg] = getRdata('z')

%% Close the connection
closeR


%     R_lInK_hANdle.SetSymbol(varname,data);
%    data = R_lInK_hANdle.GetSymbol(varname);
%         R_lInK_hANdle.EvaluateNoReturn(command);
%         result = R_lInK_hANdle.Evaluate(command);
%         R_lInK_hANdle = actxserver('StatConnectorSrv.StatConnector');
%         R_lInK_hANdle.Init('R');
%     R_lInK_hANdle.Close;
%   rh=actxserver('RCOMServerLib.StatConnector');