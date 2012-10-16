function handles = FTPLoadFileStuff(handles)
	%	This script handles file-loadign after FTP
	%	Lots of similarities to LoadFileCallbackStuff, probably can be merged at some point...

	Old_Dir=pwd;
	cd(handles.FTPLocalDir);
	CurrentFile=[handles.FTP.filename];
	currentAnalysisFx = getCurrentAnalysisFx(handles);

	TemporaryStruct = mrdr('-s 1001','800','-d',CurrentFile);
	if ~isempty(TemporaryStruct)
		TemporaryStruct=TemporaryStruct(2:(end-1));
		handles.(CurrentFile).Trials = TemporaryStruct;
		clear TemporaryStruct;
		loadedNames{1}=CurrentFile;
		KlugeTheTrials;
		% eval(['ResultVariables_old=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);  %this 0 is legacy from currentuseax
		ResultVariables = feval(currentAnalysisFx, handles.(CurrentFile).Trials, CurrentFile, 0, handles.SaccadeOptions);  %this 0 is legacy from currentuseax
		% keyboard;
		% ResultVariables = eval(CurrentAnalysisFile)(handles.(CurrentFile).Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);  %this 0 is legacy from currentuseax
		handles.(CurrentFile).Analysis=ResultVariables;
		MyVariableList=ResultVariables.MyVariableList;
		handles = SetVariables(handles, CurrentFile);
		fprintf('%s\n',['Completed one   ' CurrentAnalysisFile ]);
	else
		fprintf('%s\n','******************No Trials structure here*****************');
	end
	
	LoadedFileNames=get(handles.LoadedFiles,'string');
	if ~iscell(LoadedFileNames) & ~strcmp(LoadedFileNames,'LoadedFiles')
		TemporaryStuff{1}=LoadedFileNames;
		LoadedFileNames=TemporaryStuff;
	end

	if exist('loadedNames','var')
		if ~iscell(LoadedFileNames)
			set(handles.LoadedFiles,'string',sort(loadedNames));
		else
			NewNames=setdiff(loadedNames,LoadedFileNames);
			set(handles.LoadedFiles,'string',sort([NewNames LoadedFileNames']'));
		end
		WhereIsFile=strcmp(loadedNames{1},get(handles.LoadedFiles,'string'));
		if ~isempty(find(WhereIsFile))
			set(handles.LoadedFiles,'value',find(WhereIsFile));
		end
	end

	% clear loadedNames;

	% guidata(hObject,handles);
	cd(Old_Dir);
end

function currentAnalysisFx = getCurrentAnalysisFx(handles)
	
	AnalysisFiles=get(handles.AnalysisFile,'string');
	AnalysisFileValue=get(handles.AnalysisFile,'value');
	if iscell(AnalysisFiles)
		currentAnalysisFile=AnalysisFiles{AnalysisFileValue};
	else
		currentAnalysisFile=AnalysisFiles;
	end
	% CurrentAnalysisFile=CurrentAnalysisFile(1:(end-2));
	[pathjunk, currentAnalysisFile] = fileparts(currentAnalysisFile);
	currentAnalysisFx = str2func(currentAnalysisFile);
	
end