function [Saccades,FiltX,FiltY]=SacFind(Trial,CorrectCode,MinISI,MinLat,PlotVar,FigNum,Threshold,Ax)

%	The main XeX saccade parser
%	function [Saccades,FiltX,FiltY]=SacFind(Trial,CorrectCode,MinISI,MinLat,PlotVar,FigNum,Threshold,Ax)

%Initializing

Saccades=MakeSacStruct;
%struct('latency',NaN,'duration',NaN,'peakvelocity',NaN ,'amplitude',NaN,'velocitrace',NaN,'startx',NaN,'starty',NaN,'endx',NaN,'endy',NaN,'eyex',NaN,'eyey',NaN,'curvature',NaN);
filtlength=5;
if ~exist('MinISI','var') || isempty(MinISI) || isnan(MinISI), MinISI=0;end
if ~exist('MinLat','var') || isempty(MinLat) || isnan(MinLat), MinLat=0;end

%Finding the eye signal

tracexx = double(Trial.Signals(1).Signal);
traceyy = double(Trial.Signals(2).Signal);

%Doing Correction for Stimulus Onset

if exist('CorrectCode','var') && ~isempty(CorrectCode) && ~isnan(CorrectCode) && CorrectCode~=0
    CurrentEvents=Trial.Events;
    if ~isempty(CurrentEvents)
    CurrentCodes=double([CurrentEvents.Code]); CurrentTimes=double([CurrentEvents.Time]);
    CorrectCodeLocation=find(CurrentCodes==CorrectCode);
        if ~isempty(CorrectCodeLocation)
        CorrectCodeOnTime=CurrentTimes(CorrectCodeLocation(1));
        if CorrectCodeOnTime>=0 %ALF if loop hack check this 12-1-06
        tracexx = tracexx(:,CorrectCodeOnTime:end);
        traceyy = traceyy(:,CorrectCodeOnTime:end);
        end
        end
    end
end

%Filtering eye signal

if ~isempty(tracexx)
 
FiltX=filter(ones(1,filtlength)/filtlength,1,tracexx);
FiltY=filter(ones(1,filtlength)/filtlength,1,traceyy);
dxf=diff(FiltX);
dyf=diff(FiltY);
Velocitrace=sqrt((dxf).^2+(dyf).^2);

%Thresholding !!
%for ziggy's physiology, .1 would be a large sac value. .03 would be a
%good small saccade (1-2 degs) value
%thresh=0.2; %for ziggy's hoffman saccades

FastMoving=0*(1:length(Velocitrace));
if exist('Threshold','var')  %allowing threshold to be passed
   thresh=Threshold;
else
 thresh=.1;  %also tried .006 and .003. all for longer filter: 31ms. 
%thresh=0.03;
end

%Finding onsets and offsets

FastMoving(Velocitrace>=thresh)=1;
OnsetOffset=diff(FastMoving);

%Some ad-hoc, but sensible corrections for onsets and offsets

if ~isempty(find(OnsetOffset==1))
SacOn=find(OnsetOffset==1);
SacOff=find(OnsetOffset==-1);

if length(SacOn) ~=length(SacOff) %fprintf('Start was %d\tend was %d\n',length(SacOn),length(SacOff)); 
if length(SacOn)>length(SacOff) SacOff=[SacOff length(OnsetOffset)];end
if length(SacOff)>length(SacOn) SacOn=[1 SacOn];end
end

if SacOff(1)<SacOn(1) SacOff=[SacOff(2:end) length(OnsetOffset)];end

% Implementing the at least 5 ms rule

TestIndex=zeros(1,length(SacOn));
for TempXX=1:length(SacOn)
    inds=SacOn(TempXX):SacOff(TempXX);
    if length(inds)>=5 TestIndex(TempXX)=1;end
end
SacOn=SacOn(logical(TestIndex));
SacOff=SacOff(logical(TestIndex));
else SacOn=[];SacOff=[];
end   %Ending the if ~isempty(find(OnsetOffset==1))

