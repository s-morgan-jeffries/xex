
%  Script to plot scatterplots; analysis done by analscatter. Makes it
%  callable outside XeX
%  Also see: AnalScatter, PlotScatter

AnalScatter;

if get(handles.ReverseXY,'value')==1
    OldPlotX=PlotX;
    OldPlotY=PlotY;
    OldXStr=CurrentXAxisVariableStr;
    OldYStr=CurrentYAxisVariableStr;
    PlotX=OldPlotY;
    PlotY=OldPlotX;
    CurrentXAxisVariableStr=OldXStr;
    CurrentYAxisVariableStr=OldYStr;
    fprintf('%s\n','Reversed X and Y');
end

TemporaryHandle=plot(PlotX,PlotY,'ko');
CurrentPlotType='ScatterPlot';
set(gca,'box','off','tickdir','out');
set(TemporaryHandle,'linewidth',1,'markersize',4,'marker','o','linestyle','none');

fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);

if length(find(TotalFilter))>0
[r,p]=corrcoef([PlotX' PlotY'],'rows','complete');
fprintf('Correlation coefficient is %1.4f   and p-value is %1.4f \n',[r(1,2),p(1,2)]); 

if strcmp(CurrentXAxisVariableStr,'RFx')&&strcmp(CurrentYAxisVariableStr,'RFy')
    set(gca,'xlim',[min(PlotX)-5,max(PlotX)+5],'ylim',[min(PlotX)-5,max(PlotX)+5]);
    fprintf('%s\n','Line 33 of ScatterPlotter automatically sets axes if variables are RFx and RFy');
end

end

%I am not sure if this should be done here or in plotscatter, but we will
%see

%putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);
handles.AxisVariable(CurrentAxisNumber).XAxis=CurrentXAxisVariableStr;
handles.AxisVariable(CurrentAxisNumber).YAxis=CurrentYAxisVariableStr;

