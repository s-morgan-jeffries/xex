
%	This function makes the UseProps graphics objects visible or invisible based on handles.UseProps
%	To be called from within XeX
%	DoUseProps SCRIPT

if get(handles.UseProps,'value')==1
	visibilityFx = @makeVisible;
else
	visibilityFx = @makeInvisible;
end

for tempind=1:handles.NumberOfAxes
	feval(visibilityFx, handles.(['Axis' num2str(tempind) 'Markers']));
	feval(visibilityFx, handles.(['A' num2str(tempind) 'PropertiesTxt']));
end