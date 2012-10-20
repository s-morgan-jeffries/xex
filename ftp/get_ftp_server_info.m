function server_info = get_ftp_server_info()
	
	% server_info = repmat(struct('hostname', '', 'IP', [], 'username', '', 'password', ''), 0, 0);
	server_info = [];
	
	% Mastermind
	server_info = [server_info make_server_info_struct('mastermind', '192.168.35.100', '', '')];
	% Rig 1
	server_info = [server_info make_server_info_struct('rex1', '192.168.35.240', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('mex1', '192.168.35.238', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('vex1', '192.168.35.239', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('ao1', '192.168.35.241', '', '')];
	% Rig 2
	server_info = [server_info make_server_info_struct('rex2', '192.168.35.235', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('mex2', '192.168.35.236', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('vex2', '192.168.35.234', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('ao2', '192.168.35.237', '', '')];
	% Rig 3
	server_info = [server_info make_server_info_struct('rex3', '192.168.35.231', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('mex3', '192.168.35.232', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('vex3', '192.168.35.230', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('ao3', '192.168.35.233', '', '')];
	% Rig 4
	server_info = [server_info make_server_info_struct('rex4', '192.168.35.227', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('mex4', '192.168.35.228', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('vex4', '192.168.35.226', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('ao4', '192.168.35.229', '', '')];
	% Rig 5
	server_info = [server_info make_server_info_struct('rex5', '192.168.35.185', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('mex5', '192.168.35.184', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('vex5', '192.168.35.183', 'root', 'shoebox')];
	server_info = [server_info make_server_info_struct('ao5', '192.168.35.182', '', '')];
	
	
end

function server_info_struct = make_server_info_struct(hostname, IP, username, password)
	
	server_info_struct.hostname = hostname;
	server_info_struct.IP = IP;
	server_info_struct.username = username;
	server_info_struct.password = password;
	
end