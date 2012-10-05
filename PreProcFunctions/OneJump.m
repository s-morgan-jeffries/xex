function CurrentVariables=OneJump(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes trials from the Jump paradigms
%	CurrentVariables=OneJump(Trials,klugestring,UseAx,SacOpts)


%Initializing Variables

ArrayNumber=nan*ones(1,length(Trials));
GoodTrial=ArrayNumber;
BadTrial=ArrayNumber;
PhotoBad=ArrayNumber;
RFPhotoBad=ArrayNumber;
GotToGap=ArrayNumber;
TrialNumber=1:length(Trials);

AbortTrial=ArrayNumber;
FixationBreak=ArrayNumber;

RewardTime=ArrayNumber;
RewardDur=ArrayNumber;
ErrorTime=ArrayNumber;
RFOnTime=ArrayNumber;
RFOffTime=ArrayNumber;
RFx=ArrayNumber;
RFy=ArrayNumber;
RFTrialIndex=ArrayNumber;
RFChecksize=ArrayNumber;

Jumpx=ArrayNumber;
Jumpy=ArrayNumber;

RFRed=ArrayNumber;
RFGreen=ArrayNumber;
RFBlue=ArrayNumber;

RF2OnTime=ArrayNumber;
RF2OffTime=ArrayNumber;
RF2Checksize=ArrayNumber;
RF2x=RF2OnTime;
RF2y=RF2OnTime;
RF2Red=ArrayNumber;
RF2Green=ArrayNumber;
RF2Blue=ArrayNumber;
RF2isRed=ArrayNumber;
RF2isGreen=ArrayNumber;
MarkerCode=ArrayNumber;
FPx=RFx;
FPy=RFy;

RGood=ArrayNumber;

if ~exist('klugestring','var') | (exist('klugestring','var')  & isempty(strfind(klugestring,'z050808')))
FPx(:)=0;
FPy(:)=0;
end

FPOnTime=RFy;

WTF=ArrayNumber;

SacEndX1=ArrayNumber;
SacEndY1=ArrayNumber;

GapTime=ArrayNumber;

fprintf('%s\n','Storing sacs');
Sacs=cell(1,length(ArrayNumber));

JNumSacs=ArrayNumber; %number of saccades between gap on and reward
JWhichSac=ArrayNumber;

TempSacStruct=MakeSacStruct(2);
FPToRF2Sac=repmat(TempSacStruct,1,length(Trials));
FromRF2Sac=FPToRF2Sac;
FromFPSac=FPToRF2Sac;
ToRF2Sac=FPToRF2Sac;
ToRFSac=FPToRF2Sac;
ToFPSac=FPToRF2Sac;
FirstGapSac=FPToRF2Sac;

FPToRF2=ArrayNumber;
ToRF2=ArrayNumber;
ToRF=ArrayNumber;

HowManySacs=ArrayNumber;
SaccadicLatency=ArrayNumber;
HowManyFinSacs=ArrayNumber;
FinWhichSac=ArrayNumber;
FinWhichSacLat=ArrayNumber;
Curv=ArrayNumber;
FirstDSac=ArrayNumber;
FirstDSacLat=ArrayNumber;
HowManyDSacs=ArrayNumber;

ArrayBak=[];   %for ArrayFiddleCodeBit

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','RGood','TrialNumber','AbortTrial',...
    'FixationBreak','RewardTime','ErrorTime','RFOnTime','RFOffTime','RFx','RFy','RFTrialIndex','RF2OnTime',...
    'RF2x','RF2y','FPx','FPy','FPOnTime','WTF','GapTime','JNumSacs','JWhichSac','TrueGood','RFEccentricity',...
    'RF2dist_toRF','RFGood','SacRelRFOn','SacRelRFOff','JumpSacTime','RFLat','dRFLat','RFSacLat','SacLat',...
    'RFSacLat_Cor','RFChecksize','RF2Checksize','RFRed','RFGreen','RFBlue','MarkerCode','HowManySacs',...
    'HowManyFinSacs','FinWhichSac','FinWhichSacLat','FirstDSac','FirstDSacLat','Curv','SacEndX1','SacEndY1'};
MyResponseVariableList={'GoodTrial'};


