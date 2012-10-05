
%	This function get the handles.WhatToDo string and then decides on what to show and not show in GUI		
%	WhatToDoStuff

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};
if strcmp(WhatToDo,'MakePlot')
    set(handles.PlotData,'string','MakePlot');
%     set(handles.UseFilters,'value',1);
    set(handles.UseProps,'value',0);
%     makeInvisible(handles.UndoButton);
% elseif strcmp(WhatToDo,'UpdateAxis')
%     set(handles.PlotData,'string','UpdateAxis');
% %     set(handles.UseFilters,'value',0);
%     set(handles.UseProps,'value',0);
%     set(handles.HoldStatus,'value',0);
%     makeVisible(handles.UndoButton);
%     makeInvisible([handles.text70,handles.VariablesList]);
elseif strcmp(WhatToDo,'UpdateCell')
    set(handles.PlotData,'string','UpdateCell');
%     set(handles.UseFilters,'value',0);
    set(handles.UseProps,'value',0);
    set(handles.HoldStatus,'value',0);
%     makeInvisible([handles.UndoButton,handles.text70,handles.VariablesList]);
elseif strcmp(WhatToDo,'ActiveUpdate')
    set(handles.PlotData,'string','Inactive');
        set(handles.UseProps,'value',0);
    set(handles.HoldStatus,'value',0);
    fprintf('%s\n','The slider, binwidth, align type, unitnumber and timewindow elements are now active');
end

