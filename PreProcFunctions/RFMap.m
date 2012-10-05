function CurrentVariables=RFMap(Trials,klugestring,UseAx,SacOpts)

%	This function analyzes trials from the RF map paradigm
%	Main Difference is that rf data are now in a very long vector, up to 10
%	times length of Trials (actual number depends upon ISI).
%	CurrentVariables=RFMap(Trials,klugestring,UseAx,SacOpts)

%Initializing Variables

ArrayNumber=nan*ones(1,length(Trials));
RFGoodTrial=ArrayNumber;
BadTrial=ArrayNumber;
RFPhotoBad=ArrayNumber;
TrialNumber=1:length(Trials);

AbortTrial=ArrayNumber;
FixationBreak=ArrayNumber;

RewardTime=ArrayNumber;
ErrorTime=ArrayNumber;
FPTime=ArrayNumber;
NumRFs=ArrayNumber;

%ArrayBak=[]; %bcos we dont care about ArrayNumber

%for RFMap only

RFOnTime=repmat(ArrayNumber,1,10); 
RFWhichRF=RFOnTime;
RFOffTime=RFOnTime;
RFx=RFOnTime;
RFy=RFOnTime;
RFPat=RFOnTime;
RFTrialIndex=RFOnTime;
RFIndex=1;
PhotoBad=RFOnTime; %counter-intuitive, but convenient
GoodTrial=RFOnTime;
RFBadTrial=RFOnTime;

RFCheckSize=RFOnTime;
RFRed=RFOnTime;
RFGreen=RFOnTime;
RFBlue=RFOnTime;
RFOrientation=RFOnTime;
RFLength=RFOnTime;
RFWidth=RFOnTime;
RFMode=RFOnTime;

RFMinCheckSize=RFOnTime;
RFHoleControl=RFOnTime;
RFColor=RFOnTime;
RFColorControl=RFOnTime;
RFNumber=RFOnTime;
RFx1=RFOnTime;
RFx2=RFOnTime;
RFx3=RFOnTime;
RFx4=RFOnTime;
RFy1=RFOnTime;
RFy2=RFOnTime;
RFy3=RFOnTime;
RFy4=RFOnTime;

FPOnTime=RFOnTime;
FPx=RFx;
FPy=RFy;

RFOnTime1=ArrayNumber;
RFOnTime2=ArrayNumber;
RFOnTime3=ArrayNumber;
RFOnTime4=ArrayNumber;
RFOnTime5=ArrayNumber;

MyVariableList={'ArrayNumber','GoodTrial','BadTrial','PhotoBad','TrialNumber','AbortTrial','FixationBreak','RewardTime','ErrorTime','FPTime','NumRFs','RFOnTime','RFWhichRF','RFOffTime','RFx','RFy','RFPat','RFTrialIndex','RFPhotoBad',...
    'RFGoodTrial','RFBadTrial','FPOnTime','RFOnTime1','RFOnTime2','RFOnTime3','RFOnTime4','RFOnTime5','RFGood','RFMinCheckSize','RFHoleControl','RFCheckSize','RFRed','RFGreen','RFBlue','RFOrientation','RFLength','RFWidth','RFMode'};
MyResponseVariableList={'GoodTrial'};


for TrialIndex=1:length(Trials)
    
    CurrentEvents=Trials(TrialIndex).Events;
    CurrentCodes=double([CurrentEvents.Code]);
    CurrentTimes=double([CurrentEvents.Time]);
    
    is_reward=find(CurrentCodes==1012);
    is_error=find(CurrentCodes==1013);
    is_fp=find(CurrentCodes==1003);
    is_photobad=find(CurrentCodes==1092);
    is_abort=find(CurrentCodes==1090);
    is_fixationbreak=find(CurrentCodes==1091);
    
    if ~isempty(is_reward), RFGoodTrial(TrialIndex)=1;
    RewardTime(TrialIndex)=CurrentTimes(is_reward(1));
    elseif ~isempty(is_error),
    ErrorTime(TrialIndex)=CurrentTimes(is_error(1));
    end

    if ~isempty(is_fp), FPTime(TrialIndex)=CurrentTimes(is_fp(1));end
   
    if ~isempty(is_photobad), RFPhotoBad(TrialIndex)=1;end
    if ~isempty(is_abort) AbortTrial(TrialIndex)=1;end
    if ~isempty(is_fixationbreak) FixationBreak(TrialIndex)=1;end
    
                
    if ~isempty(is_fp)
        EarlyDrops=find(CurrentCodes>=10700);
        if length(EarlyDrops)>=4
        FPx(TrialIndex)=(CurrentCodes(EarlyDrops(3))-11000)/10;
        FPy(TrialIndex)=(CurrentCodes(EarlyDrops(4))-11000)/10;
        end
    end
       
    is_rf=find(CurrentCodes==1007);
    is_rfoff=find(CurrentCodes==1010);

            NumRFs(TrialIndex)=length(is_rf);

            if ~isempty(is_rf) & RFGoodTrial(TrialIndex)~=1 & AbortTrial(TrialIndex)~=1 & FixationBreak(TrialIndex)~=1
    if ~isempty(is_error), BadTrial(TrialIndex)=1; else BadTrial(TrialIndex)=2;end