for TrialIndex=1:length(Trials)
    
    if rem(TrialIndex,500)==0, fprintf('%s\n',['Finished   ' num2str(TrialIndex) '  Trials']);end
    
    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
    CodeIndex=1:length(CurrentCodes);
    
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
    is_rf2=find(CurrentCodes==1047);
    is_rf2off=find(CurrentCodes==1040);
    is_jump=find(CurrentCodes==1005);
    
    if ~isempty(is_gap), GotToGap(TrialIndex)=1;end %this will help estimate percentage of saccades to distractor
    
        if ~isempty(is_reward) && ~isempty(is_error), WTF(TrialIndex)=100;end
        if length(is_reward)>1, WTF(TrialIndex)=101;end
            
    if ~isempty(is_fp)
        EarlyDrops=find(CurrentCodes>=10700);
        if length(EarlyDrops)>=4
        MarkerCode(TrialIndex)=(CurrentCodes(EarlyDrops(1))-11000);
            FPx(TrialIndex)=(CurrentCodes(EarlyDrops(3))-11000)/10;
        FPy(TrialIndex)=(CurrentCodes(EarlyDrops(4))-11000)/10;
        end
        if length(EarlyDrops)>=9
            RewardDur(TrialIndex)=(CurrentCodes(EarlyDrops(9))-11000);
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
    
            is_rfphotobad=find(CurrentCodes==1092&CurrentTimes>=RFOnTime(TrialIndex)); %note that if rf is not present, rfphotobad will not report either

            if ~isempty(is_rfphotobad) RFPhotoBad(TrialIndex)=1;end
        
               FindResult=find(CurrentCodes>=10000 & abs(CurrentTimes-RFOnTime(TrialIndex))<5);
          if length(FindResult)>=1
              RFChecksize(TrialIndex)=nanmin(CurrentCodes(FindResult)-10000); end  

                  TemporaryVariable=find(abs(CurrentTimes-RFOnTime(TrialIndex))<5 & CurrentCodes<=5255&CurrentCodes>=5000);
        if ~isempty(TemporaryVariable),
            RFRed(TrialIndex)=CurrentCodes(TemporaryVariable(1))-5000;
 			RFGreen(TrialIndex)=CurrentCodes(TemporaryVariable(1)+1)-5300;
 			RFBlue(TrialIndex)=CurrentCodes(TemporaryVariable(1)+2)-5600;
		end

        if ~isempty(is_rfoff)
            RFOffTime(TrialIndex)=CurrentTimes(is_rfoff(1));
        %else fprintf('%s\n','Weird in OneJump: RFOff without RFOn');
%         else keyboard;
        end
        
        TemporaryVariable=find(abs(CurrentTimes-RFOnTime(TrialIndex))<5 & CurrentCodes<=6850&CurrentCodes>=5650);
%         TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&CurrentCodes<6350&CurrentCodes>=5650);
        if ~isempty(TemporaryVariable), RFx(TrialIndex)=(CurrentCodes(TemporaryVariable(1))-6000)/10;end
%         TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&CurrentCodes>6250&CurrentCodes<=6750);
        if ~isempty(TemporaryVariable), RFy(TrialIndex)=(CurrentCodes(TemporaryVariable(2))-6500)/10;end

%         if RFy(TrialIndex)<0, keyboard;end
          
    end %ending the if ~isempty(is_rf) loop
    

        
    if ~isempty(is_rf2), RF2OnTime(TrialIndex)=CurrentTimes(is_rf2(1));
        
        FindResult=find(CurrentCodes>=10000 & abs(CurrentTimes-RF2OnTime(TrialIndex))<60);
          if length(FindResult)>=1
              RF2Checksize(TrialIndex)=nanmin(CurrentCodes(FindResult)-10000); end  
        
        TemporaryVariable=find(abs(CurrentTimes-RF2OnTime(TrialIndex))<100 & CurrentCodes<=5255&CurrentCodes>=5000);
        if ~isempty(TemporaryVariable),
            RF2Red(TrialIndex)=CurrentCodes(TemporaryVariable(1))-5000;
            RF2Green(TrialIndex)=CurrentCodes(TemporaryVariable(1)+1)-5300;
            RF2Blue(TrialIndex)=CurrentCodes(TemporaryVariable(1)+2)-5600;
        end
        TemporaryVariable=find(abs(CurrentTimes-RF2OnTime(TrialIndex))<100 & CurrentCodes<=6850&CurrentCodes>=5650);

