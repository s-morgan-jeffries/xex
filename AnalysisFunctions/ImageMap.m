%      Script to produce an RFMap. Uses ImageRFMap and CircleRFMap to do the hard work
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

clearvars;