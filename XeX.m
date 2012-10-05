function varargout = XeX(varargin)
% XEX M-file for XeX.fig
%      XEX, by itself, creates a new XEX or raises the existing
%      singleton*.
%
%      H = XEX returns the handle to a new XEX or the handle to
%      the existing singleton*.
%
%      XEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XEX.M with the given input arguments.
%
%      XEX('Property','Value',...) creates a new XEX or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before XeX_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to XeX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help XeX

% Last Modified by GUIDE v2.5 12-Dec-2006 22:23:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @XeX_OpeningFcn, ...
                   'gui_OutputFcn',  @XeX_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before XeX is made visible.
function XeX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to XeX (see VARARGIN)

XeXDir=which('XeX');
if ~isempty(XeXDir)
handles.XeXDir=XeXDir(1:(end-5));
addpath(genpath(handles.XeXDir),'-begin');
cd(handles.XeXDir);
else
fprintf('%s\n','%Couldnt Find XeX.m on path; assuming XeX lives in current directory and adding it (with subdirectories) to PATH !!');    
handles.XeXDir=pwd;
addpath(genpath(handles.XeXDir),'-begin');
end

handles.NumberOfAxes=12;
handles.AxisVariable=repmat(struct('XAxis','Undefined','YAxis','Undefined'),1,handles.NumberOfAxes); %assuming there are 12 axes; safe, I think, for now.

handles.HandlesList=NaN*[1:handles.NumberOfAxes];
for TemporaryVariable=1:handles.NumberOfAxes
eval(['handles.HandlesList(TemporaryVariable)=handles.axes' num2str(TemporaryVariable) ';']);
end

handles.EditWindows=NaN*[1:handles.NumberOfAxes];
for TemporaryVariable=1:handles.NumberOfAxes
eval(['handles.EditWindows(TemporaryVariable)=handles.AxisObj' num2str(TemporaryVariable) ';']);
end

handles.AxisLinkTexts=NaN*[1:handles.NumberOfAxes];
for TemporaryVariable=1:handles.NumberOfAxes
eval(['handles.AxisLinkTexts(TemporaryVariable)=handles.AxisLinkText' num2str(TemporaryVariable) ';']);
end

if strcmp(get(handles.ShowAllObjWin,'checked'),'on') makeVisible(handles.EditWindows); else makeInvisible(handles.EditWindows);end

makeInvisible([handles.AxisLinkTexts]);

LayOutEditWindow;

handles.CurrentDataDirectory=[matlabroot filesep 'work'];
handles.GraphCommandsDirectory=[matlabroot filesep 'work' filesep 'XeX' filesep 'MyGraphs'];
% handles.CurrentDataDirectory='C:\MATLAB\work\physiology\ziggydata';
% handles.GraphCommandsDirectory='C:\MATLAB\work\XeX\MyGraphs';
handles.SaccadeOptions.Threshold=0.1;
handles.SaccadeOptions.MinLat=0;
handles.SaccadeOptions.ISICut=0;
handles.SaccadeOptions.CorrectCode=1003;
% handles.ShowSignificance=1; 
set(handles.PlotSig,'checked','on');
handles.BaselineWindow=[-50 0];
handles.BaselineFiringRate=NaN;
handles.SpeakToMe=0;
set(handles.SpeakToMeMenu,'checked','off');
setappdata(0,'TrialFilterHandle',(handles.TrialFilterVector));
setappdata(0,'RFLocation',[-15 0]); %default RF
setappdata(0,'XeXGUIHandle',handles.figure1);
% setappdata(0,'UseFilterHandle',handles.UseFilters);
setappdata(0,'UsePlottingHandle',handles.UseProps);
setappdata(0,'HoldFilterHandle',handles.HoldStatus);

% Choose default command line output for XeX
handles.output = hObject;
handles.LatInitTime=0;
handles.SignificanceCutoff=0.05;

handles.LastSelectedDirectory=handles.XeXDir(1:(end-4));

% MyVariableChoices=struct('XAxisVariable','RFx','X1AxisVariable','RFy','YAxisMeasureStr','SpikeRate','DiscretizeX',0,'DiscretizeX1',0,'X1AxisCentersStr','','XAxisCentersStr','','OK',0);
% handles.MyVariableChoices=MyVariableChoices;

set(handles.SpikeTruncate,'checked','on');
set(handles.figure1,'windowstyle','docked');

fprintf('%s\n','*********************************************************************************************');
fprintf('%s\n','Designed to be used with Monitor Resolution Set to 1680 by 1050; 1280 by 1024 appears to work somewhat well too.');
fprintf('%s\n','*********************************************************************************************');


set(gcf,'CloseRequestFcn','fprintf(''%s\n'',''You cannot close XeX like that. Choose Quit'')');

handles.UnitNumber=613;
handles.RFLocation=[15 15];


WhatToDoStuff;
% ShowSlider;
DoUseProps;

Objs=[handles.GetObjectPropsButton, handles.GetObjectAxes, handles.DeleteObjects, handles.MoveObj, handles.CopyObj, handles.text64, handles.text65, handles.text66, handles.ObjectNumber, handles.OldAxis,handles.NewAxis];

if strcmp(get(handles.ManageObjects,'string'), 'ManageObjects'), 
    makeInvisible(Objs);
elseif strcmp(get(handles.ManageObjects,'string'),'HideManager'), 
    makeVisible(Objs);
end

% GetPositions;
% handles.PosArray=PosArray;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes XeX wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = XeX_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SacOpts_Callback(hObject, eventdata, handles)
% hObject    handle to SacOpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'SaccadeOptions'), 
    CurrentThreshold='';
    CurrentMinLat='';
    CurrentISICut='';
    CurrentCorrectCode='';
else
    CurrentThreshold=handles.SaccadeOptions.Threshold;
    CurrentMinLat=handles.SaccadeOptions.MinLat;
    CurrentISICut=handles.SaccadeOptions.ISICut;
    CurrentCorrectCode=handles.SaccadeOptions.CorrectCode;
end
      
   prompt={'Enter Sac Threshold','Enter Min Lat','Enter ISI Cut','Enter Correct Code; use NaN for null'};
   name='Saccade Options ';
   numlines=1;
   defaultanswer={num2str(CurrentThreshold) num2str(CurrentMinLat) num2str(CurrentISICut) num2str(CurrentCorrectCode)};
 
   Answer=inputdlg(prompt,name,numlines,defaultanswer);

   if ~isempty(Answer)
handles.SaccadeOptions.Threshold=str2num(Answer{1});
handles.SaccadeOptions.MinLat=str2num(Answer{2});
handles.SaccadeOptions.ISICut=str2num(Answer{3});
handles.SaccadeOptions.CorrectCode=str2num(Answer{4});
   end

   guidata(hObject,handles);


% --- Executes on selection change in LoadedFiles.
function LoadedFiles_Callback(hObject, eventdata, handles)
% hObject    handle to LoadedFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns LoadedFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LoadedFiles

Contents=cellstr(get(hObject,'String'));
fprintf('You just selected   %s\n',Contents{get(hObject,'Value')});

 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
if ~strcmp(CurrentDataFile,'LoadedFiles')

eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), GoOn=0;else GoOn=1;end']);
eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);
eval(['if GoOn==1, MyResponseVariableList=handles.' CurrentDataFile '.Analysis.MyResponseVariableList;end']);

eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
if GoOn==1, fprintf('%s\n',CurrentVariables.summaryString);end

if GoOn==1,
%     if get(handles.XAxisVariable,'value')>length(MyVariableList), set(handles.XAxisVariable,'value',1);end
%  set(handles.XAxisVariable,'string',MyVariableList);
%     if get(handles.X1AxisVariable,'value')>length(MyVariableList), set(handles.X1AxisVariable,'value',1);end
%  set(handles.X1AxisVariable,'string',MyVariableList);
%     if get(handles.YAxisVariable,'value')>length(MyVariableList), set(handles.YAxisVariable,'value',1);end
%  set(handles.YAxisVariable,'string',{'SpikeRate',MyVariableList{:}}); 

SetVariablesScript;

end

end

% --- Executes during object creation, after setting all properties.
function LoadedFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadedFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'tooltipstring','This is the list of loaded files');
guidata(hObject,handles);
% --- Executes on selection change in AnalysisFile.
function AnalysisFile_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AnalysisFile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalysisFile


% --- Executes during object creation, after setting all properties.
function AnalysisFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalysisFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'tooltipstring',sprintf('This is the list of analysis files: will generate\nvectors of length=number of trials\n that you can then run trial filters on'));
guidata(hObject,handles);

% --- Executes on button press in AnalyzeFile.
function AnalyzeFile_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyzeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LoadedFileList=get(handles.LoadedFiles,'string');
CurrentValues=get(handles.LoadedFiles,'value');
if ~iscell(LoadedFileList), LoadedFileList={LoadedFileList};end

CurrentlyLoadedFiles=LoadedFileList(CurrentValues);
% CurrentUseAx=get(handles.UseStimAxes,'Value');
% if CurrentUseAx==1, CurrentUseAx=handles.axes7;else CurrentUseAx=[];end

