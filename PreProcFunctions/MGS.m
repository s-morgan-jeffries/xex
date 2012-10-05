function CurrentVariables=MGS(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes files from the MGS paradigm
%	CurrentVariables=MGS(Trials,klugestring,UseAx,SacOpts)

%Initializing Variables

ArrayNumber=nan*ones(1,length(Trials));
GoodTrial=ArrayNumber;
BadTrial=ArrayNumber;
PhotoBad=ArrayNumber;
TrialNumber=1:length(Trials);

AbortTrial=ArrayNumber;
FixationBreak=ArrayNumber;

RewardTime=ArrayNumber;
ErrorTime=ArrayNumber;
RFOnTime=ArrayNumber;
RFOffTime=ArrayNumber;
RFx=ArrayNumber;
RFy=ArrayNumber;
RFTrialIndex=ArrayNumber;

FPx=RFx;
FPy=RFy;
FPOnTime=RFy;


GapTime=ArrayNumber;

JNumSacs=ArrayNumber; %number of saccades between gap on and reward

% FPToRFSac=MakeSacStruct(1);
% FirstGapSac=FPToRFSac;
% FromRFSac=FPToRFSac;

ArrayBak=[];   %for ArrayFiddleCodeBit

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','TrialNumber','AbortTrial','FixationBreak','RewardTime','ErrorTime','RFOnTime','RFOffTime','RFx','RFy','RFAng','RFPat','RFTrialIndex','FPx','FPy','FPOnTime','GapTime'...
    'JNumSacs','TrueGood','JumpSacTime','SacAlignTime1','SacAlignTime2','SacRelRFOn'};
MyResponseVariableList={'TrueGood'};

for TrialIndex=1:length(Trials)
    
    if rem(TrialIndex,500)==0, fprintf('%s\n',['Finished   ' num2str(TrialIndex) '  Trials']);end
    
    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
    
    RFTrialIndex(TrialIndex)=TrialIndex;
    
    is_reward=find(CurrentCodes==1012);
    is_error=find(CurrentCodes==1013);
    is_fp=find(CurrentCodes==1003);
    is_rf=find(CurrentCodes==1007);
    is_rfoff=find(CurrentCodes==1010);
    is_photobad=find(CurrentCodes==1092);
    is_abort=find(CurrentCodes==1090);
    is_fixationbreak=find(CurrentCodes==1091);
    is_gap=find(CurrentCodes==1004);
    
            
    if ~isempty(is_fp)
        EarlyDrops=find(CurrentCodes>=10700);
        if length(EarlyDrops)>=4
        FPx(TrialIndex)=(CurrentCodes(EarlyDrops(3))-11000)/10;
        FPy(TrialIndex)=(CurrentCodes(EarlyDrops(4))-11000)/10;
        end
    end
    
    if ~isempty(is_reward), GoodTrial(TrialIndex)=1;
            RewTimeVar=CurrentTimes(find(CurrentCodes==1012));
    RewardTime(TrialIndex)=RewTimeVar(1);    
    elseif ~isempty(is_error),
    ErrorTime(TrialIndex)=CurrentTimes(find(CurrentCodes==1013));
    end

    if ~isempty(is_fp), FPOnTime(TrialIndex)=CurrentTimes(is_fp(1));end
    if ~isempty(is_photobad), PhotoBad(TrialIndex)=1;end
    if ~isempty(is_abort) AbortTrial(TrialIndex)=1;end
    if ~isempty(is_fixationbreak) FixationBreak(TrialIndex)=1;end
    
    %RF Properties
    
    if ~isempty(is_rf), RFOnTime(TrialIndex)=CurrentTimes(is_rf(1));
        
        if ~isempty(is_rfoff)
            RFOffTime(TrialIndex)=CurrentTimes(is_rfoff(1));
        %else fprintf('%s\n','Weird in OneJump: RFOff without RFOn');
%         else keyboard;
        end

        TemporaryVariable=find((CurrentTimes-RFOnTime(TrialIndex))<70 & (CurrentTimes-RFOnTime(TrialIndex))>=0 & CurrentCodes<=6850&CurrentCodes>=5650);
%         TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&CurrentCodes<6250&CurrentCodes>=5750);
        if length(TemporaryVariable>=2), RFx(TrialIndex)=(CurrentCodes(TemporaryVariable(1))-6000)/10; %end
%         TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&CurrentCodes>6250&CurrentCodes<=6750);
%         if ~isempty(TemporaryVariable), 
            RFy(TrialIndex)=(CurrentCodes(TemporaryVariable(2))-6500)/10;
     end

    end %ending the if ~isempty(is_rf) loop
    
%If gap, set bad trials

if ~isempty(is_gap), 
    GapTime(TrialIndex)=CurrentTimes(is_gap(1));
    if GoodTrial(TrialIndex)~=1 & AbortTrial(TrialIndex)~=1 & FixationBreak(TrialIndex)~=1
        if ~isempty(is_error), BadTrial(TrialIndex)=1;     
        else BadTrial(TrialIndex)=2;
        end
    end
end   %gap has to have occurred for a true bad trial

%array number filling

ArrayFiddleCodeBit;    %ArrayBak needs to be initialized at onset. Make sure

%SaccadeAnalysis
        
       SacStruct=SacFind(Trials((TrialIndex)),1003,SacOpts.ISICut,SacOpts.MinLat,0,0,SacOpts.Threshold);
  
       %Now search and allocate
       
