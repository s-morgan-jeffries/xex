function buttontest

%testing buttonpresses

h=[];
rr=nan;
firstdown=nan*ones(2,2);

if ~exist('testfig','var')
testfig=figure;
else figure(testfig);
end

numclicks=0;

testax=axes;
a=plot([0 0],[1 1]);
set(a,'marker','none','color','k');
set(testax,'Xgrid','on','ygrid','on','xlim',[0 1],'ylim',[0 1],'xtick',0:.2:1,'ytick',0:.2:1);
hold on;

set(testax,'buttondownfcn',{@tbd,numclicks,h,rr,firstdown});


% function tbd(src,evt,h,rr,firstdown)
% 
%     numclicks=numclicks+1;
%     if numclicks==3, delete([h rr]); numclicks=1;end 
%      
% temp=get(src,'CurrentPoint');
% firstdown(numclicks,1:2)=temp(1,1:2);
% h(numclicks)=plot(firstdown(numclicks,1),firstdown(numclicks,2),'ro');
% set(h(numclicks),'markersize',10,'markerfacecolor','r');
%     
% 
%     if numclicks==2
%        rr= rectangle('position',[min(firstdown(:,1)),min(firstdown(:,2)),range(firstdown(:,1)),range(firstdown(:,2))]);
%     end
%     
% end
% end
%         

