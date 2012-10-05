function clearinR(varnames)

%	Clears variables in R
%	Uses R dcom or com connection
%	clearinR(varnames)

global RPROCESSHANDLE

if isempty(RPROCESSHANDLE), 
    fprintf('%s\n','Start R first using startR');
    return
end

%use semicolons as separators


if ischar(varnames) & strcmp(varnames,'all')
    evalinR('rm(list=ls())');
    fprintf('%s\n','Cleared all variables');
    return
else
    evalinR(['rm(' varnames ')']);
    fprintf('%s\n',['Removed ' varnames]);
    return
end

if iscell(varnames), fprintf('%s\n','Use string instead, with comma separator'); return;end

% if iscell(varnames)
% 
% toremove=char(varnames);
% toremove(:,size(toremove,2)+1)=',';
% toremove(size(toremove,1),size(toremove,2))=' ';
% toremove=reshape(toremove',size(toremove,2)*size(toremove,1));
% evalinR(['rm(' toremove ')']);
%     fprintf('%s\n',['Removed ' toremove]);
% end