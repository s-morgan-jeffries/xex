%Analtuningcurve does the analysis for the tuning curve
%See also DrawTuningCurve and PlotTuningCurve

discretizeXes;
eval(['CurrentXAxisVariable=' CurrentXAxisVariableStr ';']);

UniqueX=unique(CurrentXAxisVariable(~isnan(CurrentXAxisVariable)));
YMeasure=nan*ones(1,length(UniqueX));
YStd=YMeasure;
YSem=YMeasure;
PlotX=YMeasure;

    FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;

for Runner=1:length(UniqueX)
    CurrentSet=find(CurrentXAxisVariable==UniqueX(Runner) & TotalFilter);
    if ~isempty(CurrentSet),
switch(CurrentYAxisVariableStr),
    case 'SpikeRate', 
            SRMat=CountSpikes(Trials,RFTrialIndex(CurrentSet),CurrentAlignTime(CurrentSet),TimeWindowVector, CurrentUnitNumber, CurrentAnalogCorrect );
        YMeasure(Runner)=nanmean(SRMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
        YStd(Runner)=nanstd(SRMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
        YSem(Runner)=YStd(Runner)/sqrt(length(find(~isnan(SRMat))));
    otherwise, 
        try,
        eval(['CurrentYVariable=' CurrentYAxisVariableStr ';']);
        if length(find(~isnan(CurrentYVariable(CurrentSet))))~=0
        YMeasure(Runner)=nanmean(CurrentYVariable(CurrentSet));
        YStd(Runner)=nanstd(CurrentYVariable(CurrentSet));
        YSem(Runner)=YStd(Runner)/sqrt(length(find(~isnan(CurrentYVariable(CurrentSet)))));
        end
        catch,
        fprintf('%s\n','Please Choose a Measure I can handle');
        keyboard;
        end
end
PlotX(Runner)=UniqueX(Runner);
    end

end

PlotY=YMeasure;
PlotStd=YSem;

