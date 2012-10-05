
% This script gets the latency

SigLevel=.05;

%mostly out of BaseCorrect.m

    BaselineWindowVector=handles.BaselineWindow;

    BaselineSpikeMat=CountSpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),BaselineWindowVector, CurrentUnitNumber, CurrentAnalogCorrect );
    BaseRate=nanmean(BaselineSpikeMat)*1000/(BaselineWindowVector(2)-BaselineWindowVector(1));

    if BaseRate==0, fprintf('%s\n','baseline is zero'); keyboard;end
    
% end base correct

ExpectedNumber=BaseRate*(CurrentBinWidth/1000)*length(find(TotalFilter));  %this is the expected number of spikes, added across all trials
SigLargerNumber=poissinv(1-SigLevel,ExpectedNumber);

        NumSpikesVector=nansum(SRMat);  %SRMat comes from PlotPSTH
GreaterThanExpected=NumSpikesVector>=ExpectedNumber & PlotXVector >= CurrentLatInit;
LatBin=min(find(  sum( [GreaterThanExpected(1:(end-2)) ; GreaterThanExpected(2:(end-1)); GreaterThanExpected(3:end)] ) == 3 ));
