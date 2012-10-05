
%	This script is used to remove graphix objects properties when clear axes is called

AxesHandles=nan*ones(1,handles.NumberOfAxes);

for TempVar=1:(handles.NumberOfAxes)
   eval([' AxesHandles(TempVar)=handles.axes' num2str(TempVar) ';']);
end

CurrentAxisHandle=gca;

WhichAxis=find(AxesHandles==CurrentAxisHandle);

eval(['if isfield(handles,''A' num2str(WhichAxis) '''),handles=rmfield(handles,''A' num2str(WhichAxis) ''');end']);

% fprintf('%s\t%d\n','Removed graphix objects for axis',WhichAxis);