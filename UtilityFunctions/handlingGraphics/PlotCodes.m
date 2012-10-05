function PlotCodes(Trial)

% 	Function used in Trial Viewer to plot time of relevant codes
%	Plots in current figure
% 	PlotCodes(Trial)

[CurrentCodes,CurrentTimes]=getCodesAndTimes(Trial,1);

Ylims=get(gca,'ylim');

is_reward=find(CurrentCodes==1012);
is_error=find(CurrentCodes==1013);
is_fb=find(CurrentCodes==1091);
is_abort=find(CurrentCodes==1090);
is_gap=find(CurrentCodes==1004);
is_fp=find(CurrentCodes==1003);


if ~isempty(is_fp)
    
FPOnTime=CurrentTimes(is_fp(1));

if ~isempty(is_reward), 
    h=plot( CurrentTimes(is_reward(1))*[1 1]-FPOnTime,Ylims,'g-'); set(h,'linewidth',2);
end

if ~isempty(is_error), 
    h=plot( CurrentTimes(is_error(1))*[1 1]-FPOnTime,Ylims,'r-'); set(h,'linewidth',2);
end

if ~isempty(is_fb), 
    h=plot( CurrentTimes(is_fb(1))*[1 1]-FPOnTime,Ylims,'r:'); set(h,'linewidth',2);
end

if ~isempty(is_gap)
    h=plot( CurrentTimes(is_gap(1))*[1 1]-FPOnTime,Ylims,'b-'); set(h,'linewidth',2);
end
    
end