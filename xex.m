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

% Last Modified by GUIDE v2.5 03-Dec-2012 07:00:38

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

% Set attribute to indicate we're in startup mode
handles.inOpeningFcn = 1;

% Get configuration
handles.config = read_xex_config();

handles.config.xexDir = xexDir;
% Set working directory
if isempty(handles.config.xexWorkDir)
	handles.config.xexWorkDir = [handles.config.xexDir filesep 'work'];
end
if ~exist(handles.config.xexWorkDir, 'dir')
	try
		mkdir(handles.config.xexWorkDir);
	catch
		warnmsg = 'The xex work directory, "%s", does not exist, and an attempt to create it failed. You will need to create it manually.';
		warning(warnmsg, handles.config.xexWorkDir);
	end
end

% Set closing function
set(handles.figure1, 'CloseRequestFcn', @xex_CloseRequestFcn);

% Update the AvailableSessions listbox
handles = UpdateAvailableSessions(handles);
handles.UpdateAvailableSessionsFx = @UpdateAvailableSessions;

% Update the AnalysisFunction popupmenu
handles = UpdateAnalysisFunction(handles);

% Choose default command line output for xex
handles.output = hObject;

% Set attribute to indicate we're no longer in startup mode
handles.inOpeningFcn = 0;

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


% --- Executes on button press in ChangeXexWorkDirButton.
function ChangeXexWorkDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeXexWorkDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newWorkDir = uigetdir(handles.config.xexWorkDir, 'Select Data Directory');
if newWorkDir ~= 0
	handles.config.xexWorkDir = newWorkDir;
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in GetSessionsFromServerButton.
function GetSessionsFromServerButton_Callback(hObject, eventdata, handles)
% hObject    handle to GetSessionsFromServerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% keyboard;
% set(handles.figure1, 'Visible', 'off');
% try
handles = xex_ftp(handles);
	% set(handles.figure1, 'Visible', 'on');
% catch
% 	set(handles.figure1, 'Visible', 'on');
% end


% --- Executes on selection change in SelectAnalysisFunctionPopupmenu.
function SelectAnalysisFunctionPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SelectAnalysisFunctionPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelectAnalysisFunctionPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectAnalysisFunctionPopupmenu

