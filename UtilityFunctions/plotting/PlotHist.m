
%	Plots histograms

    FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
    
    eval(['CurrentSelectedVals=' CurrentSelectedVariable ';']);
    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentSelectedVals)));end;
    fprintf('%s\n',['Histogramming  ' CurrentSelectedVariable]);
   

    PlotY=CurrentSelectedVals(TotalFilter);
if ~isempty(PlotXVector)    
    [n,i]=hist(PlotY,PlotXVector);
else
    [n,i]=hist(PlotY);
    fprintf('%s\n','Using default binning');
end

    TemporaryHandle=plot(i,n./sum(n),'k-');
    
    fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);
     
    if ~isempty(PlotXVector)&~isempty(XVector)
    set(gca,'box','off','tickdir','out','xlim',[min(XVector) max(PlotXVector)]);
    else
    set(gca,'box','off','tickdir','out');
        
    end
    set(TemporaryHandle,'linewidth',2);
% keyboard;

%putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);

if ~isempty(strfind(CurrentXAxisVariableStr,'Discretized')), XAxisVar=CurrentXAxisVariableStr(12:end);else XAxisVar=CurrentXAxisVariableStr;end
handles.AxisVariable(CurrentAxisNumber).XAxis=XAxisVar;
handles.AxisVariable(CurrentAxisNumber).YAxis='Undefined';