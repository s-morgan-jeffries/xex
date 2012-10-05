
%	 this is the major update graphic objects file. poorly called
%	 updateslider, because it is really the replacement for updateorloadgfx
%	 or something like that

%getting axes to update list

if ~strcmp(UpdateType,'Marker')
AxesToUpdateStr=get(handles.UseTheseAxes,'string');
if isempty(AxesToUpdateStr), AxesToUpdateStr='[]';end
eval(['CurrentAxesToUpdate=' AxesToUpdateStr ';']);
else
    CurrentAxesToUpdate=CurrentAxisMarkerNumber;
end

%**********     GETTING VALUES FOR OPTION VARIABLES ***************

if strcmp(get(handles.PlotLatency,'checked'),'on') CurrentPlotLatency=1; else CurrentPlotLatency=0;end
CurrentLatInit=handles.LatInitTime;
if strcmp(get(handles.PlotCB,'checked'),'on') CurrentPlotCB=1; else CurrentPlotCB=0;end
if strcmp(get(handles.PlotSig,'checked'),'on') CurrentPlotSig=1; else CurrentPlotSig=0;end
 CurrentHoldStatus=get(handles.HoldStatus,'Value');
 if strcmp(get(handles.SpikeTruncate,'checked'),'off'), CurrentAnalogCorrect=0; else CurrentAnalogCorrect=1;end
CurrentUseProps=0;  %not really used, just for completeness

%*********************************************************************

