FilterHere=1;
TotalFilter=1&CurrentFilterVector;

discretizeXes;
eval(['UniqueX=unique(' CurrentXAxisVariableStr '(~isnan(' CurrentXAxisVariableStr ')));']);
eval(['UniqueY=unique(' CurrentX1AxisVariableStr '(~isnan(' CurrentX1AxisVariableStr ')));']);
SpikeCount=nan*ones(length(UniqueY),length(UniqueX));
OverNumTrials=SpikeCount;
SigMat=SpikeCount;
SpikeRate=SpikeCount;
SpikeRateAve=SpikeCount;

for ind=1:length(UniqueX)
    for ind1=1:length(UniqueY)
        eval(['FindResult=find(' CurrentXAxisVariableStr '==UniqueX(ind) & ' CurrentX1AxisVariableStr '== UniqueY(ind1) &TotalFilter);']);
        eval(['SpikeMat=CountSpikes(Trials,RFTrialIndex(FindResult),' CurrentAlignString '(FindResult),TimeWindowVector,CurrentUnitNumber, CurrentAnalogCorrect);']); %keyboard;
       SpikeRate(ind1,ind)=nanmean(SpikeMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
        SpikeCount(ind1,ind)=nansum(SpikeMat); %total number of spikes in window across trials
        TempCount=nan*SpikeMat;
        TempCount(~isnan(SpikeMat))=1;
        OverNumTrials(ind1,ind)=nansum(TempCount); %trick to find number of ~isnans
        if OverNumTrials(ind1,ind)==0, SpikeRate(ind1,ind)=NaN; SpikeCount(ind1,ind)=NaN;end
end
end


if exist('BFR','var'),BaseRate=BFR; else BaseRate=0; fprintf('%s\n','USING DEFAULT BASE RATE OF ZERO. WATCH OUT');end

% if CurrentPlotSig==1,    
    
%    fprintf('P = %2.6f\n',CurrentPValue);
% keyboard;

    ExpNumSpikes= BaseRate * OverNumTrials * ( TimeWindowVector(2) - TimeWindowVector(1) ) / 1000;
    CDFValue = poisscdf(SpikeCount,ExpNumSpikes);
    LowSig = CDFValue < CurrentPValue;
    HighSig= CDFValue > (1-CurrentPValue);
    SigMat(LowSig==1&~isnan(SpikeCount))=1;
    SigMat(HighSig==1&~isnan(SpikeCount))=2;
    
%     NumCols=length(UniqueX);
% keyboard;
    YMat=repmat(UniqueY',1,length(UniqueX));
    XMat=repmat(UniqueX,length(UniqueY),1);
%     end