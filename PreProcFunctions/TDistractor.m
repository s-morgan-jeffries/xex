function CurrentVariables=LineMotion(Trials,klugestring,UseAx,SacOpts)

%    This function analyzes files from the line motion paradigm
%    See also: 
%    CurrentVariables=LineMotion(Trials,klugestring,UseAx,SacOpts)

% to analyze linemotion

%Initializing Variables

ArrayNumber=nan*ones(1,length(Trials));
GoodTrial=ArrayNumber;
BadTrial=ArrayNumber;
PhotoBad=ArrayNumber;
TrialNumber=1:length(Trials);
RFTrialIndex=ArrayNumber;

NumRFs=ArrayNumber;

AbortTrial=ArrayNumber;
FixationBreak=ArrayNumber;

RewardTime=ArrayNumber;
ErrorTime=ArrayNumber;
ReactionTime=ArrayNumber;

FPTime=ArrayNumber;
RFOnTime=ArrayNumber;
RFOffTime=ArrayNumber;
RFDur=ArrayNumber;
RFx=ArrayNumber;
RFy=ArrayNumber;
RFPat=ArrayNumber;
RFChecksize=ArrayNumber;

RF2x=ArrayNumber;
RF2y=ArrayNumber;
RF2OnTime=ArrayNumber;
RF2OffTime=ArrayNumber;
RF2Dur=ArrayNumber;
RF2OnTime=ArrayNumber;
RF2Checksize=ArrayNumber;
RF2Pat=ArrayNumber;

RFLen=ArrayNumber;

FPx=RFx;
FPy=RFy;

%Trial Types
Dist_at_Targ=ArrayNumber;
Dist_op_Targ=ArrayNumber;
Dist_at_Targ_L=ArrayNumber;
Dist_at_Targ_R=ArrayNumber;
Dist_op_Targ_L=ArrayNumber;
Dist_op_Targ_R=ArrayNumber;
No_dist=ArrayNumber;
No_dist_R=ArrayNumber;
No_dist_L=ArrayNumber;


ArrayBak=[];

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','TrialNumber','AbortTrial','FixationBreak','RewardTime','ReactionTime','ErrorTime','FPTime','RFOnTime','RFOffTime','RFDur','RFx','RFy','RFPat','RF2x','RF2y','RF2OnTime','RF2Dur','ISI','dISI','bISI','RF2RFD','RFLen','NumRFs'};
MyResponseVariableList={'GoodTrial'};

 for TrialIndex=1:length(Trials)
    
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
    is_rf2=find(CurrentCodes==1047);
    is_rf2off=find(CurrentCodes==1040);
    
    if ~isempty(is_reward), GoodTrial(TrialIndex)=1;
    RewardTime(TrialIndex)=CurrentTimes(is_reward(1));
    elseif ~isempty(is_error),
    ErrorTime(TrialIndex)=CurrentTimes(is_error(1));
    end

    if ~isempty(is_fp), FPTime(TrialIndex)=CurrentTimes(is_fp(1));end
                   
    if ~isempty(is_fp)
        EarlyDrops=find(CurrentCodes>=10700 & abs(CurrentTimes-FPTime(TrialIndex))<=30);  %within 30ms of FP On
        if length(EarlyDrops)>=4
        FPx(TrialIndex)=(CurrentCodes(EarlyDrops(3))-11000)/10;
        FPy(TrialIndex)=(CurrentCodes(EarlyDrops(4))-11000)/10;
        end
        
        if length(EarlyDrops)>=7 RFLen(TrialIndex)=(CurrentCodes(EarlyDrops(7)))-11000; end
        
    end
    
    
    
    if ~isempty(is_photobad), PhotoBad(TrialIndex)=1;end
    if ~isempty(is_abort) AbortTrial(TrialIndex)=1;end
    if ~isempty(is_fixationbreak) FixationBreak(TrialIndex)=1;end
    
    if ~isempty(is_rf), RFOnTime(TrialIndex)=CurrentTimes(is_rf(1));
     
        FindResult=find(CurrentCodes>=10000 &CurrentCodes<10100 & (CurrentTimes-RFOnTime(TrialIndex))>=0 & (CurrentTimes-RFOnTime(TrialIndex))<=50 ); %Within 50 ms of RFOn
          if length(FindResult)>=1
              RFChecksize(TrialIndex)=nanmin(CurrentCodes(FindResult)-10000); 
          end  
          
          NumRFs(TrialIndex)=length(FindResult);

        FindResult=find(CurrentCodes>=7000 & (CurrentTimes-RFOnTime(TrialIndex))>=0 & (CurrentTimes-RFOnTime(TrialIndex))<=50 ); %Within 50 ms of RFOn
        if length(FindResult)>=1
            RFPat(TrialIndex)=CurrentCodes(FindResult(1))-7000;
        end

        FindResult=find(CurrentCodes>=5700 & CurrentCodes<=6800 & (CurrentTimes-RFOnTime(TrialIndex))>=0 & (CurrentTimes-RFOnTime(TrialIndex))<=50 ); %Within 50 ms of RFOn, max abs coords of 300
        if length(FindResult)>=2
            RFx(TrialIndex)=(CurrentCodes(FindResult(1))-6000)/10;
            RFy(TrialIndex)=(CurrentCodes(FindResult(2))-6500)/10;
        end     
        
    end %ending the if ~isempty(is_rf) loop

   if ~isempty(is_rfoff)
    RFOffTime(TrialIndex)=CurrentTimes(is_rfoff(1));
   end
    
 if ~isempty(is_rf2), RF2OnTime(TrialIndex)=CurrentTimes(is_rf2(1));
        
      FindResult=find(CurrentCodes>=5700 & CurrentCodes<=6800 & (CurrentTimes-RF2OnTime(TrialIndex))>=0 & (CurrentTimes-RF2OnTime(TrialIndex))<=50 ); %Within 50 ms of RFOn, max abs coords of 300
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


