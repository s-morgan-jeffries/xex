function SacStruct=MakeSacStruct(WhichType)

%function SacStruct=MakeSacStruct(WhichType)
%WhichType=1 gives you the normal version
%WhichType=2 gives you the fuller version

if ~exist('WhichType','var')|WhichType==1 
%     SacStruct=struct('latency',NaN,'duration',NaN,'peakvelocity',NaN ,'amplitude',NaN,'velocitrace',NaN,'startx',NaN,'starty',NaN,'endx',NaN,'endy',NaN,'rfdistance',NaN,'gaplatency',NaN,'whichsac',NaN,'angle',NaN);
    SacStruct=struct('latency',NaN,'duration',NaN,'peakvelocity',NaN ,'amplitude',NaN,'velocitrace',NaN,'startx',NaN,'starty',NaN,'endx',NaN,'endy',NaN,'eyex',NaN,'eyey',NaN,'curvature',NaN);
else
    SacStruct=struct('latency',NaN,'duration',NaN,'peakvelocity',NaN ,'amplitude',NaN,'velocitrace',NaN,'startx',NaN,'starty',NaN,'endx',NaN,'endy',NaN,'eyex',NaN,'eyey',NaN,'curvature',NaN,'rfdistance',NaN,'rf2distance',NaN,'gaplatency',NaN,'whichsac',NaN,'angle',NaN);
end
    