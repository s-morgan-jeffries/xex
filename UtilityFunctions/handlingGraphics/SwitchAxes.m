
%	This script switches axes based on axis list in GUI

AxesPointer=AxesPointer+1;

if AxesPointer==0 | AxesPointer>length(CurrentAxesVector), AxesPointer=1;end

eval(['axes(handles.axes' num2str(CurrentAxesVector(AxesPointer)) ');']); 

CurrentAxis=CurrentAxesVector(AxesPointer);

if AxesPointer>=length(CurrentAxesVector) AxesPointer=0;end

if CurrentHoldStatus ~=1, cla; hold off;
ClearGObjects;
else hold on; end
