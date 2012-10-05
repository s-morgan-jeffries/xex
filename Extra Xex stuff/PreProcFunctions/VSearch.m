function CurrentVariables=VSearch(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes data from the search paradigm
%   It is crude and doesnt do any median based adjustments; better this way
%   for physiology
%   Different tack here, cos only first or at most
%   first two saccades are relevant: esp since we dont want to assume retinotopic
%   mapping
%   USING ADHOC 70 ms minlat, and mostly not bothering with niceties of
%   cleansac from old vsearch analysis protocol as in interlvproc
%   NOt DOING findmed_ilve either, cos due to 3/2 locations, unlikely to
%   have enough eye landings on all targets. Just base on stimulus
%   locations, also keeps consistent with search gang's analysis method
%   Micros maybe important, so mark separately esp for nearby RFs.
%	CurrentVariables=VSearch(Trials,klugestring,UseAx,SacOpts)
        
%   Initializing Trial by Trial Variables

ArrayNumber=nan*ones(1,length(Trials));
GoodTrial=ArrayNumber;
BadTrial=ArrayNumber;
PhotoBad=ArrayNumber;
TrialNumber=1:length(Trials);

MarkerCode=ArrayNumber;
MarkerTrialNumber=ArrayNumber;
BGLum=ArrayNumber;

AbortTrial=ArrayNumber;
FixationBreak=ArrayNumber;
GoodBarError=ArrayNumber;

RewardTime=ArrayNumber;
ErrorTime=ArrayNumber;
FPOnTime=ArrayNumber;
GapTime=ArrayNumber;
ReactionTime=ArrayNumber;
RFOnTime=ArrayNumber;
RFOffTime=ArrayNumber;

TargX=ArrayNumber;
TargY=TargX;
TargPat=ArrayNumber;
TargOrd=ArrayNumber;
TargCheck=ArrayNumber;
TargRed=ArrayNumber;
TargBlue=ArrayNumber;
TargGreen=ArrayNumber;

PopType=ArrayNumber;

PopX=ArrayNumber;
PopY=PopX;
PopOrd=ArrayNumber;
PopCheck=ArrayNumber;
PopRed=ArrayNumber;
PopGreen=ArrayNumber;
PopBlue=ArrayNumber;
NumStim=ArrayNumber;

ArrayBak=[];

NumSaccades=ArrayNumber;

FirstSacX=ArrayNumber;
FirstSacY=ArrayNumber;
FirstSacTargDist=ArrayNumber;

FirstSacOrd=ArrayNumber;
FSAtTarg=ArrayNumber;
FSAtPop=ArrayNumber;
FSAtOther=ArrayNumber;
FSToRF=ArrayNumber;
FSRFOrdist=ArrayNumber;

FSPopOrdist=ArrayNumber;
FSTargOrdist=ArrayNumber;

SecondSacX=ArrayNumber;
SecondSacY=ArrayNumber;
SecondSacOrd=ArrayNumber;
SSAtTarg=ArrayNumber;
SSAtPop=ArrayNumber;
SSToRF=ArrayNumber;
SSRFOrdist=ArrayNumber;
SecondSacTargDist=ArrayNumber;

%Will need some aligns linked to this at the end  !

FirstSacLat=ArrayNumber;
FirstSacDur=ArrayNumber;
SecondSacLat=ArrayNumber;
SecondSacDur=ArrayNumber;

RewX=ArrayNumber;
RewY=ArrayNumber;
RewTargDist=ArrayNumber;

OnX=ArrayNumber; % eye position at rf onset
OnY=ArrayNumber;
OnTargDist=ArrayNumber;

%RF related properties

WhatInRF=ArrayNumber;    %assign values based on target, popout or distractor
CurrentRF=getappdata(0,'RFLocation');
fprintf('%s\n',['Using RF Location of   '   num2str(CurrentRF)]);

ClosestOrd=ArrayNumber;


%Variables List

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','TrialNumber','AbortTrial','FixationBreak','GoodBarError','RewardTime','ErrorTime','FPOnTime','GapTime','RFOnTime','RFOffTime','GoodBarError',...
    'ReactionTime','TargX','TargY','TargPat','TargOrd','TargCheck','PopType','PopX','PopY','PopOrd','NumStim','NumSaccades','FirstSacX','FirstSacY','FirstSacOrd','FSAtTarg','FSAtPop','FSAtOther','SecondSacX',...
    'SecondSacY','SecondSacOrd','SSAtTarg','SSAtPop','FirstSacLat','FirstSacDur','SecondSacLat','SecondSacDur','WhatInRF','FirstSacTargDist','SecondSacTargDist','RewTargDist','OnTargDist','FSRFOrdist','SSRFOrdist','FSTargOrdist','FSPopOrdist'};
