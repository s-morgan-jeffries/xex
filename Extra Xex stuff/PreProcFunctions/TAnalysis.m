function CurrentVariables=TAnalysis(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes data from the 2-T paradigm
%	CurrentVariables=TAnalysis(Trials,klugestring,UseAx,SacOpts)

%Initializing Variables

ArrayNumber=nan*ones(1,length(Trials));
GoodTrial=ArrayNumber;
BadTrial=ArrayNumber;
PhotoBad=ArrayNumber;
TrialNumber=1:length(Trials);
MarkerCode=ArrayNumber;

AbortTrial=ArrayNumber;
FixationBreak=ArrayNumber;

RewardTime=ArrayNumber;
ErrorTime=ArrayNumber;
FPTime=ArrayNumber;
RFOnTime=ArrayNumber;
RFOffTime=ArrayNumber;
RFx=ArrayNumber;
RFy=ArrayNumber;
RFPat=ArrayNumber;
RFChecksize=ArrayNumber;
RFTrialIndex=ArrayNumber;
NumRFs=ArrayNumber;

FPx=RFx;
FPy=RFy;

RF2x=RFx;
RF2y=RFy;
RF2Pat=RFPat;
RF2Checksize=RFChecksize;
RF2OnTime=RFOnTime;
RF2OffTime=RFOffTime;
SOA=RFx;

GapTime=ArrayNumber;
GoodBarError=ArrayNumber;

NumSaccades=ArrayNumber;
SaccadeAmplitude=ArrayNumber;

ReactionTime=ArrayNumber;

ArrayBak=[];

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','TrialNumber','AbortTrial','FixationBreak','RewardTime','ErrorTime','FPTime','RFOnTime','RFOffTime','SOA','dSOA','RFx','RFy','RFPat','RFTrialIndex','GapTime','GoodBarError','NumSaccades','SaccadeAmplitude',...
    'ReactionTime','RFGood','TrueGood','NumRFs'};
MyResponseVariableList={'ReactionTime','GoodTrial','BadTrial','TrueGood'};


 for TrialIndex=1:length(Trials)
    
    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
%     fprintf('%d\n',TrialIndex);
    
    RFTrialIndex(TrialIndex)=TrialIndex;
    
    is_reward=find(CurrentCodes==1012);
    is_error=find(CurrentCodes==1013);
    is_fp=find(CurrentCodes==1003);
    is_rf=find(CurrentCodes==1007);
    is_rf2=find(CurrentCodes==1047);
    is_rfoff=find(CurrentCodes==1010);
    is_rf2off=find(CurrentCodes==1040);
    is_photobad=find(CurrentCodes==1092);
    is_abort=find(CurrentCodes==1090);
    is_fixationbreak=find(CurrentCodes==1091);
    is_gap=find(CurrentCodes==1004);
    
%     NumRFs(TrialIndex)=length((is_rf));
    
    if ~isempty(is_reward), GoodTrial(TrialIndex)=1;
    RewardTime(TrialIndex)=CurrentTimes(is_reward(1));
    elseif ~isempty(is_error),
    ErrorTime(TrialIndex)=CurrentTimes(is_error(1));
    end

    if ~isempty(is_fp), FPTime(TrialIndex)=CurrentTimes(is_fp(1));end
                   
    if ~isempty(is_fp)
        EarlyDrops=find(CurrentCodes>=10700);
        if length(EarlyDrops)>=4
                           MarkerCode(TrialIndex)=CurrentCodes(EarlyDrops(1))-11000;
        FPx(TrialIndex)=(CurrentCodes(EarlyDrops(3))-11000)/10;
        FPy(TrialIndex)=(CurrentCodes(EarlyDrops(4))-11000)/10;
        end
    end
    
    if ~isempty(is_photobad), PhotoBad(TrialIndex)=1;end
    if ~isempty(is_abort) AbortTrial(TrialIndex)=1;end
    if ~isempty(is_fixationbreak) FixationBreak(TrialIndex)=1;end
    
    if ~isempty(is_rf), RFOnTime(TrialIndex)=CurrentTimes(is_rf(1));
     
        FindResult=find(CurrentCodes>=10000 & (CurrentTimes-RFOnTime(TrialIndex))==0 );
          if length(FindResult)>=1
              RFChecksize(TrialIndex)=nanmin(CurrentCodes(FindResult)-10000); end  
    
          SacStruct=SacFind(Trials((TrialIndex)),1007,0,0);
    SacAmps=[SacStruct.amplitude];
    if isnan(SacStruct(1).latency) NumSaccades(TrialIndex)=0;else
        NumSaccades(TrialIndex)=length(find(SacAmps>5));
