


if isfield(handles,'FTP')
    
FileToFTP=[handles.FTP.pathname handles.FTP.filename];
FTPDir=[matlabroot filesep 'work'];
% FTPDir='c:\matlab\work\physiology';

if isfield(handles,'CurrentDataDirectory'), cd(handles.CurrentDataDirectory);end
    
%mhp070214. a kluge because command line inputs need short names
ncftp_command = ['!ncftpget -f ' handles.XeXDir '\assorted\pwf ', FTPDir,' ',FileToFTP 'A ' FileToFTP 'E'];
ncftp_command = strrep(ncftp_command, 'Program Files', 'Progra~1');
%%%%%%%%%%%%%%%%%%%%%%%
eval(ncftp_command);
fprintf('%s\n',['IF NCFTP REPORTED NO ERRORS, File downloaded to   ' pwd]);

FTPLoadFileStuff;

else
    TellMe('%s\n','Enter the FTP options first',handles.SpeakToMe);
end