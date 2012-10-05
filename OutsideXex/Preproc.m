function CurrentVariables=Preproc(Trials,CurrentAnalysisFile,SacCorrectCode)

% function CurrentVariables=Preproc(Trials,SaccadeOptions,ProcType)
% CurrentAnalysisFile gives the type of preprocessor
% SaccadeOptions is a structure with fields Threshold, MinLat, ISICut, and
% CorrectCode. If not supplied, it will be set automatically. 
% SacCorrectCode (default 1003) will be used to check for saccades; 1007 is
% the only other likely value

if ~exist('SacCorrectCode','var')
    SacCorrectCode=1003;
end

if ~exist('CurrentAnalysisFile','var')
    CurrentAnalysisFile='LineMotion';
    fprintf('%s\n','Preproc defaulted to line motion');
end

SaccadeOptions.Threshold=0.1;
SaccadeOptions.MinLat=0;
SaccadeOptions.ISICut=0;
SaccadeOptions.CorrectCode=SacCorrectCode;

eval(['CurrentVariables=' CurrentAnalysisFile '(Trials,''DummyVar'',0,SaccadeOptions);']);


