
%	This script does baseline correction for RFMap,  for instance.

    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;

        BaselineWindowVector=handles.BaselineWindow;
        if NextCommandSetBaseRate==1,     BaselineWindowVector=TimeWindowVector; %not using handles.baseline window
        end
        
        eval(['FindResult=find(TotalFilter);']);
        eval(['SpikeMat=CountSpikes(Trials,RFTrialIndex(FindResult),' CurrentAlignString '(FindResult),BaselineWindowVector,CurrentUnitNumber, CurrentAnalogCorrect);']);
    BaseRate=nanmean(SpikeMat)*1000/(BaselineWindowVector(2)-BaselineWindowVector(1));
    if BaseRate==0, fprintf('%s\n','baseline is zero'); keyboard;end

    if NextCommandSetBaseRate~=1&&~isnan(handles.BaselineFiringRate), BaseRate=handles.BaselineFiringRate;
%    fprintf('%s\n','Using stored baseline rate (!)');
    fprintf('Using stored baseline rate of %6.3f Hz\n',BaseRate);
    end
    
    
    
    
