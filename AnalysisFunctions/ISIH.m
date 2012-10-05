%      Script to produce an ISI histogram. Uses PlotISI to do the hard work
%      See also: 
%      ISIH

detachvars;
% SwitchAxes;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
setAlignTime;
evalAlignTime;

EvalString='ReturnMap=0;PlotISI;';

NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 

eval(EvalString);
CurrentPlotType='ISIH';
SetGObjectProperties;


% SwitchAxes;
% EvalString='ReturnMap=1;PlotISI;';
% 
% 
% NextMarkerSet;
% if isempty(NextMarker), NextMarker='k-';end
% % EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
% LocalMarkerString=NextMarker; 
% 
% eval(EvalString);
% CurrentPlotType='ReturnMap';
% SetGObjectProperties;

clearvars;