if ~strcmp(CurrentlyLoadedFiles{1},'LoadedFiles')
for FileIndex=1:length(CurrentlyLoadedFiles)
    CurrentFile=CurrentlyLoadedFiles{FileIndex};
    
    %Reload files if necessary
    
    eval(['TempStore=handles.' CurrentFile '.Trials;']);
    
    if isnumeric(TempStore) && isnan(TempStore)
        eval(['TempFile=handles.' CurrentFile '.FileName;']);
        
        if strfind(TempFile,'.mat')
            JustLoadedTrials=load(TempFile);
            fprintf('%s\n',['Loaded trials from ' TempFile]);
        else
            try,
             eval(['JustLoadedTrials = mrdr(''-s 1001'',''800'',''-d'',''',TempFile(1:(end-1)),''');']);
             JustLoadedTrials=JustLoadedTrials(2:(end-1));
                         fprintf('%s\n',['Loaded trials from ' TempFile]);
            catch,
                fprintf('%s\n','mrdr failed !!!!!!!!!!!!');
             end
        end
        
                if length(JustLoadedTrials)>0     eval([CurrentFile ' .Trials=JustLoadedTrials;']); clear JustLoadedTrials; end
    
    else
           eval([CurrentFile '.Trials=handles.' CurrentFile '.Trials;']);
    end
    
    AnalysisFiles=get(handles.AnalysisFile,'string');
    AnalysisFileValue=get(handles.AnalysisFile,'value');
    CurrentAnalysisFile=AnalysisFiles{AnalysisFileValue};

    CurrentAnalysisFile=CurrentAnalysisFile(1:(end-2));
%     if ~isempty(CurrentUseAx)
%     eval(['ResultVariables=' CurrentAnalysisFile '(' CurrentFile '.Trials,''' CurrentFile ''', CurrentUseAx, handles.SaccadeOptions);']);
% else
     eval(['ResultVariables=' CurrentAnalysisFile '(' CurrentFile '.Trials,''' CurrentFile ''', 0, handles.SaccadeOptions);']);
%     end

                 eval(['handles.' CurrentFile '.Analysis=ResultVariables;']);
                 MyVariableList=ResultVariables.MyVariableList;
                 
%                  set(handles.XAxisVariable,'value',1);
%                  set(handles.XAxisVariable,'string',ResultVariables.MyVariableList);
%                                   set(handles.X1AxisVariable,'value',1);
%                  set(handles.X1AxisVariable,'string',ResultVariables.MyVariableList);
%                  set(handles.YAxisVariable,'value',1);
%                  set(handles.YAxisVariable,'string',{'SpikeRate',ResultVariables.MyVariableList{:}});

                 
    TellMe('%s\n',['Completed one   ' CurrentAnalysisFile ],handles.SpeakToMe);
    
end

AnalLoadedFileScript;

else TellMe('%s\n','Load a file first !',handles.SpeakToMe);
end

% ShowSlider;

% eval(['clear ' CurrentFile]);

guidata(hObject,handles);

% --- Executes on button press in HoldStatus.
function HoldStatus_Callback(hObject, eventdata, handles)
% hObject    handle to HoldStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HoldStatus

% --- Executes on button press in PlotData.
function PlotData_Callback(hObject, eventdata, handles)
% hObject    handle to PlotData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ThingsToDo=get(handles.WhatToDo,'string');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'UpdateAxis')
%     BackupGraphs;
       NextCommandSetBaseRate=0;
UpdateGObjects;
elseif strcmp(WhatToDo,'UpdateCell')
%         BackupGraphs;
       NextCommandSetBaseRate=0;
LoadGFXVar=0; UpdateCellOrLoadGFX;
elseif strcmp(WhatToDo,'MakePlot')

FilterStringList=cellstr(get(handles.TrialFilterVector,'string'));
      CurrentFilterString=FilterStringList{1};
%       if get(handles.UseFilters,'value')==0, CurrentFilterString='';end


       for TempVarA=1:handles.NumberOfAxes
 eval([ 'Axis' num2str(TempVarA) 'MarkerPointer=0;'...    
 ]);
       end
       getCurrentParameters;
       NextCommandSetBaseRate=0;
if isempty(CurrentUnitNumber), CurrentUnitNumber=613; fprintf('%s\n','Using 613 as the Unit');end

if ~strcmp(CurrentDataFile,'LoadedFiles') & ~strcmp(CurrentPlottingFile,'PlottingFile') 

for numFilters=1:length(FilterStringList)

      CurrentFilterString=FilterStringList{numFilters};
      if isempty(CurrentFilterString), CurrentFilterString='1';end

      %need a line here so that switchaxes is called at beginning and hten
      %for every newaxis line
      
      if numFilters==1, SwitchAxes; end
      
      PlotOK=1;       % Initializes to PlotOK, FInterpreter will cancel to No Plot if needed
      FInterpreter;  %This calls the filter interpreter !!!!
            if RunCode==1, 
          
                    eval(['Trials=handles.' CurrentDataFile '.Trials;']);
          eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
          eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
                    if GoOn==1
CurrentVariables=ParamEval(XexParameters,CurrentVariables);
eval(['handles.' CurrentDataFile '.Analysis=CurrentVariables;']);
          end
% eval(XexParameters);
              fprintf('%s\n','Running:');
    fprintf('%s\n',XexParameters);
    
end

          if PlotOK==1,
      
              NoChangeAxesPointer=1;
                      getCurrentParameters;  % makes sure all finterpreter changes are loaded in

 %   try
eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
%  eval(['if GoOn==1, fprintf(''%s\n'',''Plotting Now'');' CurrentPlottingFile(1:(end-2)) ';end']);  %running the current plotting file
% if RunCode==1, eval(XexParameters);
%     fprintf('%s\n','Running:');
%     fprintf('%s\n',XexParameters);
% end
if NextCommandSetBaseRate==1
    SetBaseRate; NextCommandSetBaseRate=0;
else
 eval(['if GoOn==1, ' CurrentPlottingFile(1:(end-2)) ';end']);  %running the current plotting file
   %   catch, fprintf('%s\t','Error in PlottingFile:'); fprintf('%s\n',lasterr);
     %end
end

end
end

else TellMe('%s\n','Make sure you have selected a data file and a plotting file',handles.SpeakToMe);
end

else fprintf('%s\n','That button is inactive !!');
end

guidata(hObject,handles);  %routinely saving anything assigned to handles

% % --- Executes on button press in AddPlottingFile.
% function AddPlottingFile_Callback(hObject, eventdata, handles)
% % hObject    handle to AddPlottingFile (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% Old_Dir=pwd;
% if ~exist('DataDirectory','var'), DataDirectory='c:\MATLAB\work\XeX\AnalysisFunctions';end
% cd(DataDirectory);
% 
%    [input_filename, input_pathname] = uigetfile( ...
%        {'*.m','M-files (*.m)';
%         '*.*',  'All Files (*.*)'}, ...
%         'Pick a Trials file', ...
%         'MultiSelect', 'on');
% 
%     %%loading the files
% 
%      if ~isnumeric(input_filename)
%      if ~iscell(input_filename) TemporaryStuff{1}=input_filename;
%      input_filename=TemporaryStuff; 
%      end
%      
% AnalysisFileNames=get(handles.PlottingFileList,'string');
%          if ~iscell(AnalysisFileNames)&~strcmp(AnalysisFileNames,'PlottingFile')
%              TemporaryStuff{1}=AnalysisFileNames;
%              AnalysisFileNames=TemporaryStuff;
%          end
%          
%          if ~iscell(AnalysisFileNames)
%              set(handles.PlottingFileList,'string',sort(input_filename));
%          else
%              NewNames=setdiff(input_filename,AnalysisFileNames);
%              set(handles.PlottingFileList,'string',sort([NewNames AnalysisFileNames']'));
%          end
% 
%          guidata(hObject,handles);
%          
%      end
%      
%         cd(Old_Dir);


% --- Executes on selection change in CodeBitMenu.
function CodeBitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CodeBitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CodeBitMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CodeBitMenu


% --- Executes during object creation, after setting all properties.
function CodeBitMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CodeBitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in LoadFile.
function LoadFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LoadFileCallbackStuff;

% --------------------------------------------------------------------
function AxesContext_Callback(hObject, eventdata, handles)
% hObject    handle to AxesContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function FTPOptions_Callback(hObject, eventdata, handles)
% hObject    handle to FTPOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~isfield(handles,'FTP'), CurrentFTPPath='/data/'; CurrentFTPFile='';
else CurrentFTPPath=(handles.FTP.pathname);
    CurrentFTPFile=handles.FTP.filename;
end
   
   prompt={'Enter FTP path','Enter FTP file'};
   name='FTP Options ';
   numlines=1;
   defaultanswer={CurrentFTPPath CurrentFTPFile};
 
   Answer=inputdlg(prompt,name,numlines,defaultanswer);

   
   if ~isempty(Answer)
CurrentFTPPath=Answer{1};
CurrentFTPFile=Answer{2};
handles.FTP.pathname=CurrentFTPPath;
handles.FTP.filename=CurrentFTPFile;
   end

   guidata(hObject,handles);

% --- Executes on slider movement.
function BinWidth_Callback(hObject, eventdata, handles)
% hObject    handle to BinWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

CurrentValue=get(hObject,'Value');
set(handles.SliderValue,'String',['BW','=',num2str(CurrentValue)]);

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='BW';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function BinWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function SliderValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function Utilities_Callback(hObject, eventdata, handles)
% hObject    handle to Utilities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function StimulusAlignedTimeVector_Callback(hObject, eventdata, handles)
% hObject    handle to StimulusAlignedTimeVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimulusAlignedTimeVector as text
%        str2double(get(hObject,'String')) returns contents of StimulusAlignedTimeVector as a double

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='TimeWindow';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function StimulusAlignedTimeVector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimulusAlignedTimeVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function SaccadeAlignedTimeVector_Callback(hObject, eventdata, handles)
% % hObject    handle to SaccadeAlignedTimeVector (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of SaccadeAlignedTimeVector as text
% %        str2double(get(hObject,'String')) returns contents of SaccadeAlignedTimeVector as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function SaccadeAlignedTimeVector_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to SaccadeAlignedTimeVector (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end

function AxesToUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to AxesToUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxesToUpdate as text
%        str2double(get(hObject,'String')) returns contents of AxesToUpdate as a double


% --- Executes during object creation, after setting all properties.
function AxesToUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxesToUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% 
% % --- Executes on button press in UpdateTheseAxes.
% function UpdateTheseAxes_Callback(hObject, eventdata, handles)
% % hObject    handle to UpdateTheseAxes (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% BackupGraphs;
% UpdateGObjects;
% guidata(hObject,handles);  %routinely saving anything assigned to handles

% --- Executes when something happens in TrialFilterVector, I think.
function TrialFilterVector_Callback(hObject, eventdata, handles)
% hObject    handle to TrialFilterVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TrialFilterVector as text
%        str2double(get(hObject,'String')) returns contents of TrialFilterVector as a double

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='Filter';
UpdateSlider;
end

guidata(hObject,handles);


% --- Executes on selection change in PlottingFileList.
function PlottingFileList_Callback(hObject, eventdata, handles)
% hObject    handle to PlottingFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PlottingFileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlottingFileList

% ShowSlider;

contents=get(hObject,'String');
currentselection=contents{get(hObject,'value')};

switch(currentselection),
    case 'ImageMap.m', set(handles.StimulusAlignedTimeVector,'string','[50 150]'); if isempty(char(get(handles.TrialFilterVector,'string'))),set(handles.TrialFilterVector,'string','f==1&PhotoBad~=1');end
        XAxisVariables=get(handles.XAxisVariable,'string');
        WhereisRFx=find(strcmp(XAxisVariables,'RFx'));
        if ~isempty(WhereisRFx), set(handles.XAxisVariable,'value',WhereisRFx(1)); set(handles.XAxisDiscretize,'value',1); set(handles.XAxisCenters,'string','-25:5:25');end
       X1AxisVariables=get(handles.X1AxisVariable,'string');
        WhereisRFy=find(strcmp(X1AxisVariables,'RFy'));
        if ~isempty(WhereisRFy), set(handles.X1AxisVariable,'value',WhereisRFy(1)); set(handles.X1AxisDiscretize,'value',1); set(handles.X1AxisCenters,'string','-25:5:25');end
       YAxisVariables=get(handles.YAxisVariable,'string');
        WhereisSpikeRate=find(strcmp(YAxisVariables,'SpikeRate'));
        if ~isempty(WhereisSpikeRate), set(handles.YAxisVariable,'value',WhereisSpikeRate(1)); end
        
            
    case 'CircleMap.m', set(handles.StimulusAlignedTimeVector,'string','[50 150]');if isempty(char(get(handles.TrialFilterVector,'string'))),set(handles.TrialFilterVector,'string','GoodTrial==1&PhotoBad~=1');end
    case 'SpikeDensity.m', set(handles.StimulusAlignedTimeVector,'string','[-400 400]');
    case 'DrawPSTH.m', set(handles.StimulusAlignedTimeVector,'string','[-400 400]');
end        
    
        guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function PlottingFileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlottingFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function TrialFilterVector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrialFilterVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(hObject,'tooltipstring',sprintf(['This is a key area. Enter FilterValues like RFPat==28&GoodTrial==1 \nor RFx<0 & RFy>0 for upper left quadrant, etc. If empty, or set to ''TrialFilterVector'', it will be set to 1\nIf NA, then update axes will ignore it\n and use'...
%     'the saved filter string in the graphics object']));

guidata(hObject,handles);

% --- Executes on selection change in CurrentAxes.
function CurrentAxes_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CurrentAxes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CurrentAxes


% --- Executes during object creation, after setting all properties.
function CurrentAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in UpdateCell.
function UpdateCell_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%UpdateCell;

% BackupGraphs;
NextCommandSetBaseRate=0;
LoadGFXVar=0; UpdateCellOrLoadGFX;
guidata(hObject,handles);  %routinely saving anything assigned to handles


function Axis1Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis1Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis1Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis1Markers as a double


CurrentAxisMarkerNumber=1;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis1Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis1Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis2Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis2Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis2Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis2Markers as a double

CurrentAxisMarkerNumber=2;
UpdateMarkers;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Axis2Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis2Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis3Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis3Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis3Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis3Markers as a double

CurrentAxisMarkerNumber=3;
UpdateMarkers;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Axis3Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis3Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis4Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis4Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis4Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis4Markers as a double

CurrentAxisMarkerNumber=4;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis4Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis4Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis5Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis5Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis5Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis5Markers as a double

CurrentAxisMarkerNumber=5;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis5Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis5Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis6Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis6Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis6Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis6Markers as a double

CurrentAxisMarkerNumber=6;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis6Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis6Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis7Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis7Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis7Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis7Markers as a double

CurrentAxisMarkerNumber=7;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis7Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis7Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis8Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis8Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis8Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis8Markers as a double

CurrentAxisMarkerNumber=8;
UpdateMarkers;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Axis8Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis8Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Axis9Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis9Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis9Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis9Markers as a double

CurrentAxisMarkerNumber=9;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis9Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis9Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ResetProps.
function ResetProps_Callback(hObject, eventdata, handles)
% hObject    handle to ResetProps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for TempVar=1:handles.NumberOfAxes
    eval(['set(handles.Axis' num2str(TempVar) 'Markers,''string'',''b-r-m-c-k-y-'');']);
end 

guidata(hObject,handles);


% --- Executes on button press in UseProps.
function UseProps_Callback(hObject, eventdata, handles)
% hObject    handle to UseProps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UseProps

DoUseProps;

guidata(hObject,handles);

% --- Executes on button press in AddAnalysisFileButton.
function AddAnalysisFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddAnalysisFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Old_Dir=pwd;
if ~exist('DataDirectory','var'), DataDirectory='c:\MATLAB\work\XeX\PreProcFunctions';end
cd(DataDirectory);

   [input_filename, input_pathname] = uigetfile( ...
       {'*.m','M-files (*.m)';
        '*.*',  'All Files (*.*)'}, ...
        'Add an Analysis File', ...
        'MultiSelect', 'on');

    %%loading the files

     if ~isnumeric(input_filename)
     if ~iscell(input_filename) TemporaryStuff{1}=input_filename;
     input_filename=TemporaryStuff; 
     end
     
AnalysisFileNames=get(handles.AnalysisFile,'string');
         if ~iscell(AnalysisFileNames)
             TemporaryStuff{1}=AnalysisFileNames;
             AnalysisFileNames=TemporaryStuff;
         end
         
         if ~iscell(AnalysisFileNames)
             set(handles.AnalysisFile,'string',sort(input_filename));
         else
             NewNames=setdiff(input_filename,AnalysisFileNames);
             set(handles.AnalysisFile,'string',sort([NewNames AnalysisFileNames']'));
         end

         guidata(hObject,handles);
         
     end
     
        cd(Old_Dir);


% % --- Executes on button press in SaveGraphics.
% function SaveGraphics_Callback(hObject, eventdata, handles)
% % hObject    handle to SaveGraphics (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% Old_Dir=pwd;
% if isfield(handles,'GraphicsDirectory'), cd(handles.GraphicsDirectory); else try,cd('c:\MATLAB\work\physiology\GraphicsObjects');
%     catch,fprintf('%s\n','Didnt find graphics directory');end
% end
% 
% TempGraphs=[];
% for TempVar=1:(handles.NumberOfAxes)
%     EvalString=[...
%         'if isfield(handles,''A' num2str(TempVar) '''),TempGraphs.A' num2str(TempVar) '=handles.A' num2str(TempVar) ';end'...
%         ];
%     eval(EvalString);
%         EvalString=[...
%         'if isfield(handles,''A' num2str(TempVar) 'Annotations''),TempGraphs.A' num2str(TempVar) 'Annotations=handles.A' num2str(TempVar) 'Annotations;end'...
%         ];
%     eval(EvalString);
% end
% if ~isempty(TempGraphs)
%     
%      [filename, pathname, filterindex] = uiputfile( ...
%        {'*_gfx.mat','GFX-files (*_gfx.mat)'; ...
%         '*.*',  'All Files (*.*)'}, ...
%         'Save Graphics Object as', 'Untitled_gfx.mat');
%  
%     if filename~=0, save([pathname filename],'TempGraphs'),
%     TellMe('%s\n',['Saved to    ' filename],handles.SpeakToMe);
%     end
% else fprintf('%s\n','TempGraphs is empty !!'); keyboard;
% end
% 
% cd(Old_Dir);
% 
% guidata(hObject,handles);

