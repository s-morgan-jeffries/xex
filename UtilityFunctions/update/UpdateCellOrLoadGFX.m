
%	 this script does all the hard work for updating a cell or loading
%	 graphix
%   commenting and fixing: 05/12/21

%getting axes to update list

AxesToUpdateStr=get(handles.UseTheseAxes,'string');
if isempty(AxesToUpdateStr), AxesToUpdateStr='[]';end
eval(['CurrentAxesToUpdate=' AxesToUpdateStr ';']);
if LoadGFXVar==1, CurrentAxesToUpdate=1:handles.NumberOfAxes;end

%**********     GETTING VALUES FOR OPTION VARIABLES ***************
if strcmp(get(handles.PlotLatency,'checked'),'on') CurrentPlotLatency=1; else CurrentPlotLatency=0;end
CurrentLatInit=handles.LatInitTime;
if strcmp(get(handles.PlotCB,'checked'),'on') CurrentPlotCB=1; else CurrentPlotCB=0;end
if strcmp(get(handles.PlotSig,'checked'),'on') CurrentPlotSig=1; else CurrentPlotSig=0;end

 CurrentHoldStatus=get(handles.HoldStatus,'Value');
 if strcmp(get(handles.SpikeTruncate,'checked'),'off'), CurrentAnalogCorrect=0; else CurrentAnalogCorrect=1;end
CurrentUseProps=0;  %not really used, just for completeness
%*********************************************************************

%**********     GETTING VALUES FOR CELL VARIABLES ***************
 
   CurrentUnitNumber=handles.UnitNumber;
   CurrentRF=handles.RFLocation;

   %getting current data and data file ->.keeping this a single data file at the moment as well
 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), LoadedFileList={LoadedFileList}; end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
 if ~strcmp(CurrentDataFile,'LoadedFiles')
     
  eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);

  eval([...
        'Trials=handles.' CurrentDataFile '.Trials;'...
        'CurrentVariables=handles.' CurrentDataFile '.Analysis;'...
        ]);
 else TellMe('%s\n','Load a File first',handles.SpeakToMe); GoOn=0;
 end
     
 
%*********************************************************************
 

%	This is the list of saved variables for each figure

%UNUSED:
% handle
% dataset

%CELL VARIABLES:
% unitnumber
% rf

%AXIS VARIABLES
% xaxisvariablestr
% x1axisvariablestr
% yaxismeasurestr
% discretizex
% discretizex1
% xaxiscenters
% x1axiscenters

%IMPORTANT
% evalstring
% markerstring
% binwidth
% timevector
% trialfilter
% alignstring
% currentvariable
% timewindowvector
% slidervalue
% plottype

%********** IF DATA EXIST, THEN ANALYZE ***************

if GoOn==1
      
