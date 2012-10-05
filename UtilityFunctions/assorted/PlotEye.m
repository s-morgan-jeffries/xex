function PlotEye(Trials,Indices,PlotAxis)

%	This function plots eye position traces
%	Probably called from the trial viewer
%	PlotEye(Trials,Indices,PlotAxis)

%Initializing Variables

TrialIndex=Indices;

for TrialIndex=Indices
    
    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
        CodeIndices=1:length(CurrentCodes);

    is_reward=find(CurrentCodes==1012);
    is_error=find(CurrentCodes==1013);
    is_fp=find(CurrentCodes==1003);
    is_rf=find(CurrentCodes==1007);
    is_rfoff=find(CurrentCodes==1010);
    is_photobad=find(CurrentCodes==1092);
    is_abort=find(CurrentCodes==1090);
    is_fixationbreak=find(CurrentCodes==1091);
    is_gap=find(CurrentCodes==1004);
    is_rf2=find(CurrentCodes==1047);
    
    FPx=nan; FPy=nan; RFx=nan; RFy=nan; RF2x=nan; RF2y=nan; 
    RFOnTime=nan; RF2OnTime=nan;
    FPOnTime=nan;RewardTime=nan; ErrorTime=nan;
    
    SaccadeOptions=getappdata(0,'SaccadeOptions');

    cla(PlotAxis(1));
    cla(PlotAxis(2));
    
   [sac,fx,fy]=SacFind(Trials(TrialIndex),SaccadeOptions.CorrectCode,SaccadeOptions.ISICut,SaccadeOptions.MinLat,1,gcf,SaccadeOptions.Threshold,[PlotAxis(1) PlotAxis(2)]);
   hold on;
   PlotCodes(Trials(TrialIndex));
            
    if ~isempty(is_fp)
        EarlyDrops=find(CurrentCodes>=10700);
        if length(EarlyDrops)>=4
        FPx=(CurrentCodes(EarlyDrops(3))-11000)/10;
        FPy=(CurrentCodes(EarlyDrops(4))-11000)/10;
        end
    end
    
    if ~isempty(is_reward), GoodTrial=1;
            RewTimeVar=CurrentTimes(find(CurrentCodes==1012));
    RewardTime=RewTimeVar(1);    
    elseif ~isempty(is_error),
    ErrorTime=CurrentTimes(find(CurrentCodes==1013));
    end

    if ~isempty(is_fp), FPOnTime=CurrentTimes(is_fp(1));end
    if ~isempty(is_abort) AbortTrial=1;end
    if ~isempty(is_fixationbreak) FixationBreak=1;end
    
    %RF Properties
    
    if ~isempty(is_rf), RFOnTime=CurrentTimes(is_rf(1));
        
        if ~isempty(is_rfoff)
            RFOffTime=CurrentTimes(is_rfoff(1));
        end
        
        TemporaryVariable=find(abs(CurrentTimes-RFOnTime)<5 & CurrentCodes<=6850&CurrentCodes>=5650);
        if ~isempty(TemporaryVariable), RFx=(CurrentCodes(TemporaryVariable(1))-6000)/10;end
        if ~isempty(TemporaryVariable), RFy=(CurrentCodes(TemporaryVariable(2))-6500)/10;end

            
    end %ending the if ~isempty(is_rf) loop
    
    if ~isempty(is_rf2), RF2OnTime=CurrentTimes(is_rf2(1));
        TemporaryVariable=find(abs(CurrentTimes-RF2OnTime)<100 & CurrentCodes<=6850&CurrentCodes>=5650);

        if ~isempty(TemporaryVariable), RF2x=(CurrentCodes(TemporaryVariable(1))-6000)/10;end
        if ~isempty(TemporaryVariable), RF2y=(CurrentCodes(TemporaryVariable(2))-6500)/10;end
    end %ending the if ~isempty(is_rf2) loop
        
