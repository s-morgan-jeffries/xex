function varargout = FilterManagerGUI(varargin)
% FILTERMANAGERGUI M-file for FilterManagerGUI.fig
%      FILTERMANAGERGUI, by itself, creates a new FILTERMANAGERGUI or raises the existing
%      singleton*.
%       Meant to be called from XeX, but can probably be used from outside as well (but untested, 
%	   may depend on global variables).
%      Opens the filter manager.
%
%      H = FILTERMANAGERGUI returns the handle to a new FILTERMANAGERGUI or the handle to
%      the existing singleton*.
%
%      FILTERMANAGERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERMANAGERGUI.M with the given input arguments.
%
%      FILTERMANAGERGUI('Property','Value',...) creates a new FILTERMANAGERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FilterManagerGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FilterManagerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help FilterManagerGUI

% Last Modified by GUIDE v2.5 02-Feb-2006 20:28:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FilterManagerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FilterManagerGUI_OutputFcn, ...
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


% --- Executes just before FilterManagerGUI is made visible.
function FilterManagerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FilterManagerGUI (see VARARGIN)

% Choose default command line output for FilterManagerGUI
handles.output = hObject;
set(handles.figure1,'windowstyle','docked');
setappdata(0,'FilterGUIHandle',handles.figure1);
set(handles.figure1,'CloseRequestFcn','FilterGUIclosereq');
makeInvisible(handles.EditMyFilters);
set(handles.EditOrSave,'string','E');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FilterManagerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FilterManagerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on selection change in MyFilters.
function MyFilters_Callback(hObject, eventdata, handles)
% hObject    handle to MyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns MyFilters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MyFilters



% --- Executes during object creation, after setting all properties.
function MyFilters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SendFilters.
function SendFilters_Callback(hObject, eventdata, handles)
% hObject    handle to SendFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TrialFilterHandle=getappdata(0,'TrialFilterHandle');
UseFilterHandle=getappdata(0,'UseFilterHandle');
HoldFilterHandle=getappdata(0,'HoldFilterHandle');
UsePlottingHandle=getappdata(0,'UsePlottingHandle');

CurrentFilterSet=get(handles.SelectedFilters,'string');
CurrentFilters=CurrentFilterSet; %(get(handles.SelectedFilters,'value'));
% keyboard;

testfilter=ones(1,length(CurrentFilters));

for TempVar=1:length(testfilter)
    testme=strtok(CurrentFilters{TempVar});
    if ~isempty(strfind(testme,'#')) || isempty(testme) || ~isempty(strfind(testme,'*'))||~isempty(strfind(testme,'%'))
        testfilter(TempVar)=0;
    end
end

CurrentFilters=CurrentFilters(logical(testfilter));

% this is just a safety measure !

WhereNew=find(strcmp(CurrentFilters,'NEWAXIS'));

if ~isempty(WhereNew)
    
    Testa=[1 WhereNew' length(CurrentFilters)];
    DTest=diff(Testa);
    
    if any(DTest>1)
set(HoldFilterHandle,'value',1);
    end

end

set(TrialFilterHandle,'string',(CurrentFilters));
% set(UseFilterHandle,'value',1);
% set(UsePlottingHandle,'value',1);

figure(getappdata(0,'XeXGUIHandle'));

% --- Executes on button press in SaveFilters.
function SaveFilters_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Old_Dir=pwd;

if isfield(handles,'pathname'), cd(handles.pathname);
else
try,
    cd('c:\matlab\work\MyFilters\');
catch,
end
end


     [filename, pathname, filterindex] = uiputfile( ...
       {'*_xexFilt.txt','XeX filter files (*_xexFilt.txt)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Save/Append Filter as', 'MyNew_xexFilt.txt');
 
    if ~isnumeric(filename),

        fid=fopen([pathname filename],'a+');
       
        handles.filterpath=pathname;
        
        if fid~=-1,
            
        CurrentFilterSet=get(handles.MyFilters,'string');
        
        for TempInd=1:length(CurrentFilterSet)
            fprintf(fid,'%s\n',CurrentFilterSet{TempInd});
        end
        
        fclose(fid);
        
        else fprintf('%s\n','Some problem.. Not saved');
            
        end
        
    end


cd(Old_Dir);
guidata(hObject,handles);

% --- Executes on button press in ReadFilters.
function ReadFilters_Callback(hObject, eventdata, handles)
% hObject    handle to ReadFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


Old_Dir=pwd;

if isfield(handles,'pathname'), cd(handles.pathname);
else
try,
    cd('c:\matlab\work\MyFilters\');
catch,
end
end

   [input_filename, input_pathname] = uigetfile( ...
       {'*_xexFilt.txt','XeX filter files (*_xexFilt.txt)';
        '*.*',  'All Files (*.*)'}, ...
        'Read Filter file', ...
        'MultiSelect', 'off');

    %%loading the files

     if ~isnumeric(input_filename)

         cd(input_pathname);
         handles.pathname=input_pathname;
         fid=fopen(input_filename);
         
    c=textscan(fid,'%s','delimiter','\n');

if ~isempty(c{1}), 
    
set(handles.MyFilters,'string',c{1},'value',1);
    
  else    fprintf('%s\n','That aint a valid filter file'); end

     end

cd(Old_Dir);
guidata(hObject,handles);

% --- Executes on button press in EditFilters.
function EditFilters_Callback(hObject, eventdata, handles)
% hObject    handle to EditFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Old_Dir=pwd;

if isfield(handles,'pathname'), cd(handles.pathname);
else
try,
    cd('c:\matlab\work\MyFilters\');
catch,
end
end


   [input_filename, input_pathname] = uigetfile( ...
       {'*_xexFilt.txt','XeX filter files (*_xexFilt.txt)';
        '*.*',  'All Files (*.*)'}, ...
        'Edit Filter File', ...
        'MultiSelect', 'off');

    %%loading the files

     if ~isnumeric(input_filename)

handles.pathname=input_pathname;
         edit([input_pathname input_filename]);
     end
cd(Old_Dir);
guidata(hObject,handles);


% --- Executes on button press in BackToXeX.
function BackToXeX_Callback(hObject, eventdata, handles)
% hObject    handle to BackToXeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure(getappdata(0,'XeXGUIHandle'));


% --- Executes on selection change in SelectedFilters.
function SelectedFilters_Callback(hObject, eventdata, handles)
% hObject    handle to SelectedFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SelectedFilters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectedFilters


% --- Executes during object creation, after setting all properties.
function SelectedFilters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectedFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RemoveItems.
function RemoveItems_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveItems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.SelectedFilters,'String'));
CurrentlySelectedFiles=get(handles.SelectedFilters,'Value');

contents(CurrentlySelectedFiles)=[];

if ~isempty(contents)
set(handles.SelectedFilters,'String',contents,'value',1);
else
    set(handles.SelectedFilters,'String','','Value',1);
end



% --- Executes on button press in UpButton.
function UpButton_Callback(hObject, eventdata, handles)
% hObject    handle to UpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.SelectedFilters,'String'));
CurrentSelections=sort(get(handles.SelectedFilters,'Value'));

for ind=1:length(CurrentSelections)
    sel=CurrentSelections(ind);
    
    if sel~=1
        bak=contents(sel-1);
        contents(sel-1)=contents(sel);
        contents(sel)=bak;
        set(handles.SelectedFilters,'string',contents);
    else
        fprintf('%s\n','Sorry, that is it. Top of stack for item no. 1');
    end
end

newvals=CurrentSelections-1;
newvals(newvals==0)=1;
set(handles.SelectedFilters,'value',newvals);

guidata(hObject,handles);

% --- Executes on button press in ToOrg.
function ToOrg_Callback(hObject, eventdata, handles)
% hObject    handle to ToOrg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.MyFilters,'String'));
CurrentlySelectedFiles=contents(get(handles.MyFilters,'Value'));

