Trials=doMrdd('z051125c11lm1',0);
CurrentVariables=Preproc(Trials,'LineMotion');
detachvars
MakeAnalysisStruct
AnalysisStruct.XVector=[50 150];
AnalysisStruct.XAxisVariable='ISI';
AnalysisStruct.XAxisCenters=-400:100:0;
%AnalysisStruct.WhichAnalysis='PSTH';
%AnalysisStruct.WhichAnalysis='SpikeDensity';
doAnalysis
figure
plot(PlotX,PlotY,'b-');
hold on;
errorbar(PlotX,PlotY,2*PlotStd);
who
RemoveAnalVariables; 
clear Trials;  % if necessary