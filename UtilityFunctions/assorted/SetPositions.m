
load 12graph;
PosArray=pos;

for PosInd=1:12
   eval(['set(handles.axes' num2str(PosInd) ',''position'',PosArray{PosInd},''units'',''normalized'');']);
   eval(['makeVisible(handles.axes' num2str(PosInd) ');']);
   eval(['makeVisible(handles.Axis' num2str(PosInd) 'Indicator);']);
end

for PosInd=13:24
    eval(['set(handles.Axis' num2str(PosInd-12) 'Indicator,''position'',PosArray{PosInd});']);
end

handles.NumberOfAxes=12;