function LittleTimerFunction(obj,event,inStuff)

%	Currently unused (I think) function to implement the FTP timer
%	Idea was that it would FTP at routine intervals... not even sure it is fully written
%    Nope, not fully written or even written at all.

XeXDir=inStuff{1};
FTPDir=inStuff{2};
FileToFTP=inStuff{3};
% UseStimAxesHandle=inStuff{4};
FTPFileName=inStuff{5};
CurrentAnalysisFile=inStuff{6};
CurrentSacOptions=inStuff{7};

fprintf('%s\n','*********FTPing NOW *****************!!');
%mhp070214. a kluge because command line inputs need short names
ncftp_command = ['!ncftpget -f ' XeXDir '\assorted\pwf ', FTPDir,' ',FileToFTP 'A ' FileToFTP 'E' ];
ncftp_command = strrep(ncftp_command, 'Program Files', 'Progra~1');
%%%%%%%%%%%%%%%%%%%%%%%
eval(ncftp_command);
fprintf('%s\n',['IF NCFTP REPORTED NO ERRORS, File downloaded to   ' pwd]);

% TimerFTPLoadFileStuff;


% function my_callback_fcn(obj, event, string_arg)
% PROTOTYPE for callback function
% txt1 = ' event occurred at ';
% txt2 = string_arg;
% 
% event_type = event.Type;
% event_time = datestr(event.Data.time);
% 
% msg = [event_type txt1 event_time];
% disp(msg)
% disp(txt2)