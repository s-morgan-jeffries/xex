function LinkHandle
%This is the buttondownfunction for the axis. Work on it !!

SelectionType=get(gcf,'SelectionType');
handles=getappdata(gcf,'UsedByGUIData_m');  %so this is now the handles object; later on, save changes
LinkAxisHandle=gca;
    
    AxesList=handles.HandlesList;
    WhichAxis=find(LinkAxisHandle==AxesList);
    
    CurrentLinkAxis=WhichAxis;
    
    evalString=['XAxisVariable=handles.AxisVariable(' num2str(WhichAxis) ').XAxis;'...
        'YAxisVariable=handles.AxisVariable(' num2str(WhichAxis) ').YAxis;'...
        ];
    eval(evalString);

RectDrawn=0;

if strcmp(SelectionType,'normal')
    
NumClicks=getappdata(LinkAxisHandle,'NumClicks');
CurrentPointPlots=getappdata(LinkAxisHandle,'CurrentPointPlots');
OldPointPlots=CurrentPointPlots;

OldXLim=get(LinkAxisHandle,'xlim');
OldYLim=get(LinkAxisHandle,'ylim');

CurrentPoint=get(LinkAxisHandle,'CurrentPoint');
CurrentPoint=CurrentPoint(1,1:2);

% fprintf('%s\n','Registered a c lick');

if NumClicks==1|NumClicks==3
    setappdata(LinkAxisHandle,'FirstClick',CurrentPoint);
    CurrentPointPlots(1)=plot(CurrentPoint(1),CurrentPoint(2),'ro');
elseif NumClicks==2
    setappdata(LinkAxisHandle,'SecondClick',CurrentPoint);   
    FirstClick=getappdata(LinkAxisHandle,'FirstClick');
    SecondClick=CurrentPoint;
    
    if ( FirstClick(1)~=SecondClick(1) & FirstClick(2)~=SecondClick(2))
   RectDrawn=1;
    else
        CurrentRect=plot(NaN,NaN); %dummy
    end
    
    CurrentPointPlots(2)=plot(CurrentPoint(1),CurrentPoint(2),'ro');

end


%here is where you do the hard work; rectangle was drawn, so have to update
if RectDrawn==1
    
    %first create the appendfilter

    
    minX=min([FirstClick(1), SecondClick(1)]);
    maxX=max([FirstClick(1) SecondClick(1)]);
    minY=min([FirstClick(2) SecondClick(2)]);
    maxY=max([FirstClick(2) SecondClick(2)]);
    
    AppendFilter='';
    
    XUnd=0; YUnd=0;
    
     if ~strcmp(XAxisVariable,'Undefined') && ~strcmp(XAxisVariable,'SpikeRate')%if they are not undefined, then create the append filter
        AppendFilter=[ AppendFilter XAxisVariable '<' num2str(maxX) '&' XAxisVariable '>' num2str(minX)]; 
     else XUnd=1;
     end
     
     if ~strcmp(YAxisVariable,'Undefined')&& ~strcmp(YAxisVariable,'SpikeRate')
        AppendFilter= [AppendFilter '&' YAxisVariable '<' num2str(maxY) '&' YAxisVariable '>' num2str(minY)];
     else YUnd=1;
     end
     
     if XUnd==0&&YUnd==0
    CurrentRect=rectangle('position',[min(FirstClick(1),SecondClick(1)) min(FirstClick(2), SecondClick(2)) range([FirstClick(1) SecondClick(1)]) range([FirstClick(2) SecondClick(2)])]);
     elseif (XUnd==1&&YUnd==0)
                  XLim=get(LinkAxisHandle,'xlim');
         CurrentRect(1)=plot(XLim,[FirstClick(2) FirstClick(2)],'k-');
         CurrentRect(2)=plot(XLim,[SecondClick(2) SecondClick(2)],'k-');


%          CurrentRect=errorbar((FirstClick(1)+SecondClick(1))/2,(FirstClick(2)+SecondClick(2))/2,range([FirstClick(2) SecondClick(2)])/2);
% CurrentRect=plot([FirstClick(1) SecondClick(1)],[FirstClick(2) SecondClick(2)],'k-');

     elseif XUnd==0&&YUnd==1
                  YLim=get(LinkAxisHandle,'ylim');
         CurrentRect(1)=plot([FirstClick(1) FirstClick(1)],YLim,'k-');
         CurrentRect(2)=plot([SecondClick(1) SecondClick(1)],YLim,'k-');
%          CurrentRect=herrorbar((FirstClick(1)+SecondClick(1))/2,(FirstClick(2)+SecondClick(2))/2,range([FirstClick(1) SecondClick(1)])/2);
     elseif XUnd==1&YUnd==1, CurrentRect=plot(NaN,NaN); %dummy
     end
     
     if size(CurrentRect,1)>1, CurrentRect=CurrentRect';end
    
    setappdata(LinkAxisHandle,'CurrentRect',CurrentRect);
 set(CurrentRect,'linewidth',1);

     
%          keyboard;

        %that is it, now we are ready to update, using this append filter
        
        if strcmp(XAxisVariable,'Time')
            UpdateType='TimeLinkAxis';
            TimeWindowLinkAxis=[FirstClick(1) SecondClick(1)];
        else
        UpdateType='LinkAxis';  %FirstClick and SecondClick are still available if necessary for use for timewindow vector
        end

        UpdateSlider;
     
    end
        


setappdata(LinkAxisHandle,'CurrentPointPlots',CurrentPointPlots);
set(CurrentPointPlots,'markersize',10,'markerfacecolor','r');

if NumClicks==3
    NumClicks=1; 
CurrentRect=getappdata(LinkAxisHandle,'CurrentRect');
    delete([OldPointPlots CurrentRect]);
    setappdata(LinkAxisHandle,'FirstClick',CurrentPoint);
end

NumClicks=NumClicks+1;

setappdata(LinkAxisHandle,'NumClicks',NumClicks);

set(LinkAxisHandle,'xlim',OldXLim','ylim',OldYLim);

drawnow;

% keyboard;
setappdata(gcf,'UsedByGUIData_m',handles); %this saves all the stuff you got from handles


end
% testax=axes;
% a=plot([0 0],[1 1]);
% set(a,'marker','none','color','k');
% set(testax,'Xgrid','on','ygrid','on','xlim',[0 1],'ylim',[0 1],'xtick',0:.2:1,'ytick',0:.2:1);
% hold on; 

        