end

    if ~isempty(is_rf), 
        
        
         for TempVar=1:length(is_rf)   %Only 1 RF per presentation, so this works. 
            
          RFWhichRF(RFIndex)=TempVar;
          RFOnTime(RFIndex)=CurrentTimes(is_rf(TempVar));
          eval(['RFOnTime' num2str(TempVar) '(TrialIndex)=RFOnTime(RFIndex);']);
          %assuming max of 100 ms duration & min of 100 ms ISI
          FindResult=find(CurrentCodes==1010 & (CurrentTimes-RFOnTime(RFIndex))>=0 & (CurrentTimes-RFOnTime(RFIndex))<100 );  
          if length(FindResult)~=1, RFOffTime(RFIndex)=0; else RFOffTime(RFIndex)=CurrentTimes(FindResult);end
          FindResult=find(CurrentCodes==1092 & (CurrentTimes-RFOnTime(RFIndex))>=0 & (CurrentTimes-RFOnTime(RFIndex))<100 );
          if length(FindResult)~=0, PhotoBad(RFIndex)=1; end

          FindResult=find(abs(CurrentTimes-RFOnTime(RFIndex))<5 & CurrentCodes<=6850&CurrentCodes>=5650);

%           FindResult=find(CurrentCodes>6250 & CurrentCodes<6750 & (CurrentTimes-RFOnTime(RFIndex))==0);
          if length(FindResult)>=2, RFy(RFIndex)=(CurrentCodes(FindResult(2))-6500)/10;
%           end
%           FindResult=find(CurrentCodes<6250 & CurrentCodes>5750 & (CurrentTimes-RFOnTime(RFIndex))==0 );
%           if length(FindResult)~=0, 
              RFx(RFIndex)=(CurrentCodes(FindResult(1))-6000)/10;end
          
         
          %first create rf1x..... rf4y.. at the top, i niitlize, later on
          %take care of elan up as well like rfontime
          %
          % indresult=..... find the 70000s with the same ontime as
          % rfontime, and code>=7000
          %for listloop=1:length(findresult)
          %eval(['RF' num2str(listloop) 'X(RFIndex)=CurrentCodes(FindResult(ListLoop))-6000;']);
          %eval(['RF' num2str(listloop) 'Y(RFIndex)=CurrentCodes(FindResult(ListLoop))-6500;']);
          %end
          
          FindResult=find(CurrentCodes>=7000 & CurrentCodes<10000 & (CurrentTimes-RFOnTime(RFIndex))==0 );
          if length(FindResult)>=1 %& length(FindResult)<=4
          for listloop=1:length(FindResult)
          eval(['RFx' num2str(listloop) '(RFIndex)=CurrentCodes((FindResult(listloop))+1)-6000;']);
          eval(['RFy' num2str(listloop) '(RFIndex)=CurrentCodes((FindResult(listloop))+2)-6500;']);
          end
          end
          
          FindResult=find(CurrentCodes>=10000 & abs(CurrentTimes-RFOnTime(RFIndex))<60 );
          if length(FindResult)>=1
              RFMinCheckSize(RFIndex)=nanmin(CurrentCodes(FindResult)-10000);
          end                    
         
