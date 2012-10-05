
%	Script to do analysis for PlotPSTH; callable outside Xex

    FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;
    SRMat=BinSpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),XVector, CurrentUnitNumber, CurrentAnalogCorrect );
    PlotY=nanmean(SRMat)*1000/CurrentBinWidth; 
    PlotX=PlotXVector; %introduced april 24 NOtice inconsistency HERE with plotxvector !!!
    PlotN=length(find(TotalFilter)); %scalar value with number of Trials
    PlotStd=nanstd(SRMat)*1000/(CurrentBinWidth*sqrt(PlotN)); %sem of binned psth here