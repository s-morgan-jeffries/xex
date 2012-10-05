
for ind=1:9
    eval(['set(handles.axes' num2str(ind) ',''position'',pos{ind});']);
    eval(['set(handles.Axis' num2str(ind) 'Indicator,''position'',pos{9+ind});']);
end

for ind=10:12
    eval(['makeInvisible(handles.axes' num2str(ind) ');']);
     eval(['makeInvisible(handles.Axis' num2str(ind) 'Indicator);']);
end

handles.NumberOfAxes=9;