MyResponseVariableList={'ReactionTime','GoodTrial','BadTrial','FSAtPop','FSAtOther','SSAtPop','FSAtTarg','SSAtTarg','FirstSaclat','FSPopOrdist','FSTargOrdist'};

%Start filling in arrays

for TrialIndex=1:length(Trials)

    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CodeIndices=1:length(CurrentCodes);
    CurrentTimes=double([CurrentEvents.Time]);

    tracexx = double(Trials(TrialIndex).Signals(1).Signal);
    traceyy = double(Trials(TrialIndex).Signals(2).Signal);

    %checking for key codes here

    is_reward=find(CurrentCodes==1012);
    is_error=find(CurrentCodes==1013);
    is_fp=find(CurrentCodes==1003);
    is_rf=find(CurrentCodes==1007);
    is_rfoff=find(CurrentCodes==1010);
    is_photobad=find(CurrentCodes==1092);
    is_abort=find(CurrentCodes==1090);
    is_fixationbreak=find(CurrentCodes==1091);
    is_gap=find(CurrentCodes==1004);

    %GoodTrial, RewardTime, and ErrorTime

    if ~isempty(is_reward), GoodTrial(TrialIndex)=1;
        RewardTime(TrialIndex)=CurrentTimes(is_reward(1));
        RewX(TrialIndex)=tracexx(RewardTime(TrialIndex));
        RewY(TrialIndex)=traceyy(RewardTime(TrialIndex));
    elseif ~isempty(is_error),
        ErrorTime(TrialIndex)=CurrentTimes(is_error(1));
        if length(tracexx)>=ErrorTime(TrialIndex),
        RewX(TrialIndex)=tracexx(ErrorTime(TrialIndex));       
        RewY(TrialIndex)=traceyy(ErrorTime(TrialIndex));       
        end
    end
    

    if ~isempty(is_fp), FPOnTime(TrialIndex)=CurrentTimes(is_fp(1));end

        if ~isempty(is_fp)
            EarlyDrops=find(CurrentCodes>=11000);
            if length(EarlyDrops)>=2
               MarkerCode(TrialIndex)=CurrentCodes(EarlyDrops(1))-11000;
               BGLum(TrialIndex)=CurrentCodes(EarlyDrops(2))-11000;
