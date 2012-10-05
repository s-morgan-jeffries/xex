%Analtuningcurve is trying to do the population analysis in imagemap form

discretizeXes;

eval(['UniqueX=unique(' CurrentXAxisVariableStr '(~isnan(' CurrentXAxisVariableStr ')));']);
eval(['UniqueY=unique(' CurrentX1AxisVariableStr '(~isnan(' CurrentX1AxisVariableStr ')));']);
SpikeCount=nan*ones(length(UniqueY),length(UniqueX));
OverNumTrials=SpikeCount;

SpikeRate=SpikeCount;



PlotX=YMeasure;

FilterHere=1;
TotalFilter=FilterHere&CurrentFilterVector;
if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;

for Runner=1:length(UniqueX)
    CurrentSet=find(CurrentXAxisVariable==UniqueX(Runner) & TotalFilter);
    for Runner1=1:length(UniqueY)
        CurrentSet=find(CurrentYAxisVariable==UniqueY(Runner1) & TotalFilter);
        eval(['FindResult=find(' CurrentXAxisVariableStr '==UniqueX(Runner) & ' CurrentX1AxisVariableStr '== UniqueY(Runner1) &TotalFilter);']);
        eval(['SpikeMat=CountSpikes(Trials,RFTrialIndex(FindResult),' CurrentAlignString '(FindResult),TimeWindowVector,CurrentUnitNumber, CurrentAnalogCorrect);']); %keyboard;
        SpikeRate(Runner1,Runner)=nanmean(SpikeMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
        SpikeCount(Runner1,Runner)=nansum(SpikeMat); %total number of spikes in window across trials
        TempCount=nan*SpikeMat;
        TempCount(~isnan(SpikeMat))=1;
        OverNumTrials(Runner1,Runner)=nansum(TempCount); %trick to find number of ~isnans
        if OverNumTrials(Runner1,Runner)==0, SpikeRate(Runner1,Runner)=NaN; SpikeCount(Runner1,Runner)=NaN;end
    end
end
BaselineWindowVector=BFR;
ExpNumSpikes= BFR * OverNumTrials * ( TimeWindowVector(2) - TimeWindowVector(1) ) / 1000;
YMat=repmat(UniqueY',1,length(UniqueX));
XMat=repmat(UniqueX,length(UniqueY),1);

end


ShiftX=[-40:5:40];
ShiftY=[-40:5:40];
ShiftRFCenter=nan*ones(length(ShiftX),length(ShiftY)); %center 0,0 will be 11,11

RFxLocation=XMat(find(XMat==RFxFilt));
RFyLocation=YMat(find(YMat==RFyFilt));


% PlotY=YMeasure;
% PlotStd=YSem;