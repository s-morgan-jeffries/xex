
%This function clears all the variables that were recently detached

StructVariableNames=fieldnames(CurrentVariables);

for ListIndex=1:length(StructVariableNames)
    CurrentVariableName=StructVariableNames{ListIndex};
    clear(CurrentVariableName);
end

clear StructVariableNames ListIndex CurrentVariableName;