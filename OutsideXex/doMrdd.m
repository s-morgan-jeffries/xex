function Trials=doMrdd(FileName,NoSave);


if(FileName(end)=='A'|FileName(end)=='E')
    
    FileName=FileName(1:(end-1));
    
end

Trials = mrdr('-s','800','-d',FileName);

if exist('NoSave','var') & NoSave==0
    % DONT SAVE
else
    save(FileName,'Trials');  %SAVE
end