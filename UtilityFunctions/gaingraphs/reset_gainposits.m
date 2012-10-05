
%	This scriptlet is used in to change layouts to say GainGraph or SixGraph

opos=getappdata(0,'oposits');

set(handles.axes1,'position',opos{1});
set(handles.axes2,'position',opos{2});
set(handles.axes3,'position',opos{3});
set(handles.axes4,'position',opos{4});
set(handles.axes5,'position',opos{5});
set(handles.axes6,'position',opos{6});
set(handles.axes7,'position',opos{7});
set(handles.axes8,'position',opos{8});
set(handles.axes9,'position',opos{9});


set(handles.Axis1Indicator,'string',opos{11});
set(handles.Axis2Indicator,'position',opos{12});
set(handles.Axis3Indicator,'position',opos{14});
set(handles.Axis4Indicator,'string',opos{17});
set(handles.Axis5Indicator,'position',opos{18});
set(handles.Axis6Indicator,'position',opos{20});
set(handles.Axis7Indicator,'position',opos{22});
set(handles.Axis8Indicator,'string',opos{25});
set(handles.Axis9Indicator,'position',opos{26});

clear opos;