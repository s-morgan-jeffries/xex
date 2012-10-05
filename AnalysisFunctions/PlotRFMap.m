%      Script to produce an RFMap. Uses ImageRFMap and CircleRFMap to do the hard work
%      Has been superseded by ImageMap and CircleMap. Outdated function
%      See also:
%      PlotRFMap

detachvars;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector

setAlignTime;
evalAlignTime;

% SwitchAxes;
EvalString='ImageRFMap;';
eval(EvalString);
LocalMarkerString=''; 
SetGObjectProperties;

% SwitchAxes;
EvalString='CircleRFMap;';
eval(EvalString);
LocalMarkerString=''; 
SetGObjectProperties;


clearvars;