%     keyboard;
    
    axes(PlotAxis(3)); cla;
   
    h=plot(FPx,FPy,'ko');
    set(h,'markerfacecolor','k');
    hold on;
    h=plot(RF2x,RF2y,'bo');
    set(h,'markerfacecolor','b');
    set(gca,'xlim',[-25 25],'ylim',[-25 25],'box','off','tickdir','out');

    %**********************this is where the visual search stuff is done
    
   
            FindResult=find( inbetween(CurrentCodes,3001,3035) & inbetween( CurrentTimes-RFOnTime,0,65) );

            if length(FindResult)>=1
                NumStim=CurrentCodes(FindResult(1))-3000;
            else NumStim=NaN;
            end
            
            if NumStim>1

            %using the checksize drop to catch all rf codes and to verify
            %numstim

            FindResult=find( inbetween(CurrentCodes,10001,10010) & inbetween(CurrentTimes-RFOnTime,0,65) );

            if length(FindResult) < NumStim, fprintf('%s\n','Something wrong with RF Code Drops, Not enough codes ?');
            elseif length(FindResult)>NumStim, FindResult=FindResult(1:NumStim);  %only taking the first NumStim values
            end

            RFSet=repmat(struct('number',nan,'x',nan,'y',nan,'pat',nan,'checksize',nan,'ord',nan,'fgr',nan,'fgg',nan,'fgb',nan),1,NumStim); %initializing a structure to hold the rf property values

            for fillerindex=1:length(FindResult)    %filling in using values obtained for FindResult

                RFSet(fillerindex).number=fillerindex;
                RFSet(fillerindex).checksize=CurrentCodes(FindResult(fillerindex))-10000;

                if fillerindex==1, StartingIndex=is_rf(1); else StartingIndex=FindResult(fillerindex-1);end

                FindResult2= find ( CodeIndices > StartingIndex & CodeIndices < FindResult(fillerindex) & CurrentCodes>=5700 & CurrentCodes<=6800 );
                RFSet(fillerindex).x=(CurrentCodes(FindResult2(1))-6000)/10;
                RFSet(fillerindex).y=(CurrentCodes(FindResult2(2))-6500)/10;

                FindResult2= find ( CodeIndices > StartingIndex & CodeIndices < FindResult(fillerindex) & CurrentCodes>=7000 );
                RFSet(fillerindex).pat=CurrentCodes(FindResult2(1))-7000;

                StartingIndex=FindResult(fillerindex)-4;

                FindResult2= find ( CodeIndices > StartingIndex & CodeIndices < FindResult(fillerindex) & CurrentCodes>=5000 & CurrentCodes<=5855);
%                 fprintf('%d\t',length(FindResult2));
%                 if length(FindResult2)==4, keyboard;end
                if length(FindResult2)==3
                    RFSet(fillerindex).fgr=CurrentCodes(FindResult2(1))-5000;
                    RFSet(fillerindex).fgg=CurrentCodes(FindResult2(2))-5300;
                    RFSet(fillerindex).fgb=CurrentCodes(FindResult2(3))-5600;
                end

            end  %     ending ->   for fillerindex=1:length(FindResult)

            RFangs=atan2([RFSet.y],[RFSet.x]);
            RFangs(RFangs<0)=2*pi+RFangs(RFangs<0);
            [SortedAngs,SortedIndices]=sort(RFangs);

            for SortedIndex=1:length(SortedIndices)
                RFSet(SortedIndices(SortedIndex)).ord=SortedIndex-1; %start at 0
            end

            WhereisTarget=find([RFSet.pat]==28 | [RFSet.pat]==29);
            if ~isempty(WhereisTarget)
                TargX=RFSet(WhereisTarget).x;
                TargY=RFSet(WhereisTarget).y;
            end
            
            MaxGreen=nanmax([RFSet.fgg]);
            WhereisPop=find([RFSet.fgg]==MaxGreen);  %KLUGE : green 255 is popout
            if ~isempty(WhereisPop)
                PopX=RFSet(WhereisPop).x;
                PopY=RFSet(WhereisPop).y;
            end
            
            h=plot([RFSet.x],[RFSet.y],'bo');
            set(h,'markerfacecolor','b');
            h=plot(PopX,PopY,'bo');
            set(h,'markerfacecolor','g');
            h=plot(TargX,TargY,'ko');
            set(h,'markerfacecolor','k');
            
            else
                    h=plot(RFx,RFy,'ro');
                    set(h,'markerfacecolor','r');
            end
            %**************************************************************
    
    h=plot(fx(6:end),fy(6:end),'g-');
    set(h,'linewidth',2)
%     keyboard;
 
if(SaccadeOptions.CorrectCode==1003)
    
if ~isnan(RFOnTime)
h=plot(fx(RFOnTime-FPOnTime-5),fy(RFOnTime-FPOnTime-5),'ro');
set(h,'markerfacecolor','r');
end

if ~isnan(RF2OnTime),
    h=plot(fx(RF2OnTime-FPOnTime-5),fy(RF2OnTime-FPOnTime-5),'bo');
set(h,'markerfacecolor','r');
end
end

if ~isempty(is_reward), title('GoodTrial==1');
elseif ~isempty(is_fixationbreak), title('FixationBreak==1');
elseif ~isempty(is_abort), title('Abort==1');
elseif ~isempty(is_error), title('BadTrial==1');
end

end   %ending main loop

zoom on

