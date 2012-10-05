
%	Script to plot tuning curves
%	a single variable (IsAngular) decides if angular or normal tuning curves are plotted

AnalTuningCurve;

if IsAngular==0
    if any(~isnan(PlotStd)) && CurrentPlotCB==1
        TemporaryHandle=errorbar(PlotX,PlotY,2*PlotStd);
        set(TemporaryHandle,'color','k','linestyle','-');
    else
TemporaryHandle=plot(PlotX,PlotY,'ko-');
    end
 CurrentPlotType='TuningCurve';
elseif IsAngular==1
    if CurrentHoldStatus~=1,hold off;else hold on; end
TemporaryHandle=polar(PlotX,PlotY,'k-'); hold on;
MaxVal=max(abs([get(gca,'xlim') get(gca,'ylim')]));
set(gca,'xlim',[-1*MaxVal MaxVal],'ylim',[-1*MaxVal MaxVal]);
AngularX=linspace(0,2*pi,100);
plot(MaxVal*cos(AngularX),MaxVal*sin(AngularX),'k-');
plot(MaxVal*cos(AngularX)/2,MaxVal*sin(AngularX)/2,'k-');
plot([0 0],[-1*MaxVal MaxVal],'k--');
plot([-1*MaxVal MaxVal],[0 0],'k--');

 CurrentPlotType='AngularTuningCurve';

end
set(gca,'box','off','tickdir','out');
 set(TemporaryHandle,'linewidth',2);
     fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);

%putting in the xaxis variable name tag for this axis

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);

if ~isempty(strfind(CurrentXAxisVariableStr,'Discretized')), XAxisVar=CurrentXAxisVariableStr(12:end);else XAxisVar=CurrentXAxisVariableStr;end
handles.AxisVariable(CurrentAxisNumber).XAxis=XAxisVar;
handles.AxisVariable(CurrentAxisNumber).YAxis='Undefined';

% if ~isempty(strfind(CurrentX1AxisVariableStr,'Discretized')), X1AxisVar=CurrentX1AxisVariableStr(12:end);else X1AxisVar=CurrentX1AxisVariableStr;end
% handles.AxisVariable(CurrentAxisNumber).YAxis=X1AxisVar;

