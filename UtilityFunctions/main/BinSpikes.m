function [countsmat,timesmat]=BinSpikes(Trials,indices,alignTimes,xVec,unitCode,AnalogCorrect)

%	returns binned spike counts for each Trial in a matrix.
%	[countsmat,timesmat]=BinSpikes(Trials,indices,alignTimes,xVec,unitCode,AnalogCorrect)

if ~exist('AnalogCorrect','var') AnalogCorrect=1;end

countsmat=nan*ones(length(indices),length(xVec));
timesmat=nan*ones(length(indices),5000); %5000 as a reasonable upper cutoff for the number of spikes

xx=1;
for ind=indices
    
    cur=Trials(ind);
    
    ee=[cur.Events];
    if ~isempty(ee)
    cc=double([ee.Code]);
    tt=double([ee.Time]);
    end
    
    spikeTimes=[];
    un=[cur.Units];
    if ~isempty(un)
    temp=find([un.Code]==unitCode);
    if ~isempty(temp)
    spikeTimes=double([un(temp).Times]);
    end
    end
        
    AnalogStartTime=cur.aStartTime;
    AnalogEndTime=cur.aEndTime;
    if AnalogCorrect==1, spikeTimes=spikeTimes(spikeTimes<=AnalogEndTime & spikeTimes>=AnalogStartTime);end
    
    if ~isempty(spikeTimes) && ~isnan(alignTimes(xx))  %just changed these from ind to xx
    countsmat(xx,:)=histc(spikeTimes-alignTimes(xx),xVec);
    invalid_xVec= (xVec+alignTimes(xx))<AnalogStartTime | (xVec+alignTimes(xx))>AnalogEndTime;
    countsmat(xx,invalid_xVec)=nan;
%     if any(find(invalid_xVec)), keyboard;end
    end
%     keyboard;
    xx=xx+1; 
end