% keyboard;

AlreadySelected=cellstr(get(handles.SelectedFilters,'String'));

if isempty(AlreadySelected{1}) && length(AlreadySelected)<2
set(handles.SelectedFilters,'string',CurrentlySelectedFiles);
else
    set(handles.SelectedFilters,'string',[AlreadySelected; CurrentlySelectedFiles]);
end

guidata(hObject,handles);

% --- Executes on button press in DownButton.
function DownButton_Callback(hObject, eventdata, handles)
% hObject    handle to DownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.SelectedFilters,'String'));
CurrentSelections=sort(get(handles.SelectedFilters,'Value'));

for ind=1:length(CurrentSelections)
    sel=CurrentSelections(ind);
    
    if sel~=length(contents)
        bak=contents(sel+1);
        contents(sel+1)=contents(sel);
        contents(sel)=bak;
        set(handles.SelectedFilters,'string',contents);
    else
        fprintf('%s\n','Sorry, that is it. End of stack for last item');
    end
end

newvals=CurrentSelections+1;
newvals(newvals>length(contents))=length(contents);
set(handles.SelectedFilters,'value',newvals);

guidata(hObject,handles);



function EditMyFilters_Callback(hObject, eventdata, handles)
% hObject    handle to EditMyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditMyFilters as text
%        str2double(get(hObject,'String')) returns contents of EditMyFilters as a double




% --- Executes during object creation, after setting all properties.
function EditMyFilters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMyFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in EditOrSave.
function EditOrSave_Callback(hObject, eventdata, handles)
% hObject    handle to EditOrSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmp(get(hObject,'string'),'E')
    
    makeInvisible(handles.MyFilters');
    makeVisible(handles.EditMyFilters');
    set(handles.EditMyFilters,'string',get(handles.MyFilters,'string'));
    set(hObject,'string','S');
    
else

    makeVisible(handles.MyFilters');
    makeInvisible(handles.EditMyFilters');
    set(handles.MyFilters,'string',cellstr(get(handles.EditMyFilters,'string')));
    
    set(hObject,'string','E');
 
end


% --------------------------------------------------------------------
function SaveSend_Callback(hObject, eventdata, handles)
% hObject    handle to EditFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Old_Dir=pwd;

if isfield(handles,'pathname'), cd(handles.pathname);
else
try,
    cd('c:\matlab\work\MyFilters\');
catch,
end
end


     [filename, pathname, filterindex] = uiputfile( ...
       {'*_xexFilt.txt','XeX filter files (*_xexFilt.txt)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Save/Append Filter as', 'MyNew_xexFilt.txt');
 
    if ~isnumeric(filename),

        fid=fopen([pathname filename],'a+');
       
        handles.filterpath=pathname;
        
        if fid~=-1,
            
        CurrentFilterSet=get(handles.SelectedFilters,'string');
        
        for TempInd=1:length(CurrentFilterSet)
            fprintf(fid,'%s\n',CurrentFilterSet{TempInd});
        end
        
        fclose(fid);
        
        else fprintf('%s\n','Some problem.. Not saved');
            
        end
        
    end


cd(Old_Dir);
guidata(hObject,handles);

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


