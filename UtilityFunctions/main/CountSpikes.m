function [countsmat]=CountSpikes(Trials,indices,alignTimes,xVec,unitCode,AnalogCorrect)

%	returns total spike counts for each Trial in a matrix
%	[countsmat]=CountSpikes(Trials,indices,alignTimes,xVec,unitCode,AnalogCorrect)

if ~exist('AnalogCorrect','var') AnalogCorrect=1;end

countsmat=nan*ones(length(indices),1);

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
    countsmat(xx)=length(find(spikeTimes-alignTimes(xx) >=xVec(1) & spikeTimes-alignTimes(xx) <=xVec(2)));
    end
    
    xx=xx+1; 
end