%           if RFWhichRF(RFIndex)~=4 & RFMinCheckSize(RFIndex)~=6, keyboard;end
          
          if(RFIndex>=4 && all(RFMinCheckSize((RFIndex-3):(RFIndex))==0)) RFHoleControl(RFIndex)=1; else RFHoleControl(RFIndex)=0;end
          
          %Basic RF parameters
                    
                    FindResult=find(CurrentCodes>=10000 & CurrentCodes<=10100 ...
                                    & abs(CurrentTimes-RFOnTime(RFIndex))<60 );
if length(FindResult)>0
                    RFCheckSize(RFIndex)=CurrentCodes(FindResult(1))-10000;
end
        
                    FindResult=find(CurrentCodes>=10100 & CurrentCodes<=10200 ...
                                    & abs(CurrentTimes-RFOnTime(RFIndex))<60 );
if length(FindResult)>0
                    RFMode(RFIndex)=CurrentCodes(FindResult(1))-10000;
end

FindResult=find(CurrentCodes>=10200 & CurrentCodes<=10700 ...
                                    & abs(CurrentTimes-RFOnTime(RFIndex))<60 );
if length(FindResult)>0  
                    RFOrientation(RFIndex)=CurrentCodes(FindResult(1))-10200;
end

                    FindResult=find(CurrentCodes>=10700 & CurrentCodes<=10800 ...
                                    & abs(CurrentTimes-RFOnTime(RFIndex))<60 );
if length(FindResult)>0
                    RFLength(RFIndex)=CurrentCodes(FindResult(1))-10000;
end

                    FindResult=find(CurrentCodes>=10800 & CurrentCodes<=10900 ...
                                    & abs(CurrentTimes-RFOnTime(RFIndex))<60 );
if length(FindResult)>0
                    RFWidth(RFIndex)=CurrentCodes(FindResult(1))-10000;
end

          FindResult=find((CurrentCodes>=5000 & CurrentCodes<=5255) & (CurrentTimes-RFOnTime(RFIndex))==0 );
if length(FindResult)>0  
          RFRed(RFIndex)=CurrentCodes(FindResult(1))-5000;
end
FindResult=find((CurrentCodes>=5300 & CurrentCodes<=5555) & (CurrentTimes-RFOnTime(RFIndex))==0 );
if length(FindResult)>0  
RFGreen(RFIndex)=CurrentCodes(FindResult(1))-5000;         
end
FindResult=find((CurrentCodes>=5600 & CurrentCodes<=5855) & (CurrentTimes-RFOnTime(RFIndex))==0 );

if length(FindResult)>0  RFBlue(RFIndex)=CurrentCodes(FindResult(1))-5000;
end

% sets RFColor flag for whichever color is changed

          FindRed=find((CurrentCodes>5000 & CurrentCodes<5255) & (CurrentTimes-RFOnTime(RFIndex))==0 );
          if length(FindRed)>=1
              RFColor(RFIndex)=1;
          end                    
          FindGreen=find((CurrentCodes>5255 & CurrentCodes<5555) & (CurrentTimes-RFOnTime(RFIndex))==0 );
          if length(FindGreen)>=1
              RFColor(RFIndex)=1;
          end           
          FindBlue=find((CurrentCodes>5555 & CurrentCodes<5855) & (CurrentTimes-RFOnTime(RFIndex))==0 );
          if length(FindBlue)>=1
              RFColor(RFIndex)=1;
          end
          if(RFIndex>=4 && all(RFColor((RFIndex-3):(RFIndex))==1)) RFColorControl(RFIndex)=1; else RFColorControl(RFIndex)=0;end

    %evals number of RF's presented when checksize not used to change hole
          FindResult=find(CurrentCodes==7111 & (CurrentTimes-RFOnTime(RFIndex))==0 );
          if length(FindResult)>=1
              RFNumber(RFIndex)=length(FindResult);
          end     
          
          
          if(RFIndex>=4 && all(RFMinCheckSize((RFIndex-3):(RFIndex))==0)) RFHoleControl(RFIndex)=1; else RFHoleControl(RFIndex)=0;end
          
          RFTrialIndex(RFIndex)=TrialIndex;
          
          FindResult=find(CurrentCodes>=7000 & (CurrentTimes-RFOnTime(RFIndex))==0 );
          if length(FindResult)~=0, RFPat(RFIndex)=CurrentCodes(FindResult(1))-7000;end
          
          FPOnTime(RFIndex)=FPTime(TrialIndex);
          
          if TempVar==1, FirstRFx(TrialIndex)=RFx(RFIndex);
              FirstRFy(TrialIndex)=RFy(RFIndex);
          end

          GoodTrial(RFIndex)=RFGoodTrial(TrialIndex);
          RFBadTrial(RFIndex)= BadTrial(TrialIndex);
          
          RFIndex=RFIndex+1;

          end
        
           end %ending the if ~isempty(is_rf) loop
           
    %ArrayFiddleCodeBit;
    