%         TemporaryVariable=find(CurrentTimes>=RF2OnTime(TrialIndex)&CurrentCodes<6250&CurrentCodes>=5750);
        if ~isempty(TemporaryVariable), RF2x(TrialIndex)=(CurrentCodes(TemporaryVariable(1))-6000)/10;end
%         TemporaryVariable=find(CurrentTimes>=RF2OnTime(TrialIndex)&CurrentCodes>6250&CurrentCodes<=6750);
        if ~isempty(TemporaryVariable), RF2y(TrialIndex)=(CurrentCodes(TemporaryVariable(2))-6500)/10;end
TempVarRed=find(abs(CurrentTimes-RF2OnTime(TrialIndex))<100 & CurrentCodes<=5000&CurrentCodes>=5299);
        %         if ~isempty(TempVarRed), RF2Red(TrialIndex)=(CurrentCodes(TempVarRed(1))-5000);end
        %          TempVarGreen=find(abs(CurrentTimes-RF2OnTime(TrialIndex))<100 & CurrentCodes<=5300&CurrentCodes>=5599);
        %          if ~isempty(TempVarGreen), RF2Green(TrialIndex)=(CurrentCodes(TempVarGreen(1))-5300);end
        %           TempVarBlue=find(abs(CurrentTimes-RF2OnTime(TrialIndex))<100 & CurrentCodes<=5600&CurrentCodes>=5899);
        %           if ~isempty(TempVarBlue), RF2Blue(TrialIndex)=(CurrentCodes(TempVarBlue(1))-5600);end
        %         if RF2Red(TrialIndex)~=0&RF2Green(TrialIndex)==0, RF2isRed(TrialIndex)=1; end
        %         if RF2Red(TrialIndex)==0&RF2Green(TrialIndex)~=0, RF2isGreen(TrialIndex)=1; end
        TemporaryVariable=find(abs(CurrentTimes-RF2OnTime(TrialIndex))<100 & CurrentCodes<=5855&CurrentCodes>=5000);
        % keyboard;
         
%         if ~isempty(TemporaryVariable),
%             RF2Red(TrialIndex)=CurrentCodes(TemporaryVariable(1))-5000;
%             RF2Green(TrialIndex)=CurrentCodes(TemporaryVariable(1)+1)-5300;
%             RF2Blue(TrialIndex)=CurrentCodes(TemporaryVariable(1)+2)-5600;
%         end
        
        if ~isempty(is_rf2off)
            RF2OffTime(TrialIndex)=CurrentTimes(is_rf2off(1));
           
            %else fprintf('%s\n','Weird in OneJump: RFOff without RFOn');
            %         else keyboard;
        end
    end %ending the if ~isempty(is_rf2) loop
        
    if ~isempty(is_jump), JumpOnTime=CurrentTimes(is_jump(1));
        FindResult=find(CurrentCodes>=10000 & abs(CurrentTimes-JumpOnTime)<60);
        
        TemporaryVariable=find(abs(CurrentTimes-JumpOnTime)<100 & CurrentCodes<=6850&CurrentCodes>=5650);

%         TemporaryVariable=find(CurrentTimes>=RF2OnTime(TrialIndex)&CurrentCodes<6250&CurrentCodes>=5750);
        if ~isempty(TemporaryVariable), Jumpx(TrialIndex)=(CurrentCodes(TemporaryVariable(1))-6000)/10;end
%         TemporaryVariable=find(CurrentTimes>=RF2OnTime(TrialIndex)&CurrentCodes>6250&CurrentCodes<=6750);
        if ~isempty(TemporaryVariable), Jumpy(TrialIndex)=(CurrentCodes(TemporaryVariable(2))-6500)/10;end
    end %ending the if ~isempty(is_rf2) loop    
    
    
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

        if WTF(TrialIndex)>=100,  GoodTrial(TrialIndex)=NaN; BadTrial(TrialIndex)=NaN; end
        
        if(GoodTrial(TrialIndex)==1 || BadTrial(TrialIndex)==1)
            
       SacStruct=SacFind(Trials((TrialIndex)),1003,SacOpts.ISICut,SacOpts.MinLat,0,0,SacOpts.Threshold);
       Sacs{TrialIndex}=SacStruct;
  
       %Now search and allocate
       
