function print2jpeg(FileName,Resolution, PaperSize,DoFigure)

%	Function to print screen to a jpeg with supplied parameters
%	Called from cmd window mostly to print to a jpg that can be used in the wiki
%	print2jpeg(FileName,Resolution, PaperSize,DoFigure)


if ~exist('DoFigure','var'), DoFigure=gcf;end
if ~exist('PaperSize','var'), PaperSize=[1 1];end
if ~exist('Resolution','var'), Resolution=600;end
 if ~exist('FileName','var'), FileName='CurrentFigure.jpg';end
 
figure(DoFigure);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 PaperSize]);
eval(['print -djpeg ' FileName ' -r' num2str(Resolution) ';']);

