
% This is a script so that it can be run in any format anywhere
% Expects a structure in a certain form to be present; obtaiined by
% MakeAnalysisStruct
% And also something that tells it which analysis to do and then done; this
% should be contained in AnalysisStruct.WhichAnalysis (TuningCurve, PSTH or
% SpikeDensity)


CurrentFilterString=AnalysisStruct.FilterString;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector

CurrentAlignString=AnalysisStruct.AlignString;
eval(['CurrentAlignTime=' CurrentAlignString ';']);

CurrentAnalogCorrect=AnalysisStruct.AnalogCorrect;
CurrentUnitNumber=AnalysisStruct.UnitNumber;
CurrentRF=AnalysisStruct.RF;
CurrentBinWidth=AnalysisStruct.BinWidth;
CurrentSliderValue=AnalysisStruct.SliderValue;
CurrentPValue=AnalysisStruct.PValue;

if ~isstr(AnalysisStruct.XVector), CurrentStimString=num2str(AnalysisStruct.XVector); else CurrentStimString=AnalysisStruct.XVector;end
ParseStimString;
    
% XVector=AnalysisStruct.XVector;
% TimeWindowVector=[XVector(1) XVector(2)];

CurrentSelectedVariable=AnalysisStruct.WhichVariable;  %this was the response variable, now it is the xaxis variable

if ~strcmp(AnalysisStruct.ErrorBarType,'Bootstrap')
CurrentErrorBarType='ChangeErrorToBootstrap';
else
    CurrentErrorBarType='Bootstrap';
end

%instead of parsestimstring
%CurrentStimVector=
% PlotXVector =     % Now this should never be needed
%TimeWindowVector=CurrentStimVector;

CurrentXAxisVariableStr=AnalysisStruct.XAxisVariable;
CurrentX1AxisVariableStr=AnalysisStruct.X1AxisVariable;
CurrentYAxisVariableStr=AnalysisStruct.YAxisVariable;

CurrentXAxisCenters=AnalysisStruct.XAxisCenters;
CurrentX1AxisCenters=AnalysisStruct.X1AxisCenters;
CurrentXAxisCentersStr=['[' num2str(CurrentXAxisCenters) ']'] ;
CurrentX1AxisCentersStr=[ '[' num2str(CurrentX1AxisCenters) ']'];

if all(~isnan(CurrentXAxisCenters)), CurrentXAxisDiscretize=1; else CurrentXAxisDiscretize=0;end
if all(~isnan(CurrentX1AxisCenters)), CurrentX1AxisDiscretize=1; else CurrentX1AxisDiscretize=0;end

switch(AnalysisStruct.WhichAnalysis)
    case 'TuningCurve', AnalTuningCurve; %output is now in PlotX, PlotY, and PlotStd
    case 'PSTH',  AnalPSTH;
    case 'SpikeDensity', AnalPSTD;
    case 'ImageMap', AnalImageMap;
    case 'CountSpikes', AnalCountSpikes;
    otherwise, fprintf('%s\n','Fix your AnalysisStruct.WhichAnalysis');
end

% HOW TO USE THIS
%~~~~~~~~~~~~~
% Trials=doMrdd('z051125c11lm1',0);
% CurrentVariables=Preproc(Trials,'LineMotion');
% detachvars
% MakeAnalysisStruct
% AnalysisStruct.XVector=[50 150];
% AnalysisStruct.XAxisVariable='ISI';
% AnalysisStruct.XAxisCenters=-400:100:0;
% doAnalysis
% figure
% plot(PlotX,PlotY,'b-');
% hold on;
% errorbar(PlotX,PlotY,2*PlotStd);
% %RemoveAnalVariables