% % --- Executes on button press in LoadGraphics.
% function LoadGraphics_Callback(hObject, eventdata, handles)
% % hObject    handle to LoadGraphics (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% Old_Dir=pwd;
% if isfield(handles,'GraphicsDirectory'), cd(handles.GraphicsDirectory); else try,cd('c:\MATLAB\work\physiology\GraphicsObjects');
%     catch,fprintf('%s\n','Didnt find graphics directory');end
% end
% 
% CurrentHoldStatus=get(handles.HoldStatus,'Value');
% 
%    [CurrentFile, input_pathname] = uigetfile( ...
%        {'*_gfx.mat','graphix_mat-files (*_gfx.mat)';...
%         '*.*',  'All Files (*.*)'}, ...
%         'Pick a Graphics Object file');
% 
%     %%loading the files
% 
%      if ~isnumeric(CurrentFile)
%      
%      cd(input_pathname);
%      
%          if ~isempty(strfind(CurrentFile,'.mat'))
%              CurrentFile=CurrentFile(1:(end-4));
%              eval([CurrentFile '= load(''' CurrentFile '.mat'');']);
%              eval(['TempGraphs=' CurrentFile '.TempGraphs;']);
%           
%              for TempVar=1:(handles.NumberOfAxes)
%                  NStr=num2str(TempVar);
%                  
%                  LocalTempEvalString=['if isfield(TempGraphs,''A' NStr '''),'...
%                      'TempLen=length(TempGraphs.A' NStr ');'...
%                      'if isfield(handles,''A' NStr '''), OldLen=length(handles.A' NStr '); else OldLen=0;end,'...
%                      'for indica=1:TempLen, TempGraphs.A' NStr '(indica).newgraph=1;end,'...
%                      'if CurrentHoldStatus==1, handles.A' NStr '((OldLen+1):(OldLen+TempLen))=TempGraphs.A' NStr ';end,'...
%                      'if CurrentHoldStatus~=1, handles.A' NStr '=TempGraphs.A' NStr ';end,'...
%                      'if isfield(TempGraphs,''A' NStr 'Annotations''), handles.A' NStr 'Annotations=TempGraphs.A' NStr 'Annotations;end,'...
%                  'end;'];
%                  eval(LocalTempEvalString);
%                  clear LocalTempEvalString;
%              end
%          end
%      
% LoadGFXVar=1;
% UpdateCellOrLoadGFX;
% guidata(hObject,handles);
% 
%      end
%      
         
% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function AnalyzeFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalyzeFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'tooltipstring','Choose an Analysis File to run analyses on selected data file(s)');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function LoadFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'tooltipstring','Load (Multiple) Data File(s) Here');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AddAnalysisFileButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AddAnalysisFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%set(hObject,'tooltipstring','Add Analysis Files to the Popup Menu');
guidata(hObject,handles);

