
%takes care of edit window positioning


CurEditPos=get(handles.AxisObj1,'Position');
CurEditWidth=CurEditPos(3);
CurEditHeight=CurEditPos(4);

CurLinkTextPos=get(handles.AxisLinkText1,'Position');
CurLinkTextWidth=CurLinkTextPos(3);
CurLinkTextHeight=CurLinkTextPos(4);


evalString='';

for TemporaryVariable=1:handles.NumberOfAxes
        TemporaryVariableString=num2str(TemporaryVariable);
        evalString=[evalString...
        'CurPos=get(handles.axes' TemporaryVariableString ',''Position'');'...
        'set(handles.AxisObj' TemporaryVariableString ',''Position'',[CurPos(1)+CurPos(3)-CurEditWidth,CurPos(2)+CurPos(4),CurEditWidth,CurEditHeight]);'...
        'set(handles.AxisLinkText' TemporaryVariableString ',''Position'',[CurPos(1)+CurPos(3) CurPos(2)+CurPos(4) CurLinkTextWidth CurLinkTextHeight]);'...
        ];
end  

         eval(evalString);
