
% Script that handles graph exporting in XeX

AxesToExportStr=get(handles.AxesToExport,'string');
eval(['CurrentAxesToExport=' AxesToExportStr ';']);

CurrentColorMap=get(gcf,'colormap');

ExportAxes=nan*ones(1,length(CurrentAxesToExport));
ExportFigure=figure;

for TagMe=1:handles.NumberOfAxes
    eval(['set(handles.axes' num2str(TagMe) ',''tag'',''axes', num2str(TagMe), ''');']);
end
% keyboard;
for ExportIndex=1:length(CurrentAxesToExport)

    CurrentAxis=CurrentAxesToExport(ExportIndex);
    CUStr=num2str(CurrentAxis);
%         eval(['CurrentProps=get(handles.axes' CUStr ',''position'');']);
    
      eval(['  CurrentHandle=handles.axes' CUStr ';']);
      set(CurrentHandle,'units','inches');
      CurrentGrid=get(CurrentHandle,'grid');
      if ~isempty(get(CurrentHandle,'children'))
      NewHandle=copyobj(CurrentHandle,ExportFigure);
      set(NewHandle,'grid',CurrentGrid);
      else fprintf('%s\n','skipping empty axes');
      end
      set(CurrentHandle,'units','normalized');
end

set(ExportFigure,'colormap',CurrentColorMap);
Children=get(ExportFigure,'children');
PosMat=nan*ones(length(Children),4);
for PosVar=1:length(Children);
    PosMat(PosVar,:)=get(Children(PosVar),'position');
end

HeightY=min(PosMat(:,2));
PosMat(:,2)=PosMat(:,2)-HeightY+.6;
PosMat(:,1)=PosMat(:,1)+.3;
for PosVar=1:length(Children);
    set(Children(PosVar),'position',PosMat(PosVar,:));
end


