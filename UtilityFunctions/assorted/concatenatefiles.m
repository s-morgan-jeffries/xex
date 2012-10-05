
%	This scriptlet concatenates the code from an entire list of files in a directory and outputs to 'OutputFile.txt'.
%	Which can then be printed.

ListOfFiles=dir(pwd);

    ofid=fopen('OutputFile.txt','w');

    for Index=1:length(ListOfFiles)
    CurrentFile=ListOfFiles(Index).name;
    
    
    if ~isempty(strfind(CurrentFile,'.m'))
    
        fprintf(ofid,'%s\n',CurrentFile);
        fprintf(ofid,'%s\n','~~~~~~~~~~~~~~~~~~~~~~');
        fprintf(ofid,'%s\n','');
        
        fid=fopen(CurrentFile,'r');
        Line=fgets(fid);
        while ~isequal(Line,-1)
            fprintf(ofid,'%s',Line);
        Line=fgets(fid);
        end
            
                fprintf(ofid,'\n%s\n','*********************************************************************************');
    end
    end
    
    fclose(fid);
    fclose(ofid);
    