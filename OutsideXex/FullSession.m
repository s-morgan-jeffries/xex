
%suggested analysis script

% Trials=doMrdd('z051125c11lm1',0);
% CurrentVariables=Preproc(Trials,'LineMotion');
% detachvars
% MakeAnalysisStruct
% AnalysisStruct.XVector=[50 150];
% AnalysisStruct.XAxisVariable='ISI';
% AnalysisStruct.XAxisCenters=-400:100:0;

%AnalysisStruct.WhichAnalysis='TuningCurve';
%AnalysisStruct.WhichAnalysis='PSTH';
%AnalysisStruct.WhichAnalysis='SpikeDensity';


% doAnalysis
% figure
% plot(PlotX,PlotY,'b-');
% hold on;
% errorbar(PlotX,PlotY,2*PlotStd);
% who
% RemoveAnalVariables

%Other option is to go through the preprocessign once, and save each
%preprocessor output in a mat file for future use
%go to the directory of itnerest (cd)
%Trials=doMrdd('z051125c11lm1',0);
%CurrentVariables=Preproc(Trials,'LineMotion');
%cd MyLmAnalyses
%save z051124c11lm1Results CurrentVariables Trials
%repeat for all your files in a loop, or by hand. probably by hand.
%Now you are done with all the preprocessing

%need some way of cycling through all files
%i suggest systematically making a struct, with two fields:
%filename: that is a string with entire pathname/filename
%commandset: a bunch of commands to evaluate for that file
cd C:\MATLAB\work\physiology\InhibPop\BlockMGS
InhibFilesBlockMGS=struct('Filename',nan,'Command',nan);
InhibFilesBlockMGS(1).Filename='z060815c3ti2ResultsTDBlock';
InhibFilesBlockMGS(1).Command='mg=1;block=0;'
save InhibFilesBlockMGS InhibFilesBlockMGS
%when analyzing!!!!
cd C:\MATLAB\work\physiology\InhibPop\BlockMGS
load InhibFilesBlockMGS

% set up the analysis parameters

MakeAnalysisStruct
AnalysisStruct.XVector=[-400 400];
AnalysisStruct.XAxisVariable='RFOnTime';
%AnalysisStruct.XAxisVariable='RF2dist_toRF';
%AnalysisStruct.XAxisCenters=0:5:50;
%AnalysisStruct.WhichAnalysis='TuningCurve';
% AnalysisStruct.XAxisCenters=-400:100:0;
AnalysisStruct.WhichAnalysis='PSTH';
AnalysisStruct.BinWidth=15;

NumberOfBins=length(AnalysisStruct.XVector(1):AnalysisStruct.BinWidth(1):AnalysisStruct.XVector(end));
Inhib_PSTH=repmat(nan,length(InhibFilesBlockMGS),NumberOfBins);

for InhibIndex=[1:length(InhibFilesBlockMGS)]
    currentfile=InhibFilesBlockMGS(InhibIndex);
    load(currentfile.Filename);

    detachvars;
    Trials=Trials(2:end);
    
    numTrials(InhibIndex)=length(find(GoodTrial==1&PhotoBad~=1));
    
    eval([currentfile.Command]);
    AnalysisStruct.FilterString='GoodTrial==1&PhotoBad~=1';
    doAnalysis
    Inhib_PSTH(InhibIndex,:)=PlotY;
    %REPEAT as needed with new parameters

    RemoveAnalVariables;
    clear Trials

end

%Now make plots etc
%EquateAxis is a useful function !!!

f1=figure;
p1_minbox=plot(XVector,nanmean(Inhib_PSTH_block),'k-');
hold on;
p1_minbox=plot(XVector,nanmean(Inhib_PSTH_mgs),'g-');
