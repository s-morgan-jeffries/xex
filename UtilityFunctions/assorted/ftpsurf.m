
%	This scriptlet calls FTPSurfer from within Matlab

old_dir=pwd;
cd([matlabroot '\work\XeX\UtilityFunctions\assorted']);
!FTPSurfer.lnk
cd(old_dir);