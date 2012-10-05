function CurrentVariables=PostSac(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes trials from the old jumping eye-position task
%	CurrentVariables=PostSac(Trials,klugestring,UseAx,SacOpts)

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

RFTrialIndex=ArrayNumber;

FPx=ArrayNumber;
FPy=FPx;
FPang=FPx;
FPOnTime=FPy;
ToFPDelay=FPx;

ToFPSac=MakeSacStruct(2);

ArrayBak=[];   %for ArrayFiddleCodeBit

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','TrialNumber','AbortTrial','FixationBreak','RewardTime','ErrorTime','RFTrialIndex','FPx','FPy','FPang','FPOnTime',...
    'TrueGood','JumpSacTime','ToFPAngle','ToFPDelay'};
MyResponseVariableList={'GoodTrial'};

for TrialIndex=1:length(Trials)
    
    if rem(TrialIndex,500)==0, fprintf('%s\n',['Finished   ' num2str(TrialIndex) '  Trials']);end
    
    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
    
    RFTrialIndex(TrialIndex)=TrialIndex;
    
    is_reward=find(CurrentCodes==1012);
    is_error=find(CurrentCodes==1013);
    is_fp=find(CurrentCodes==1003);
    is_photobad=find(CurrentCodes==1092);
    is_abort=find(CurrentCodes==1090);
    is_fixationbreak=find(CurrentCodes==1091);

    
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
    
%array number filling

ArrayFiddleCodeBit;    %ArrayBak needs to be initialized at onset. Make sure

%SaccadeAnalysis

       SacStruct=SacFind(Trials((TrialIndex)),0,SacOpts.ISICut,SacOpts.MinLat,0,0,SacOpts.Threshold);
%        [SacStruct.angle]=deal([atan2([SacStruct.endy]-[SacStruct.starty],[SacStruct.endx]-[SacStruct.startx])]);
  
       %Now search and allocate
       
    SacAmp=[SacStruct.amplitude];
    SacLat=[SacStruct.latency];
    SacDur=[SacStruct.duration];
    StartX=[SacStruct.startx];
    EndX=[SacStruct.endx];
    StartY=[SacStruct.starty];
    EndY=[SacStruct.endy];
    EndAtFP=sqrt( (EndX-FPx(TrialIndex)).^2 + (EndY-FPy(TrialIndex)).^2 ); 
        
    %Key Saccade !!!
    
    find_the_sac=find(EndAtFP < 4 & SacLat<= FPOnTime(TrialIndex)); 
        if ~isempty(find_the_sac)
        TempSac=SacStruct(find_the_sac(1));
        TempSac.whichsac=find_the_sac(1);
        TempSac.angle=atan2(EndY(find_the_sac(1))-StartY(find_the_sac(1)),EndX(find_the_sac(1))-StartX(find_the_sac(1)));
        if TempSac.whichsac==1, ToFPDelay(TrialIndex)=TempSac.latency; else ToFPDelay(TrialIndex)=SacStruct(find_the_sac(1)).latency-(SacStruct(find_the_sac(1)-1).latency+SacStruct(find_the_sac(1)-1).duration);end

    else
       TempSac=MakeSacStruct(2);
        end
     
    ToFPSac(TrialIndex)=TempSac; clear TempSac;
    JNumSacs(TrialIndex)=length(find_the_sac);
   
    
end   %ending main loop


TrueGood=nan*GoodTrial;
JumpSacTime=[ToFPSac.latency];
ToFPAngle=[ToFPSac.angle];
ToFPAngle(ToFPAngle<0)=2*pi+ToFPAngle(ToFPAngle<0);
FPang=atan2(FPy,FPx);
FPang(FPang<0)=2*pi+FPang(FPang<0);

SacAlignTime1=JumpSacTime;  %this is crucial !!


% cell kluging

if ~exist('klugestring','var') | (exist('klugestring','var')  & isempty(strfind(klugestring,'z050808')))
 TrueGood(BadTrial==1&PhotoBad~=1)=0;  %removed RFGood==1, for continuous stimuli. Use in filter, if needed.
 TrueGood(GoodTrial==1&PhotoBad~=1)=1;
else
fprintf('%s\n',['Kluging for cell      ' klugestring]);
end

%packing variables into CurrentVariables


 
 %Now printing out details of analysis

 summaryString=[summaryString sprintf('%s\n','******************************************************************')];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(Trials)) '  trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(PhotoBad==1))) ' PhotoBad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1))) '  Good Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(100*(length(find(GoodTrial==1)))/length(find(GoodTrial==1|BadTrial==1)),'%3.2f') '  % correct'])];
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];


fprintf('%s\n',summaryString);
attachvars; 