for UpdateIndex=1:length(CurrentAxesToUpdate)
    
    %FIND CURRENT AXIS
    
    CurrentAxis=CurrentAxesToUpdate(UpdateIndex);
    CUStr=num2str(CurrentAxis);
    eval(['axes(handles.axes' CUStr ');']);
   
    if ~(strcmp(UpdateType,'LinkAxis')&&CurrentAxis==CurrentLinkAxis)  %dont update the link axis, rarely makes sense.
    
    %FIND CURRENT OBJECT LIST
    
    eval(['if isfield(handles,''A' CUStr '''), CurrentObjects=handles.A' CUStr ';else CurrentObjects=[];end']);  %getting the current objects
    
    if ~isempty(CurrentObjects)  %trying to update empty axes
    
    %CLEAR AXIS, MAKE TITLES, ETC

%     cla; hold off;
%     if(CurrentHoldStatus==1),  hold on; end  % i am not touchin this (july 2006), but this is really not effective. hold on is called later anyway, as it should be !!!

hold on; %july 2006, commented out the two lines above, and using this now

 %% This is for the hold component; if you want hold on to take effect. Off
 %%  for now.
 % if(CurrentHoldStatus~=1), cla; hold off; else hold on; end
 %     title(''); xlabel(''); ylabel('');

eval(['if isfield(handles,''A' CUStr 'Annotations''), CurrentAnnotation=handles.A' CUStr 'Annotations;else CurrentAnnotation=[];end']);  %getting the current annotations;  uncommented on feb 20

%GETTING THE OBJECTS TO UPDATE LIST

FindObjectsToUpdate;
if isempty(CurrentObjectsToUpdate) | any(CurrentObjectsToUpdate>length(CurrentObjects)) 
    CurrentObjectsToUpdate=1:length(CurrentObjects);
    fprintf('%s\n','Warning: Invalid Axis Objects to update Ignored');
end

    
    %REDO EACH OBJECT IN THIS LOOP if it is a member of a valid
    %currentupdate
    
%         for ObjectIndex=1:length(CurrentObjects)
        for ObjectIndex=CurrentObjectsToUpdate

%             if (LoadGFXVar==1&&CurrentObjects(ObjectIndex).newgraph==1) || (LoadGFXVar~=1)

      CurrentFilterString='DUMMY';  %DUMMY, JUST SO getcurrentparameters will get BY 
     getCurrentParameters; %baseline values, will be overwritten by saved values below.
     
                %GETTING ALL RELEVANT SAVED VARIABLES
%             keyboard;
         SavedDataFile=CurrentObjects(ObjectIndex).dataset;  
        SavedHandle=CurrentObjects(ObjectIndex).handle;

 
%use the same data file for axes update
     eval([...
        'Trials=handles.' SavedDataFile '.Trials;'...
        'CurrentVariables=handles.' SavedDataFile '.Analysis;'...
        ]);
       CurrentDataFile=SavedDataFile;

        CurrentRF=CurrentObjects(ObjectIndex).rf;
        SavedEvalString=CurrentObjects(ObjectIndex).evalstring;
        NextMarker=CurrentObjects(ObjectIndex).markerstring;
        
        if strcmp(UpdateType,'Marker')
            OldMarker=NextMarker;
            NextMarkerSet;
            if isempty(NextMarker) NextMarker=OldMarker;end
        end
        
        if ~strcmp(UpdateType,'UnitNumber')
                    CurrentUnitNumber=CurrentObjects(ObjectIndex).unitnumber;
        end
        
        SavedPValue=CurrentObjects(ObjectIndex).pvalue;
        CurrentPValue=SavedPValue;
        
        if ~strcmp(UpdateType,'BW'),
        CurrentBinWidth=CurrentObjects(ObjectIndex).binwidth;
        CurrentSliderValue=(CurrentBinWidth/10)-5; %legacy: keeping two variables
        else
          CurrentPValue=CurrentBinWidth/250; %goes from 0 to 0.4; hardcoded
        end
        
%         if ~strcmp(UpdateType,'slider')
%         CurrentSliderValue=CurrentObjects(ObjectIndex).slidervalue;
%         end
        
        if ~strcmp(UpdateType,'TimeWindow')&&~strcmp(UpdateType,'TimeLinkAxis')  %if mousing in a link axis window with xaxis of time then take it from there
        CurrentStimVector=CurrentObjects(ObjectIndex).timevector;
        TimeWindowVector=CurrentObjects(ObjectIndex).timewindowvector;
        elseif strcmp(UpdateType,'TimeLinkAxis')
            CurrentStimVector=TimeWindowLinkAxis;
            TimeWindowVector=CurrentStimVector;
        end

         XVector=CurrentStimVector(1):CurrentBinWidth:CurrentStimVector(2);
        PlotXVector=[(CurrentStimVector(1)+(CurrentBinWidth/2)):CurrentBinWidth:(CurrentStimVector(2)+(CurrentBinWidth/2))];
        SavedFilterString=CurrentObjects(ObjectIndex).trialfilter;
        
        if ~strcmp(UpdateType,'Align'),
        CurrentAlignString=CurrentObjects(ObjectIndex).alignstring;
        end
        
        SavedAlignString=CurrentAlignString;
        SavedVariable=CurrentObjects(ObjectIndex).currentvariable;
        CurrentSelectedVariable=SavedVariable;
        SavedErrorBarType=CurrentObjects(ObjectIndex).errorbartype;
        CurrentErrorBarType=SavedErrorBarType;
  

        LocalMarkerString=NextMarker;

        CurrentXAxisVariableStr=CurrentObjects(ObjectIndex).xaxisvariablestr;
        CurrentX1AxisVariableStr=CurrentObjects(ObjectIndex).x1axisvariablestr;
        CurrentYAxisVariableStr=CurrentObjects(ObjectIndex).yaxisvariablestr;
        CurrentXAxisDiscretize=CurrentObjects(ObjectIndex).discretizex;
        CurrentX1AxisDiscretize=CurrentObjects(ObjectIndex).discretizex1;
        CurrentXAxisCentersStr=CurrentObjects(ObjectIndex).xaxiscenters;
        CurrentX1AxisCentersStr=CurrentObjects(ObjectIndex).x1axiscenters;        
        
        switch(UpdateType)
            case 'XAxisVar', TempAxisVars=cellstr(get(handles.XAxisVariable,'string')); 
                TempVal=get(handles.XAxisVariable,'value'); 
                CurrentXAxisVariableStr=TempAxisVars{TempVal};
            case 'X1AxisVar',TempAxisVars=cellstr(get(handles.X1AxisVariable,'string')); 
                TempVal=get(handles.X1AxisVariable,'value'); 
                CurrentX1AxisVariableStr=TempAxisVars{TempVal};
            case 'YAxisVar',TempAxisVars=cellstr(get(handles.YAxisVariable,'string')); 
                TempVal=get(handles.YAxisVariable,'value'); 
                CurrentYAxisVariableStr=TempAxisVars{TempVal};
            case 'XAxisDiscreteVals',
                if get(handles.XAxisDiscretize,'value')==1
                    CurrentXAxisCentersStr=get(handles.XAxisCenters,'string');
                end
            case 'X1AxisDiscreteVals',
                if get(handles.X1AxisDiscretize,'value')==1
                    CurrentX1AxisCentersStr=get(handles.X1AxisCenters,'string');
                end
        end               
        
        ThingsToDo=get(handles.WhatToDo,'String');
        WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};

%         if strcmp(WhatToDo,'ActiveUpdate') & strcmp(UpdateType,'slider')
%         %INTERESTING TRICK: PROBABLY SHOULD ADAPT TO BINWIDTH TO ADJUST
%         CENTERS STR.. BUT NOW WE HAVE CENTERS UPDATE
%             
% if isstr(CurrentXAxisCentersStr),            TemporaryVariable=str2num(CurrentXAxisCentersStr);
% else TemporaryVariable=CurrentXAxisCentersStr;
% end
%             InitVar=TemporaryVariable(1)-((TemporaryVariable(2)-TemporaryVariable(1))/2);
%             FinVar=TemporaryVariable(end)+((TemporaryVariable(2)-TemporaryVariable(1))/2);
%             NumBin=round(((CurrentSliderValue+5)/10)*20)+2;
%             TemporaryVariable=InitVar:((FinVar-InitVar)/NumBin):FinVar;
%             TemporaryVariable=round(mean([TemporaryVariable(1:(end-1));TemporaryVariable(2:end)]));
%             CurrentXAxisCentersStr=(TemporaryVariable);
%             
%         end
        
        CurrentPlotType=CurrentObjects(ObjectIndex).plottype;
        
        if ~strcmp(UpdateType,'Filter') CurrentFilterString=SavedFilterString;

                    if strcmp(UpdateType,'LinkAxis') ,CurrentFilterString=[CurrentFilterString '&' AppendFilter];end %that does the append filter

        else
            
            FilterStringList=cellstr(get(handles.TrialFilterVector,'string'));
      CurrentFilterString=FilterStringList{1};
            
        end
            

        %getting data from cell
        
       detachvars;    

%        setAlignTime;
       evalAlignTime;
       
       
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current filter vector

if ~isempty(find(CurrentFilterVector))
            delete(SavedHandle);  %july 2006, will this work ?
eval(SavedEvalString); hold on;
EvalString=SavedEvalString; 

            CurrentDisplayFilterString=CurrentFilterString;

            if strcmp(UpdateType,'LinkAxis') %| strcmp(UpdateType,'Filter')  %not reversing for type 'Filter'
            CurrentFilterString=CurrentObjects(ObjectIndex).trialfilter;  %reversing the filter change
end


MakeTempGraphix;

NStr=num2str(CurrentAxis);

% if LoadGFXVar~=1 && CurrentHoldStatus==1  %now here, evaluate the eval string and set the handles.a1 structure to include the new object
% eval(['handles.A' NStr '(length(handles.A' NStr ')+1)=TempGraphix;']);
%         else                                   %here, evaluate the eval string, and replace the handles.a1(xx) structure with the new graphics object
eval(['handles.A' NStr '(ObjectIndex)=TempGraphix;']);
%         end

else fprintf('%s\n','Refusing to update empty filtervectors');
end   %ending ~isempty(find(currentfiltervector))

        clearvars;        
        
        end  %ending for objects = loop

     if ~isempty(CurrentAnnotation), title(CurrentAnnotation{1}); 
         if length(CurrentAnnotation)>1,xlabel(CurrentAnnotation{2});end
         if length(CurrentAnnotation)>2,ylabel(CurrentAnnotation{3});end %change on feb 20
     end
    
    else
        fprintf('%s\n','Warning: That axis is EMPTY');
    end %ending if ~isempty(currentobjects) loop
    else fprintf('%s\n','Warning: Not updating the link axis');
    end
end%ending the current axis loop