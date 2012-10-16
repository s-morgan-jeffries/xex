
%	This script sets CurrentAlignString to the correct value, based on the AlignCode obtained from the GUI

AlignCodeList=get(handles.AlignCode,'string');
CurrentAlign=get(handles.AlignCode,'value');
switch(AlignCodeList{CurrentAlign})
    case 'RF1', CurrentAlignString='RFOnTime';
    case 'RF2', CurrentAlignString='RF2OnTime';
    case 'Gap', CurrentAlignString='GapTime';
    case 'RT', CurrentAlignString='ReactionTime';
    case 'FP', CurrentAlignString='FPOnTime';
    case 'SacTime1', CurrentAlignString='SacAlignTime1';
    case 'SacTime2', CurrentAlignString='SacAlignTime2';
    case 'SacTime3', CurrentAlignString='SacAlignTime3';
    case 'UseOld', if exist('SavedAlignString','var'), CurrentAlignString=SavedAlignString; else CurrentAlignString='FPOnTime'; fprintf('%s\n','Cannot use Old Align if it doesnt exist, using FP!!');end
    otherwise, fprintf('%s\n','Not yet programmed align code. May crash');
end
