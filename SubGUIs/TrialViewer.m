function varargout = TrialViewer(varargin)
% TRIALVIEWER M-file for TrialViewer.fig
%      TRIALVIEWER, by itself, creates a new TRIALVIEWER or raises the existing
%      singleton*.
%      To be opened from within XeX, this is a single trial viewer.
%      H = TRIALVIEWER returns the handle to a new TRIALVIEWER or the handle to
%      the existing singleton*.
%
%      TRIALVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIALVIEWER.M with the given input arguments.
%
%      TRIALVIEWER('Property','Value',...) creates a new TRIALVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrialViewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrialViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help TrialViewer

% Last Modified by GUIDE v2.5 28-Nov-2005 07:26:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrialViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @TrialViewer_OutputFcn, ...
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


% --- Executes just before TrialViewer is made visible.
function TrialViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrialViewer (see VARARGIN)

% Choose default command line output for TrialViewer
handles.output = hObject;
zoom on;
handles.TrialIndex=1;

handles.Trials=getappdata(0,'ViewTrials');
handles.SaccadeOptions=getappdata(0,'SaccadeOptions');

% if length(varargin)>=2,
% handles.sacparameters=varargin{2};
axes(handles.axes1);
handles.CurrentTitle=title(['Trial Number   ' num2str(handles.TrialIndex)]);

[Kodes,Tims]=getCodesAndTimes(handles.Trials,handles.TrialIndex);
if ~isempty(find(Kodes==1012))
set(handles.CurrentTitle,'string',['Trial Number   ' num2str(handles.TrialIndex) '     A Good Trial']);
else
set(handles.CurrentTitle,'string',['Trial Number   ' num2str(handles.TrialIndex) '     A Bad Trial']);
end

PlotEye(handles.Trials,handles.TrialIndex,[handles.axes1 handles.axes2 handles.axes3]);

% end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrialViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrialViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in TrialsList.
function TrialsList_Callback(hObject, eventdata, handles)
% hObject    handle to TrialsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TrialsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TrialsList

ListOfCells=get(hObject,'String');
handles.TrialIndex=str2num(ListOfCells{get(hObject,'Value')}); %tedious because will be same as value, but still...
childs=get(gcf,'children'); 


[Kodes,Tims]=getCodesAndTimes(handles.Trials,handles.TrialIndex);
if ~isempty(find(Kodes==1012))
set(handles.CurrentTitle,'string',['Trial Number   ' num2str(handles.TrialIndex) '     A Good Trial']);
else
set(handles.CurrentTitle,'string',['Trial Number   ' num2str(handles.TrialIndex) '     A Bad Trial']);
end

% axes(childs(1)); cla;
% axes(childs(2)); cla;

PlotEye(handles.Trials,handles.TrialIndex,[handles.axes1 handles.axes2 handles.axes3]);

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function TrialsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrialsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',cellstr(num2str((1:length(getappdata(0,'ViewTrials')))')));

guidata(hObject,handles);

