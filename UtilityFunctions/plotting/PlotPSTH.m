
%This function plots the PSTH, after calling AnalPSTH for analysis

AnalPSTH;

    
    if length(find(TotalFilter))>1, 
        TemporaryHandle=plot(PlotXVector(1:(end-1)),PlotY(1:(end-1)),'k-');
          
    if CurrentPlotLatency==1,
        getLatency;  %returns bin with latency, if it exists
%         keyboard;

        if ~isempty(LatBin)
            hold on;
        TemporaryHandle(length(TemporaryHandle)+1)=plot(PlotXVector(LatBin),PlotY(LatBin),'o');
        TellMe('%s\n',['Latency is ' num2str(PlotXVector(LatBin)) ' ms'],handles.SpeakToMe);
        else TellMe('%s\n','Latency not found',handles.SpeakToMe);
        end
    end
   
    else TemporaryHandle=plot(nan,nan);
    end

    fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);
     
    set(gca,'box','off','tickdir','out','xlim',[min(XVector) max(PlotXVector)]);  %XVector and PlotXVector differ by half the binwidth
    set(TemporaryHandle,'linewidth',2);
% keyboard;

%putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);
handles.AxisVariable(CurrentAxisNumber).XAxis='Time';
handles.AxisVariable(CurrentAxisNumber).YAxis='SpikeRate';

fprintf('Binwidth is %d\n',XVector(2)-XVector(1));
