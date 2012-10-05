function setinR(varname,x)

%	 function to set variable in R (identiied in RPROCESSHANDLE)
%	setinR(varname,x)

global RPROCESSHANDLE

if isempty(RPROCESSHANDLE), 
    fprintf('%s\n','Start R first using startR');
    return
end

RPROCESSHANDLE.SetSymbol(varname,x);
