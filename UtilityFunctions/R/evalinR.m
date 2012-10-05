function x=evalinR(Rcommands)

%	Evaluates commands in RPROCESSHANDLE's r program
%    Multiple R commands with a semicolon separator are separated and sent separately
%	evalinR(Rcommands)

global RPROCESSHANDLE

if isempty(RPROCESSHANDLE), 
    fprintf('%s\n','Start R first using startR');
    return
end

%use semicolons as separators

semicolons=strfind(Rcommands,';');

semicolons=semicolons(semicolons~=length(Rcommands));  %ignoring semicolons at end of command set

if isempty(semicolons), enders=length(Rcommands);
    starters=1;
else enders=[semicolons length(Rcommands)];
    starters=[1 semicolons+1];
end


for ind=1:length(starters)
    CurrentCommand=Rcommands(starters(ind):enders(ind));
    if strcmp(CurrentCommand(end),';'), CurrentCommand=CurrentCommand(1:(end-1));end
    RPROCESSHANDLE.EvaluateNoReturn(CurrentCommand);
end
