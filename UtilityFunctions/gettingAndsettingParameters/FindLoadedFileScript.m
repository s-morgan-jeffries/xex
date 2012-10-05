 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};

 if ~strcmp(CurrentDataFile,'LoadedFiles')

eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);

if ~iscell(MyVariableList), TemporaryVariable{1}=MyVariableList; MyVariableList=TemporaryVariable; clear TemporaryVariable; end

SetVariablesScript;

 end
