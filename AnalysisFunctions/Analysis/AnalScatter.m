%AnalScatter does the analysis for the scatterplot
%See also: PlotScatter and ScatterPlotter

% discretizeXes;

eval(['CurrentXAxisVariable=' CurrentXAxisVariableStr ';']);

FilterHere=1;
TotalFilter=FilterHere&CurrentFilterVector;
if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;

PlotX=CurrentXAxisVariable(TotalFilter);
% YMeasure=nan*ones(1,length(Uniqu));
PlotY=NaN*PlotX;

if ~isempty(PlotX)
    switch(CurrentYAxisVariableStr),
    case 'SpikeRate', 
            SRMat=CountSpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),TimeWindowVector, CurrentUnitNumber, CurrentAnalogCorrect );
            PlotY=SRMat*1000/(TimeWindowVector(2)-TimeWindowVector(1));
    otherwise, 
        try,
        eval(['CurrentYVariable=' CurrentYAxisVariableStr ';']);
        PlotY=CurrentYVariable(TotalFilter);
        catch,
        fprintf('%s\n','Please Choose a Measure I can handle');
        keyboard;
        end
    end
end

if size(PlotX,1)>1, PlotX=PlotX';end
if size(PlotY,1)>1, PlotY=PlotY';end