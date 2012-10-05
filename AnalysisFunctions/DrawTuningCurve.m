%      Script to produce a tuning curve. Uses PlotTuningCurve to do the hard work
%      See also: AngularTuningCurve
%      DrawTuningCurve

detachvars;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
setAlignTime;
evalAlignTime;

% SwitchAxes;
EvalString='IsAngular=0;PlotTuningCurve;';  %This focuses on the Visual On-response.. so basically plot measure over some timewindow as a function of RF time relative to  saccade


NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 
eval(EvalString);
SetGObjectProperties;
clearvars;