end  %ending the main loop

RFIndex=RFIndex-1;
RFx=RFx(1:RFIndex);
RFy=RFy(1:RFIndex);
RFOnTime=RFOnTime(1:RFIndex);
RFOffTime=RFOffTime(1:RFIndex);
RFPat=RFPat(1:RFIndex);
PhotoBad=PhotoBad(1:RFIndex);
RFTrialIndex=RFTrialIndex(1:RFIndex);
FPOnTime=FPOnTime(1:RFIndex);
GoodTrial=GoodTrial(1:RFIndex);
RFBadTrial=RFBadTrial(1:RFIndex);
RFMinCheckSize=RFMinCheckSize(1:RFIndex);
RFHoleControl=RFHoleControl(1:RFIndex);
RFColor=RFColor(1:RFIndex);
RFColorControl=RFColorControl(1:RFIndex);
RFNumber=RFNumber(1:RFIndex);
RFx1=RFx1(1:RFIndex);
RFx2=RFx2(1:RFIndex);
RFx3=RFx3(1:RFIndex);
RFx4=RFx4(1:RFIndex);
RFy1=RFy1(1:RFIndex);
RFy2=RFy2(1:RFIndex);
RFy3=RFy3(1:RFIndex);
RFy4=RFy4(1:RFIndex);
RFWhichRF=RFWhichRF(1:RFIndex);

RFRed=RFRed(1:RFIndex);
RFGreen=RFGreen(1:RFIndex);
RFBlue=RFBlue(1:RFIndex);
RFCheckSize=RFCheckSize(1:RFIndex);
RFOrientation=RFOrientation(1:RFIndex);

% if ~isempty(find(~isnan(RFMinCheckSize)))
% if ( length(find(RFMinCheckSize==0&~isnan(RFMinCheckSize))) / length(find(~isnan(RFMinCheckSize))) > .7) RFHoleControl=ones(1,length(RFMinCheckSize)); else RFHoleControl=zeros(1,length(RFMinCheckSize));end
% end

RFGood=(RFOffTime-RFOnTime)>30 & (RFOffTime-RFOnTime)<70;


 
 if exist('UseAx','var')&&UseAx~=0, axes(UseAx); 
    plot(RFx,RFy,'bo');
 end

 
 summaryString=sprintf('%s\n','***********Analysis****************');
summaryString=[summaryString sprintf('%s\t%d\n','Number of Trials=',length(Trials))];
summaryString=[summaryString sprintf('%s\t%d\n','Number of Good Trials=',length(find(RFGoodTrial==1)))];
summaryString=[summaryString sprintf('%s\t%d\n','Number of Photobads=',length(find(RFPhotoBad==1)))];

FPmat=[FPx;FPy]';
FPmat=FPmat(~isnan(FPx),:);
FPmat=unique(FPmat,'rows');
if length(FPmat)<10
  summaryString=[summaryString sprintf('%s\n','FPx     FPy')];
    for ii=1:size(FPmat,1)
       summaryString=[summaryString sprintf('%s\n',num2str([FPmat(ii,1) FPmat(ii,2)],'%6.2f'))];
    end
  summaryString=[summaryString  sprintf('%s\n','********')];
end


RFmat=[RFx;RFy]';
RFmat=unique(RFmat,'rows');
if length(RFmat)<10
    summaryString=[summaryString sprintf('%s\n','RFx     RFy')];
    for ii=1:size(RFmat,1)
       summaryString=[summaryString sprintf('%s\n',num2str([RFmat(ii,1) RFmat(ii,2)],'%6.2f'))];
    end
end

fprintf('%s',summaryString);

 attachvars;