
%This script detaches all the variables from a structure and assigns them
%to variables in the workspace. If those variables already existed, they
%will be overwritten, but a warning message will appear.
%detachvars

StructVariableNames=fieldnames(CurrentVariables);

AmOverwriting=0;

for ListIndex=1:length(StructVariableNames)
    CurrentVariableName=StructVariableNames{ListIndex};
    if exist(CurrentVariableName,'var') AmOverwriting=AmOverwriting+1;end
    eval([CurrentVariableName '=CurrentVariables.' CurrentVariableName ';']);
end

% if AmOverwriting>0, fprintf('%s\n',['*************Overwrote ',num2str(AmOverwriting),' Variables****************']);end

clear AmOverwriting StructVariableNames CurrentVariableName ListIndex  %bookkeeping to prevent variable proliferation as this is a script