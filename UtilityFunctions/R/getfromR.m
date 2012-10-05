function x=getfromR(varname,x)

%	function to get a variable from R, identified in RPROCESSHANDLE
%    x=getfromR(varname,x)

global RPROCESSHANDLE

if isempty(RPROCESSHANDLE), 
    fprintf('%s\n','Start R first using startR');
    return
end

x=RPROCESSHANDLE.GetSymbol(varname);