%             FPx(TrialIndex)=(CurrentCodes(EarlyDrops(3))-11000)/10;
%             FPy(TrialIndex)=(CurrentCodes(EarlyDrops(4))-11000)/10;
            end
        end

    if ~isempty(is_photobad), PhotoBad(TrialIndex)=1;end
    if ~isempty(is_abort) AbortTrial(TrialIndex)=1;end
    if ~isempty(is_fixationbreak) FixationBreak(TrialIndex)=1;end

    if ~isempty(is_rf), RFOnTime(TrialIndex)=CurrentTimes(is_rf(1));

                if length(tracexx)>=RFOnTime(TrialIndex),
        OnX(TrialIndex)=tracexx(RFOnTime(TrialIndex));
        OnY(TrialIndex)=traceyy(RFOnTime(TrialIndex));
                end

        if ~isempty(is_reward) | ~isempty(is_error)    % only calculate if there is a reward code or an error code

            %Number of stimuli

            FindResult=find( inbetween(CurrentCodes,3001,3035) & inbetween( CurrentTimes-RFOnTime(TrialIndex),0,65) );

            if length(FindResult)>=1
                NumStim(TrialIndex)=CurrentCodes(FindResult(1))-3000;
            end

            %using the checksize drop to catch all rf codes and to verify
            %numstim

            FindResult=find( inbetween(CurrentCodes,10001,10010) & inbetween(CurrentTimes-RFOnTime(TrialIndex),0,65) );

            if length(FindResult) < NumStim(TrialIndex), fprintf('%s\n','Something wrong with RF Code Drops, Not enough codes ?');
            elseif length(FindResult)>NumStim(TrialIndex), FindResult=FindResult(1:NumStim(TrialIndex));  %only taking the first NumStim(TrialIndex) values
            end

            RFSet=repmat(struct('number',nan,'x',nan,'y',nan,'pat',nan,'checksize',nan,'ord',nan,'fgr',nan,'fgg',nan,'fgb',nan),1,NumStim(TrialIndex)); %initializing a structure to hold the rf property values

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
                TargX(TrialIndex)=RFSet(WhereisTarget).x;
                TargY(TrialIndex)=RFSet(WhereisTarget).y;
                TargPat(TrialIndex)=RFSet(WhereisTarget).pat;
                TargCheck(TrialIndex)=RFSet(WhereisTarget).checksize;
             TargRed(TrialIndex)=RFSet(WhereisTarget).fgr;
                TargGreen(TrialIndex)=RFSet(WhereisTarget).fgg;
                TargBlue(TrialIndex)=RFSet(WhereisTarget).fgb;                
                TargOrd(TrialIndex)=RFSet(WhereisTarget).ord;
            end
            
            MaxGreen=nanmax([RFSet.fgg]);
            WhereisPop=find([RFSet.fgg]==MaxGreen);  %KLUGE : green 255 is popout
            
            if length(WhereisPop)==1
                PopX(TrialIndex)=RFSet(WhereisPop).x;
                PopY(TrialIndex)=RFSet(WhereisPop).y;
                PopOrd(TrialIndex)=RFSet(WhereisPop).ord;
                PopCheck(TrialIndex)=RFSet(WhereisPop).checksize;
                PopRed(TrialIndex)=RFSet(WhereisPop).fgr;
                PopGreen(TrialIndex)=RFSet(WhereisPop).fgg;
                PopBlue(TrialIndex)=RFSet(WhereisPop).fgb;                
            
                if PopX(TrialIndex)==TargX(TrialIndex) & PopY(TrialIndex)==TargY(TrialIndex), PopType(TrialIndex)=3;
                else PopType(TrialIndex)=1;
                end

            else PopType(TrialIndex)=2; %no popout
