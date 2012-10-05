
%	This script handles file-loadign after FTP
%	Lots of similarities to LoadFileCallbackStuff, probably can be merged at some point...

Old_Dir=pwd;
cd(FTPDir);
% CurrentUseAx=get(handles.UseStimAxes,'Value');
% if CurrentUseAx==1, CurrentUseAx=handles.axes7;else CurrentUseAx=[];end
  CurrentFile=[handles.FTP.filename];

    AnalysisFiles=get(handles.AnalysisFile,'string');
    AnalysisFileValue=get(handles.AnalysisFile,'value');
    if iscell(AnalysisFiles)
    CurrentAnalysisFile=AnalysisFiles{AnalysisFileValue};
    else
        CurrentAnalysisFile=AnalysisFiles;
    end
    CurrentAnalysisFile=CurrentAnalysisFile(1:(end-2));
             
             eval(['TemporaryStruct = mrdr(''-s 1001'',''800'',''-d'',''',CurrentFile,''');']);
             TemporaryStruct=TemporaryStruct(2:(end-1));
             eval([CurrentFile '.Trials=TemporaryStruct; clear TemporaryStruct;']); 
             eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials;end']);
             if isfield(handles,CurrentFile)
             loadedNames{1}=CurrentFile;
              KlugeTheTrials;        

%               if isempty(CurrentUseAx)
%      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''');']);
%               else      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx);']);
    eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);  %this 0 is legacy from currentuseax
%               else   
% eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx,handles.SaccadeOptions);']);
%               end

              eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
              
              MyVariableList=ResultVariables.MyVariableList;
         
   SetVariablesScript;              
              
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
    
    WhereIsFile=strcmp(loadedNames{1},get(handles.LoadedFiles,'string'));
  if ~isempty(find(WhereIsFile)),  set(handles.LoadedFiles,'value',find(WhereIsFile)); end
    
    end    
        
    clear loadedNames;
    
     guidata(hObject,handles);
cd(Old_Dir);