if ~isempty(SacAmps) && length(find(~isnan(SacAmps)))~=0,        SaccadeAmplitude(TrialIndex)=nanmax(SacAmps); end
    end  % ending the sacccade analysis loop
   
    end %ending the if ~isempty(is_rf) loop

   if ~isempty(is_rfoff)
    RFOffTime(TrialIndex)=CurrentTimes(is_rfoff(1));
end
    
%finding rf properties

TemporaryIndex=1:length(CurrentCodes);
TemporaryLocation=NaN;
if ~isnan(RFOnTime(TrialIndex))
TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&(CurrentCodes==7029|CurrentCodes==7028));    %assumes 28 and 29 for up-T and down-T
if ~isempty(TemporaryVariable), RFPat(TrialIndex)=CurrentCodes(TemporaryVariable(1))-7000;
TemporaryLocation=TemporaryVariable(1);
end

        TemporaryVariable=find(abs(CurrentTimes-RFOnTime(TrialIndex))<5 & CurrentCodes<=6850&CurrentCodes>=5650&TemporaryIndex>TemporaryLocation);

% TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&CurrentCodes<6250&CurrentCodes>=5750&TemporaryIndex>TemporaryLocation);
% if ~isempty(TemporaryVariable), 
if length(TemporaryVariable)>=2
    RFx(TrialIndex)=(CurrentCodes(TemporaryVariable(1))-6000)/10;%end
% TemporaryVariable=find(CurrentTimes>=RFOnTime(TrialIndex)&CurrentCodes>6250&CurrentCodes<=6750&TemporaryIndex>TemporaryLocation);
% if ~isempty(TemporaryVariable), 
    RFy(TrialIndex)=(CurrentCodes(TemporaryVariable(2))-6500)/10;end

end

if ~isempty(is_gap), GapTime(TrialIndex)=CurrentTimes(is_gap(1));end

if ~isempty(is_rf) & GoodTrial(TrialIndex)~=1 & AbortTrial(TrialIndex)~=1 & FixationBreak(TrialIndex)~=1
    if ~isempty(is_error), BadTrial(TrialIndex)=1; 
    HowManyBars=find((CurrentCodes==11001|CurrentCodes==11002)&CurrentTimes>RFOnTime(TrialIndex));
    if length(HowManyBars)==1, GoodBarError(TrialIndex)=1; else GoodBarError(TrialIndex)=length(HowManyBars);end
    else BadTrial(TrialIndex)=2;end
end

