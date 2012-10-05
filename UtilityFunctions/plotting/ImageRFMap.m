
%	This script does the ImageRFMap

FilterHere=1;
TotalFilter=1&CurrentFilterVector;

discretizeXes;
eval(['UniqueX=unique(' CurrentXAxisVariableStr '(~isnan(' CurrentXAxisVariableStr ')));']);
eval(['UniqueY=unique(' CurrentX1AxisVariableStr '(~isnan(' CurrentX1AxisVariableStr ')));']);
SpikeCount=nan*ones(length(UniqueY),length(UniqueX));
OverNumTrials=SpikeCount;
SigMat=SpikeCount;
SpikeRate=SpikeCount;
SpikeRateAve=SpikeCount;

for ind=1:length(UniqueX)
    for ind1=1:length(UniqueY)
        eval(['FindResult=find(' CurrentXAxisVariableStr '==UniqueX(ind) & ' CurrentX1AxisVariableStr '== UniqueY(ind1) &TotalFilter);']);
        eval(['SpikeMat=CountSpikes(Trials,RFTrialIndex(FindResult),' CurrentAlignString '(FindResult),TimeWindowVector,CurrentUnitNumber, CurrentAnalogCorrect);']); %keyboard;
       SpikeRate(ind1,ind)=nanmean(SpikeMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
        SpikeCount(ind1,ind)=nansum(SpikeMat); %total number of spikes in window across trials
        TempCount=nan*SpikeMat;
        TempCount(~isnan(SpikeMat))=1;
        OverNumTrials(ind1,ind)=nansum(TempCount); %trick to find number of ~isnans
        if OverNumTrials(ind1,ind)==0, SpikeRate(ind1,ind)=NaN; SpikeCount(ind1,ind)=NaN;end
end
end

% AnalImageMap;
BaseCorrect;

% keyboard;

% if handles.BaselineCorrectVar==1,    SpikeCount=(SpikeCount-BaseRate)/BaseRate;end
% figure;
TemporaryHandle=image(UniqueX,UniqueY,SpikeRate);
colormap(gray);
set(TemporaryHandle,'CDataMapping','scaled');
set(gca,'ydir','normal');
%  set(gca,'box','off','tickdir','out','xlim',[-30 30],'ylim',[-30 30]);
% colorbar;
if CurrentPlotSig==1,    
    
   fprintf('P = %2.6f\n',CurrentPValue);

    ExpNumSpikes= BaseRate * OverNumTrials * ( TimeWindowVector(2) - TimeWindowVector(1) ) / 1000;
    CDFValue = poisscdf(SpikeCount,ExpNumSpikes);
    LowSig = CDFValue < CurrentPValue;
    HighSig= CDFValue > (1-CurrentPValue);
    SigMat(LowSig==1&~isnan(SpikeCount))=1;
    SigMat(HighSig==1&~isnan(SpikeCount))=2;
    SigMat(isnan(SpikeCount))=-1; %catching the 0 trials runs
    
%     NumCols=length(UniqueX);
% keyboard;
    YMat=repmat(UniqueY',1,length(UniqueX));
    XMat=repmat(UniqueX,length(UniqueY),1);
    
    
    hold on;

    if any(any(SigMat==1))
     TemporaryHandle(2)=plot( XMat(SigMat==1), YMat(SigMat==1),'yo');
    set(TemporaryHandle(2),'markersize',2,'markerfacecolor','m');
    else
        TemporaryHandle(2)=plot(nan,nan);
    end
    
    if any(any(SigMat==2))
    TemporaryHandle(3)=plot( XMat(SigMat==2),YMat(SigMat==2),'co');
    set(TemporaryHandle(3),'markersize',2,'markerfacecolor','c');
    else
        TemporaryHandle(3)=plot(nan,nan);
    end
    
    if any(any(SigMat==-1))
        TemporaryHandle(4)=plot(XMat(SigMat==-1),YMat(SigMat==-1),'rx');
        set(TemporaryHandle(4),'markersize',6);
    else
        TemporaryHandle(4)=plot(nan,nan);
    end
    
end

%  keyboard;
% colorbar;
%  SpikeCounty=SpikeCount;
clear SpikeCount;
CurrentPlotType='ImageRF';

% %putting in the xaxis variable name tag for this axis
% 
% CurrentAxisHandle=gca;
% CurrentAxisNumber=find(CurrentAxisHandle==handles.HandlesList);
% 
% if ~isempty(strfind(CurrentXAxisVariableStr,'Discretized')), XAxisVar=CurrentXAxisVariableStr(12:end);else XAxisVar=CurrentXAxisVariableStr;end
% if ~isempty(strfind(CurrentX1AxisVariableStr,'Discretized')), X1AxisVar=CurrentX1AxisVariableStr(12:end);else X1AxisVar=CurrentX1AxisVariableStr;end
% 
% handles.AxisVariable(CurrentAxisNumber).XAxis=XAxisVar;
% handles.AxisVariable(CurrentAxisNumber).YAxis=X1AxisVar;
