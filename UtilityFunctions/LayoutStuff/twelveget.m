for ind=1:12
    eval(['pos{ind}=get(handles.axes' num2str(ind) ',''position'');']);
    eval(['pos{ind+12}=get(handles.Axis' num2str(ind) 'Indicator,''position'');']);
end