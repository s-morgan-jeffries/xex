% 
% %	This script does the ImageRFMap
% 
% FilterHere=1;
% TotalFilter=1&CurrentFilterVector;
% 
% discretizeXes;
% eval(['UniqueX=unique(' CurrentXAxisVariableStr '(~isnan(' CurrentXAxisVariableStr ')));']);
% eval(['UniqueY=unique(' CurrentX1AxisVariableStr '(~isnan(' CurrentX1AxisVariableStr ')));']);
% SpikeCount=nan*ones(length(UniqueY),length(UniqueX));
% OverNumTrials=SpikeCount;
% SigMat=SpikeCount;
% SpikeRate=SpikeCount;
% SpikeRateAve=SpikeCount;
% 
% for ind=1:length(UniqueX)
%     for ind1=1:length(UniqueY)
%         eval(['FindResult=find(' CurrentXAxisVariableStr '==UniqueX(ind) & ' CurrentX1AxisVariableStr '== UniqueY(ind1) &TotalFilter);']);
%         eval(['SpikeMat=CountSpikes(Trials,RFTrialIndex(FindResult),' CurrentAlignString '(FindResult),TimeWindowVector,CurrentUnitNumber, CurrentAnalogCorrect);']); %keyboard;
%        SpikeRate(ind1,ind)=nanmean(SpikeMat)*1000/(TimeWindowVector(2)-TimeWindowVector(1));
%         SpikeCount(ind1,ind)=nansum(SpikeMat); %total number of spikes in window across trials
%         TempCount=nan*SpikeMat;
%         TempCount(~isnan(SpikeMat))=1;
%         OverNumTrials(ind1,ind)=nansum(TempCount); %trick to find number of ~isnans
%         if OverNumTrials(ind1,ind)==0, SpikeRate(ind1,ind)=NaN; SpikeCount(ind1,ind)=NaN;end
% end
% end

AnalImageMap;


% if handles.BaselineCorrectVar==1,    SpikeCount=(SpikeCount-BaseRate)/BaseRate;end

TemporaryHandle=image(UniqueX,UniqueY,SpikeRate);
colormap(gray);
set(TemporaryHandle,'CDataMapping','scaled');
set(gca,'ydir','normal');
%  set(gca,'box','off','tickdir','out','xlim',[-30 30],'ylim',[-30 30]);

if CurrentPlotSig==1,    
    
   fprintf('P = %2.6f\n',CurrentPValue);
% keyboard;
% 
%     ExpNumSpikes= BaseRate * OverNumTrials * ( TimeWindowVector(2) - TimeWindowVector(1) ) / 1000;
%     CDFValue = poisscdf(SpikeCount,ExpNumSpikes);
%     LowSig = CDFValue < CurrentPValue;
%     HighSig= CDFValue > (1-CurrentPValue);
%     SigMat(LowSig==1&~isnan(SpikeCount))=1;
%     SigMat(HighSig==1&~isnan(SpikeCount))=2;
%     
% %     NumCols=length(UniqueX);
% % keyboard;
%     YMat=repmat(UniqueY',1,length(UniqueX));
%     XMat=repmat(UniqueX,length(UniqueY),1);
    
    
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
    
end
%alf hack for finding the minimum location on image map using average of
%surrounding squares.
% for i=1:length(SpikeRate)
%     for ii=1:length(SpikeRate)
%         tc=SpikeRate(i,ii);
% 
%         if i-1<1, s1=nan; s2=nan; s3=nan; end
%         if i+1>length(SpikeRate), s6=nan; s7=nan; s8=nan; end
% 
%         if (i-1>=1)&ii>=1&ii<=length(SpikeRate)
%             s2=SpikeRate(i-1,ii);
% %             keyboard;
%         end
%         if (i+1<=length(SpikeRate))&ii>=1&ii<=length(SpikeRate)
%             s7=SpikeRate(i+1,ii);
% %             keyboard;
%         end
% 
%         if ii-1<1, s1=nan; s4=nan; s6=nan; end
%         if ii+1>length(SpikeRate), s3=nan; s5=nan; s8=nan;  end
%         if (ii-1>=1)&(ii+1<=length(SpikeRate))&i>=1&i<=length(SpikeRate)
%             s4=SpikeRate(i,ii-1);
%         end
%         if (ii+1<=length(SpikeRate))&i>=1&i<=length(SpikeRate)
%             s5=SpikeRate(i,ii+1);
%         end
%         if i-1>=1&ii-1>=1
%             s1=SpikeRate(i-1,ii-1);
%         end
%         if i-1>=1&ii+1<=length(SpikeRate)
%            s3=SpikeRate(i-1,ii+1);
%         end
%         if ii-1>=1&i+1<=length(SpikeRate)
%            s6=SpikeRate(i+1,ii-1);
%         end    
%         if i+1<=length(SpikeRate)&ii+1<=length(SpikeRate)
%            s8=SpikeRate(i+1,ii+1);
%         end      
%          tempvar=[s1 s2 s3 s4 s5 s6 s7 s8 tc];   
%          tempvarsum=nansum(tempvar);
%     SpikeRateAve(i,ii)=tempvarsum/(length(find(~isnan(tempvar))));
% %     keyboard;
%     end
%    
% end
[unX]=un(RFx);
[unY]=un(RFy);
% keyboard;
for i=1:length(unX)
    for ii=1:length(YMat)
        tc=SpikeRate(i,ii);

        if i-1<1, s1=nan; s2=nan; s3=nan; end
        if i+1>length(unX), s6=nan; s7=nan; s8=nan; end

        if (i-1>=1)&ii>=1&ii<=length(unY)
            s2=SpikeRate(i-1,ii);
%             keyboard;
        end
        if (i+1<=length(unX))&ii>=1&ii<=length(unY)
            s7=SpikeRate(i+1,ii);
%             keyboard;
        end

        if ii-1<1, s1=nan; s4=nan; s6=nan; end
        if ii+1>length(unY), s3=nan; s5=nan; s8=nan;  end
        if (ii-1>=1)&(ii+1<=length(unY))&i>=1&i<=length(unX)
            s4=SpikeRate(i,ii-1);
        end
        if (ii+1<=length(unY))&i>=1&i<=length(unX)
            s5=SpikeRate(i,ii+1);
        end
        if i-1>=1&ii-1>=1
            s1=SpikeRate(i-1,ii-1);
        end
        if i-1>=1&ii+1<=length(unY)
           s3=SpikeRate(i-1,ii+1);
        end
        if ii-1>=1&i+1<=length(unX)
           s6=SpikeRate(i+1,ii-1);
        end    
        if i+1<=length(unX)&ii+1<=length(unY)
           s8=SpikeRate(i+1,ii+1);
        end      
         tempvar=[s1 s2 s3 s4 s5 s6 s7 s8 tc];   
         tempvarsum=nansum(tempvar);
    SpikeRateAve(i,ii)=tempvarsum/(length(find(~isnan(tempvar))));
%     keyboard;
    end
   
end



MinLocation=find(SpikeRate==nanmin(nanmin(SpikeRate))&SigMat==1);
if ~isempty(MinLocation)
    [XMat(MinLocation) YMat(MinLocation)]
else
    fprintf('%s\n','Something weird: line 78 imagerfmap');
end
MinLocationAve=find(SpikeRateAve==nanmin(nanmin(SpikeRateAve)));
if ~isempty(MinLocationAve)
    [XMat(MinLocationAve) YMat(MinLocationAve)]
else
    fprintf('%s\n','Something weird: line 78 imagerfmap');
end
keyboard;
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