% 
% % --- Executes during object creation, after setting all properties.
% function LoadGraphics_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to LoadGraphics (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% set(hObject,'tooltipstring',sprintf('Click here to load saved graphics objects\nTitles will be loaded as well'));
% guidata(hObject,handles);


% --- Executes on button press in DeleteLoadedFiles.
function DeleteLoadedFiles_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteLoadedFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList) && strcmp(LoadedFileList,'LoadedFiles')
     TellMe('%s\n','Nothing to delete !!',handles.SpeakToMe);
 else
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value');
 FilesToDelete=LoadedFileList(CurrentValue);
 
 set(handles.LoadedFiles,'listboxtop',1);
 
 for TempVar=1:length(FilesToDelete)
     eval(['handles=rmfield(handles,''' FilesToDelete{TempVar} ''');']);
     fprintf('%s\n',['Deleted  ' FilesToDelete{TempVar}]);
         end
 
 FilesToKeep=setdiff(1:length(LoadedFileList),CurrentValue);
 if isempty(FilesToKeep), LoadedFileList='LoadedFiles'; else LoadedFileList=LoadedFileList(FilesToKeep);end
set(handles.LoadedFiles,'string',(LoadedFileList),'value',1);

fprintf('%s',sprintf('If there are graphics objects\n that depend on these files,\n then if you try to update axes, it will fail\n'));
fprintf('%s\n','ALSO: this step takes time because a copy of handles is created and modified. May also screw up memory. WAIT for loaded files to appear, if you are deleting a LOT of files');

guidata(hObject,handles);
 end

% --- Executes during object creation, after setting all properties.
function DeleteLoadedFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DeleteLoadedFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'tooltipstring','Delete Loaded Data Files (Trials and Analysis)');
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

hold on;


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


hold on;


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3

hold on;



% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4
hold on;



% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5

hold on;


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6

hold on;


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7

hold on;
% zoom on;

% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8

hold on;


% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes9

hold on;

% --- Executes during object creation, after setting all properties.
function text30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'tooltipstring',sprintf('Enter the in-RF location here\n[x y]\nVariable is CurrentRF'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function SaveGraphics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveGraphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Only on because other buttons somehow have this as their "dud" create
% function

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function UpdateTheseAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpdateTheseAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'tooltipstring',sprintf('Remember: to keep current filter inactive\n,set it to empty. Easy to miss'));
guidata(hObject,handles);


% --- Executes on selection change in AlignCode.
function AlignCode_Callback(hObject, eventdata, handles)
% hObject    handle to AlignCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AlignCode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AlignCode

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='Align';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function AlignCode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlignCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ClearAxes_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold off; cla;
set(gca,'xlim',[-inf inf],'ylim',[-inf inf]);
ClearGObjects;

AxesList=handles.HandlesList;
AxisNum=find(gca==AxesList);

UnlinkTheseAxes;
UndefineAxisVars;

guidata(hObject,handles);




% --------------------------------------------------------------------
function General_Callback(hObject, eventdata, handles)
% hObject    handle to FTPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function GetInsideMe_Callback(hObject, eventdata, handles)
% hObject    handle to GetInsideMe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

keyboard;


% --------------------------------------------------------------------
function FTPFile_Callback(hObject, eventdata, handles)
% hObject    handle to FTPFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'FTP')
    
FileToFTP=[handles.FTP.pathname handles.FTP.filename];
FTPDir=[matlabroot filesep 'work'];
% FTPDir='c:\MATLAB\work\physiology';

if isfield(handles,'CurrentDataDirectory'), cd(handles.CurrentDataDirectory);end

%mhp070214. a kluge because command line inputs need short names
ncftp_command = ['!ncftpget -f ' handles.XeXDir '\assorted\pwf ', FTPDir,' ',FileToFTP 'A ' FileToFTP 'E'];
ncftp_command = strrep(ncftp_command, 'Program Files', 'Progra~1');
%%%%%%%%%%%%%%%%%%%%%%%
eval(ncftp_command);
fprintf('%s\n',['IF NCFTP REPORTED NO ERRORS, File downloaded to   ' pwd]);

FTPLoadFileStuff;

else
    TellMe('%s\n','Enter the FTP options first',handles.SpeakToMe);
end

% --------------------------------------------------------------------
function ClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


for TempVar=1:(handles.NumberOfAxes)
    eval(['axes(handles.axes' num2str(TempVar) ');']);
    cla; hold off; set(gca,'xlim',[-inf inf],'ylim',[-inf inf]);
eval(['if isfield(handles,''A' num2str(TempVar) '''), handles=rmfield(handles,''A' num2str(TempVar) ''');end']);
end

AxisNum=1:12;
UnlinkTheseAxes;
UndefineAxisVars;

guidata(hObject,handles);

% --------------------------------------------------------------------
function PlotEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); plotedit('on');
else set(hObject,'Checked','off'); plotedit('off');
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function AnnotateAxis_Callback(hObject, eventdata, handles)
% hObject    handle to AnnotateAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


AxesHandles=nan*ones(1,handles.NumberOfAxes);

for TempVar=1:(handles.NumberOfAxes)
   eval([' AxesHandles(TempVar)=handles.axes' num2str(TempVar) ';']);
end

CurrentAxisHandle=gca;

WhichAxis=find(AxesHandles==CurrentAxisHandle);

estring=(['if isfield(handles,''A' num2str(WhichAxis) 'Annotations''), danswer=handles.A' num2str(WhichAxis) 'Annotations; else danswer={'''','''',''''};end']);
%     else danswer={''Axis' num2str(WhichAxis) ''',''X Label'',''Y Label'' };end']); 
%    keyboard;
   eval(estring);
    danswer{4}=num2str(get(gca,'xlim'));
    danswer{5}=num2str(get(gca,'ylim'));
    
   prompt={'Enter axis title','Enter X label' 'Enter Y label','Enter X Lim', 'Enter Y Lim'};
   name=['Annotate Axis ' num2str(WhichAxis)];
   numlines=1;
   defaultanswer=danswer;
 
   answer=inputdlg(prompt,name,numlines,defaultanswer);

   
   if ~isempty(answer)
   title(answer{1});
   xlabel(answer{2});
   ylabel(answer{3});
   set(gca,'xlim',str2num(answer{4}));
   set(gca,'ylim',str2num(answer{5}));
   
   eval(['handles.A' num2str(WhichAxis) 'Annotations=answer;']);
   
   end

   guidata(hObject,handles);

function UnitNumber_Callback(hObject, eventdata, handles)
% hObject    handle to UnitNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UnitNumber as text
%        str2double(get(hObject,'String')) returns contents of UnitNumber as a double


% --- Executes during object creation, after setting all properties.
function UnitNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UnitNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function SetDataDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to SetDataDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TempDir=uigetdir(handles.CurrentDataDirectory,'Set Data Directory');
if ~isequal(TempDir,0)
    handles.CurrentDataDirectory=TempDir;
end

guidata(hObject,handles);

% --- Executes on button press in GetVariables.
function GetVariables_Callback(hObject, eventdata, handles)
% hObject    handle to GetVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
if ~strcmp(CurrentDataFile,'LoadedFiles')

eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
%eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);
% eval(['if GoOn==1, MyResponseVariableList=handles.' CurrentDataFile '.Analysis.MyResponseVariableList;end']);

%detachvars;

msgbox(MyVariableList,'Variable List','help');
set(gcf,'CloseRequestFcn','TellMe(''%s\n'',''Hit OK. You cannot close this box like that.'',handles.SpeakToMe)');


else TellMe('%s\n','Make sure you have selected a data file and a plotting file',handles.SpeakToMe);
end

% --- Executes on button press in LaunchViewer.
function LaunchViewer_Callback(hObject, eventdata, handles)
% hObject    handle to LaunchViewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LoadedFileList=get(handles.LoadedFiles,'string');
CurrentValues=get(handles.LoadedFiles,'value');
if length(CurrentValues)>0 & iscell(LoadedFileList)
CurrentFile=LoadedFileList{CurrentValues(1)};
else
    CurrentFile=LoadedFileList;
end

if ~strcmp(CurrentFile,'LoadedFiles') 
        eval(['Trials=handles.' CurrentFile '.Trials;']);
        setappdata(0,'SaccadeOptions',handles.SaccadeOptions);
        setappdata(0,'ViewTrials',Trials);
%         CellToPass=cell(1,4);
%         CellToPass{1}=handles.SaccadeOptions.CorrectCode;
%         CellToPass{2}=handles.SaccadeOptions.ISICut;
%         CellToPass{3}=handles.SaccadeOptions.MinLat;
%         CellToPass{4}=handles.SaccadeOptions.Threshold;
%         TrialViewer(Trials,CellToPass);
        TrialViewer;
else
    TellMe('%s\n','Choose a data file first',handles.SpeakToMe);

end


% --------------------------------------------------------------------
function BrowseFTP_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseFTP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ftpsurf;

% % --- Executes on button press in SetAxisVariables.
% function SetAxisVariables_Callback(hObject, eventdata, handles)
% % hObject    handle to SetAxisVariables (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
%  LoadedFileList=get(handles.LoadedFiles,'string');
%  if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
%  CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
%  CurrentDataFile=LoadedFileList{CurrentValue};
%  
% if ~strcmp(CurrentDataFile,'LoadedFiles')
% 
% eval(['Trials=handles.' CurrentDataFile '.Trials;']);
% eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
% %eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
% eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList; MyResponseVariableList=handles.' CurrentDataFile '.Analysis.MyResponseVariableList;end']);
% 
% if ~iscell(MyVariableList), TemporaryVariable{1}=MyVariableList; MyVariableList=TemporaryVariable; clear TemporaryVariable; end
% if ~iscell(MyResponseVariableList), MyResponseVariableList=cellstr(MyResponseVariableList);end
% 
% MyVariableChoices=EnterAxisVariables(MyVariableList,MyResponseVariableList,handles.MyVariableChoices);
% if MyVariableChoices.OK==1
%     handles.MyVariableChoices=MyVariableChoices;
% end
% 
% % [TwoDX,TempOK]=listdlg('PromptString','Select X variable for 2D map','SelectionMode','single','ListString',MyVariableList);
% % if TempOK==1, handles.TwoDXVar=MyVariableList{TwoDX}; end
% % 
% % 
% % [TwoDY,TempOK]=listdlg('PromptString','Select Y variable for 2D map','SelectionMode','single','ListString',MyVariableList);
% % if TempOK==1, handles.TwoDYVar=MyVariableList{TwoDY}; end
% 
% else TellMe('%s\n','Make sure you have selected a data file and a plotting file',handles.SpeakToMe);
% end
% 
% guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExportGraphics.
function ExportGraphics_Callback(hObject, eventdata, handles)
% hObject    handle to ExportGraphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ExportGFX;


% --- Executes on button press in ExploreVariables.
function ExploreVariables_Callback(hObject, eventdata, handles)
% hObject    handle to ExploreVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
if ~strcmp(CurrentDataFile,'LoadedFiles')

eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);
eval(['if GoOn==1, MyResponseVariableList=handles.' CurrentDataFile '.Analysis.MyResponseVariableList;end']);
% 
% msgbox(MyVariableList,'Variable List','help');

eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
detachvars;
if exist('CurrentVariables','var'), clear CurrentVariables;end  %***newly added to clear off possible big structure from workspace.
keyboard;
% clearvars;  %**************************** removed this as well as it is
                      %% superfluous, i think

else TellMe('%s\n','Make sure you have selected a data file and a plotting file',handles.SpeakToMe);
end

% --- Executes on button press in UseAxisVars.
function UseAxisVars_Callback(hObject, eventdata, handles)
% hObject    handle to UseAxisVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UseAxisVars


