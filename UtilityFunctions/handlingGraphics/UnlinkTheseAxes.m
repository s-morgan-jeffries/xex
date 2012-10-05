

set(handles.HandlesList(AxisNum),'buttondownfcn','','xgrid','off','ygrid','off','nextplot','replace');  %nextplot should act like hold, ithink

for tempind=1:length(AxisNum)
setappdata(handles.HandlesList(AxisNum(tempind)),'NumClicks',1);

setappdata(handles.HandlesList(AxisNum(tempind)),'CurrentPointPlots',[]);

setappdata(handles.HandlesList(AxisNum(tempind)),'CurrentRect',[]);
eval(['makeInvisible(handles.AxisLinkText' num2str(AxisNum(tempind)) ');']);
end

