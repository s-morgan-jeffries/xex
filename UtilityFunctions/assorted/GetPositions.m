
for PosInd=1:9
   eval([' PosArray{PosInd}=get(handles.axes' num2str(PosInd) ',''position'');']);
end

for PosInd=10:18
    eval(['PosArray{PosInd}=get(handles.Axis' num2str(PosInd-9) 'Indicator,''position'');']);
end