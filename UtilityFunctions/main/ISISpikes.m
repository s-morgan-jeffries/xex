function [isi1s,isi2s]=ISISpikes(Trials,indices,alignTimes,xVec,unitCode,AnalogCorrect)

%	function used in isi calculation, modeled after binspikes
%	[isi1s,isi2s]=ISISpikes(Trials,indices,alignTimes,xVec,unitCode,AnalogCorrect)


if ~exist('AnalogCorrect','var') AnalogCorrect=1;end


isi1s=nan*zeros(1,25000); %25000 as a reasonable upper cutoff for the number of spikes
isi2s=isi1s;

xx=1;
runningCount=1;

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
    isis=spikeTimes(2:end)-spikeTimes(1:(end-1));
    
    isi1s(runningCount:(runningCount+length(isis)-2))=isis(1:(end-1));
    isi2s(runningCount:(runningCount+length(isis)-2))=isis(2:end);
    
    runningCount=runningCount+length(isis)-1;
    end
    
    xx=xx+1; 
    
end