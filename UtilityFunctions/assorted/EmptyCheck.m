
%To check if xexparameteres in finterpreter is empty
%Purely utility
%Emptycheck.m

if isempty(XexParameters)
    fprintf('%s\n',[XexCommand '  :Yikes, command without parameters ??']);
    PlotOK=0;
end

%stripping off empty space at beginning

XexParameters=StripSpace(XexParameters);