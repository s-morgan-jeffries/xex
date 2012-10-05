
load 9graph.mat

for ind=1:9
    eval(['set(handles.axes' num2str(ind) ',''position'',pos{ind});']);
    eval(['set(handles.Axis' num2str(ind) 'Indicator,''position'',pos{9+ind});']);
        eval(['makeVisible(handles.axes' num2str(ind) ');']);
     eval(['makeVisible(handles.Axis' num2str(ind) 'Indicator);']);
end

for ind=10:12
    eval(['makeInvisible(handles.axes' num2str(ind) ');']);
     eval(['makeInvisible(handles.Axis' num2str(ind) 'Indicator);']);
end

handles.NumberOfAxes=9;

       FullString=[];
    
    for tempind=10:12
        FullString=[FullString 'handles.Axis' num2str(tempind) 'Markers, handles.A' num2str(tempind) 'PropertiesTxt,'];
    end
  
    eval(['makeInvisible([' FullString '])']);
    
    LayOutEditWindow;
    FullString=[];
    for tempind=10:12
        FullString=[FullString 'handles.AxisObj' num2str(tempind) ','];
    end
    
    eval(['makeInvisible([' FullString '])']);
    
