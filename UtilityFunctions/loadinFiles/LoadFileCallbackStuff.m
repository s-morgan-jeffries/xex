
%	This file handles file loading, from GUI.

Old_Dir=pwd;
if ~exist('DataDirectory','var'), 
    DataDirectory=[matlabroot filesep 'work'];
%     DataDirectory='c:\matlab\work\physiology';
end
% cd(DataDirectory);
cd(handles.LastSelectedDirectory);

% CurrentUseAx=get(handles.UseStimAxes,'Value');
% if CurrentUseAx==1, CurrentUseAx=handles.axes7;else CurrentUseAx=[];end
    
   [input_filename, input_pathname] = uigetfile( ...
       {'*.mat;*A','Data-files (*.mat *A)'; ...
       '*A;*E','A/E files';...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a Trials file', ...
        'MultiSelect', 'on');
    
     %%loading the files
        
     if ~isnumeric(input_filename)
         
     if ~iscell(input_filename) TemporaryStuff{1}=input_filename;
     input_filename=TemporaryStuff; 
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
         if ~isempty(strfind(CurrentFile,'.mat'))
             %CurrentFile=input_filename{load_index};
             CurrentFile=CurrentFile(1:(end-4));
             eval([CurrentFile '= load(''' CurrentFile '.mat'');']);
             eval([CurrentFile '.Trials=' CurrentFile '.Trials(2:(end-1));']);
             eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials; handles.' CurrentFile '.FileName=''' [input_pathname input_filename{load_index}] ''';end']); 
             if isfield(handles,CurrentFile)
             NumLoads=NumLoads+1;
             loadedNames{NumLoads}=CurrentFile;
             KlugeTheTrials;          
             %now doing the current analysis and printing out the results

%              if isempty(CurrentUseAx)
     eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);
%              else      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx,handles.SaccadeOptions);']);
%              end
             
                 eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
    fprintf('%s\n',['Completed one   ' CurrentAnalysisFile ]);
             
             else fprintf('%s\n','******************No Trials structure here*****************');
             end
         elseif (CurrentFile(end)=='A'|CurrentFile(end)=='E')
%               try,
             CurrentFile=CurrentFile(1:(end-1));
             eval(['TemporaryStruct = mrdr(''-s 1001'',''800'',''-d'',''',CurrentFile,''');']);
             TemporaryStruct=TemporaryStruct(2:(end-1));
             if length(TemporaryStruct)>0
             eval([CurrentFile '.Trials=TemporaryStruct; clear TemporaryStruct;']); 
%              eval([CurrentFile ' = mrdr(''-s 1001'',''800'',''-d'',' CurrentFile(1:(end-1)),');']);
%              eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials;end']);
             eval(['if isfield(',CurrentFile,',''Trials''),','handles.' CurrentFile '.Trials=' CurrentFile '.Trials; handles.' CurrentFile '.FileName=''' [input_pathname input_filename{load_index}] ''';end']); 

             if isfield(handles,CurrentFile)
             NumLoads=NumLoads+1;
             loadedNames{NumLoads}=CurrentFile;
%               keyboard;
              KlugeTheTrials;        
%               if isempty(CurrentUseAx)
     eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''',0,handles.SaccadeOptions);']);
%               else      eval(['ResultVariables=' CurrentAnalysisFile '(handles.' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx,handles.SaccadeOptions);']);
% 
%               end
                 eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
    fprintf('%s\n',['Completed one   ' CurrentAnalysisFile ]);
 

             else fprintf('%s\n','Nothing here');
             end
    
             else fprintf('%s\n','******************No Trials structure here*****************');
             end
% 
%               catch,
%                   fprintf('%s\n','******** MRDR failed *********');
%              end
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
  if ~isempty(find(WhereIsFile)),  set(handles.LoadedFiles,'value',find(WhereIsFile)); end

    end    
    
    % setappdata(0,'handles',handles);
    clear loadedNames;
    
    AnalLoadedFileScript;

    
     guidata(hObject,handles);
     end %ending the ~isnumeric loop
     cd(Old_Dir);