if ~isempty(is_rf) & GoodTrial(TrialIndex)~=1 & AbortTrial(TrialIndex)~=1 & FixationBreak(TrialIndex)~=1
    if ~isempty(is_error), BadTrial(TrialIndex)=1; 
    else BadTrial(TrialIndex)=2;end
end
  
% if isempty(is_rf2)
%     noRF2ISI(TrialIndex)=RFOnTime(TrialIndex)-1000;
% end

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
 if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&((RFx(TrialIndex)<0&RF2x(TrialIndex)<0)|(RFx(TrialIndex)>0&RF2x(TrialIndex)>0)), Dist_at_Targ(TrialIndex)=1; end
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&((RFx(TrialIndex)<0&RF2x(TrialIndex)>0)|(RFx(TrialIndex)>0&RF2x(TrialIndex)<0)), Dist_op_Targ(TrialIndex)=1; end
     if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)>0&RF2x(TrialIndex)>0), Dist_at_Targ_R(TrialIndex)=1; end
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)>0&RF2x(TrialIndex)<0), Dist_op_Targ_R(TrialIndex)=1; end   
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)<0&RF2x(TrialIndex)<0), Dist_at_Targ_L(TrialIndex)=1; end
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)<0&RF2x(TrialIndex)>0), Dist_op_Targ_L(TrialIndex)=1; end
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&isnan(RF2x(TrialIndex)), No_dist(TrialIndex)=1; end
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&isnan(RF2x(TrialIndex))&RFx(TrialIndex)>0, No_dist_R(TrialIndex)=1; end
    if GoodTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&isnan(RF2x(TrialIndex))&RFx(TrialIndex)<0, No_dist_L(TrialIndex)=1; end
    
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&((RFx(TrialIndex)<0&RF2x(TrialIndex)<0)|(RFx(TrialIndex)>0&RF2x(TrialIndex)>0)), Dist_at_Targ(TrialIndex)=0; end
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&((RFx(TrialIndex)<0&RF2x(TrialIndex)>0)|(RFx(TrialIndex)>0&RF2x(TrialIndex)<0)), Dist_op_Targ(TrialIndex)=0; end
     if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)>0&RF2x(TrialIndex)>0), Dist_at_Targ_R(TrialIndex)=0; end
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)>0&RF2x(TrialIndex)<0), Dist_op_Targ_R(TrialIndex)=0; end   
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)<0&RF2x(TrialIndex)<0), Dist_at_Targ_L(TrialIndex)=0; end
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&(RFx(TrialIndex)<0&RF2x(TrialIndex)>0), Dist_op_Targ_L(TrialIndex)=0; end
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&isnan(RF2x(TrialIndex)), No_dist(TrialIndex)=0; end
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&isnan(RF2x(TrialIndex))&RFx(TrialIndex)>0, No_dist_R(TrialIndex)=0; end
    if BadTrial(TrialIndex)==1&PhotoBad(TrialIndex)~=1&isnan(RF2x(TrialIndex))&RFx(TrialIndex)<0, No_dist_L(TrialIndex)=0; end 
 end

