%      Script to produce a spike-density. Uses PlotPSTD to do the hard work
%      See also: DrawPSTH
%      SpikeDensity

detachvars;
% SwitchAxes;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
setAlignTime;
evalAlignTime;

EvalString='PlotPSTD;';

NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 


eval(EvalString);
CurrentPlotType='SDF';
SetGObjectProperties;
clearvars;