% if ~isnan(SacStruct(1).latency) %i hope this is enough
            
    SacAmp=[SacStruct.amplitude];
    SacLat=[SacStruct.latency];
    SacDur=[SacStruct.duration];
    StartX=[SacStruct.startx];
    EndX=[SacStruct.endx];
    StartY=[SacStruct.starty];
    EndY=[SacStruct.endy];
    EndAtRF=sqrt( (EndX-RFx(TrialIndex)).^2 + (EndY-RFy(TrialIndex)).^2 );    
    StartFromFP=sqrt( (StartX-FPx(TrialIndex)).^2 + (StartY-FPy(TrialIndex)).^2 );
    StartFromRF=sqrt( (StartX-RFx(TrialIndex)).^2 + (StartY-RFy(TrialIndex)).^2 );
   

    %Key Saccade !!!
    
    find_the_sac=find(StartFromFP<3 & EndAtRF < 7 & SacLat>= (GapTime(TrialIndex)-FPOnTime(TrialIndex)));
    if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one fp_to_rf !!');end
   if GoodTrial(TrialIndex)==1 & isempty(find_the_sac), fprintf('%s\n','More strangeness in RF code drops');end
    
    if ~isempty(find_the_sac)
        TempSac=SacStruct(find_the_sac(1));
        TempSac.rfdistance=EndAtRF(find_the_sac(1));
        TempSac.gaplatency=SacLat(find_the_sac(1))-GapTime(TrialIndex);
        TempSac.whichsac=find_the_sac(1);
        TempSac.angle=atan2(EndY(find_the_sac(1))-StartY(find_the_sac(1)),EndX(find_the_sac(1))-StartX(find_the_sac(1)));
    else
       TempSac=MakeSacStruct(1);
       TempSac.rfdistance=nan; TempSac.gaplatency=nan; TempSac.whichsac=NaN; TempSac.angle=nan;
    end

    FPToRFSac(TrialIndex)=TempSac; clear TempSac;
    
    find_the_sac=find(SacLat>=(GapTime(TrialIndex)-FPOnTime(TrialIndex)));

        if ~isempty(find_the_sac)
        TempSac=SacStruct(find_the_sac(1));
        TempSac.rfdistance=EndAtRF(find_the_sac(1));
        TempSac.gaplatency=SacLat(find_the_sac(1))-GapTime(TrialIndex);
        TempSac.whichsac=find_the_sac(1);
        TempSac.angle=atan2(EndY(find_the_sac(1))-StartY(find_the_sac(1)),EndX(find_the_sac(1))-StartX(find_the_sac(1)));
    else
       TempSac=MakeSacStruct(1);
       TempSac.rfdistance=nan; TempSac.gaplatency=nan; TempSac.whichsac=NaN; TempSac.angle=nan;
        end

        FirstGapSac(TrialIndex)=TempSac; clear TempSac;
    JNumSacs(TrialIndex)=length(find_the_sac);

%     
%     find_the_sac=find(SacLat>=(GapTime(TrialIndex)-FPOnTime(TrialIndex))&StartFromRF<3);
%         if ~isempty(find_the_sac)
%         TempSac=SacStruct(find_the_sac(1));
%         TempSac.rfdistance=EndAtRF(find_the_sac(1));
%         TempSac.gaplatency=SacLat(find_the_sac(1))-GapTime(TrialIndex);
%         TempSac.whichsac=find_the_sac(1);
%         TempSac.angle=atan2(EndY(find_the_sac(1))-StartY(find_the_sac(1)),EndX(find_the_sac(1))-StartX(find_the_sac(1)));
%     else
%        TempSac=MakeSacStruct(2);
%     end
%         FromRFSac(TrialIndex)=TempSac; clear TempSac;


end   %ending main loop

RFGood=(RFOffTime-RFOnTime)<100 & (RFOffTime-RFOnTime)>20;  %rf has to be brief, 40 because of 60 Hz refresh rate, and only for flash stimuli. No use for continuous stimuli.
TrueGood=nan*GoodTrial;
RFEccentricity=sqrt( (RFx-FPx).^2 + (RFy-FPy).^2 );
JumpSacTime=[FPToRFSac.latency];
SacRelRFOn=RFOnTime-FPOnTime-JumpSacTime;    %RFOnTime relative to Saccade Onset

SacAlignTime1=JumpSacTime+FPOnTime;  %this is crucial !! Or weird bugs
% SacAlignTime2=[FromRFSac.latency]+FPOnTime;
 RFAng=atan2(RFy,RFx);
 RFAng(RFAng<0)=2*pi+RFAng(RFAng<0);
 UnRFAng=un(RFAng);

% cell kluging

if ~exist('klugestring','var') | (exist('klugestring','var')  & isempty(strfind(klugestring,'z050808')))
 TrueGood(BadTrial==1&PhotoBad~=1)=0;  %removed RFGood==1, for continuous stimuli. Use in filter, if needed.
 TrueGood(GoodTrial==1&PhotoBad~=1)=1;
else
fprintf('%s\n',['Kluging for cell      ' klugestring]);
end


 %Now printing out details of analysis

 summaryString=[ sprintf('%s\n','******************************************************************')];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(Trials)) '  trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(PhotoBad==1))) ' PhotoBad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1))) '  Good Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(100*(length(find(GoodTrial==1)))/length(find(GoodTrial==1|BadTrial==1)),'%3.2f') '  % correct'])];
 summaryString=[summaryString sprintf('%s\n',num2str([un([RFx RFy])]))];
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];
 RFmat=[RFx;RFy]';
 RFmat=RFmat(~isnan(RFmat(:,1)),:);
 RFmat=unique(RFmat,'rows');
 
 if exist('UseAx','var')&&UseAx~=0, axes(UseAx); 
    plot(RFx,RFy,'bo');
end

 %packing variables into CurrentVariables

fprintf('%s\n',summaryString);
attachvars; 