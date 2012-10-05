function endR

% Closes the R connection in RPROCESSHANDLE
% endR

global RPROCESSHANDLE

if isempty(RPROCESSHANDLE)
    fprintf('%s\n','Nothing to end');
    clear global RPROCESSHANDLE;
else
    try,
        RPROCESSHANDLE.Close;
        clear global RPROCESSHANDLE;
        fprintf('%s\n','Closed R connection');
   catch,
        fprintf('%s\n','Couldnt close R connection');
    end
end