%doing some rf2 calculations

 if ~isempty(is_rf2), RF2OnTime(TrialIndex)=CurrentTimes(is_rf2(1));
        
      FindResult=find(CurrentCodes>=5700 & CurrentCodes<=6800 & (CurrentTimes-RF2OnTime(TrialIndex))>=0 & (CurrentTimes-RF2OnTime(TrialIndex))<=50 ); %Within 50 ms of RF2On, max abs coords of 300
        if length(FindResult)>=2
            RF2x(TrialIndex)=(CurrentCodes(FindResult(1))-6000)/10;
            RF2y(TrialIndex)=(CurrentCodes(FindResult(2))-6500)/10;
        end     
   
         FindResult=find(CurrentCodes>=10000 & (CurrentTimes-RF2OnTime(TrialIndex))>=0 & (CurrentTimes-RF2OnTime(TrialIndex))<=50 ); %Within 50 ms of RFOn
          if length(FindResult)>=1
              RF2Checksize(TrialIndex)=nanmin(CurrentCodes(FindResult)-10000); 
          end  

        FindResult=find(CurrentCodes>=7000 & (CurrentTimes-RF2OnTime(TrialIndex))>=0 & (CurrentTimes-RF2OnTime(TrialIndex))<=50 ); %Within 50 ms of RFOn
        if length(FindResult)>=1
            RF2Pat(TrialIndex)=CurrentCodes(FindResult(1))-7000;
        end
 
        if ~isempty(is_rf2off), RF2OffTime(TrialIndex)=CurrentTimes(is_rf2off(1));end
 
 end %ending the if ~isempty(is_rf2) loop
    
    %a little fiddling to take care of oCurrentCodesasions where rex doenst drop an arrya code. details.
    % Verify this IMP
    
    TemporaryArrayNumber=find(CurrentCodes>=2000&CurrentCodes<=2060);
    if ~isempty(TemporaryArrayNumber)
        if length(TemporaryArrayNumber)==1 ArrayNumber(TrialIndex)=CurrentCodes(TemporaryArrayNumber)-2000; ArrayBak=[];
        elseif length(TemporaryArrayNumber)==2 ArrayNumber(TrialIndex)=CurrentCodes(TemporaryArrayNumber(1))-2000; ArrayBak=CurrentCodes(TemporaryArrayNumber(2))-2000;
        else ArrayNumber(TrialIndex)=-1; ArrayBak=[];
        end
    elseif ~isempty(ArrayBak) ArrayNumber(TrialIndex)=ArrayBak; ArrayBak=[];
    end
    
 end

SOA=RFOnTime-RF2OnTime;
dSOA=DiscretizeMe(SOA,100:100:300);
dSOA(isnan(RF2OnTime))=0;

 
if length(un(GoodBarError))==1 && un(GoodBarError)==0, else
BadTrial(GoodBarError~=1&BadTrial==1)=-1;
end

ReactionTime(GoodTrial==1)=RewardTime(GoodTrial==1)-RFOnTime(GoodTrial==1); %kluge
ReactionTime(BadTrial==1)=ErrorTime(BadTrial==1)-RFOnTime(BadTrial==1);

% RFGood=(RFOffTime-RFOnTime)<45 & (RFOffTime-RFOnTime)>20;
TrueGood=nan*GoodTrial;
RFDuration=RFOffTime-RFOnTime;
RFGood=RFDuration<60;

if ~exist('klugestring','var') | (exist('klugestring','var')  & isempty(strfind(klugestring,'z050808')))

 TrueGood(BadTrial==1&RFGood==1&PhotoBad~=1)=0;
 TrueGood(GoodTrial==1&RFGood==1&PhotoBad~=1)=1;
else
fprintf('%s\n',['Kluging for cell      ' klugestring]);
 TrueGood(BadTrial==1)=0;
 TrueGood(GoodTrial==1)=1;
end

 

 
 %Now printing out details of analysis
 
summaryString=  sprintf('%s\n','******************************************************************');
summaryString=[summaryString sprintf('%s\n',[num2str(length(Trials)) '  trials'])];
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1))) '  Good Trials'])];
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(100*(length(find(GoodTrial==1)))/length(find(GoodTrial==1|BadTrial==1)),'%3.2f') '  % correct'])];
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];
 RFmat=[RFx;RFy]';
 RFmat=RFmat(~isnan(RFmat(:,1)),:);
 RFmat=unique(RFmat,'rows');
 summaryString=[summaryString sprintf('%s\n','RFx        RFy')];
 
 for printIndex=1:size(RFmat,1)
     summaryString=[summaryString sprintf('%3.1f\t%3.1f\t',RFmat(printIndex,1),RFmat(printIndex,2))];
      summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
summaryString=[summaryString sprintf('%s\t','T-trials  ')];
 summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFPat==29&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==29&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
  summaryString=[summaryString sprintf('%s\t','Inverted T trials')];
 summaryString=[summaryString sprintf('%s\n ',[num2str(100*(length(find(GoodTrial==1&RFPat==28&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==28&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];

 end
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];


fprintf('%s\n',summaryString);

  attachvars;