% if ~isnan(SacStruct(1).latency) %i hope this is enough
            
    SacAmp=[SacStruct.amplitude];
    SacLat=[SacStruct.latency];
    SacDur=[SacStruct.duration];
    StartX=[SacStruct.startx];
    EndX=[SacStruct.endx];
    StartY=[SacStruct.starty];
    EndY=[SacStruct.endy];
    EndAtRF2=sqrt( (EndX-RF2x(TrialIndex)).^2 + (EndY-RF2y(TrialIndex)).^2 );
    EndAtJump=sqrt( (EndX-Jumpx(TrialIndex)).^2 + (EndY-Jumpy(TrialIndex)).^2 );
    EndAtRF=sqrt( (EndX-RFx(TrialIndex)).^2 + (EndY-RFy(TrialIndex)).^2 );    
    EndAtFP=sqrt( (EndX-FPx(TrialIndex)).^2 + (EndY-FPy(TrialIndex)).^2 ); 
    StartFromFP=sqrt( (StartX-FPx(TrialIndex)).^2 + (StartY-FPy(TrialIndex)).^2 );
    StartFromRF2=sqrt( (StartX-RF2x(TrialIndex)).^2 + (StartY-RF2y(TrialIndex)).^2 );
    StartFromRF=sqrt( (StartX-RFx(TrialIndex)).^2 + (StartY-RFy(TrialIndex)).^2 );    
    
    
    RefTime=GapTime(TrialIndex)-FPOnTime(TrialIndex)-100;
    
find_the_sac=find(SacLat>= RefTime & SacLat<=(RefTime+500)); %this gives me 400 ms after true gap on begins
    
    HowManySacs(TrialIndex)=length(find_the_sac);
    if HowManySacs(TrialIndex)>0
    SaccadicLatency(TrialIndex)=SacStruct(find_the_sac(1)).latency;
    SacEndX1(TrialIndex)=EndX(1);
    SacEndY1(TrialIndex)=EndY(1);
    end
    
find_the_sac=find(SacLat>= RefTime & SacLat<=(RefTime+500) & EndAtRF2<5.5); %this gives me 400 ms after true gap on begins
HowManyFinSacs(TrialIndex)=length(find_the_sac);
if HowManyFinSacs(TrialIndex)>0
FinWhichSac(TrialIndex)=find_the_sac(1);
FinWhichSacLat(TrialIndex)=SacLat(find_the_sac(1));
Curv(TrialIndex)=SacStruct(find_the_sac(1)).curvature(1);
end

find_the_sac=find(SacLat>= RefTime & SacLat<=(RefTime+500) & EndAtRF<5.0); %this gives me 400 ms after true gap on begins
HowManyDSacs(TrialIndex)=length(find_the_sac);
if HowManyDSacs(TrialIndex)>0
FirstDSac(TrialIndex)=find_the_sac(1);  %note that firstdsac can be 1, and also finwhichsac will be 1, if rf2 and rf are really close to each other
FirstDSacLat(TrialIndex)=SacLat(find_the_sac(1));
end   
    
    %Key Saccade !!!
    
    find_the_sac=find(StartFromFP<3 & EndAtRF2 < 3 & SacLat>= (GapTime(TrialIndex)-FPOnTime(TrialIndex)));
    find_the_sac=find(StartFromFP<4 & (EndAtRF2 < 5|EndAtJump<5) & SacLat>= (GapTime(TrialIndex)-FPOnTime(TrialIndex))-50); %used to be 2,2 for fp and rf2
    if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one fp_to_rf2 !!');end

%     if GoodTrial(TrialIndex)==1 & length(find_the_sac)==0, fprintf('change parameters   %d\n',TrialIndex);end
%     if(TrialIndex==27), keyboard;end
    
%     if GoodTrial(TrialIndex)==1, keyboard;end
    
    CreateTempSac;
    if isempty(find_the_sac), FPToRF2(TrialIndex)=0;end
    FPToRF2Sac(TrialIndex)=TempSac; clear TempSac;
    
    %Others
    
%     find_the_sac=find(StartFromRF2 < 4);
% %     if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one start from rf2 !!');end
%     CreateTempSac;
%     FromRF2Sac(TrialIndex)=TempSac; clear TempSac;
%     
%     find_the_sac=find(StartFromFP < 4);
% %     if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one start from fp !!');end
%     CreateTempSac;
%     FromFPSac(TrialIndex)=TempSac; clear TempSac;
%     

    find_the_sac=find(EndAtRF2 < 3 & SacLat>= (GapTime(TrialIndex)-FPOnTime(TrialIndex))-50);

