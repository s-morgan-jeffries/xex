    
%FindObjectsToUpdate: this script looks at the AxisObj windows and picks up
%which objects are to be updated, in the axis chosen for updating

%called from Update Slider
%CUStr is available as num2str(CurrentAxis)

evalString=[...
    'if strcmp(get(handles.AxisObj' CUStr ',''visible''),''on''), CurrentObjectsToUpdate=str2num(get(handles.AxisObj' CUStr ',''string''));else CurrentObjectsToUpdate=1:length(CurrentObjects);end'...
    ];

eval(evalString);