% --- Executes on button press in AddVariable.
function AddVariable_Callback(hObject, eventdata, handles)
% hObject    handle to AddVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
if ~strcmp(CurrentDataFile,'LoadedFiles')

eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);
eval(['if GoOn==1, MyResponseVariableList=handles.' CurrentDataFile '.Analysis.MyResponseVariableList;end']);
eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
detachvars;

if(GoOn==1), 
  prompt={'Enter Expression for New Variable. If you want to modify a variable: trick is <varname=statement>; <other statements acting on varname>; varname will be saved !!'};
   name='Add New Variable ';
   numlines=1;
   defaultanswer={''};
 
   Answer=inputdlg(prompt,name,numlines,defaultanswer);

   if ~isempty(Answer)
try,
if iscell(Answer),    Answer=Answer{1};end
    eval(Answer);
    CutoffMark=strfind(Answer,'=');
    if ~isempty(CutoffMark),
        AddedVariableString=Answer(1:(CutoffMark-1));
        TellMe('%s\n',['Just calculated   ' AddedVariableString],handles.SpeakToMe);
    end
 
  eval(['CurrentVariables.' AddedVariableString '=' AddedVariableString '; CurrentVariables.MyVariableList{length(CurrentVariables.MyVariableList)+1}=''' AddedVariableString ''';handles.' CurrentDataFile '.Analysis=CurrentVariables;']);
%     eval(['CurrentVariables.' AddedVariableString '=' AddedVariableString '; CurrentVariables.MyVariableList{length(CurrentVariables.MyVariableList)+1}=''' AddedVariableString ''';CurrentVariables.MyResponseVariableList{length(CurrentVariables.MyResponseVariableList)+1}=''' AddedVariableString ''';handles.' CurrentDataFile '.Analysis=CurrentVariables;']);

catch,
    fprintf('%s\n','That expression is wrong, for some reason; check again');
end  % closes the try 
   else fprintf('%s\n','OK, cancelled !');
   end % closes the ~isempty(answer) loop
clearvars;
% ShowSlider;
guidata(hObject,handles);
   end
   
else TellMe('%s\n','Make sure you have selected a data file and a plotting file',handles.SpeakToMe);
end



% --------------------------------------------------------------------
function SpikeTruncate_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeTruncate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); 
else set(hObject,'Checked','off');
end
guidata(hObject,handles);



% --------------------------------------------------------------------
function ClearPolar_Callback(hObject, eventdata, handles)
% hObject    handle to ClearPolar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  prompt={'Enter Polar Axis'};
   name='Clear Polar ';
   numlines=1;
   defaultanswer={''};
 
   Answer=inputdlg(prompt,name,numlines,defaultanswer);

   if ~isempty(Answer)

if iscell(Answer),    Answer=Answer{1};end

AxisNum=str2num(Answer);

for index=1:length(AxisNum)
    CurAx=num2str(AxisNum(index));
    eval(['Pos=get(handles.axes' CurAx ',''position'');']);
    eval(['CurContext=get(handles.axes' CurAx ',''uicontextmenu'');']);
    eval(['delete(handles.axes' CurAx ');']);   
    eval(['handles.axes' CurAx '=axes;']);
    eval(['set(handles.axes' CurAx,',''units'',''normalized'',''position'',Pos,''uicontextmenu'',CurContext);']);
end

UnlinkTheseAxes;
UndefineAxisVars;
guidata(hObject,handles);
   end


% % --- Executes on slider movement.
% function UpdateSlider_Callback(hObject, eventdata, handles)
% % hObject    handle to UpdateSlider (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'Value') returns position of slider
% %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 
% % BackupGraphs;
% 
% CurrentValue=get(hObject,'Value');
% set(handles.SliderText,'String',['SV =',num2str(CurrentValue)]);
% ThingsToDo=get(handles.WhatToDo,'String');
% WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};
% 
% if strcmp(WhatToDo,'ActiveUpdate'),
% UpdateType='slider';
% UpdateSlider;
% end
% 
% guidata(hObject,handles);
% 
% % --- Executes during object creation, after setting all properties.
% function UpdateSlider_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to UpdateSlider (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: slider controls usually have a light gray background.
% if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor',[.9 .9 .9]);
% end


% --------------------------------------------------------------------
function GetObjectAxes_Callback(hObject, eventdata, handles)
% hObject    handle to GetObjectAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GetObjectAxes as text
%        str2double(get(hObject,'String')) returns contents of GetObjectAxes as a double


% --- Executes during object creation, after setting all properties.
function GetObjectAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GetObjectAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function ObjectNumber_Callback(hObject, eventdata, handles)
% hObject    handle to ObjectNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ObjectNumber as text
%        str2double(get(hObject,'String')) returns contents of ObjectNumber as a double


% --- Executes during object creation, after setting all properties.
function ObjectNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ObjectNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function OldAxis_Callback(hObject, eventdata, handles)
% hObject    handle to OldAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OldAxis as text
%        str2double(get(hObject,'String')) returns contents of OldAxis as a double


% --- Executes during object creation, after setting all properties.
function OldAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OldAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function NewAxis_Callback(hObject, eventdata, handles)
% hObject    handle to NewAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewAxis as text
%        str2double(get(hObject,'String')) returns contents of NewAxis as a double


% --- Executes during object creation, after setting all properties.
function NewAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DeleteObjects.
function DeleteObjects_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


CurrentAxis=str2num(get(handles.OldAxis,'string'));
if isnumeric(CurrentAxis) && length(CurrentAxis)==1
    
    eval(['if isfield(handles,''A' num2str(CurrentAxis) '''),CurrentObjects=handles.A' num2str(CurrentAxis) ';end,']);
if exist('CurrentObjects','var')    && length(CurrentObjects)>=1
    ObjectsToDelete=str2num(get(handles.ObjectNumber, 'string'));
    
    if max(ObjectsToDelete)<=length(CurrentObjects),
        
    for Looper=1:length(ObjectsToDelete)
        delete(CurrentObjects(ObjectsToDelete(Looper)).handle);
        fprintf('%s\n',['Deleted 1 ' CurrentObjects(ObjectsToDelete(Looper)).plottype ' object from axis ' num2str(CurrentAxis)]);
    end
    
    CurrentObjects(ObjectsToDelete)=[];
    eval(['handles.A' num2str(CurrentAxis) '=CurrentObjects;']);
    
    else
        TellMe('%s\n','Cannot delete non existent objects',handles.SpeakToMe);
    end
    
    else TellMe('%s\n','No objects to delete !!',handles.SpeakToMe);
    end
    
else TellMe('%s\n','Enter only 1 Axis',handles.SpeakToMe);
end

guidata(hObject,handles);


% --- Executes on button press in MoveObj.
function MoveObj_Callback(hObject, eventdata, handles)
% hObject    handle to MoveObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CurrentAxis=str2num(get(handles.OldAxis,'string'));
NewAxis=str2num(get(handles.NewAxis,'string'));

if isnumeric(CurrentAxis) && length(CurrentAxis)==1 && length(NewAxis)==1
    
    if CurrentAxis~=NewAxis
        
    eval(['if isfield(handles,''A' num2str(CurrentAxis) '''),CurrentObjects=handles.A' num2str(CurrentAxis) ';end,']);
    eval(['if isfield(handles,''A' num2str(NewAxis) '''),NewObjects=handles.A' num2str(NewAxis) ';end,']);
    
    if exist('CurrentObjects','var') && length(CurrentObjects)>=1
    ObjectsToCopy=str2num(get(handles.ObjectNumber, 'string'));
    
    if max(ObjectsToCopy)<=length(CurrentObjects),
        
   TempObjects=CurrentObjects;
        
    for Looper=1:length(ObjectsToCopy)
        eval(['Newhandle=copyobj(CurrentObjects(ObjectsToCopy(Looper)).handle,handles.axes' num2str(NewAxis) ');']);
        TempObjects(ObjectsToCopy(Looper)).handle=Newhandle;
        delete(CurrentObjects(ObjectsToCopy(Looper)).handle);  %main difference 1 from copy objects
        fprintf('%s\n',['Moved 1 ' CurrentObjects(ObjectsToCopy(Looper)).plottype ' object from axis ' num2str(CurrentAxis) ' to axis ' num2str(NewAxis)]);
    end

    if exist('NewObjects','var'), NewObjects=[NewObjects TempObjects(ObjectsToCopy)]; else NewObjects=TempObjects(ObjectsToCopy);end
    eval(['handles.A' num2str(NewAxis) '=NewObjects;']);
    
     CurrentObjects(ObjectsToCopy)=[];
%      keyboard;
     if length(CurrentObjects)==0, 
         eval(['handles=rmfield(handles,''A' num2str(CurrentAxis) ''');']);
     else
     eval(['handles.A' num2str(CurrentAxis) '=CurrentObjects;']);  %these two lines are main difference number 2 from copy objects
     end
     
    else
        TellMe('%s\n','Cannot move non existent objects',handles.SpeakToMe);
    end
    
    else TellMe('%s\n','No objects to move !!',handles.SpeakToMe);
    end
    
    else TellMe('%s\n','Moving an object from an axis to itself is fun; I dont have to do anything',handles.SpeakToMe);
    end
    
else TellMe('%s\n','Enter only 1 Axis',handles.SpeakToMe);
end

guidata(hObject,handles);

% --- Executes on button press in GetObjectPropsButton.
function GetObjectPropsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GetObjectPropsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AxesToGet=str2num(get(handles.GetObjectAxes,'string'));
OutputString={};

if isnumeric(AxesToGet) && length(AxesToGet)==1,
   
    eval(['if isfield(handles,''A' num2str(AxesToGet) '''),CurrentObjects=handles.A' num2str(AxesToGet) ';end,']);

    if exist('CurrentObjects','var')
        for Looper=1:length(CurrentObjects)
    OutputString={OutputString{:} [num2str(Looper) ':   ' CurrentObjects(Looper).plottype '   ' CurrentObjects(Looper).markerstring '   ' CurrentObjects(Looper).trialfilter]};
        end
    end
    
    if isempty(OutputString), OutputString={'Nothing. Nada. Zilch. No objects here in this axis'};end
  msgbox(OutputString,'Objects','help');
    set(gcf,'CloseRequestFcn','disp(''Hit OK. You cannot close this Message Box like that.'')');
    
    fprintf('%s\n','*******************************************');
    for TempVar=1:length(OutputString)
        fprintf('%s\n',OutputString{TempVar});
    end
    fprintf('%s\n','*******************************************');

else TellMe('%s\n','Enter only 1 axis',handles.SpeakToMe);
end

guidata(hObject,handles);


% --- Executes on button press in CopyObj.
function CopyObj_Callback(hObject, eventdata, handles)
% hObject    handle to CopyObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CurrentAxis=str2num(get(handles.OldAxis,'string'));
NewAxis=str2num(get(handles.NewAxis,'string'));

if isnumeric(CurrentAxis) && length(CurrentAxis)==1 && length(NewAxis)==1
    
    eval(['if isfield(handles,''A' num2str(CurrentAxis) '''),CurrentObjects=handles.A' num2str(CurrentAxis) ';end,']);
    eval(['if isfield(handles,''A' num2str(NewAxis) '''),NewObjects=handles.A' num2str(NewAxis) ';end,']);
    
    if exist('CurrentObjects','var') && length(CurrentObjects)>=1
    ObjectsToCopy=str2num(get(handles.ObjectNumber, 'string'));
    
    if max(ObjectsToCopy)<=length(CurrentObjects),
        
   TempObjects=CurrentObjects;
        
    for Looper=1:length(ObjectsToCopy)
        eval(['Newhandle=copyobj(CurrentObjects(ObjectsToCopy(Looper)).handle,handles.axes' num2str(NewAxis) ');']);
        TempObjects(ObjectsToCopy(Looper)).handle=Newhandle;
        fprintf('%s\n',['Copied 1 ' CurrentObjects(ObjectsToCopy(Looper)).plottype ' object from axis ' num2str(CurrentAxis) ' to axis ' num2str(NewAxis)]);
    end

    if exist('NewObjects','var'), NewObjects=[NewObjects TempObjects(ObjectsToCopy)]; else NewObjects=TempObjects(ObjectsToCopy);end
    eval(['handles.A' num2str(NewAxis) '=NewObjects;']);
    
%     CurrentObjects(ObjectsToDelete)=[];
%     eval(['handles.A' num2str(CurrentAxis) '=CurrentObjects;']);
    
    else
        TellMe('%s\n','Cannot copy non existent objects',handles.SpeakToMe);
    end
    
    else TellMe('%s\n','No objects to copy !!',handles.SpeakToMe);
    end
    
else TellMe('%s\n','Enter only 1 Axis',handles.SpeakToMe);
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function PlotSig_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on');  
    else set(hObject,'Checked','off'); 
end
guidata(hObject,handles);

% 
% % --- Executes on button press in DefaultSlide.
% function DefaultSlide_Callback(hObject, eventdata, handles)
% % hObject    handle to DefaultSlide (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% CurrentValue=0.04;
% set(handles.UpdateSlider,'value',CurrentValue);
% set(handles.SliderText,'String',['SV =',num2str(CurrentValue,'%2.2f')]);
% 
% UpdateSlider;
% 
% guidata(hObject,handles);

% 
% % --- Executes on button press in UndoButton.
% function UndoButton_Callback(hObject, eventdata, handles)
% % hObject    handle to UndoButton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% if isfield(handles,'OldGraphs'), TempGraphs=handles.OldGraphs; else TempGraphs=[];end
% 
% if ~isempty(TempGraphs),
% 
%              for TempVar=1:(handles.NumberOfAxes)
%                  NStr=num2str(TempVar);
%                  
%                  LocalTempEvalString=['if isfield(TempGraphs,''A' NStr '''),'...
%                      'TempLen=length(TempGraphs.A' NStr ');'...
%                      'for indica=1:TempLen, TempGraphs.A' NStr '(indica).newgraph=1;end,'...
%                      'handles.A' NStr '=TempGraphs.A' NStr ';end,'...
%                  ];
%                  eval(LocalTempEvalString);
%                  clear LocalTempEvalString;
%              end
%      
% LoadGFXVar=1;
% UpdateCellOrLoadGFX;
% guidata(hObject,handles);
% 
% else TellMe('%s\n','Nothing to undo. Sorry',handles.SpeakToMe);
% end

% % --- Executes on button press in BackupButton.
% function BackupButton_Callback(hObject, eventdata, handles)
% % hObject    handle to BackupButton (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% BackupGraphs;
% guidata(hObject,handles);


% --------------------------------------------------------------------
function SpeakToMeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SpeakToMeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); handles.SpeakToMe=1;
else set(hObject,'Checked','off'); handles.SpeakToMe=0;
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function MainStuff_Callback(hObject, eventdata, handles)
% hObject    handle to MainStuff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function QuitXeX_Callback(hObject, eventdata, handles)
% hObject    handle to QuitXeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

endR;
delete(handles.figure1);


% --------------------------------------------------------------------
function AnalysisOptions_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotLatency_Callback(hObject, eventdata, handles)
% hObject    handle to PlotLatency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); 
else set(hObject,'Checked','off');    
end

guidata(hObject,handles);

% --------------------------------------------------------------------
function SetBaselineWindow_Callback(hObject, eventdata, handles)
% hObject    handle to SetBaselineWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


defaultanswer={'[-50 0]'};    
    
       prompt={'Enter baseline window'};
   name=['Baseline Window']; 
   numlines=1;

    answer=inputdlg(prompt,name,numlines,defaultanswer);

   if ~isempty(answer)

       BaselineWindow=str2num(answer{1});
       if isnumeric(BaselineWindow),
           handles.BaselineWindow=BaselineWindow;
           fprintf('%s\n',['Baseline Window set to [' num2str(BaselineWindow) ' ]']);
       end
       
   end
    
guidata(hObject,handles);
    


% --------------------------------------------------------------------
function PlottingContext_Callback(hObject, eventdata, handles)
% hObject    handle to PlottingContext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in TalkToMe.
function TalkToMe_Callback(hObject, eventdata, handles)
% hObject    handle to TalkToMe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

XeXUtters;


% --------------------------------------------------------------------
function ErrorBarType_Callback(hObject, eventdata, handles)
% hObject    handle to ErrorBarType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'label'),'ChangeErrorToBootstrap'), set(hObject,'label','ChangeErrorToPoisson'); fprintf('%s\n','Confidence bands now Bootstrap'); 
else set(hObject,'label','ChangeErrorToBootstrap'); fprintf('%s\n','Confidence bands now Poisson'); 
end

guidata(hObject,handles);


% % --------------------------------------------------------------------
% function FTPTimer_Callback(hObject, eventdata, handles)
% % hObject    handle to FTPTimer (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% if isfield(handles,'FTP')
% 
%     if strcmp(get(hObject,'Checked'),'off'), 
%     
% defaultanswer={'5'};
% 
%    prompt={'FTPTimer every so many minutes'};
%    name=['How often to FTPTimer ?'];
%    numlines=1;
% %    defaultanswer=danswer;
%  
%    answer=inputdlg(prompt,name,numlines,defaultanswer);
% 
%    if ~isempty(answer)
% handles.FTPDelay=str2num(answer{1});
% set(hObject,'Checked','on'), fprintf('%s\n','Turning timer on!!');
%        
%     
% FileToFTP=[handles.FTP.pathname handles.FTP.filename];
% FTPDir='c:\MATLAB\work\physiology';
% 
%     AnalysisFiles=get(handles.AnalysisFile,'string');
%     AnalysisFileValue=get(handles.AnalysisFile,'value');
%     if iscell(AnalysisFiles)
%     CurrentAnalysisFile=AnalysisFiles{AnalysisFileValue};
%     else
%         CurrentAnalysisFile=AnalysisFiles;
%     end
%     CurrentAnalysisFile=CurrentAnalysisFile(1:(end-2));
% 
% if isfield(handles,'CurrentDataDirectory'), cd(handles.CurrentDataDirectory);end
%     
% if isfield(handles,'timerhandle') && ~isempty(handles.timerhandle),
%     stop(handles.timer);
% delete(handles.timerhandle); handles.timerhandle=[];    
% fprintf('%s\n','Just stopped an unexpected running timer');
% end
% 
%    handles.timerhandle=timer('TimerFcn', {'LittleTimerFunction' {handles.XeXDir,FTPDir,FileToFTP,handles.UseStimAxes,handles.FTP.filename,CurrentAnalysisFile,handles.SaccadeOptions} },'Period', handles.FTPDelay*60,'ExecutionMode','fixedDelay','busymode','drop');
% start(handles.timerhandle);
% fprintf('%s\n','Started FTP timer !!');
% 
%    else fprintf('%s\n','Not starting timer... then.'); set(hObject,'Checked','off');
%    end
%    
% else 
%     
%     if isfield(handles,'timerhandle') && ~isempty(handles.timerhandle),
%     stop(handles.timerhandle);
% delete(handles.timerhandle); handles.timerhandle=[];    
% fprintf('%s\n','Turning timer off');
%     else fprintf('%s\n','Weird, where is the timer ?');    handles.timerhandle=[]; 
%     end
%     set(hObject,'Checked','off'); 
% 
%   end
% 
% else
%     TellMe('%s\n','Enter the FTPTimer options first',handles.SpeakToMe);
% end
% 
% guidata(hObject,handles);



% --------------------------------------------------------------------
function PlotCB_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); 
else set(hObject,'Checked','off'); 
end

guidata(hObject,handles);


% --- Executes on button press in FiltersList.
function FiltersList_Callback(hObject, eventdata, handles)
% hObject    handle to FiltersList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isappdata(0,'TrialFilterHandle'), setappdata(0,'TrialFilterHandle',handles.TrialFilterVector);end
% if ~isappdata(0,'UseFilterHandle'), setappdata(0,'UseFilterHandle',handles.UseFilters);end
if ~isappdata(0,'FilterGUIHandle'), FilterManagerGUI;
    
if ~isappdata(0,'UsePlottingHandle'),    setappdata(0,'UsePlottingHandle',handles.UseProps); end
if ~isappdata(0,'HoldFilterHandle'), setappdata(0,'HoldFilterHandle',handles.HoldStatus); end
    
else figure(getappdata(0,'FilterGUIHandle'));
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function GainGraph_Callback(hObject, eventdata, handles)
% hObject    handle to GainGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); 
% %     keyboard;
%     if strcmp(get(handles.SixGraph,'Checked'),'on'),
%            set(handles.SixGraph,'checked','off');
% %    makeVisible([handles.axes7 handles.axes8 handles.axes9]);
%     end
    
    gset;
    
% %        set_gainposits;
% else set(hObject,'Checked','off');
% %     reset_gainposits;
% twelveset;
% %     makeVisible([handles.Axis7Indicator handles.Axis8Indicator handles.Axis9Indicator]);
% end

% handles.NumberOfAxes=9;

guidata(hObject,handles);

% --- Executes on selection change in WhatToDo.
function WhatToDo_Callback(hObject, eventdata, handles)
% hObject    handle to WhatToDo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns WhatToDo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WhatToDo

WhatToDoStuff;
DoUseProps;

ThingsToDo=get(handles.WhatToDo,'string');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};
if strcmp(WhatToDo,'MakeHist')
% set(handles.UpdateSlider,'value',5);
% set(handles.SliderText,'string','SV=5');
set(handles.BinWidth,'value',100);
set(handles.SliderValue,'string','BW=100');
end

% ShowSlider;

% contents=get(handles.PlottingFileList,'String');
% currentselection=contents{get(handles.PlottingFileList,'value')};
% 
% switch(currentselection),
%     case 'ImageMap.m', set(handles.StimulusAlignedTimeVector,'string','[50 150]');
%     case 'CircleMap.m', set(handles.StimulusAlignedTimeVector,'string','[50 150]');
%     case 'SpikeDensity.m', set(handles.StimulusAlignedTimeVector,'string','[-400 400]');
%     case 'DrawPSTH.m', set(handles.StimulusAlignedTimeVector,'string','[-400 400]');
% end        
    
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function WhatToDo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WhatToDo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------

function UseTheseAxes_Callback(hObject, eventdata, handles)
% hObject    handle to UseTheseAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UseTheseAxes as text
%        str2double(get(hObject,'String')) returns contents of UseTheseAxes as a double


% --- Executes during object creation, after setting all properties.
function UseTheseAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UseTheseAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% % --- Executes on button press in UseFilters.
% function UseFilters_Callback(hObject, eventdata, handles)
% % hObject    handle to UseFilters (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of UseFilters
% 
% if get(hObject,'value')==0
% %     set(handles.TrialFilterVector,'string','');
% end
% guidata(hObject,handles);


% --------------------------------------------------------------------
function LatencyAfter_Callback(hObject, eventdata, handles)
% hObject    handle to LatencyAfter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

defaultanswer={'0'};    
    
       prompt={'Calculate latency after'};
   name=['Latency after']; 
   numlines=1;

    answer=inputdlg(prompt,name,numlines,defaultanswer);

   if ~isempty(answer)

       LatInitTime=str2num(answer{1});
       if isnumeric(LatInitTime),
           handles.LatInitTime=LatInitTime;
           fprintf('%s\n',['Latency after ' num2str(LatInitTime) ' ms']);
       end
       
   end
    
guidata(hObject,handles);



% --------------------------------------------------------------------
function SetCellProps_Callback(hObject, eventdata, handles)
% hObject    handle to SetCellProps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%    prompt={'Enter Unit Number','Enter RF location'};
   prompt={'Enter RF location'};
   name='RF Location ';
   numlines=1;
   defaultanswer={num2str(handles.RFLocation)};
 
   Answer=inputdlg(prompt,name,numlines,defaultanswer);
   
   if ~isempty(Answer)
% handles.UnitNumber=str2num(Answer{1});
handles.RFLocation=str2num(Answer{1});
   end

   setappdata(0,'RFLocation',handles.RFLocation);
   guidata(hObject,handles);



% --- Executes on selection change in VariablesList.
function VariablesList_Callback(hObject, eventdata, handles)
% hObject    handle to VariablesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns VariablesList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VariablesList


% --- Executes during object creation, after setting all properties.
function VariablesList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VariablesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function Layouts_Callback(hObject, eventdata, handles)
% hObject    handle to Layouts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SixGraph_Callback(hObject, eventdata, handles)
% hObject    handle to SixGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 
% if strcmp(get(hObject,'Checked'),'off') set(hObject,'checked','on'); 
%    if strcmp(get(handles.GainGraph,'Checked'),'on'),
% %        reset_gainposits;
%        set(handles.GainGraph,'Checked','off');
%    end
      nineset;
makeInvisible([handles.axes7 handles.axes8 handles.axes9 handles.Axis7Indicator handles.Axis8Indicator handles.Axis9Indicator]);
handles.NumberOfAxes=6;
% else
%    set(hObject,'checked','off');
% %    makeVisible([handles.axes7 handles.axes8 handles.axes9 handles.Axis7Indicator handles.Axis8Indicator handles.Axis9Indicator]);
% twelveset;
% end

 FullString=[];
    for tempind=7:12
        FullString=[FullString 'handles.AxisObj' num2str(tempind) ','];
    end
    
    eval(['makeInvisible([' FullString '])']);
    
guidata(hObject,handles);


% --- Executes on button press in ManageObjects.
function ManageObjects_Callback(hObject, eventdata, handles)
% hObject    handle to ManageObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Objs=[handles.GetObjectPropsButton, handles.GetObjectAxes, handles.DeleteObjects, handles.MoveObj, handles.CopyObj, handles.text64, handles.text65, handles.text66, handles.ObjectNumber, handles.OldAxis,handles.NewAxis];

VarObjs=[handles.text88, handles.text89, handles.text90, handles.UnBut, handles.XAxisVariable, handles.X1AxisVariable, handles.YAxisVariable, handles.XAxisCenters, handles.X1AxisCenters, handles.XAxisDiscretize, handles.X1AxisDiscretize, handles.ReverseXY];

if strcmp(get(hObject,'string'), 'ManageObjects'), set(hObject,'string','BackToVars');
    makeVisible(Objs);
    makeInvisible(VarObjs);
else set(hObject,'string','ManageObjects');
    makeInvisible(Objs);
    makeVisible(VarObjs);
end

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function ManageObjects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManageObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in UnBut -> DOES THE UNIQUE(CURRENTVARIABLE)
function UnBut_Callback(hObject, eventdata, handles)
% hObject    handle to UnBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

VarList=cellstr(get(handles.XAxisVariable,'string'));
CurVar=VarList{get(handles.XAxisVariable,'value')};

  LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
if ~strcmp(CurrentDataFile,'LoadedFiles')

eval(['Trials=handles.' CurrentDataFile '.Trials;']);
eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);
% 
% msgbox(MyVariableList,'Variable List','help');

eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
detachvars;

if exist(CurVar,'var')
eval(['UnVar=un(' CurVar ');']);

if length(UnVar)<50, fprintf('%6.2f\n',UnVar); else fprintf('There are %d unique variables\n',length(UnVar));end 

clearvars;

else fprintf('%s\n','That variable doesnt exist ??');
end

end

% keyboard;

% --- Executes during object creation, after setting all properties.
function UnBut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManageObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on selection change in GraphCommandFiles.
function GraphCommandFiles_Callback(hObject, eventdata, handles)
% hObject    handle to GraphCommandFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns GraphCommandFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GraphCommandFiles

% contents=cellstr(get(hObject,'String'));
% CurrentCommandFile=contents{get(hObject,'value')}; %string contains current command filename
% 
% if strcmp(CurrentCommandFile,'CmdEditor')
%     
%     if ~isappdata(0,'TrialFilterHandle'), setappdata(0,'TrialFilterHandle',handles.TrialFilterVector);end
% % if ~isappdata(0,'UseFilterHandle'), setappdata(0,'UseFilterHandle',handles.UseFilters);end
% if ~isappdata(0,'UsePlottingHandle'),    setappdata(0,'UsePlottingHandle',handles.UseProps); end
% if ~isappdata(0,'HoldFilterHandle'), setappdata(0,'HoldFilterHandle',handles.HoldStatus);end
% 
% if ~isappdata(0,'GraphCmdGUIHandle'), GraphCommandEditor;
%    else figure(getappdata(0,'GraphCmdGUIHandle'));
% end
% 
% end

% guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function GraphCommandFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GraphCommandFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddGrapher.
function AddGrapher_Callback(hObject, eventdata, handles)
% hObject    handle to AddGrapher (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


Old_Dir=pwd;
if ~exist('GraphCommandsDirectory','var'), GraphCommandsDirectory='c:\MATLAB\work\XeX\MyGraphs';end
cd(GraphCommandsDirectory);

   [input_filename, input_pathname] = uigetfile( ...
       {'*_gfx.m','Graph-files (*_gfx.m)';
        '*.*',  'All Files (*.*)'}, ...
        'Add Graph Command File(s)', ...
        'MultiSelect', 'on');

    %%loading the files

     if ~isnumeric(input_filename)
     if ~iscell(input_filename) TemporaryStuff{1}=input_filename;
     input_filename=TemporaryStuff; 
     end
     
GraphFileNames=get(handles.GraphCommandFiles,'string');
         if ~iscell(GraphFileNames)&&~strcmp(GraphFileNames,'CmdFiles')
             TemporaryStuff{1}=GraphFileNames;
             GraphFileNames=TemporaryStuff;
         end
         
         if ~iscell(GraphFileNames)
             set(handles.GraphCommandFiles,'string',sort(input_filename));
         else
             NewNames=setdiff(input_filename,GraphFileNames);
             set(handles.GraphCommandFiles,'string',sort([NewNames GraphFileNames']'));
         end

         guidata(hObject,handles);
         
     end
     
        cd(Old_Dir);


% --- Executes on button press in RunGraph.
function RunGraph_Callback(hObject, eventdata, handles)
% hObject    handle to RunGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


GraphCommandProcessor;

guidata(hObject,handles);  %routinely saving anything assigned to handles


% --- Executes on button press in SetGraphicDir.
function SetGraphicDir_Callback(hObject, eventdata, handles)
% hObject    handle to SetGraphicDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TempDir=uigetdir(handles.GraphCommandsDirectory,'Set Graph Commands Directory');
if ~isequal(TempDir,0)
    handles.GraphCommandsDirectory=TempDir;
end

guidata(hObject,handles);


% --- Executes on selection change in UnitNumberPop.
function UnitNumberPop_Callback(hObject, eventdata, handles)
% hObject    handle to UnitNumberPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns UnitNumberPop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UnitNumberPop

contents=cellstr(get(hObject,'string'));
handles.UnitNumber=str2num(contents{get(hObject,'value')});
fprintf('%s\n',['Unit Number is now ' num2str(handles.UnitNumber) ' ']);

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='UnitNumber';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function UnitNumberPop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UnitNumberPop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in DelTrials.
function DelTrials_Callback(hObject, eventdata, handles)
% hObject    handle to DelTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


LoadedFileList=get(handles.LoadedFiles,'string');
CurrentValues=get(handles.LoadedFiles,'value');
if ~iscell(LoadedFileList), LoadedFileList={LoadedFileList};end

CurrentlyLoadedFiles=LoadedFileList(CurrentValues);


if ~strcmp(CurrentlyLoadedFiles{1},'LoadedFiles')
for FileIndex=1:length(CurrentlyLoadedFiles)
    CurrentFile=CurrentlyLoadedFiles{FileIndex};
    eval(['handles.' CurrentFile '.Trials= NaN;']);
    fprintf('%s\n',['Removed trials from ' CurrentFile]);
 
end
else TellMe('%s\n','Load a file first !',handles.SpeakToMe);
end

guidata(hObject,handles);




% --------------------------------------------------------------------
function RmIndicators_Callback(hObject, eventdata, handles)
% hObject    handle to RmIndicators (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'checked'),'on')
    set(hObject,'checked','off');
    for i=1:handles.NumberOfAxes
    eval(['makeVisible(handles.Axis' num2str(i) 'Indicator);']);
    end
else
    set(hObject,'checked','on');
      for i=1:handles.NumberOfAxes
    eval(['makeInvisible(handles.Axis' num2str(i) 'Indicator);']);
      end
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function ResetLayout_Callback(hObject, eventdata, handles)
% hObject    handle to ResetLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

twelveset;
guidata(hObject,handles);


% --------------------------------------------------------------------
function ClearTitle_Callback(hObject, eventdata, handles)
% hObject    handle to ClearTitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for Temp=1:handles.NumberOfAxes
    eval(['axes(handles.axes' num2str(Temp) ');']);
    title(''); xlabel(''); ylabel('');
    eval(['handles.A' num2str(Temp) 'Annotations={'''','''',''''};']);
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function Axis10Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis10Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis10Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis10Markers as a double

CurrentAxisMarkerNumber=10;
UpdateMarkers;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Axis10Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis10Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function Axis11Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis11Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis11Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis11Markers as a double

CurrentAxisMarkerNumber=11;
UpdateMarkers;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Axis11Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis11Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Axis12Markers_Callback(hObject, eventdata, handles)
% hObject    handle to Axis12Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Axis12Markers as text
%        str2double(get(hObject,'String')) returns contents of Axis12Markers as a double

CurrentAxisMarkerNumber=12;
UpdateMarkers;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Axis12Markers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis12Markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function NineGraphs_Callback(hObject, eventdata, handles)
% hObject    handle to NineGraphs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nineset;

guidata(hObject,handles);

% --- Executes on button press in EditCmdFile.
function EditCmdFile_Callback(hObject, eventdata, handles)
% hObject    handle to EditCmdFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TempG=cellstr(get(handles.GraphCommandFiles,'string'));
CurrentGFile=TempG{get(handles.GraphCommandFiles,'value')};
if ~strcmp(CurrentGFile,'CmdFiles')
edit(CurrentGFile);
else fprintf('%s\n','Add a file first');
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function SigLevel_Callback(hObject, eventdata, handles)
% hObject    handle to SigLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

defaultanswer={num2str(handles.SignificanceCutoff)};    
    
       prompt={'Enter alpha'};
   name=['Significance alpha']; 
   numlines=1;

    answer=inputdlg(prompt,name,numlines,defaultanswer);

   if ~isempty(answer)

       sigalpha=str2num(answer{1});
       if isnumeric(sigalpha),
           handles.SignificanceCutoff=sigalpha;
           fprintf('%s\n',['Alpha set to [' answer{1} ' ]']);
       end
       
   end
    
guidata(hObject,handles);



%--- 

function FTPFileName_Callback(hObject, eventdata, handles)
% hObject    handle to FTPFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FTPFileName as text
%        str2double(get(hObject,'String')) returns contents of FTPFileName as a double

if isfield(handles,'FTP')
handles.FTP.filename=get(hObject,'string');
guidata(hObject,handles);
else
    fprintf('%s\n','Enter FTP Pathname from Menu: FTP Options first');
end

% --- Executes during object creation, after setting all properties.
function FTPFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FTPFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FTPMe.
function FTPMe_Callback(hObject, eventdata, handles)
% hObject    handle to FTPMe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


FTPScript;
guidata(hObject,handles);


% --------------------------------------------------------------------
function FTPRelated_Callback(hObject, eventdata, handles)
% hObject    handle to FTPRelated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FTPMode_Callback(hObject, eventdata, handles)
% hObject    handle to FTPMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'checked'),'on')
    set(hObject,'checked','off');
    makeInvisible([handles.FTPMe handles.FTPFileName handles.FTPUpdate]);
else
    set(hObject,'checked','on');
    makeVisible([handles.FTPMe handles.FTPFileName handles.FTPUpdate]);
end

guidata(hObject,handles);

% --------------------------------------------------------------------
function HelpTips_Callback(hObject, eventdata, handles)
% hObject    handle to HelpTips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% helpstring={'pwf is a file in the "Assorted" subdirectory of the root xex directory. It contains the information that ncftpget uses'};
% helpdlg(helpstring,'FTP information');

web('help.html');

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function ResetAxisProps_Callback(hObject, eventdata, handles)
% hObject    handle to ResetAxisProps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for TempVar=1:handles.NumberOfAxes
    eval(['set(handles.Axis' num2str(TempVar) 'Markers,''string'',''b-r-m-c-k-y-'');']);
end 

guidata(hObject,handles);


% --- Executes on selection change in XAxisVariable.
function XAxisVariable_Callback(hObject, eventdata, handles)
% hObject    handle to XAxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns XAxisVariable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XAxisVariable

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='XAxisVar';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function XAxisVariable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XAxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in X1AxisVariable.
function X1AxisVariable_Callback(hObject, eventdata, handles)
% hObject    handle to X1AxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns X1AxisVariable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from X1AxisVariable

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='X1AxisVar';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function X1AxisVariable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X1AxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in XAxisDiscretize.
function XAxisDiscretize_Callback(hObject, eventdata, handles)
% hObject    handle to XAxisDiscretize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of XAxisDiscretize


% --- Executes on button press in X1AxisDiscretize.
function X1AxisDiscretize_Callback(hObject, eventdata, handles)
% hObject    handle to X1AxisDiscretize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of X1AxisDiscretize



function XAxisCenters_Callback(hObject, eventdata, handles)
% hObject    handle to XAxisCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XAxisCenters as text
%        str2double(get(hObject,'String')) returns contents of XAxisCenters as a double

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='XAxisDiscreteVals';
UpdateSlider;
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function XAxisCenters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XAxisCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
function X1AxisCenters_Callback(hObject, eventdata, handles)
% hObject    handle to X1AxisCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X1AxisCenters as text
%        str2double(get(hObject,'String')) returns contents of X1AxisCenters as a double


ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='YAxisDiscreteVals';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function X1AxisCenters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X1AxisCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in YAxisVariable.
function YAxisVariable_Callback(hObject, eventdata, handles)
% hObject    handle to YAxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns YAxisVariable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YAxisVariable

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='YAxisVar';
UpdateSlider;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function YAxisVariable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YAxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in FTPUpdate.
function FTPUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to FTPUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FTPScript;
NextCommandSetBaseRate=0;
LoadGFXVar=0; UpdateCellOrLoadGFX;
fprintf('%s\n','Selected graphs updated');
guidata(hObject,handles);


% --------------------------------------------------------------------
function ShowObjWin_Callback(hObject, eventdata, handles)
% hObject    handle to ShowObjWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CurrentAxisHandle=gca;
CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);
CurrentEditWindow=handles.EditWindows(CurrentAxisNumber);

if strcmp(get(CurrentEditWindow,'visible'),'on')
    makeInvisible(CurrentEditWindow);
else makeVisible(CurrentEditWindow);
end

guidata(hObject,handles);

% --------------------------------------------------------------------
function AxisObj1_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj1 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj1 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj4_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj4 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj4 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj9_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj9 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj9 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj2_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj2 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj2 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj6_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj6 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj6 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj10_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj10 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj10 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj3_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj3 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj3 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj7_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj7 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj7 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj11_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj11 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj11 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj8_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj8 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj8 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj12_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj12 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj12 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AxisObj5_Callback(hObject, eventdata, handles)
% hObject    handle to AxisObj5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AxisObj5 as text
%        str2double(get(hObject,'String')) returns contents of AxisObj5 as a double


% --- Executes during object creation, after setting all properties.
function AxisObj5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AxisObj5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ShowAllObjWin_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAllObjWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CurrentEditWindows=handles.EditWindows;

if strcmp(get(hObject,'checked'),'off')
    set(hObject,'checked','on');
    for TemporaryVariable=1:handles.NumberOfAxes
    makeVisible(CurrentEditWindows(TemporaryVariable));
    end
    
else set(hObject,'checked','off');
    for TemporaryVariable=1:handles.NumberOfAxes
    makeInvisible(CurrentEditWindows(TemporaryVariable));
    end
    
end

guidata(hObject,handles);



% --------------------------------------------------------------------
function MakeLinkable_Callback(hObject, eventdata, handles)
% hObject    handle to MakeLinkable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LinkAxis_Callback(hObject, eventdata, handles)
% hObject    handle to LinkAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AxesList=handles.HandlesList;
AxisNum=find(gca==AxesList);

eval(['CurrentLinkState=get(handles.AxisLinkText' num2str(AxisNum) ',''visible'');']);

if strcmp(CurrentLinkState,'off')
    
setappdata(gca,'NumClicks',1);
set(gca,'buttondownfcn','LinkHandle');
hold on;
set(gca,'xgrid','on','ygrid','on');
eval(['makeVisible(handles.AxisLinkText' num2str(AxisNum) ');']);

else

    ToDel=getappdata(handles.HandlesList(AxisNum),'CurrentPointPlots');
delete(ToDel);
ToDel=getappdata(handles.HandlesList(AxisNum),'CurrentRect');
delete(ToDel);

UnlinkTheseAxes;

end

% % --------------------------------------------------------------------
% function UnlinkAxis_Callback(hObject, eventdata, handles)
% % hObject    handle to UnlinkAxis (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% AxesList=handles.HandlesList;
% AxisNum=find(gca==AxesList);
% 
% ToDel=getappdata(handles.HandlesList(AxisNum),'CurrentPointPlots');
% delete(ToDel);
% ToDel=getappdata(handles.HandlesList(AxisNum),'CurrentRect');
% delete(ToDel);
% 
% UnlinkTheseAxes;
% 
% % set(gca,'buttondownfcn','');
% % setappdata(gca,'NumClicks',1);
% 


% --- Executes on button press in ReverseXY.
function ReverseXY_Callback(hObject, eventdata, handles)
% hObject    handle to ReverseXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReverseXY




% --------------------------------------------------------------------
function Documentation_Callback(hObject, eventdata, handles)
% hObject    handle to Documentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

web('C:/MATLAB/work/XeX/XeXDocumentation/index.html');


% --- Executes during object creation, after setting all properties.
function DelTrials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DelTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


