%This script evaluates what variables are present in the calling
%workspace and assigns them to a structure variable called
%Current_Variables. Anything called Trials is excluded from the attachment.

CurrentVariableList=who;
WhereisTrials=strcmp(CurrentVariableList,'Trials');
CurrentVariableList=CurrentVariableList(~WhereisTrials); %removing Trials from the structure

for VariableListIndex=1:length(CurrentVariableList)
            eval(['CurrentVariables.',CurrentVariableList{VariableListIndex},'=',CurrentVariableList{VariableListIndex},';']);
end

clear CurrentVariableList WhereisTrials VariableListIndex;  %bookkeeping to prevent variable proliferation as this is a script