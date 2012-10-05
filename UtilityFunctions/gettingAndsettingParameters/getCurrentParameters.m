
%This script collects parameters from the GUI. 
%getCurrentParameters.m

%getting the axes vector for plotting and for update, and resetting axes pointer

AxesList=get(handles.UseTheseAxes,'string');
eval(['CurrentAxesVector=' AxesList ';']);
if ~exist('NoChangeAxesPointer','var')||NoChangeAxesPointer~=1
AxesPointer=0; % to be used to update which axes to plot into
end

AxesToUpdateStr=AxesList;
if isempty(AxesToUpdateStr), AxesToUpdateStr='[]';end
eval(['CurrentAxesToUpdate=' AxesToUpdateStr ';']);

 %AXIS MARKER LIST !!
 
 for TempVarA=1:handles.NumberOfAxes
 eval(['Axis' num2str(TempVarA) 'Markers=get(handles.Axis' num2str(TempVarA) 'Markers,''string'');'...
%  'Axis' num2str(TempVarA) 'MarkerPointer=0;'...    
 ]);
 end
 clear TempVarA;
 
CurrentA7XLim=get(handles.axes7,'xlim');
CurrentA8XLim=get(handles.axes8,'xlim');
CurrentA9XLim=get(handles.axes9,'xlim');

CurrentPValue=handles.SignificanceCutoff;

%DATA FILE !!

 LoadedFileList=get(handles.LoadedFiles,'string');
 if ~iscell(LoadedFileList), TempVar{1}=LoadedFileList; LoadedFileList=TempVar;end
 CurrentValue=get(handles.LoadedFiles,'value'); CurrentValue=CurrentValue(1);
 CurrentDataFile=LoadedFileList{CurrentValue};
 
%PLOTTING FILE !!

 PlottingFileList=get(handles.PlottingFileList,'string');
 if ~iscell(PlottingFileList) TempArray{1}=PlottingFileList; PlottingFileList=TempArray;clear TempArray;end
 CurrentValue=get(handles.PlottingFileList,'value'); CurrentValue=CurrentValue(1);
 CurrentPlottingFile=PlottingFileList{CurrentValue};
 
 %OPTION VARIABLES
 
if strcmp(get(handles.PlotLatency,'checked'),'on') CurrentPlotLatency=1; else CurrentPlotLatency=0;end
CurrentLatInit=handles.LatInitTime;
if strcmp(get(handles.PlotCB,'checked'),'on') CurrentPlotCB=1; else CurrentPlotCB=0;end
if strcmp(get(handles.PlotSig,'checked'),'on') CurrentPlotSig=1; else CurrentPlotSig=0;end
 CurrentHoldStatus=get(handles.HoldStatus,'Value');
 CurrentUseProps=get(handles.UseProps,'Value');
 if strcmp(get(handles.SpikeTruncate,'checked'),'off'), CurrentAnalogCorrect=0; else CurrentAnalogCorrect=1;end
 
 %CELL VARIABLES
 
  CurrentUnitNumber=(handles.UnitNumber);
  CurrentRF=handles.RFLocation;


% IMPORTANT GUI VARIABLES

setAlignTime;
CurrentBinWidth=get(handles.BinWidth,'value');
CurrentSliderValue=(CurrentBinWidth/10)-5;
% CurrentSliderValue=get(handles.UpdateSlider,'value');  %trying the eliminate the slider

%Actual filter extraction outside getcurrent parameters, because of graphic
%command processing

if strcmp(CurrentFilterString,'TrialFilterVector') | isempty(CurrentFilterString), CurrentFilterString='1';end

OurVariables=cellstr(get(handles.XAxisVariable,'string'));
CurrentSelectedVariable=OurVariables{get(handles.XAxisVariable,'value')};

CurrentErrorBarType=get(handles.ErrorBarType,'label');
  
  %AXIS VARIABLES
  
  XAxisVariables=cellstr(get(handles.XAxisVariable,'string'));
  CurrentXAxisVariableStr=XAxisVariables{get(handles.XAxisVariable,'value')};
  X1AxisVariables=cellstr(get(handles.X1AxisVariable,'string'));
  CurrentX1AxisVariableStr=X1AxisVariables{get(handles.X1AxisVariable,'value')};
  YAxisVariables=cellstr(get(handles.YAxisVariable,'string'));
  CurrentYAxisVariableStr=YAxisVariables{get(handles.YAxisVariable,'value')};
  
  CurrentXAxisDiscretize=get(handles.XAxisDiscretize,'value');
  CurrentX1AxisDiscretize=get(handles.X1AxisDiscretize,'value');
  
CurrentXAxisCentersStr=get(handles.XAxisCenters,'string');
CurrentXAxisCenters=str2num(CurrentXAxisCentersStr);
CurrentX1AxisCentersStr=get(handles.X1AxisCenters,'string');
CurrentX1AxisCenters=str2num(CurrentX1AxisCentersStr);

% CurrentYAxisMeasureStr=handles.MyVariableChoices.YAxisMeasureStr;

% TIME WINDOW PROCESSING

CurrentStimString=get(handles.StimulusAlignedTimeVector,'string');

%Processing string in window for different plotting files and different
%colon or no-colon formats (POOR MAN's REGEXP :)

ParseStimString;