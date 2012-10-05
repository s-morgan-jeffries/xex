%      Script to produce an histogram. Uses PlotHist to do the hard work
%      See also: DrawKDE
%      MakeHist

detachvars;
% SwitchAxes;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
CurrentAlignTime=nan;

EvalString='PlotHist;';

NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 

eval(EvalString);
CurrentPlotType='Histogram';
SetGObjectProperties;
clearvars;

