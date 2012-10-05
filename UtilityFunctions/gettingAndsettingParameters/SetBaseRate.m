detachvars;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector

setAlignTime;
evalAlignTime;

FilterHere=1;
TotalFilter=1&CurrentFilterVector;
BaseCorrect; %This outputs something called Baserate, which contains the necessary value

handles.BaselineFiringRate=BaseRate;
fprintf('BFR= %6.2f Hz\n',BaseRate);
