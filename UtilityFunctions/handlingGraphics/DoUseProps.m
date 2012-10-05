
%	This function makes the UseProps graphics objects visible or invisible based on handles.UseProps
%	To be called from within XeX
%	DoUseProps SCRIPT

if get(handles.UseProps,'value')==1
    
%        FullString=['handles.ResetProps,'];
        FullString=[];
    
    for tempind=1:handles.NumberOfAxes
        FullString=[FullString 'handles.Axis' num2str(tempind) 'Markers, handles.A' num2str(tempind) 'PropertiesTxt,'];
    end
  
%     FullString(end)=[];
    eval(['makeVisible([' FullString '])']);
    
else
    
%        FullString=['handles.ResetProps,'];
            FullString=[];

    for tempind=1:handles.NumberOfAxes
         FullString=[FullString 'handles.Axis' num2str(tempind) 'Markers, handles.A' num2str(tempind) 'PropertiesTxt,'];
    end
    
%     FullString(end)=[];
    eval(['makeInvisible([' FullString '])']);
    
end
