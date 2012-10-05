
%	Plots histograms

    FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
    
    eval(['CurrentSelectedVals=' CurrentSelectedVariable ';']);
    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentSelectedVals)));end;
    fprintf('%s\n',['Histogramming  ' CurrentSelectedVariable]);
   
%         set(handles.SliderText,'string',['binwidth=' num2str(InsertBinWidth,'%d\n')]);

    PlotY=CurrentSelectedVals(TotalFilter);
    
    uniquePlotY=un(PlotY);
    numberOfs=nan*uniquePlotY;
    
    for JustInd=1:length(uniquePlotY)
        numberOfs(JustInd)=length(find(PlotY==uniquePlotY(JustInd)));
    end
    
    if any(numberOfs>0)
    TemporaryHandle=bar(uniquePlotY,numberOfs);
            
     
    set(gca,'box','off','tickdir','out','xlim',[min(uniquePlotY) max(uniquePlotY)]);
    
    else
        
   TemporaryHandle=plot(NaN,NaN); %dummy variable, commenting out for now
        
    end
    
%     set(TemporaryHandle,'linewidth',2);
% keyboard;

fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);

%putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);

if ~isempty(strfind(CurrentXAxisVariableStr,'Discretized')), XAxisVar=CurrentXAxisVariableStr(12:end);else XAxisVar=CurrentXAxisVariableStr;end
handles.AxisVariable(CurrentAxisNumber).XAxis=XAxisVar;
handles.AxisVariable(CurrentAxisNumber).YAxis='Undefined';