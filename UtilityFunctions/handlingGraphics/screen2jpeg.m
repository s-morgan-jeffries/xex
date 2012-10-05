function screen2jpeg(filename,Resolution)
%SCREEN2JPEG Generate a JPEG file of the current figure with
% dimensions consistent with the figure's screen dimensions.
%
% SCREEN2JPEG('filename') saves the current figure to the
% JPEG file "filename".
%
% Sean P. McCarthy
% Copyright (c) 1984-98 by The MathWorks, Inc. All Rights Reserved

if nargin < 1
error('Not enough input arguments!')
end

if ~exist('Resolution','var') Resolution=300;end

oldscreenunits = get(gcf,'Units');
oldpaperunits = get(gcf,'PaperUnits');
oldpaperpos = get(gcf,'PaperPosition');
set(gcf,'Units','pixels');
scrpos = get(gcf,'Position');
newpos = scrpos/100;
set(gcf,'PaperUnits','inches',...
'PaperPosition',newpos)
eval(['print -djpeg ' filename ' -r' num2str(Resolution) ';'])
drawnow
set(gcf,'Units',oldscreenunits,...
'PaperUnits',oldpaperunits,...
'PaperPosition',oldpaperpos)