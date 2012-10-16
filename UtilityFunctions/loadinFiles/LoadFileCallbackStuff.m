function handles = LoadFileCallbackStuff(handles)
	%	This file handles file loading, from GUI.

	Old_Dir=pwd;
	if ~exist('DataDirectory','var'), 
		DataDirectory=[matlabroot filesep 'work'];
	end
	cd(handles.LastSelectedDirectory);

	% Pick a file (or multiple file?)
	[input_filename, input_pathname] = uigetfile( ...
		{'*.mat;*A','Data-files (*.mat *A)'; ...
		'*A;*E','A/E files';...
		'*.*',  'All Files (*.*)'}, ...
		'Pick a Trials file', ...
		'MultiSelect', 'on');

	%%loading the files
	if ~isnumeric(input_filename)
		if ~iscell(input_filename)
			% TemporaryStuff{1}=input_filename;
			% input_filename=TemporaryStuff;
			input_filename = {input_filename};
		end

		NumLoads=0;
		AnalysisFiles=get(handles.AnalysisFile,'string');
		AnalysisFileValue=get(handles.AnalysisFile,'value');
		if iscell(AnalysisFiles)
			CurrentAnalysisFile=AnalysisFiles{AnalysisFileValue};
		else
			CurrentAnalysisFile=AnalysisFiles;
		end
		CurrentAnalysisFile=CurrentAnalysisFile(1:(end-2));

		cd(input_pathname);
		handles.LastSelectedDirectory=input_pathname;

		for load_index=1:length(input_filename)
			CurrentFile=input_filename{load_index};
			% If it's a mat file
			if ~isempty(strfind(CurrentFile,'.mat'))
				CurrentFile=CurrentFile(1:(end-4));
				eval([CurrentFile '= load(''' CurrentFile '.mat'');']);
				eval([CurrentFile '.Trials=' CurrentFile '.Trials(2:(end-1));']);
				eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials; handles.' CurrentFile '.FileName=''' [input_pathname input_filename{load_index}] ''';end']); 
				if isfield(handles,CurrentFile)
					NumLoads=NumLoads+1;
					loadedNames{NumLoads}=CurrentFile;
					KlugeTheTrials;          
					%now doing the current analysis and printing out the results
					eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);
					eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
					fprintf('%s\n',['Completed one   ' CurrentAnalysisFile ]);

				else
					fprintf('%s\n','******************No Trials structure here*****************');
				end
			% If it's an A or E file (although if you select both, it looks like it will process them twice)
			elseif (CurrentFile(end)=='A'|CurrentFile(end)=='E')
				CurrentFile=CurrentFile(1:(end-1));
				eval(['TemporaryStruct = mrdr(''-s 1001'',''800'',''-d'',''',CurrentFile,''');']);
				TemporaryStruct=TemporaryStruct(2:(end-1));
				if length(TemporaryStruct)>0
					eval([CurrentFile '.Trials=TemporaryStruct; clear TemporaryStruct;']); 
					eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials; handles.' CurrentFile '.FileName=''' [input_pathname input_filename{load_index}] ''';end']); 
					if isfield(handles,CurrentFile)
						NumLoads=NumLoads+1;
						loadedNames{NumLoads}=CurrentFile;
						KlugeTheTrials;        
						eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);
						eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
						fprintf('%s\n',['Completed one   ' CurrentAnalysisFile ]);
					else
						fprintf('%s\n','Nothing here');
					end
				else
					fprintf('%s\n','******************No Trials structure here*****************');
				end
			end
		end
		fprintf('%s\n',['loaded ' num2str(NumLoads) ' trials structures']);
		fprintf('%s\n','****************************************************');
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
		clear loadedNames;
		handles = AnalLoadedFile(handles);
		% guidata(hObject,handles);
	end %ending the ~isnumeric loop
	cd(Old_Dir);
end