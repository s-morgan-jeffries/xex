function varargout = xex(varargin)
% XEX M-file for xex.fig
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
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xex_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xex_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xex

% Last Modified by GUIDE v2.5 17-Oct-2012 21:28:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xex_OpeningFcn, ...
                   'gui_OutputFcn',  @xex_OutputFcn, ...
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


% --- Executes just before xex is made visible.
function xex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xex (see VARARGIN)

% Add what we need to the path
xexDir = fileparts(which('xex'));
addpath(genpath(xexDir),'-begin');

% Get configuration
handles.config = get_xex_config();

handles.config.xexDir = xexDir;
% Set working directory
if isempty(handles.config.xexWorkDir)
	handles.config.xexWorkDir = [handles.config.xexDir filesep 'work'];
end

% Set closing function
set(handles.figure1, 'CloseRequestFcn', @xex_CloseRequestFcn);

% Update the AvailableSessions listbox
handles = UpdateAvailableSessions(handles);

% Choose default command line output for xex
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xex wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xex_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in AvailableSessions.
function AvailableSessions_Callback(hObject, eventdata, handles)
% hObject    handle to AvailableSessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns AvailableSessions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AvailableSessions

handles = UpdateAvailableSessions(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function AvailableSessions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AvailableSessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GetRemoteDataButton.
function GetRemoteDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to GetRemoteDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keyboard;
handles = xex_ftp(handles);


% --- Executes on button press in AnalyzeDataButton.
function AnalyzeDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyzeDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PlotDataButton.
function PlotDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SelectxexWorkDirButton.
function SelectxexWorkDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectxexWorkDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newWorkDir = uigetdir(handles.config.xexWorkDir, 'Select Data Directory');
if newWorkDir ~= 0
	handles.config.xexWorkDir = newWorkDir;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on attempt to close xex.
function xex_CloseRequestFcn(hObject, eventdata)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


user_response = questdlg('Do you really want to close xex?', ...
                         'Confirm Close', ...
                         'Yes', 'No',...
                         'No');

if strcmp(user_response, 'Yes')
	delete(hObject);
end


% --- Used to updated the AvailableSessions widget
function handles = UpdateAvailableSessions(handles)

AvailableSessionInfo = GetAvailableSessionInfo(handles);
SessionInfoStrs = {AvailableSessionInfo.SessionInfoStr};
set(handles.AvailableSessions, 'String', SessionInfoStrs);
handles.SelectedSessionInfo = AvailableSessionInfo(get(handles.AvailableSessions, 'Value'));

% % Update handles structure
% hObject = handles.figure1;
% guidata(hObject, handles);


% --- Used to get info on sessions in xexWorkDir
function AvailableSessionInfo = GetAvailableSessionInfo(handles)

AFileSuffix = 'A';
AFileRegexSuffix = [strrep(AFileSuffix, '.', '\.') '$'];
EFileSuffix = 'E';
EFileRegexSuffix = [strrep(EFileSuffix, '.', '\.') '$'];
MatFileSuffix = '.mat';
MatFileRegexSuffix = [strrep(MatFileSuffix, '.', '\.') '$'];
AnalyzedFileSuffix = '.Analyzed.mat';
AnalyzedFileRegexSuffix = [strrep(AnalyzedFileSuffix, '.', '\.') '$'];

DirContents = dir(handles.config.xexWorkDir);
FileNames = {DirContents.name};

AFileMask = ~cellfun('isempty', regexp(FileNames, AFileRegexSuffix));
EFileMask = ~cellfun('isempty', regexp(FileNames, EFileRegexSuffix));
MatFileMask = ~cellfun('isempty', regexp(FileNames, MatFileRegexSuffix));
AnalyzedFileMask = ~cellfun('isempty', regexp(FileNames, AnalyzedFileRegexSuffix));
FormattedFileMask = MatFileMask & ~AnalyzedFileMask;


ASessions = regexprep(FileNames(AFileMask), AFileRegexSuffix, '');
ESessions = regexprep(FileNames(EFileMask), EFileRegexSuffix, '');
FormattedSessions = regexprep(FileNames(FormattedFileMask), MatFileRegexSuffix, '');
AnalyzedSessions = regexprep(FileNames(AnalyzedFileMask), AnalyzedFileRegexSuffix, '');

AllSessions = unique([ASessions, ESessions, FormattedSessions, AnalyzedSessions]);
for ii = 1 : length(AllSessions)
	AvailableSessionInfo(ii).SessionName = AllSessions{ii};
	AvailableSessionInfo(ii).ASession = ismember(AllSessions{ii}, ASessions);
	AvailableSessionInfo(ii).ESession = ismember(AllSessions{ii}, ESessions);
	AvailableSessionInfo(ii).FormattedSession = ismember(AllSessions{ii}, FormattedSessions);
	AvailableSessionInfo(ii).AnalyzedSession = ismember(AllSessions{ii}, AnalyzedSessions);
	
	SessionInfoStr = [AvailableSessionInfo(ii).SessionName ' - '];
	if AvailableSessionInfo(ii).ASession
		SessionInfoStr = [SessionInfoStr 'A,'];
	end
	if AvailableSessionInfo(ii).ESession
		SessionInfoStr = [SessionInfoStr 'E,'];
	end
	if AvailableSessionInfo(ii).FormattedSession
		SessionInfoStr = [SessionInfoStr 'Formatted,'];
	end
	if AvailableSessionInfo(ii).AnalyzedSession
		SessionInfoStr = [SessionInfoStr 'Analyzed,'];
	end
	AvailableSessionInfo(ii).SessionInfoStr = regexprep(SessionInfoStr, ',$', '');
end