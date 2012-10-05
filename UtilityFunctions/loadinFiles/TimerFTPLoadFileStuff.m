
%	This is for the ill-fated FTP timer 
%	NOT WORKING AT THE MOMENT !!!

Old_Dir=pwd;
cd(FTPDir);

% CurrentUseAx=get(UseStimAxes,'Value');

if CurrentUseAx==1, CurrentUseAx=handles.axes7;else CurrentUseAx=[];end

CurrentFile=FTPFileName;

             eval(['TemporaryStruct = mrdr(''-s 1001'',''800'',''-d'',''',CurrentFile,''');']);
             TemporaryStruct=TemporaryStruct(2:(end-1));
             eval([CurrentFile '.Trials=TemporaryStruct; clear TemporaryStruct;']); 
             eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials;end']);
             if isfield(handles,CurrentFile)
             loadedNames{1}=CurrentFile;
              KlugeTheTrials;        

              if isempty(CurrentUseAx)
%      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''');']);
%               else      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx);']);
    eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,CurrentSacOptions);']);
              else      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx,CurrentSacOptions);']);
              end

              eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
              fprintf('%s\n',['Completed one   ' CurrentAnalysisFile ]);

             else fprintf('%s\n','******************No Trials structure here*****************');
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
    end    
    
    clear loadedNames;
    
     guidata(hObject,handles);
cd(Old_Dir);