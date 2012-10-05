%      Script to produce an kernel density estimate. Uses PlotKDE to do the hard work
%      See also: MakeHist
%      DrawKDE;

detachvars;
% SwitchAxes;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
CurrentAlignTime=nan;

EvalString='PlotKDE;';

NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 

eval(EvalString);
CurrentPlotType='KDE';
SetGObjectProperties;
clearvars;