%                 keyboard;
            end
                          
        if ~isempty(is_rfoff)
            RFOffTime(TrialIndex)=CurrentTimes(is_rfoff(1));
        end
        
           % Stimulus, X and Y locations !!
           
           ThisTrialX=[RFSet.x];
           ThisTrialY=[RFSet.y];
           
           % Estimating What in RF
           
           DistanceFromRF= ( ThisTrialX - CurrentRF(1) ).^2 + (ThisTrialY-CurrentRF(2)).^2;
           ClosestToRF= find ( DistanceFromRF == nanmin(DistanceFromRF) );
           if length(ClosestToRF)>1, fprintf('%s\n','More than 1 stimulus closest to RF !!!'); ClosestToRF=ClosestToRF(1);end
           ClosestOrd(TrialIndex)=RFSet(ClosestToRF).ord;
           if ClosestOrd(TrialIndex)==TargOrd(TrialIndex), WhatInRF(TrialIndex)=3;   %target in RF
           elseif ClosestOrd(TrialIndex)==PopOrd(TrialIndex), WhatInRF(TrialIndex)=1;  %popout distractor in RF
           else WhatInRF(TrialIndex)=2;   %distractor in RF
           end
           
           
            %Saccade analysis

            SacStruct=SacFind(Trials((TrialIndex)),1007,0,70);
            SacAmps=[SacStruct.amplitude];
            SaccadesSet=SacStruct(SacAmps>=2);
            
            NumSaccades(TrialIndex)=length(SaccadesSet);
            
            if NumSaccades(TrialIndex)>=1
           
                FirstSacX(TrialIndex)=SaccadesSet(1).endx;
                FirstSacY(TrialIndex)=SaccadesSet(1).endy;
                FirstSacLat(TrialIndex)=SaccadesSet(1).latency;
                FirstSacDur(TrialIndex)=SaccadesSet(1).duration;
            
                StimulusDists= ( FirstSacX(TrialIndex)-ThisTrialX).^2 + (FirstSacY(TrialIndex) - ThisTrialY).^2 ; %why sqrt unnecessarily :)
                ClosestStimulus = find( StimulusDists == nanmin(StimulusDists) );
                if length(ClosestStimulus)>1, fprintf('%s\n','More than one nearby stimulus !!'); ClosestStimulus=ClosestStimulus(1);end
                FirstSacOrd(TrialIndex)=RFSet(ClosestStimulus).ord;
                if FirstSacOrd(TrialIndex)==TargOrd(TrialIndex), FSAtTarg(TrialIndex)=1; else FSAtTarg(TrialIndex)=0;end
                if FirstSacOrd(TrialIndex)==PopOrd(TrialIndex), FSAtPop(TrialIndex)=1; else FSAtPop(TrialIndex)=0;end
                if FSAtTarg(TrialIndex)==0 & FSAtPop(TrialIndex)==0, FSAtOther(TrialIndex)=1; else FSAtOther(TrialIndex)=0;end
                
                FSRFOrdist(TrialIndex)=min(abs(FirstSacOrd(TrialIndex)-ClosestOrd(TrialIndex)),NumStim(TrialIndex)-abs(FirstSacOrd(TrialIndex)-ClosestOrd(TrialIndex)));
                FSPopOrdist(TrialIndex)=min(abs(FirstSacOrd(TrialIndex)-PopOrd(TrialIndex)),NumStim(TrialIndex)-abs(FirstSacOrd(TrialIndex)-PopOrd(TrialIndex)));
                FSTargOrdist(TrialIndex)=min(abs(FirstSacOrd(TrialIndex)-TargOrd(TrialIndex)),NumStim(TrialIndex)-abs(FirstSacOrd(TrialIndex)-TargOrd(TrialIndex)));
                
            end

            if NumSaccades(TrialIndex)>=2
                SecondSacX(TrialIndex)=SaccadesSet(2).endx;
                SecondSacY(TrialIndex)=SaccadesSet(2).endy;
                SecondSacLat(TrialIndex)=SaccadesSet(2).latency;
                SecondSacDur(TrialIndex)=SaccadesSet(2).duration;
            
                StimulusDists= ( SecondSacX(TrialIndex)-ThisTrialX).^2 + (SecondSacY(TrialIndex) - ThisTrialY).^2 ; %why sqrt unnecessarily :)
                ClosestStimulus = find( StimulusDists == nanmin(StimulusDists) );
                if length(ClosestStimulus)>1, fprintf('%s\n','More than one nearby stimulus !!'); ClosestStimulus=ClosestStimulus(1);end
                SecondSacOrd(TrialIndex)=RFSet(ClosestStimulus).ord;
                if SecondSacOrd(TrialIndex)==TargOrd(TrialIndex), SSAtTarg(TrialIndex)=1; else SSAtTarg(TrialIndex)=0; end
                if SecondSacOrd(TrialIndex)==PopOrd(TrialIndex), SSAtPop(TrialIndex)=1; else SSAtPop(TrialIndex)=0; end

                SSRFOrdist(TrialIndex)=min(abs(SecondSacOrd(TrialIndex)-ClosestOrd(TrialIndex)),NumStim(TrialIndex)-abs(SecondSacOrd(TrialIndex)-ClosestOrd(TrialIndex)));

            end
                        
        end  % ending the if ~isempty(is_reward) | ~isempty(is_error) 
   
    end %ending the if ~isempty(is_rf) loop

if ~isempty(is_gap), GapTime(TrialIndex)=CurrentTimes(is_gap(1));end

if ~isempty(is_rf) & GoodTrial(TrialIndex)~=1 & AbortTrial(TrialIndex)~=1 & FixationBreak(TrialIndex)~=1
    if ~isempty(is_error), BadTrial(TrialIndex)=1; 
    HowManyBars=find((CurrentCodes==11001|CurrentCodes==11002)&CurrentTimes>RFOnTime(TrialIndex));
    if length(HowManyBars)==1, GoodBarError(TrialIndex)=1; else GoodBarError(TrialIndex)=length(HowManyBars);end
    else BadTrial(TrialIndex)=2;end
end

       
 end  % THE BIG FAT END

if length(un(GoodBarError))==1 && un(GoodBarError)==0, else
BadTrial(GoodBarError~=1&BadTrial==1)=-1;
end

