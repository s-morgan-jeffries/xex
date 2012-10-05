    
    FilterHere=1;
TotalFilter=1&CurrentFilterVector;
CurrentSet=find(TotalFilter);

discretizeXes;
SpikeCounts=CountSpikes(Trials,RFTrialIndex(CurrentSet),RFOnTime(CurrentSet),TimeWindowVector,CurrentUnitNumber, CurrentAnalogCorrect); %keyboard;