SaccadeNumber=1;
sacstartvar=[];
sacendvar=[];
dummyvar=zeros(1,length(SacOn));

%Filling Saccade Structure

for TempXX=1:length(SacOn)
    
    SacSamples=SacOn(TempXX):SacOff(TempXX);

            if length(SacSamples)>=5 && ( (exist('MinLat','var') && (SacOn(TempXX)+filtlength)>=MinLat) || ~exist('MinLat','var'))

        sacstartvar(SaccadeNumber)=SacOn(TempXX);
        sacendvar(SaccadeNumber)=SacOff(TempXX);

        Saccades(SaccadeNumber).latency=SacOn(TempXX);%+filtlength; %to compensate for filter !! Not compensating for filter
        Saccades(SaccadeNumber).duration=SacOff(TempXX)-SacOn(TempXX)+1;
        Saccades(SaccadeNumber).peakvelocity=max(Velocitrace(SacSamples));
        startx=FiltX(SacOn(TempXX));
        endx=FiltX(SacOff(TempXX));
        starty=FiltY(SacOn(TempXX));
        endy=FiltY(SacOff(TempXX));
        Saccades(SaccadeNumber).amplitude=sqrt((startx-endx).^2+(starty-endy).^2);
       Saccades(SaccadeNumber).startx=startx;
       Saccades(SaccadeNumber).endx=endx;
       Saccades(SaccadeNumber).starty=starty;
       Saccades(SaccadeNumber).endy=endy;
       Saccades(SaccadeNumber).velocitrace=Velocitrace;
       Saccades(SaccadeNumber).eyex=tracexx(SacSamples);
       Saccades(SaccadeNumber).eyey=traceyy(SacSamples);
       Saccades(SaccadeNumber).curvature=AnalyzeCurvature(tracexx(SacSamples),traceyy(SacSamples),startx,endx,starty,endy);
        SaccadeNumber=SaccadeNumber+1; 
        end
end

%Doing ISI correction

for ind=1:length(Saccades)
     latencies=[Saccades.latency];
     endingtimes=[Saccades.latency]+[Saccades.duration]-1;
     if length(latencies)>1 isis=latencies(2:end)-endingtimes(1:end-1); 
            Saccades(find(isis<=MinISI)+1)=[];
            sacstartvar(find(isis<=MinISI)+1)=[];
            sacendvar(find(isis<=MinISI)+1)=[];
        if ~isempty(find(isis<=0)) fprintf('%s\n','Warning: you have isis <=0. line 124 in SacFind.m');end
    else isis=[];end
end

%Doing the Plotting

if (exist('PlotVar','var') && PlotVar==1 ) 
    if exist('FigNum','var') && ~isempty(FigNum) && ~isnan(FigNum), figure(FigNum);else figure;end
    if ~exist('Ax','var') || length(Ax)<2, Ax(1)=subplot(2,1,1); Ax(2)=subplot(2,1,2);end

axes(Ax(1)); hold on;
hvar=plot(sqrt((FiltX).^2+(FiltY).^2),'k-');
set(hvar,'linewidth',2);
hold on;
h1=plot(FiltX,'b:');
h2=plot(FiltY,'r:');
set([h1 h2],'linewidth',2);
ylims=get(gca,'ylim');
for TempXX=1:length(sacstartvar)
hvar=plot([sacstartvar(TempXX) sacstartvar(TempXX)],ylims,'b-');
hvar=plot([sacendvar(TempXX) sacendvar(TempXX)],ylims,'y-');
end

axes(Ax(2)); hold on;
hvar=plot(Velocitrace,'r');
set(hvar,'linewidth',2);
hold on;
ylims=get(gca,'ylim');
for TempXX=1:length(sacstartvar)
h=plot([sacstartvar(TempXX) sacstartvar(TempXX)],ylims,'b-');
h=plot([sacendvar(TempXX) sacendvar(TempXX)],ylims,'y-');
end

zoom on;
 
end  %the PlotVar loop ends here

end %the ~isempty(tracexx) loop ends here

 if ~exist('FiltX','var'), FiltX=nan;FiltY=nan;end
 
