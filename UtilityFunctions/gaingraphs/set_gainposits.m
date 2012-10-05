
%	This scriptlet is used in to change layouts to say GainGraph or SixGraph

opos{1}=get(handles.axes1,'position');
opos{2}=get(handles.axes2,'position');
opos{3}=get(handles.axes3,'position');
opos{4}=get(handles.axes4,'position');
opos{5}=get(handles.axes5,'position');
opos{6}=get(handles.axes6,'position');
opos{7}=get(handles.axes7,'position');
opos{8}=get(handles.axes8,'position');
opos{9}=get(handles.axes9,'position');

opos{10}=get(handles.Axis1Indicator,'position');
opos{11}=get(handles.Axis1Indicator,'string');
opos{12}=get(handles.Axis2Indicator,'position');
opos{13}=get(handles.Axis2Indicator,'string');
opos{14}=get(handles.Axis3Indicator,'position');
opos{15}=get(handles.Axis3Indicator,'string');
opos{16}=get(handles.Axis4Indicator,'position');
opos{17}=get(handles.Axis4Indicator,'string');
opos{18}=get(handles.Axis5Indicator,'position');
opos{19}=get(handles.Axis5Indicator,'string');
opos{20}=get(handles.Axis6Indicator,'position');
opos{21}=get(handles.Axis6Indicator,'string');
opos{22}=get(handles.Axis7Indicator,'position');
opos{23}=get(handles.Axis7Indicator,'string');
opos{24}=get(handles.Axis8Indicator,'position');
opos{25}=get(handles.Axis8Indicator,'string');
opos{26}=get(handles.Axis9Indicator,'position');
opos{27}=get(handles.Axis9Indicator,'string');

setappdata(0,'oposits',opos);

load gain_posits;

set(handles.axes1,'position',pos1);
set(handles.axes2,'position',pos2);
set(handles.axes3,'position',pos3);
set(handles.axes4,'position',pos4);
set(handles.axes5,'position',pos5);
set(handles.axes6,'position',pos6);
set(handles.axes7,'position',pos7);
set(handles.axes8,'position',pos8);
set(handles.axes9,'position',pos9);
clear pos1 pos2 pos3 pos4 pos5 pos6 pos7 pos8 pos9

load gaintxt_posits

set(handles.Axis2Indicator,'position',pos2);
set(handles.Axis3Indicator,'position',pos3);
set(handles.Axis5Indicator,'position',pos5);
set(handles.Axis6Indicator,'position',pos6);
set(handles.Axis7Indicator,'position',pos7);
set(handles.Axis9Indicator,'position',pos9);

set(handles.Axis1Indicator,'string','');
set(handles.Axis4Indicator,'string','');
set(handles.Axis8Indicator,'string','');

clear pos2 pos3 pos5 pos6 pos7 pos9