ISI=RFOnTime-RF2OnTime;
dISI=DiscretizeMe(ISI,0:100:1000);
noRF2ISI=RFOnTime(find(isnan(RF2x)))-1000;
bISI=DiscretizeMe(noRF2ISI,0:100:1000);
% if isnan(ISI) 
%     nISI=RFOnTime-400;
%     bISI=DiscretizeMe(ISI,0:100:1000);
% end
dISI(isnan(RF2x))=0;

FPOnTime=FPTime;
 RF2RFD=sqrt( (RF2x-RFx).^2 + (RF2y-RFy).^2 );
 RFDur=(RFOffTime-RFOnTime);
 RF2Dur=(RF2OffTime-RF2OnTime);
 dRFDur=DiscretizeMe(RFDur, 50:100:1000);
 dRF2Dur=DiscretizeMe(RF2Dur, 50:100:1000);
 
 ReactionTime(GoodTrial==1)=RewardTime(GoodTrial==1)-RFOnTime(GoodTrial==1); %kluge
ReactionTime(BadTrial==1)=ErrorTime(BadTrial==1)-RFOnTime(BadTrial==1);
ReactionTime=ReactionTime-50; %for bar waiting time, I think 50 is what saproc uses.
%  PerCor=length(find(GoodTrial==1&PhotoBad~=1))/(length(find(GoodTrial==1&PhotoBad~=1))+length(find(BadTrial==1&PhotoBad~=1)));
%  UTPerCor=length(find(GoodTrial==1&PhotoBad~=1&RFPat==29))/(length(find(GoodTrial==1&PhotoBad~=1&RFPat==29))+length(find(BadTrial==1&PhotoBad~=1&RFPat==29)));
%  DTPerCor=length(find(GoodTrial==1&PhotoBad~=1&RFPat==28))/(length(find(GoodTrial==1&PhotoBad~=1&RFPat==28))+length(find(BadTrial==1&PhotoBad~=1&RFPat==28)));
%  Dist_at_Targ=length(find(
 
 %Now printing out details of analysis
  summaryString=[ sprintf('%s\n','******************************************************************')];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(Trials)) '  trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1))) '  Good Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n',[num2str(100*(length(find(GoodTrial==1)))/length(find(GoodTrial==1|BadTrial==1)),'%3.2f') '  % correct'])];
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];

 RFmat=[RFx;RFy]';
RFmat=un(RFmat);
if length(RFmat)<10
    summaryString=[summaryString sprintf('%s\n','RFx     RFy')];
    for ii=1:size(RFmat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([RFmat(ii,1) RFmat(ii,2)],'%6.2f'))];
    end
end

 RF2mat=[RF2x;RF2y]';
RF2mat=un(RF2mat);
if length(RF2mat)<10
    summaryString=[summaryString sprintf('%s\n','RF2x     RF2y')];
    for ii=1:size(RF2mat,1)
        summaryString=[summaryString sprintf('%s\n',num2str([RF2mat(ii,1) RF2mat(ii,2)],'%6.2f'))];
    end
end

summaryString=[summaryString sprintf('%s\t','Unique ISIS are')];
summaryString=[summaryString sprintf('%d\t',un(dISI))];
summaryString=[summaryString sprintf('%s\n','')];

for printIndex=1:size(RFmat,1)
     summaryString=[summaryString sprintf('%3.1f\t%3.1f\t',RFmat(printIndex,1),RFmat(printIndex,2))];
      summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
summaryString=[summaryString sprintf('%s\t','All trials  ')];
 summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFPat==29&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==29&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % uT correct'])];
  summaryString=[summaryString sprintf('%s\t','/')];
 summaryString=[summaryString sprintf('%s\n ',[num2str(100*(length(find(GoodTrial==1&RFPat==28&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==28&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % dT correct'])];

 end
 summaryString=[summaryString sprintf('%s\n','******************************************************************')];


fprintf('%s\n',summaryString);
 attachvars;