%     find_the_sac=find(EndAtRF2 < 4);
% %     if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one ends at rf2 !!');end
    CreateTempSac;
    if isempty(find_the_sac), ToRF2(TrialIndex)=0;else ToRF2(TrialIndex)=1;end
    ToRF2Sac(TrialIndex)=TempSac; clear TempSac;
    
%     
    find_the_sac=find(EndAtRF < 6 & StartFromFP<3 & EndAtRF2>3& SacLat>= (GapTime(TrialIndex)-FPOnTime(TrialIndex))-50);
% %     if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one ends at rf !!');end
    CreateTempSac;
    if isempty(find_the_sac), ToRF(TrialIndex)=0;else ToRF(TrialIndex)=1;end
    ToRFSac(TrialIndex)=TempSac; clear TempSac;
%     
%     find_the_sac=find(EndAtFP < 4);
% %     if length(find_the_sac)>1, fprintf('%d\t%s\n',TrialIndex,'More than one ends at fp !!');end
%     CreateTempSac;
%     ToFPSac(TrialIndex)=TempSac; clear TempSac;
% 
%     find_the_sac=find(SacLat>=(GapTime(TrialIndex)-FPOnTime(TrialIndex)-60) & SacLat <= (RewardTime(TrialIndex)-FPOnTime(TrialIndex)) & SacAmp >=5 );
%     CreateTempSac;
%     FirstGapSac(TrialIndex)=TempSac; clear TempSac;
%     JNumSacs(TrialIndex)=length(find_the_sac);
%     
        end  % ending  if(GoodTrial==1 || BadTrial==1)
    
%     if TrialIndex==13, keyboard;end
    
%     if JNumSacs(TrialIndex)~=1, keyboard;end
%     end  % ending the sacccade analysis loop
    

end   %ending main loop

% keyboard;
RFDur=RFOffTime-RFOnTime;
RFDur(isnan(RFx)&isnan(RFy))=-1; % hack for no stimulus trials

RFGood=(RFOffTime-RFOnTime)<40 & (RFOffTime-RFOnTime)>20;  %rf has to be brief, 40 because of 60 Hz refresh rate, and only for flash stimuli. No use for continuous stimuli.



TrueGood=nan*GoodTrial;
RFEccentricity=sqrt( (RFx-FPx).^2 + (RFy-FPy).^2 );
JumpSacTime=[FPToRF2Sac.latency];
SacRelRFOn=RFOnTime-FPOnTime-JumpSacTime;    %RFOnTime relative to Saccade Onset
SacRelRFOff=RFOffTime-FPOnTime-JumpSacTime;  %RFOffTime relative to Saccade Onset

RFLat=(RFOnTime-GapTime);
%dRFLat=DiscretizeMe(RFLat,[50 100 150]);
dRFLat=DiscretizeMe(RFLat,[50 100 150 200]);
fprintf('%s\t','dRFing with'); fprintf('%d ',un(dRFLat)); fprintf('%s\n','');
RFSacLat=-1*SacRelRFOn;
SacLat=JumpSacTime-GapTime+FPOnTime;
FinWhichSacLat=FinWhichSacLat-GapTime+FPOnTime;
FirstDSacLat=FirstDSacLat-GapTime+FPOnTime;
RFSacLat_Cor=dRFLat+RFSacLat;

JWhichSac=[FPToRF2Sac.whichsac];

%alf stuff for top down
RF2dist_toRF=sqrt( (RF2x-RFx).^2 + (RF2y-RFy).^2 );

% KLUGE FOR KDE CALC

% RFSacLat_Cor(BadTrial==1)=10000;
% SacLat(BadTrial==1)=10000;

SacAlignTime1=JumpSacTime+FPOnTime;  %this is crucial !! Or weird bugs

% cell kluging

if ~exist('klugestring','var') | (exist('klugestring','var')  & isempty(strfind(klugestring,'z050808')))
 TrueGood(BadTrial==1&PhotoBad~=1)=0;  %removed RFGood==1, for continuous stimuli. Use in filter, if needed.
 TrueGood(GoodTrial==1&PhotoBad~=1)=1;
else 
fprintf('%s\n',['Kluging for cell      ' klugestring]);
end

