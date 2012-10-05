function R_handle=startR(type)

%	function to start R
%	type determines if dcom or com
%	global RPROCESSHANDLE carries handle of opened session
%	R_handle=startR(type)

global RPROCESSHANDLE

if isempty(RPROCESSHANDLE)
    
try,

    if exist('type','var') && type==1
    R_handle=actxserver('RCOMServerLib.StatConnector'); % open the actx server in matlab, assign handle to R
    else
    R_handle=actxserver('StatConnectorSrv.StatConnector'); % open the actx server in matlab, assign handle to R
    end
    
    R_handle.Init('R');
    fprintf('%s\n','Have opened the connection to R');

RPROCESSHANDLE=R_handle;

catch,
    fprintf('%s\n','No R connection opened, some problem or the other');
    RPROCESSHANDLE=[];
end

else
    R_handle=RPROCESSHANDLE;

    if ~isempty(strfind(class(RPROCESSHANDLE),'RCOM')), fprintf('%s\n','RCom Server connection exists; that handle returned');
    else fprintf('%s\n','RDCOM server connection exists; that handle returned');
    end
    
end