SacAlignTime1=FirstSacLat+RFOnTime;
SacAlignTime2=SecondSacLat+RFOnTime;

ReactionTime(GoodTrial==1)=RewardTime(GoodTrial==1)-RFOnTime(GoodTrial==1); %kluge
ReactionTime(BadTrial==1)=ErrorTime(BadTrial==1)-RFOnTime(BadTrial==1);
ReactionTime=ReactionTime-50; %for bar waiting time, I think 50 is what saproc uses.

RFGood=(RFOffTime-RFOnTime)<45 & (RFOffTime-RFOnTime)>20;
TrueGood=nan*GoodTrial;

 TrueGood(BadTrial==1&RFGood==1&PhotoBad~=1)=0;
 TrueGood(GoodTrial==1&RFGood==1&PhotoBad~=1)=1;

 FirstSacTargDist=sqrt ( (FirstSacX-TargX).^2 + (FirstSacY-TargY).^2);
 SecondSacTargDist=sqrt ( (SecondSacX-TargX).^2 + (SecondSacY-TargY).^2);
 RewTargDist=sqrt( (RewX-TargX).^2 + (RewY-TargY).^2 );
 OnTargDist=sqrt( (OnX-TargX).^2 + (OnY-TargY).^2 );

RFTrialIndex=1:length(Trials);

  %Now printing out details of analysis
 
summaryString=  sprintf('%s\n','******************************************************************');
summaryString=[summaryString sprintf('Unique Markers %s\n',[num2str([un(MarkerCode)])])];
summaryString=[summaryString sprintf('%s\n',[num2str([un(BGLum) un(TargCheck) un(NumStim)])])];
summaryString=[summaryString sprintf('%s\n',[num2str([un(TargRed) un(TargBlue) un(TargGreen)])])]; 
summaryString=[summaryString sprintf('%s\n',[num2str([un(PopRed) un(PopBlue) un(PopGreen)])])]; 
summaryString=[summaryString sprintf('%s\n',[num2str(length(Trials)) '  trials'])];
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1))) '  Good Trials'])];
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(100*(length(find(GoodTrial==1)))/length(find(GoodTrial==1|BadTrial==1)),'%3.2f') '  % correct'])];
 summaryString=[summaryString sprintf('%s\n','TargX   TargY')];
 summaryString=[summaryString,sprintf('%3.3f\t%3.3f\n',[un([TargX' TargY'])]')];
 summaryString=[summaryString sprintf('%s\n','PopX   PopY')];
 summaryString=[summaryString,sprintf('%3.3f\t%3.3f\n',[un([PopX' PopY'])]')];
summaryString=[summaryString,sprintf('%s percent sacs to target',num2str(100*(length(find(GoodTrial==1&PhotoBad~=1&FSTargOrdist<=1)))/length(find(GoodTrial==1&PhotoBad~=1))))];
summaryString=[summaryString,sprintf('%s\n','')];
summaryString=[summaryString,sprintf('%s percent sacs to pop',num2str(100*(length(find(GoodTrial==1&PhotoBad~=1&FSPopOrdist<=1)))/length(find(GoodTrial==1&PhotoBad~=1))))];
summaryString=[summaryString,sprintf('%s\n','')];
%  summaryString=[summaryString,'\n',[num2str(un([PopX' PopY']))]];
  summaryString=[summaryString sprintf('%s\n','******************************************************************')];
%  RFmat=[RFx;RFy]';
%  RFmat=RFmat(~isnan(RFmat(:,1)),:);
%  RFmat=unique(RFmat,'rows');
%  summaryString=[summaryString sprintf('%s\n','RFx        RFy')];
%  
%  for printIndex=1:size(RFmat,1)
%      summaryString=[summaryString sprintf('%3.1f\t%3.1f\t',RFmat(printIndex,1),RFmat(printIndex,2))];
%       summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
% summaryString=[summaryString sprintf('%s\t','T-trials  ')];
%  summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFPat==29&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==29&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
%   summaryString=[summaryString sprintf('%s\t','Inverted T trials')];
%  summaryString=[summaryString sprintf('%s\n ',[num2str(100*(length(find(GoodTrial==1&RFPat==28&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==28&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
% 
%  end
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];


  MarkerAnalyze;
fprintf('%s\n',summaryString);

  attachvars;
