function handles = DoFTP(handles)

	if isfield(handles,'FTP')
		config_file = [handles.XeXDir '\assorted\pwf'];
		% config_file = strrep(config_file, ' ', '^ ');
		% config_file = ['"' config_file '"'];
		handles.FTPLocalDir=[matlabroot filesep 'work'];
		% handles.FTPLocalDir = strrep(handles.FTPLocalDir, ' ', '^ ');
		% handles.FTPLocalDir = ['"' handles.FTPLocalDir '"'];
		FileToFTP=[handles.FTP.pathname handles.FTP.filename];
		a_file = [FileToFTP 'A'];
		e_file = [FileToFTP 'E'];
		% handles.FTPLocalDir='c:\matlab\work\physiology';
		if isfield(handles,'CurrentDataDirectory')
			cd(handles.CurrentDataDirectory);
		end
		%mhp070214. a kluge because command line inputs need short names
		ncftp_command = ['!ncftpget -f "', config_file, '" "', handles.FTPLocalDir, '" ', a_file, ' ', e_file];
		% ncftp_command = strrep(ncftp_command, 'Program Files', 'Progra~1');
		%%%%%%%%%%%%%%%%%%%%%%%
		% keyboard;
		eval(ncftp_command);
		fprintf('%s\n',['IF NCFTP REPORTED NO ERRORS, File downloaded to   ' pwd]);
		handles = FTPLoadFileStuff(handles);
	else
		TellMe('%s\n','Enter the FTP options first',handles.SpeakToMe);
	end
	
end