for UpdateIndex=1:length(CurrentAxesToUpdate)
    
    %FIND CURRENT AXIS
    
    CurrentAxis=CurrentAxesToUpdate(UpdateIndex);
    CUStr=num2str(CurrentAxis);
    eval(['axes(handles.axes' CUStr ');']);
    fprintf('%s\n',['Updating axis  ' CUStr]);
    
    %FIND CURRENT OBJECT LIST
    
    eval(['if isfield(handles,''A' CUStr '''), CurrentObjects=handles.A' CUStr ';else CurrentObjects=[];end']);  %getting the current objects
    
    %CLEAR AXIS, MAKE TITLES, ETC
    
if(CurrentHoldStatus~=1), cla; hold off; else hold on; end
    title(''); xlabel(''); ylabel('');
    eval(['if isfield(handles,''A' CUStr 'Annotations''), CurrentAnnotation=handles.A' CUStr 'Annotations;else CurrentAnnotation=[];end']);  %getting the current annotations
    
    %REDO EACH OBJECT IN THIS LOOP
    
        for ObjectIndex=1:length(CurrentObjects)

%             if (LoadGFXVar==1&&CurrentObjects(ObjectIndex).newgraph==1) || (LoadGFXVar~=1)
           
if LoadGFXVar~=1
     
                %GETTING ALL RELEVANT SAVED VARIABLES
            
%         SavedDataFile=CurrentObjects(ObjectIndex).dataset;  
%         SavedHandle=CurrentObjects(ObjectIndex).handle;

        SavedEvalString=CurrentObjects(ObjectIndex).evalstring;
        NextMarker=CurrentObjects(ObjectIndex).markerstring;
        CurrentBinWidth=CurrentObjects(ObjectIndex).binwidth;
        CurrentSliderValue=CurrentObjects(ObjectIndex).slidervalue;
        CurrentStimVector=CurrentObjects(ObjectIndex).timevector;
         XVector=CurrentStimVector(1):CurrentBinWidth:CurrentStimVector(2);
        PlotXVector=[(CurrentStimVector(1)+(CurrentBinWidth/2)):CurrentBinWidth:(CurrentStimVector(2)+(CurrentBinWidth/2))];
        CurrentFilterString=CurrentObjects(ObjectIndex).trialfilter;
        CurrentAlignString=CurrentObjects(ObjectIndex).alignstring;
        SavedAlignString=CurrentAlignString;
        SavedVariable=CurrentObjects(ObjectIndex).currentvariable;
        CurrentSelectedVariable=SavedVariable;
        SavedErrorBarType=CurrentObjects(ObjectIndex).errorbartype;
        CurrentErrorBarType=SavedErrorBarType;
        SavedPValue=CurrentObjects(ObjectIndex).pvalue;
        CurrentPValue=SavedPValue;

        LocalMarkerString=NextMarker;
        TimeWindowVector=CurrentObjects(ObjectIndex).timewindowvector;

        CurrentXAxisVariableStr=CurrentObjects(ObjectIndex).xaxisvariablestr;
        CurrentX1AxisVariableStr=CurrentObjects(ObjectIndex).x1axisvariablestr;
        CurrentYAxisVariableStr=CurrentObjects(ObjectIndex).yaxisvariablestr;
        CurrentXAxisDiscretize=CurrentObjects(ObjectIndex).discretizex;
        CurrentX1AxisDiscretize=CurrentObjects(ObjectIndex).discretizex1;
        CurrentXAxisCentersStr=CurrentObjects(ObjectIndex).xaxiscenters;
        CurrentX1AxisCentersStr=CurrentObjects(ObjectIndex).x1axiscenters;        
        
        CurrentPlotType=CurrentObjects(ObjectIndex).plottype;

        %getting data from cell
        
       detachvars;    

%        setAlignTime;
       evalAlignTime;
       
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current filter vector
eval(SavedEvalString); hold on;
EvalString=SavedEvalString;
CurrentDisplayFilterString=CurrentFilterString;
MakeTempGraphix;

NStr=num2str(CurrentAxis);

if LoadGFXVar~=1 && CurrentHoldStatus==1  %now here, evaluate the eval string and set the handles.a1 structure to include the new object
eval(['handles.A' NStr '(length(handles.A' NStr ')+1)=TempGraphix;']);
        else                                   %here, evaluate the eval string, and replace the handles.a1(xx) structure with the new graphics object
eval(['handles.A' NStr '(ObjectIndex)=TempGraphix;']);
        end

        clearvars;
end

  
     if ~isempty(CurrentAnnotation), title(CurrentAnnotation{1}); 
         if length(CurrentAnnotation)>1,xlabel(CurrentAnnotation{2});end
         if length(CurrentAnnotation)>2,ylabel(CurrentAnnotation{3});end %change on feb 20
     end
     
%      if ~isempty(CurrentAnnotation), title(CurrentAnnotation{1}); xlabel(CurrentAnnotation{2}); ylabel(CurrentAnnotation{3});end
        end
end%ending the current axis loop

 end %ending the GoOn Loop
