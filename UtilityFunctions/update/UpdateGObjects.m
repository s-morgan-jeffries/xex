
%	this script does the hard work for updateaxis 
%	mostly works
%	backup still dubious, but not the fault of this script
%   UPDATEAXES has been deprecated... THIS WILL NO LONGER BE CALLED !!!!!

%************ FINDING CURRENTAXESTOUPDATE ********************************
AxesToUpdateStr=get(handles.UseTheseAxes,'string');
if isempty(AxesToUpdateStr), AxesToUpdateStr='[]';end
eval(['CurrentAxesToUpdate=' AxesToUpdateStr ';']);


%************ GOING TO EACH AXIS AND PICKING UP CURRENT OBJECTS *********

for UpdateIndex=1:length(CurrentAxesToUpdate)
    CurrentAxis=CurrentAxesToUpdate(UpdateIndex);
    CUStr=num2str(CurrentAxis);
        eval(['axes(handles.axes' CUStr ');']);
        
%********** RESETTING AXIS MARKER POINTERS ***********************

eval(['Axis' CUStr 'MarkerPointer=0;']);
    
 %  *****************   getting the current objects

    eval(['if isfield(handles,''A' CUStr '''), CurrentObjects=handles.A' CUStr ';else CurrentObjects=[];end']);  

%************ ARE WE HOLDING OR NOT ? **********************************

CurrentHoldStatus=get(handles.HoldStatus,'value');
    if(CurrentHoldStatus~=1), cla; hold off; else hold on; end
    
    for ObjectIndex=1:length(CurrentObjects)

        %****************** GETTING SAVED PARAMETERS ***************
        
        getSavedParameters;
     
        %**************************PICKING UP CURRENT FILTER STRING 
  
     CurrentFilterC=cellstr(get(handles.TrialFilterVector,'string'));
  
     CurrentFilterString=CurrentFilterC{1};
%  if get(handles.UseFilters,'value')==0, CurrentFilterString='';end
       
 %MOVING OUT OF LOOP: 12/22
%       for TempVarA=1:9
%  eval([ 'Axis' num2str(TempVarA) 'MarkerPointer=0;'...    
%  ]);
%  end

%***********ONLY REASON TO REDO GCP IS TO REPLENISH THINGS THAT YOU MAY
%HAVE INADVRETENTLY CHANGED AFTER LAST CALL

        getCurrentParameters;
 
        %USEFUL.. MAKE XEX GET MARKER PROPS FROM GUI
        
 if CurrentUseProps==1, UpdateAxis; LocalMarkerString=NextMarker; else NextMarker=SavedMarkerString; LocalMarkerString=SavedMarkerString;end
 
%use the same data file for axes update. IS SAFE !!!!!!!!!!!!!!!!!!!!!! DO
%SAME FOR UNDO

try,
     eval([...
        'Trials=handles.' SavedDataFile '.Trials;'...
        'CurrentVariables=handles.' SavedDataFile '.Analysis;'...
        ]);
       CurrentDataFile=SavedDataFile;
catch,
    fprintf('%s\n','I think there is a problem here... You may have deleted a data file with a graph');
end

%        if isempty(get(handles.TrialFilterVector,'string')) CurrentFilterString=SavedFilter;end

        CurrentFilterString=SavedFilter;
        CurrentSliderValue=SavedSliderValue;
        CurrentSelectedVariable=SavedVariable;
        CurrentErrorBarType=SavedErrorBarType;
    
        if CurrentBinWidth==0, CurrentBinWidth=SavedBinWidth;end
        if isempty(CurrentStimVector) CurrentStimVector=SavedStimVector; 
         XVector=CurrentStimVector(1):CurrentBinWidth:CurrentStimVector(2);
 PlotXVector=[(CurrentStimVector(1)+(CurrentBinWidth/2)):CurrentBinWidth:(CurrentStimVector(2)+(CurrentBinWidth/2))];
        end

        %         if strcmp(CurrentFilterString,'NA'), end     %removed |strcmp(CurrentFilterString,'1') here
        if isempty(CurrentRF), CurrentRF=SavedRF; end
        if isempty(TimeWindowVector), TimeWindowVector=SavedTimeWindowVector;end
        if isempty(CurrentUnitNumber), CurrentUnitNumber=SavedUnitNumber;end
        
%         if CurrentUseAxisVars~=1
%             
%***************CHANGED 12/22/2005... This seems to make MORE SENSE *****

        CurrentXAxisCenters=SavedXAxisCentersStr;    
        CurrentX1AxisCenters=SavedX1AxisCentersStr;    
        CurrentXAxisVariableStr=SavedXAxisVariableStr;
        CurrentX1AxisVariableStr=SavedX1AxisVariableStr;
         CurrentYAxisVariableStr=SavedYAxisVariableStr;
         CurrentXAxisDiscretize=SavedXAxisDiscretize;
         CurrentX1AxisDiscretize=SavedX1AxisDiscretize;
         CurrentXAxisCentersStr=SavedXAxisCentersStr;
         CurrentX1AxisCentersStr=SavedX1AxisCentersStr;
         
         CurrentPValue=SavedPValue;
%          
%         end

        detachvars;
        
%         discretizeXes; %I think this is OK here... Probably all overkill. Watch out. Same for next two sentences
%         eval(['CurrentXAxisVariable=' CurrentXAxisVariableStr ';']);
%         eval(['CurrentX1AxisVariable=' CurrentX1AxisVariableStr ';']);
        

setAlignTime;  %need to call again so that currentaligntime is set, previous call in getcurrentparameters is not enough
evalAlignTime;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
eval(SavedEvalString); hold on; 

CurrentPlotType=SavedPlotType;
CurrentDisplayFilterString=CurrentFilterString;

EvalString=SavedEvalString; MakeTempGraphix;

NStr=num2str(CurrentAxis);

        if CurrentHoldStatus==1    %now here, evaluate the eval string and set the handles.a1 structure to include the new object
eval(['handles.A' NStr '(length(handles.A' NStr ')+1)=TempGraphix;']);
        else                                   %here, evaluate the eval string, and replace the handles.a1(xx) structure with the new graphics object
%             delete(SavedHandle);  %removes the graphics object from the screen
eval(['handles.A' NStr '(ObjectIndex)=TempGraphix;']);
        end
        
        clearvars; %clear CurrentAlignTime;
    end  %ending the current axis loop
    
end