RGood(GoodTrial==1&PhotoBad~=1&RFDur<=50)=1;
RGood(BadTrial==1&PhotoBad~=1&RFDur<=50)=0;

 
 %Now printing out details of analysis

 summaryString=[sprintf('%s\n','******************************************************************')];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(Trials)) '  trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(PhotoBad==1))) ' PhotoBad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(RFPhotoBad==1))) 'RFPhotoBad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(FixationBreak==1))) ' Fixation Breaks '])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1))) '  Good Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1&FPToRF2==0))),'  Good Trials with Bad Saccades'])];
  if length(find(GoodTrial==1|BadTrial==1))>0
 summaryString=[summaryString sprintf('%s\n',[num2str(100*(length(find(GoodTrial==1)))/length(find(GoodTrial==1|BadTrial==1)),'%3.2f') '  % correct'])];
  summaryString=[summaryString sprintf('%s\n',[num2str( 100*length(find(isnan(RFx) & GoodTrial==1))/length(find(GoodTrial==1)),'%3.2f') ' % good no-stimulus trials'])]; 
 else summaryString=[summaryString sprintf('%s\n','No good or bad trials')];
 end
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(WTF>=100))) '   Weird Trials. WTF > 100'])];
 if length(find(~isnan(RFOnTime)))>0
 summaryString=[summaryString sprintf('%s\n',[num2str( 100*length(find(~isnan(RFOffTime) & RFOffTime-RFOnTime <=100))/length(find(RFOnTime(~isnan(RFOnTime)))),'%3.2f') ' % flashes'])]; 
 else summaryString=[summaryString sprintf('%s\n','No RFs')];end
 

 
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];
 
 RFmat=[RFx;RFy]';
RFmat=RFmat(~isnan(RFmat(:,1)),:);

if ~isempty(RFmat)
    
 RFmat=un(RFmat);
 
 if exist('UseAx','var')&&UseAx~=0, axes(UseAx); 
    plot(RFx,RFy,'bo');
 end

    summaryString=[summaryString sprintf('%s\n','RFx     RFy')];
    for ii=1:size(RFmat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([RFmat(ii,1) RFmat(ii,2)],'%6.2f'))];
    end
else
    summaryString=[summaryString sprintf('%s\n','No RF')];
end

 RF2mat=[RF2x;RF2y]';
RF2mat=RF2mat(~isnan(RF2x),:);

if ~isempty(RF2mat)
RF2mat=un(RF2mat);
if length(RF2mat)<10
    summaryString=[summaryString sprintf('%s\n','RF2x     RF2y')];
    for ii=1:size(RF2mat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([RF2mat(ii,1) RF2mat(ii,2)],'%6.2f'))];
    end
    summaryString=[summaryString sprintf('%s\n','********')];
end
else summaryString=[summaryString sprintf('%s\n','No RF2')];
end

FPmat=[FPx(GoodTrial==1);FPy(GoodTrial==1)]'; %the GoodTrial==1 prevents 0 from showing up
FPmat=FPmat(~isnan(FPmat(:,1)),:);

if ~isempty(FPmat)
if size(FPmat,1)>1
    FPmat=un(FPmat);
end
if length(FPmat)<10
    summaryString=[summaryString sprintf('%s\n','FPx     FPy')];
    for ii=1:size(FPmat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([FPmat(ii,1) FPmat(ii,2)],'%6.2f'))];
    end
    summaryString=[summaryString sprintf('%s\n','********')];
end
else summaryString=[summaryString sprintf('%s\n','No FPs')];
end

% summaryString=[summaryString sprintf('%s\n','---------------------ANALYSIS NOTES---------------------------')];
% summaryString=[summaryString sprintf('%s\n','1. Look at RFLat histogram, and dRFLat dischistogram')];
% summaryString=[summaryString sprintf('%s\n','2. Look at SacLat Histogram for GoodTrial==1&PhotoBad~=1&~isnan(RFx)')];
% summaryString=[summaryString sprintf('%s\n','Eventually incorporate into command set ')];
summaryString=[summaryString sprintf('%s\n','USE RFPHOTOBAD')];
% summaryString=[summaryString sprintf('%s\n','---------------------ANALYSIS NOTES---------------------------')];

%packing variables into CurrentVariables

fprintf('%s\n',summaryString);
attachvars;

%how many gap times
%mean control latency
%percentage of good trials
%percentage of bad trials to rf2
%percentage of first saccade to target
%percentage of first saccade to rf2
%mean curvature index of first saccade to rf2
%mean saccade amplitude error (better than endpoint, as calibration can
%easily drift)
