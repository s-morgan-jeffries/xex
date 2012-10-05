function varargout = EnterAxisVariables(varargin)
% ENTERAXISVARIABLES M-file for EnterAxisVariables.fig
%	 Meant solely to be called from XeX
%	 To enter axis variables for plotting tuning curves.
%      ENTERAXISVARIABLES, by itself, creates a new ENTERAXISVARIABLES or raises the existing
%      singleton*.
%
%      H = ENTERAXISVARIABLES returns the handle to a new ENTERAXISVARIABLES or the handle to
%      the existing singleton*.
%
%      ENTERAXISVARIABLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENTERAXISVARIABLES.M with the given input arguments.
%
%      ENTERAXISVARIABLES('Property','Value',...) creates a new ENTERAXISVARIABLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EnterAxisVariables_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EnterAxisVariables_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help EnterAxisVariables

% Last Modified by GUIDE v2.5 22-Oct-2005 13:43:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EnterAxisVariables_OpeningFcn, ...
                   'gui_OutputFcn',  @EnterAxisVariables_OutputFcn, ...
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


% --- Executes just before EnterAxisVariables is made visible.
function EnterAxisVariables_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EnterAxisVariables (see VARARGIN)

% Choose default command line output for EnterAxisVariables
handles.output = hObject;

if length(varargin)>=1, handles.MyVariableList=varargin{1}; handles.ResponseVariableList=varargin{2}; PresetVariables=varargin{3};
    
    TemporaryVariable=varargin{2}; TemporaryVariable{end+1}='SpikeRate'; handles.ResponseVariableList=TemporaryVariable;
    
    set(handles.XAxisVariable,'string',handles.MyVariableList);
    set(handles.X1AxisVariable,'string',handles.MyVariableList);
    set(handles.YAxisMeasure,'string',handles.ResponseVariableList);

    findx=find(strcmp(handles.MyVariableList,PresetVariables.XAxisVariable));
    if ~isempty(findx), set(handles.XAxisVariable,'value',findx(1));
    else findrfx=find(strcmp(handles.MyVariableList,'RFx'));
        if ~isempty(findrfx), set(handles.XAxisVariable,'value',findrfx(1));
        else set(handles.XAxisVariable,'value',1);
        end
    end
    
    findx1=find(strcmp(handles.MyVariableList,PresetVariables.X1AxisVariable));
    if ~isempty(findx1), set(handles.X1AxisVariable,'value',findx1(1));
    else findrfy=find(strcmp(handles.MyVariableList,'RFy'));
        if ~isempty(findrfy), set(handles.X1AxisVariable,'value',findrfy(1));
        else set(handles.X1AxisVariable,'value',1);
        end
    end

    findy=find(strcmp(handles.ResponseVariableList,PresetVariables.YAxisVariableStr));
    if ~isempty(findy), set(handles.YAxisMeasure,'value',findy(1));
    else findy=find(strcmp(handles.MyVariableList,'SpikeRate'));
        if ~isempty(findy), set(handles.YAxisMeasure,'value',findy(1));
        else set(handles.YAxisMeasure,'value',1);
        end
    end
    
   
    set(handles.DiscretizeX,'value',PresetVariables.DiscretizeX);
    set(handles.DiscretizeX1,'value',PresetVariables.DiscretizeX1);
    set(handles.XAxisCenters,'string',PresetVariables.XAxisCentersStr);
    set(handles.X1AxisCenters,'string',PresetVariables.X1AxisCentersStr);
   
% MyVariableChoices.XAxisCentersStr=get(handles.XAxisCenters,'string');
% MyVariableChoices.X1AxisCentersStr=get(handles.X1AxisCenters,'string');
    
    
end

set(gcf,'CloseRequestFcn','disp(''Hit OK or Cancel. You cannot close this GUI like that.'')');
set(hObject,'WindowStyle','modal')

% Update handles structure
guidata(hObject, handles);
uiwait;

% UIWAIT makes EnterAxisVariables wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EnterAxisVariables_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);


% --- Executes on selection change in XAxisVariable.
function XAxisVariable_Callback(hObject, eventdata, handles)
% hObject    handle to XAxisVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns XAxisVariable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XAxisVariable


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


% --- Executes on button press in DiscretizeX.
function DiscretizeX_Callback(hObject, eventdata, handles)
% hObject    handle to DiscretizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DiscretizeX


% --- Executes on button press in DiscretizeX1.
function DiscretizeX1_Callback(hObject, eventdata, handles)
% hObject    handle to DiscretizeX1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DiscretizeX1



function XAxisCenters_Callback(hObject, eventdata, handles)
% hObject    handle to XAxisCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XAxisCenters as text
%        str2double(get(hObject,'String')) returns contents of XAxisCenters as a double


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



function X1AxisCenters_Callback(hObject, eventdata, handles)
% hObject    handle to X1AxisCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X1AxisCenters as text
%        str2double(get(hObject,'String')) returns contents of X1AxisCenters as a double


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


% --- Executes on selection change in YAxisMeasure.
function YAxisMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to YAxisMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns YAxisMeasure contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YAxisMeasure


% --- Executes during object creation, after setting all properties.
function YAxisMeasure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YAxisMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in OKButton.
function OKButton_Callback(hObject, eventdata, handles)
% hObject    handle to OKButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GetVariableChoices;
MyVariableChoices.OK=1;

handles.output=MyVariableChoices;
guidata(hObject,handles);
uiresume;

% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GetVariableChoices;
MyVariableChoices.OK=0;
handles.output=MyVariableChoices;
guidata(hObject,handles);
uiresume;

