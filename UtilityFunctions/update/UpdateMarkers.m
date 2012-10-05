
%This script is what gets done for the markers callback
%as usual, the hard work is in updateslider
%CurrentAxisMarkerNumber contains the axis to be updated

ThingsToDo=get(handles.WhatToDo,'String');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

eval(['Axis' num2str(CurrentAxisMarkerNumber) 'MarkerPointer=0;']); %resetting pointer location

if strcmp(WhatToDo,'ActiveUpdate'),
UpdateType='Marker';
UpdateSlider;
end