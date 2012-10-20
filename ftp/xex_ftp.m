function varargout = xex_FTP(varargin)
% XEX_FTP M-file for xex_FTP.fig
%      XEX_FTP, by itself, creates a new XEX_FTP or raises the existing
%      singleton*.
%
%      H = XEX_FTP returns the handle to a new XEX_FTP or the handle to
%      the existing singleton*.
%
%      XEX_FTP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XEX_FTP.M with the given input arguments.
%
%      XEX_FTP('Property','Value',...) creates a new XEX_FTP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xex_FTP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xex_FTP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xex_FTP

% Last Modified by GUIDE v2.5 18-Oct-2012 13:16:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xex_FTP_OpeningFcn, ...
                   'gui_OutputFcn',  @xex_FTP_OutputFcn, ...
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


% --- Executes just before xex_FTP is made visible.
function xex_FTP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xex_FTP (see VARARGIN)


callerHandles = varargin{1};

server_info = get_ftp_server_info();
servernames = {server_info.hostname};
PopupmenuStr = ['(Choose server)' servernames];
set(handles.PreconfiguredLoginPopupmenu, 'String', PopupmenuStr);
set(handles.ServerIPEdit, 'String', callerHandles.config.FTP.ServerIP);
set(handles.UsernameEdit, 'String', callerHandles.config.FTP.ServerUsername);
set(handles.PasswordEdit, 'String', callerHandles.config.FTP.ServerPassword);
set(handles.ServerDataDirectoryEdit, 'String', callerHandles.config.FTP.ServerDataDir);
UpdatePopupFromLogin(handles);

% Choose default command line output for xex_FTP
% handles.output = hObject;
handles.output = callerHandles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xex_FTP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xex_FTP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ServerDataDirectoryEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ServerDataDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ServerDataDirectoryEdit as text
%        str2double(get(hObject,'String')) returns contents of ServerDataDirectoryEdit as a double


% --- Executes during object creation, after setting all properties.
function ServerDataDirectoryEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ServerDataDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SessionNamesEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SessionNamesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SessionNamesEdit as text
%        str2double(get(hObject,'String')) returns contents of SessionNamesEdit as a double


% --- Executes during object creation, after setting all properties.
function SessionNamesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SessionNamesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GetSessionsNowButton.
function GetSessionsNowButton_Callback(hObject, eventdata, handles)
% hObject    handle to GetSessionsNowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FTPConfig = GetFTPConfig(handles);
% keyboard;

function ServerIPEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ServerIPEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ServerIPEdit as text
%        str2double(get(hObject,'String')) returns contents of ServerIPEdit as a double

UpdatePopupFromLogin(handles);


% --- Executes during object creation, after setting all properties.
function ServerIPEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ServerIPEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UsernameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to UsernameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UsernameEdit as text
%        str2double(get(hObject,'String')) returns contents of UsernameEdit as a double

UpdatePopupFromLogin(handles);


% --- Executes during object creation, after setting all properties.
function UsernameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UsernameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PasswordEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PasswordEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PasswordEdit as text
%        str2double(get(hObject,'String')) returns contents of PasswordEdit as a double

UpdatePopupFromLogin(handles);


% --- Executes during object creation, after setting all properties.
function PasswordEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PasswordEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PreconfiguredLoginPopupmenu.
function PreconfiguredLoginPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PreconfiguredLoginPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PreconfiguredLoginPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PreconfiguredLoginPopupmenu

% keyboard;

UpdateLoginFromPopup(handles);


% --- Executes during object creation, after setting all properties.
function PreconfiguredLoginPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreconfiguredLoginPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function UpdateLoginFromPopup(handles)
% handles    structure with handles and user data (see GUIDATA)

server_info = get_ftp_server_info();
servernames = {server_info.hostname};
PopupmenuStr = get(handles.PreconfiguredLoginPopupmenu, 'String');
selected_server_name = PopupmenuStr(get(handles.PreconfiguredLoginPopupmenu, 'Value'));

if ismember(selected_server_name, servernames)
	server_idx = find(strcmp(selected_server_name, servernames));
	% keyboard;
	set(handles.ServerIPEdit, 'String', server_info(server_idx).IP);
	set(handles.UsernameEdit, 'String', server_info(server_idx).username);
	set(handles.PasswordEdit, 'String', server_info(server_idx).password);
end


function UpdatePopupFromLogin(handles)
% handles    structure with handles and user data (see GUIDATA)

server_info = get_ftp_server_info();
serverIPs = {server_info.IP};
usernames = {server_info.username};
passwords = {server_info.password};

FTPConfig = GetFTPConfig(handles);

server_idx = find(strcmp(FTPConfig.ServerIP, serverIPs) & strcmp(FTPConfig.Username, usernames) & strcmp(FTPConfig.Password, passwords));
if ~isempty(server_idx)
	popup_idx = server_idx + 1;
	set(handles.PreconfiguredLoginPopupmenu, 'Value', popup_idx);
else
	set(handles.PreconfiguredLoginPopupmenu, 'Value', 1);
end
% keyboard;


function FTPConfig = GetFTPConfig(handles)

FTPConfig.ServerIP = get(handles.ServerIPEdit, 'String');
FTPConfig.Username = get(handles.UsernameEdit, 'String');
FTPConfig.Password = get(handles.PasswordEdit, 'String');
FTPConfig.ServerDataDirectory = get(handles.ServerDataDirectoryEdit, 'String');
FTPConfig.SessionNames = ParseSessionNames(handles);


function SessionNames = ParseSessionNames(handles)

delim = ',';

SessionNames = {};
SessionNameStr = get(handles.SessionNamesEdit, 'String');
while ~isempty(SessionNameStr)
	[NextSessionStr, SessionNameStr] = strtok(SessionNameStr, delim);
	SessionNames{end+1} = strtrim(NextSessionStr);
	% keyboard;
end