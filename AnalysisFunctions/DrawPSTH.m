%      Script to produce a PSTH. Uses PlotPSTH to do the hard work
%      See also: SpikeDensity
%      DrawPSTH

detachvars;
% SwitchAxes;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
setAlignTime;
evalAlignTime;

EvalString='PlotPSTH;';

NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 

eval(EvalString);
CurrentPlotType='PSTH';
SetGObjectProperties;
clearvars;