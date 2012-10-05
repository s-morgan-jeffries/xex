%      Script to produce a scatter plot. Uses ScatterPlotter to do the hard work
%      See also: ScatterPlotter, AnalScatter

detachvars;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
setAlignTime;
evalAlignTime;

% SwitchAxes;
EvalString='ScatterPlotter;';


NextMarkerSet;
NextMarkerEvalString=[...
     'set(TemporaryHandle,''color'',NextMarker(1),''linestyle'',''none'');'...
    ]; %resetting it here for scatter plot

if isempty(NextMarker)
  NextMarker='k-';
end

EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 
eval(EvalString);
SetGObjectProperties;
clearvars;