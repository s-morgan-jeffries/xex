%	Script that plots spike-densities
%	See also: PlotPSTH

AnalPSTD;

    if size(SRMat,1)>0

   if length(find(TotalFilter))>1, 

       TemporaryHandle(1)=plot(TemPlotX,PlotY,'k-'); hold on;
if CurrentPlotCB==1,
    TemporaryHandle(2)=plot(TemPlotX,PlotY+2*spikeSD,'k-');
        TemporaryHandle(3)=plot(TemPlotX,PlotY-2*spikeSD,'k-');
end    
     
        
    if CurrentPlotLatency==1,

            SRMat=BinSpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),XVector, CurrentUnitNumber, CurrentAnalogCorrect );

        getLatency;  %returns bin with latency, if it exists
                             %REDO WITH DENSITY

    if ~isempty(LatBin)
          
            LatBin=min(find(TemPlotX>=XVector(LatBin)));
        TemporaryHandle(length(TemporaryHandle)+1)=plot(TemPlotX(LatBin),PlotY(LatBin),'o');
        TellMe('%s\n',['Latency is ' num2str(TemPlotX(LatBin)) ' ms'],handles.SpeakToMe);
        else TellMe('%s\n','Latency not found',handles.SpeakToMe);
    end
    end
   
   else TemporaryHandle=plot(nan,nan);
   end
   
    else  TemporaryHandle=plot(nan,nan);
   end
   
        fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);

    set(gca,'box','off','tickdir','out','xlim',[min(XVector) max(PlotXVector)]);
    set(TemporaryHandle(1),'linewidth',2);
    
 %putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);
handles.AxisVariable(CurrentAxisNumber).XAxis='Time';
handles.AxisVariable(CurrentAxisNumber).YAxis='SpikeRate';
