for ind=1:9
    eval(['pos{ind}=get(handles.axes' num2str(ind) ',''position'');']);
    eval(['pos{ind+9}=get(handles.Axis' num2str(ind) 'Indicator,''position'');']);
end