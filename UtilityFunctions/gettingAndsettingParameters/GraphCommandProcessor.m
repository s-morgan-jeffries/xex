
% Basically does what Plot data does, but reads in commands from a gfx
% command file
% GraphCommandProcessor


%Basic parameter collection and setting

for TempVarA=1:handles.NumberOfAxes
    eval([ 'Axis' num2str(TempVarA) 'MarkerPointer=0;'...    
        ]);
end

CurrentFilterString='DUMMY';
getCurrentParameters;

NextCommandSetBaseRate=0;

TempG=cellstr(get(handles.GraphCommandFiles,'string'));
CurrentGFile=TempG{get(handles.GraphCommandFiles,'value')};

if isempty(CurrentUnitNumber), CurrentUnitNumber=613; fprintf('%s\n','Using 613 as the Unit');end

if ~strcmp(CurrentDataFile,'LoadedFiles') & ~strcmp(CurrentGFile,'CmdFiles')
    
    %Make sure it is all loaded in; can preprocess for this even.
    %First thing to do is to read in or take the cell array of command
    %lines
        
   Old_Dir=pwd;
   cd(handles.GraphCommandsDirectory);
   try,
   fid=fopen(CurrentGFile);
   c=textscan(fid,'%s','delimiter','\n');
   fclose(fid);
   CurrentGCommands=c{1};
   catch,
       fprintf('%s\n','Could not read file');
       CurrentGCommands='';
   end
   
   cd(Old_Dir);
   
if ~isempty(CurrentGCommands)
    
    %%***********something like this to strip off comment lines
    
    testcommands=ones(1,length(CurrentGCommands));

    for TempVar=1:length(testcommands)
        testme=strtok(CurrentGCommands{TempVar});
        if ~isempty(strfind(testme,'#')) || isempty(testme) || ~isempty(strfind(testme,'*'))||~isempty(strfind(testme,'%'))
            testcommands(TempVar)=0;
        end
    end

    CurrentGCommands=CurrentGCommands(logical(testcommands));
    
%     keyboard;
    
    for numCommands=1:length(CurrentGCommands)  % change to line list from the file !!
        
      CurrentFilterString=CurrentGCommands{numCommands};

      %need a line here so that switchaxes is called at beginning
      
      if numCommands==1, SwitchAxes; end
  
      PlotOK=1;       % Initializes to PlotOK, FInterpreter will cancel to No Plot if needed
      FInterpreter;  %This calls the filter interpreter !!!!

      if RunCode==1, 
          
                    eval(['Trials=handles.' CurrentDataFile '.Trials;']);
          eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
          eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
          if GoOn==1
CurrentVariables=ParamEval(XexParameters,CurrentVariables);
eval(['handles.' CurrentDataFile '.Analysis=CurrentVariables;']);
          end
              fprintf('%s\n','Running:');
    fprintf('%s\n',XexParameters);
%     clearvars;
end
      
      if PlotOK==1,
          
          if isempty(CurrentFilterString), CurrentFilterString='1';end 
          
          NoChangeAxesPointer=1;
          getCurrentParameters;
         
          %   try
          
          eval(['Trials=handles.' CurrentDataFile '.Trials;']);
          eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
          eval(['if GoOn==1, CurrentVariables=handles.' CurrentDataFile '.Analysis;end']);
          %  eval(['if GoOn==1, fprintf(''%s\n'',''Plotting Now'');' CurrentPlottingFile(1:(end-2)) ';end']);  %running the current plotting file
          eval(['if GoOn==1, ' CurrentPlottingFile(1:(end-2)) ';end']);  %running the current plotting file
          %   catch, fprintf('%s\t','Error in PlottingFile:'); fprintf('%s\n',lasterr);
          %end
      end
    end

end  % ending ~isempty(gcommands)
else TellMe('%s\n','FOR NOW, Make sure you have selected a data file; even if you overwrite this in the graph file',handles.SpeakToMe);
end

%   This is a parser for the graphic command syntax
%   Outputs a string that can be fed to eval !!!
%   Commands:
%   hold on;
%   NEWAXIS;
%   Hold on
%   NEWGRAPH;
%   One of {ImageMap, CircleMap, SpikeDensity, DrawTuningCurve, MakeHist,
%   DrawPSTH, AngularTuningCurve, DrawRasters, ISIH, DrawKDE}
%   Color = 
%   Bandwidth =
%   TimeWindow =
%   Datafile = 
%   Analysis = 
%   Filter =
%   RFx =
%   RFy =
%   Align =
%   Unit =
%   PlotCB=
%   PlotLatency=
%   LatInit =
%   Baselinewindow =
%   XAxis=
%   XAxisDiscrete=
%   XAxisCenters=
%   X1Axis=
%   X1AxisDiscrete=
%   X1AxisCenters=
%   YAxis=