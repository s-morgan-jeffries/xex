function handles = AnalLoadedFile(handles)
	LoadedFileList=get(handles.LoadedFiles,'string');
	if ~iscell(LoadedFileList)
		LoadedFileList = {LoadedFileList};
	end
	CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
	CurrentDataFile=LoadedFileList{CurrentValue};

	if ~strcmp(CurrentDataFile,'LoadedFiles')
		if isfield(handles.(CurrentDataFile),'Analysis')
			handles = SetVariables(handles, CurrentDataFile);
		else
			disp('Analyze your dataset first');
		end
	end
end