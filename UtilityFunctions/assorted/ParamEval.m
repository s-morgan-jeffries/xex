function CurrentVariables=ParamEval(XexParameters,CurrentVariables)

%This function works in PlotData and in Graphcommandprocessor and serves to
%include variables that come out of RUN into the CurrentVariables structure
%ParamEval.m

detachvars;
eval(XexParameters);
clear CurrentVariables;
attachvars;
