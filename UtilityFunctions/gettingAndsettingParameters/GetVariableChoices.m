
%	This scriptlet parses stuff from EnterAxisVariables
%	Used to set variables for tuning curves, etc.

Xstring=get(handles.XAxisVariable,'string');
Xvalue=get(handles.XAxisVariable,'value');
if iscell(Xstring),MyVariableChoices.XAxisVariable=Xstring{Xvalue};else MyVariableChoices.XAxisVariable=Xstring;end

X1string=get(handles.X1AxisVariable,'string');
X1value=get(handles.X1AxisVariable,'value');
if iscell(X1string),MyVariableChoices.X1AxisVariable=X1string{X1value}; else MyVariableChoices.X1AxisVariable=X1string;end

MyVariableChoices.DiscretizeX=get(handles.DiscretizeX,'value');
MyVariableChoices.DiscretizeX1=get(handles.DiscretizeX1,'value');

MyVariableChoices.XAxisCentersStr=get(handles.XAxisCenters,'string');
MyVariableChoices.X1AxisCentersStr=get(handles.X1AxisCenters,'string');

Ystring=get(handles.YAxisMeasure,'string');
Yvalue=get(handles.YAxisMeasure,'value');
if iscell(Ystring),MyVariableChoices.YAxisMeasureStr=Ystring{Yvalue};else MyVariableChoices.YAxisMeasureStr=Ystring;end