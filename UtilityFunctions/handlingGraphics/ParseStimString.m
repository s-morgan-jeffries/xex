
%This script is used by getcurrentparameters.m among other scripts, to
%parse currentstimstring. Also by the graphics command processor
%ParseStimString.m

Vectormade=0;
InsertBinWidth=CurrentBinWidth;

if ~isempty(CurrentStimString), 
    
    iscolon=strfind(CurrentStimString,':');
    
    if ~isempty(iscolon) 
                if length(iscolon)==2,
               
                    InsertBinWidth=str2num(CurrentStimString( (iscolon(1)+1) :(iscolon(2)-1)));
                    CurrentStimString=[CurrentStimString(1:(iscolon(1)-1)) ' ' CurrentStimString((iscolon(2)+1):end)];

                    if exist('CurrentPlottingFile','var')
                        
                    if ~strcmp(CurrentPlottingFile,'MakeHist.m') && ~strcmp(CurrentPlottingFile,'DrawKDE.m')

                        fprintf('%s\n','Just fixed your stim vector; it is not a histogram');
                    else
                        eval(['CurrentStimVector=[' CurrentStimString '];']);
    
                        if strcmp(CurrentPlottingFile,'MakeHist.m'),
                               InsertBinWidth= ((ceil(CurrentSliderValue)+5)/10)*InsertBinWidth;
                               fprintf('Hist Binwidth is %d\n',InsertBinWidth);
                               %comment out below on aug 06
%                                        set(handles.SliderText,'string',['binwidth=' num2str(InsertBinWidth,'%d\n')]);  
                        end
    
                        XVector=CurrentStimVector(1):InsertBinWidth:CurrentStimVector(2);
                        PlotXVector=XVector;
                        Vectormade=1;
                    end
                    
                    else fprintf('%s\n','OutsideXex warning: Just fixed XVector; no colons, just endpoints !! If you see this error within XeX, find me !!');
                    end
                    
                else fprintf('%s\n','Your stim vector is all wrong'); keyboard;
                end
    end
    
    if Vectormade==0
            eval(['CurrentStimVector=[' CurrentStimString '];']);
            XVector=CurrentStimVector(1):CurrentBinWidth:CurrentStimVector(end);  %these two 'ends' were 2, changed April 23
            PlotXVector=[(CurrentStimVector(1)+(CurrentBinWidth/2)):CurrentBinWidth:(CurrentStimVector(end)+(CurrentBinWidth/2))];
    end
    
else CurrentStimVector=[];XVector=[];PlotXVector=[];
end

%  CurrentTimeWindow1Str=get(handles.StimulusAlignedTimeVector,'string');
% 
%  if ~isempty(CurrentTimeWindow1Str) & ~strcmp(CurrentTimeWindow1Str,'NA')
%      eval(['TimeWindowVector=[' CurrentTimeWindow1Str '];']);
%  else 
%      TimeWindowVector=[];
%  end

TimeWindowVector=CurrentStimVector;