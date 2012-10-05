
%Script to do analysis for PlotPSTD; callable outside Xex

FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
%         TemPlotX=(XVector(1)-2*CurrentBinWidth):1:(XVector(end)+2*CurrentBinWidth);
        TemPlotX=XVector(1):1:XVector(end);

    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;
    SRMat=BinSpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),TemPlotX, CurrentUnitNumber, CurrentAnalogCorrect );  %1ms binning
    
    if strcmp(CurrentErrorBarType,'ChangeErrorToBootstrap'), errtype=1;  %fprintf('%s\n','Poisson error'); %poisson error
    else errtype=2;% fprintf('%s\n','Bootstrap error');
    end
    
    if size(SRMat,1)>0
    [spikesOut,spikeSD,gaus]=SpikeDensityFunction(SRMat,CurrentBinWidth,1,errtype)  ; %CurrentBinWidth is doing double duty as gaussian sigma
    
    %now need to restrict to valid region; by only taking region from
    %length(gaus) to length(spikesOut), and then shifting PlotX by half the
    %length of gaus backwards

    PlotY=spikesOut(length(gaus): (length(spikesOut) - length(gaus) + 1) );
    spikeSD=spikeSD(length(gaus):(length(spikeSD) - length(gaus) + 1));
    TempLenVar=ceil(length(gaus)/2+0.25);
    TemPlotX=TemPlotX( TempLenVar : ( TempLenVar + length(PlotY) -1 ) ); 
    
      PlotX=TemPlotX;
      PlotN=length(find(TotalFilter));
      PlotStd=spikeSD;
    else
        PlotX=nan;
        PlotN=nan;
        PlotY=nan;
        PlotStd=nan;
    end