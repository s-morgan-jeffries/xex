
%	This script does the Circle RF Map

FilterHere=1;
TotalFilter=1&CurrentFilterVector;

% UniqueX=unique(RFx(~isnan(RFx)));
% UniqueY=(unique(RFy(~isnan(RFy))));

discretizeXes;
eval(['UniqueX=unique(' CurrentXAxisVariableStr '(~isnan(' CurrentXAxisVariableStr ')));']);
eval(['UniqueY=unique(' CurrentX1AxisVariableStr '(~isnan(' CurrentX1AxisVariableStr ')));']);

AngleVector=linspace(0,2*pi,100);

HandleNumber=1;
NormFactor=10.^(-1*CurrentSliderValue);
    
BaseCorrect;

for ind=1:length(UniqueX)
    for ind1=1:length(UniqueY)
        eval(['FindResult=find(' CurrentXAxisVariableStr '==UniqueX(ind) & ' CurrentX1AxisVariableStr '== UniqueY(ind1) &TotalFilter);']);
        eval(['SpikeMat=CountSpikes(Trials,RFTrialIndex(FindResult),' CurrentAlignString '(FindResult),TimeWindowVector,CurrentUnitNumber, CurrentAnalogCorrect);']);
        SpikeCount=nanmean(SpikeMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
% if handles.BaselineCorrectVar==1,    SpikeCount=(SpikeCount-BaseRate)/BaseRate;end
        TemporaryHandle(HandleNumber)=plot(UniqueX(ind)+(SpikeCount/NormFactor)*cos(AngleVector),UniqueY(ind1)+(SpikeCount/NormFactor)*sin(AngleVector),'k-');
        HandleNumber=HandleNumber+1; hold on;
end
end


% keyboard;

 set(gca,'box','off','tickdir','out','xlim',[-30 30],'ylim',[-30 30]);
 
CurrentPlotType='CircleRF';

%putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);

if ~isempty(strfind(CurrentXAxisVariableStr,'Discretized')), XAxisVar=CurrentXAxisVariableStr(12:end);else XAxisVar=CurrentXAxisVariableStr;end
if ~isempty(strfind(CurrentX1AxisVariableStr,'Discretized')), X1AxisVar=CurrentX1AxisVariableStr(12:end);else X1AxisVar=CurrentX1AxisVariableStr;end

handles.AxisVariable(CurrentAxisNumber).XAxis=XAxisVar;
handles.AxisVariable(CurrentAxisNumber).YAxis=X1AxisVar;