handles = UpdateAnalysisFunction(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SelectAnalysisFunctionPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectAnalysisFunctionPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AnalyzeSelectedSessionButton.
function AnalyzeSelectedSessionButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyzeSelectedSessionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% AnalysisFunctionStr = handles.config.AnalysisFunction;
% if isempty(AnalysisFunctionStr)
% 	AnalysisFunctionStr = [handles.config.xexDir filesep 'analysis_functions' filesep 'dummy_analysis_function.m'];
% end

AnalysisFunctionName = handles.SelectedAnalysisFunctionInfo.AnalysisFunctionName;
AnalysisFunctionHandle = handles.SelectedAnalysisFunctionInfo.AnalysisFunctionHandle;
SessionName = handles.SelectedSessionInfo.SessionName;
Matfile = handles.SelectedSessionInfo.Matfile;

% AvailableSessionInfo = GetAvailableSessionInfo(handles);
% SelectedSessionInfo = AvailableSessionInfo(get(handles.AvailableSessions, 'Value'));

try
	load(Matfile);
catch
	disp(['Error loading ' Matfile '. Creating empty Trials struct.']);
	Trials = [];
end
disp(['Analyzing session ' SessionName ' using ' AnalysisFunctionName '.'])
feval(AnalysisFunctionHandle, Trials);


% --- Executes on attempt to close xex.
function xex_CloseRequestFcn(hObject, eventdata)
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB

user_response = questdlg('Do you really want to close xex?', ...
                         'Confirm Close', ...
                         'Yes', 'No',...
                         'No');
if strcmp(user_response, 'Yes')
	delete(hObject);
end


% --- Used to updated the AnalysisFunctionPopupmenu widget
function handles = UpdateAnalysisFunction(handles)

AnalysisFunctionInfo = GetAnalysisFunctionInfo(handles);
AnalysisFunctionNames = {AnalysisFunctionInfo.AnalysisFunctionName};
set(handles.SelectAnalysisFunctionPopupmenu, 'String', AnalysisFunctionNames);
if handles.inOpeningFcn
	SelectAnalysisFunctionIdx = min(find(strcmp(handles.config.AnalysisFunction, {AnalysisFunctionInfo.AnalysisFunctionName})));
	if ~isempty(SelectAnalysisFunctionIdx)
		set(handles.SelectAnalysisFunctionPopupmenu, 'Value', SelectAnalysisFunctionIdx);
	end
end
handles.SelectedAnalysisFunctionInfo = AnalysisFunctionInfo(get(handles.SelectAnalysisFunctionPopupmenu, 'Value'));


% --- Used to get info on functions in xexWorkDirText
function AnalysisFunctionInfo = GetAnalysisFunctionInfo(handles)

MFileSuffix = '.m';
MFileRegexSuffix = [strrep(MFileSuffix, '.', '\.') '$'];

AnalysisFunctionDir = handles.config.AnalysisFunctionDir;
% AnalysisFunctionDir = regexprep(AnalysisFunctionDir, ['^' regexptranslate('escape', ['.' filesep])], [handles.config.xexDir filesep]);
AnalysisFunctionDir = regexprep(AnalysisFunctionDir, ['^' regexptranslate('escape', ['.' filesep])], regexptranslate('escape', [handles.config.xexDir filesep]));
if isempty(AnalysisFunctionDir)
	AnalysisFunctionDir = [handles.config.xexDir filesep 'analysis_function_library\common'];
end
AnalysisFunctionDir = regexprep(AnalysisFunctionDir, '\\$', '');

DirContents = dir(AnalysisFunctionDir);
FileNames = {DirContents.name};
MFiles = FileNames(~cellfun('isempty', regexp(FileNames, MFileRegexSuffix)));
AnalysisFunctionPathStrs = strcat([AnalysisFunctionDir filesep], MFiles);
% keyboard;
AnalysisFunctionInfo.AnalysisFunctionPathStr = '';
AnalysisFunctionInfo.AnalysisFunctionName = '<empty>';
AnalysisFunctionInfo.AnalysisFunctionHandle = @(Trials) disp(['No analysis functions available. Functions should be placed in ' AnalysisFunctionDir]);

for ii = 1 : length(MFiles)
	AnalysisFunctionInfo(ii).AnalysisFunctionPathStr = AnalysisFunctionPathStrs{ii};
	[AnalysisFunctionDir, AnalysisFunctionName] = fileparts(which(AnalysisFunctionPathStrs{ii}));
	AnalysisFunctionInfo(ii).AnalysisFunctionName = regexprep(AnalysisFunctionName, MFileRegexSuffix, '');
	% This is a clunky workaround to make a function_handle out of a string.
	OldDir = pwd;
	cd(AnalysisFunctionDir);
	AnalysisFunctionInfo(ii).AnalysisFunctionHandle = str2func(AnalysisFunctionName);
	cd(OldDir);
end


% --- Used to updated the AvailableSessions widget
function handles = UpdateAvailableSessions(handles)

AvailableSessionInfo = GetAvailableSessionInfo(handles);
SessionInfoStrs = {AvailableSessionInfo.SessionInfoStr};
set(handles.AvailableSessions, 'String', SessionInfoStrs);
handles.SelectedSessionInfo = AvailableSessionInfo(get(handles.AvailableSessions, 'Value'));


% --- Used to get info on sessions in xexWorkDirText
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

% AllSessions = unique([ASessions, ESessions, FormattedSessions, AnalyzedSessions]);
AllSessions = unique(FormattedSessions);
if isempty(AllSessions)
	AllSessions = {''};
end
for ii = 1 : length(AllSessions)
	AvailableSessionInfo(ii).SessionName = AllSessions{ii};
	% AvailableSessionInfo(ii).ASession = ismember(AllSessions{ii}, ASessions);
	% AvailableSessionInfo(ii).ESession = ismember(AllSessions{ii}, ESessions);
	% AvailableSessionInfo(ii).FormattedSession = ismember(AllSessions{ii}, FormattedSessions);
	% AvailableSessionInfo(ii).AnalyzedSession = ismember(AllSessions{ii}, AnalyzedSessions);
	
	% SessionInfoStr = [AvailableSessionInfo(ii).SessionName ' - '];
	% if AvailableSessionInfo(ii).ASession
	% 	SessionInfoStr = [SessionInfoStr 'A,'];
	% end
	% if AvailableSessionInfo(ii).ESession
	% 	SessionInfoStr = [SessionInfoStr 'E,'];
	% end
	% if AvailableSessionInfo(ii).FormattedSession
	% 	SessionInfoStr = [SessionInfoStr 'Formatted,'];
	% end
	% if AvailableSessionInfo(ii).AnalyzedSession
	% 	SessionInfoStr = [SessionInfoStr 'Analyzed,'];
	% end
	% AvailableSessionInfo(ii).SessionInfoStr = regexprep(SessionInfoStr, ',$', '');
	AvailableSessionInfo(ii).SessionInfoStr = AvailableSessionInfo(ii).SessionName;
	AvailableSessionInfo(ii).Matfile = [handles.config.xexWorkDir filesep AvailableSessionInfo(ii).SessionName MatFileSuffix];
end


% --- Used to read config.txt
function config = read_xex_config()
	
field_pattern = '(?<field>^\w+):';
base_val_pattern = ':\s*(?<val>\S+.*)';

xexdir = fileparts(which('xex'));
defaultconfigfile = [xexdir filesep 'config' filesep 'default_xex_config_do_not_edit.txt'];
configfile = [xexdir filesep 'config' filesep 'xex_config.txt'];
if ~exist(configfile)
	copyfile(defaultconfigfile, configfile);
end
fid = fopen(configfile, 'r');
try
	while ~feof(fid)
		line = fgetl(fid);
		fieldname = regexp(line, field_pattern, 'tokens');
		if isempty(fieldname)
			continue;
		end
		fieldname = fieldname{1}{1};
		val_pattern = [regexptranslate('escape', fieldname) base_val_pattern];
		value = regexp(line, val_pattern, 'tokens');
		if ~isempty(value)
			value = value{1}{1};
		else
			value = '';
		end
		config.(fieldname) = value;
	end
	fclose(fid);
catch
	fclose(fid);
end


