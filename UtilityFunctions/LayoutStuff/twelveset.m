
load 12graph.mat

for ind=1:12
    eval(['set(handles.axes' num2str(ind) ',''position'',pos{ind},''units'',''normalized'');']);
    eval(['set(handles.Axis' num2str(ind) 'Indicator,''position'',pos{12+ind},''units'',''normalized'');']);
end


for ind=1:12
    eval(['makeVisible(handles.axes' num2str(ind) ');']);
     eval(['makeVisible(handles.Axis' num2str(ind) 'Indicator);']);
end

handles.NumberOfAxes=12;

if get(handles.UseProps,'value')==1
       FullString=[];
    
    for tempind=1:12
        FullString=[FullString 'handles.Axis' num2str(tempind) 'Markers, handles.A' num2str(tempind) 'PropertiesTxt,'];
    end
  
    eval(['makeVisible([' FullString '])']);
    
end

    LayOutEditWindow;
   
    
    if strcmp(get(handles.ShowAllObjWin,'checked'),'on'), 
        makeVisible(handles.EditWindows);
    end