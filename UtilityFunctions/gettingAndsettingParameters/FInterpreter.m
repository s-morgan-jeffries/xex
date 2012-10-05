
%   This script does the filter interpretation; will grow
%   FInterpreter.m

[XexCommand,XexParameters]=strtok(CurrentFilterString);
RunCode=0;

% RUN a command or matlab m-file or whatever !!

if (strcmpi(XexCommand,'RUN')), 
    
    EmptyCheck;
    if(PlotOK==0), return; end

    RunCode=1;
%     eval(XexParameters);
    PlotOK=0; 
    return;
end

% NEW FIGURE

if (strcmpi(XexCommand,'NEWAXIS')), SwitchAxes; 
    fprintf('%s\n','New axis');
    PlotOK=0; 
    return;
end

% % VARIABLE CHOICE
% if (strcmpi(XexCommand,'YVAR')),
%     
%     EmptyCheck;
%     if(PlotOK==0), return; end
% 
%     VarList=cellstr(get(handles.VariablesList,'string'));
%     findvar=find(strcmp(VarList,XexParameters));
% %     keyboard;
%     if ~isempty(findvar),
%         set(handles.VariablesList,'value',findvar);
%     end
%     
%     PlotOK=0;
%     return;
% end

% Xlabel, Ylabel and Title

TempAxesHandles=nan*ones(1,handles.NumberOfAxes);
CurrentAxisHandle=gca;

for TempVar=1:(handles.NumberOfAxes)
   eval([' TempAxesHandles(TempVar)=handles.axes' num2str(TempVar) ';']);
end

WhichAxis=find(TempAxesHandles==CurrentAxisHandle);

if (strcmpi(XexCommand,'Xlabel'))

    EmptyCheck;
    if(PlotOK==0), return; end
    
    Curxlabel=XexParameters;
    xlabel(Curxlabel);
    eval(['handles.A' num2str(WhichAxis) 'Annotations{2}=Curxlabel; if length(handles.A' num2str(WhichAxis) 'Annotations)<3, handles.A' num2str(WhichAxis) 'Annotations{3}='''';end']);
    
    PlotOK=0;
    return;

elseif (strcmpi(XexCommand,'Ylabel'))
    
%     [dummyvar,Curylabel]=strtok(CurrentFilterString);
    EmptyCheck;
    if(PlotOK==0), return; end

    Curylabel=XexParameters;
   ylabel(Curylabel);
   eval(['handles.A' num2str(WhichAxis) 'Annotations{3}=Curylabel;']);
    
    PlotOK=0;
    return;
    
elseif (strcmpi(XexCommand,'Title'))
    
%     [dummyvar,Curtitle]=strtok(CurrentFilterString);
        EmptyCheck;
    if(PlotOK==0), return; end

    Curtitle=XexParameters;
    title(Curtitle);
   eval(['handles.A' num2str(WhichAxis) 'Annotations{1}=Curtitle;']);
   eval(['if length(handles.A' num2str(WhichAxis) 'Annotations)<2, handles.A' num2str(WhichAxis) 'Annotations{2}='''';end']);
   eval(['if length(handles.A' num2str(WhichAxis) 'Annotations)<3, handles.A' num2str(WhichAxis) 'Annotations{3}='''';end']);
    
    PlotOK=0;
    return;    

elseif (strcmpi(XexCommand,'Xlim'))
    
%     [dummyvar,Curxlim]=strtok(CurrentFilterString);
        EmptyCheck;
    if(PlotOK==0), return; end
Curxlim=XexParameters;
    xlim(str2num(Curxlim));
    eval(['handles.A' num2str(WhichAxis) 'Annotations{4}=Curxlim;']);
    
    PlotOK=0;
    return;    

elseif (strcmpi(XexCommand,'Ylim'))
    
%     [dummyvar,Curylim]=strtok(CurrentFilterString);
    EmptyCheck;
    if(PlotOK==0), return; end
    Curylim=XexParameters;
    ylim(Curylim);
   eval(['handles.A' num2str(WhichAxis) 'Annotations{5}=Curylim;']);
    
    PlotOK=0;
    return;    
    
end

% HOLD ON and HOLD OFF

if (strcmpi(XexCommand,'HOLD')), 

        EmptyCheck;
    if(PlotOK==0), return; end

    if ~isempty(strfind(XexParameters,'OFF')),
           set(handles.HoldStatus,'value',0);
           fprintf('%s\n','HOLD OFF');
    elseif ~isempty(strfind(XexParameters,'ON')),
           set(handles.HoldStatus,'value',1);
           fprintf('%s\n','HOLD ON');
    end
    
    PlotOK=0;
    return;
    
end

% COLORS ON AND OFF

if (strcmpi(XexCommand,'COLORS')), 

        EmptyCheck;
    if(PlotOK==0), return; end

    if ~isempty(strfind(XexParameters,'OFF')),
           set(handles.UseProps,'value',0);
           fprintf('%s\n','COLORS OFF');
    elseif ~isempty(strfind(XexParameters,'ON')),
           set(handles.UseProps,'value',1);
           fprintf('%s\n','COLORS ON');
    end
    
    DoUseProps;
    
    PlotOK=0;
    return;
    
end

% CB ON and CB OFF

if (strcmpi(XexCommand,'CB')), 

    EmptyCheck;
    if(PlotOK==0), return; end
   
    if ~isempty(strfind(XexParameters,'OFF')),
           set(handles.PlotCB,'checked','off');
           fprintf('%s\n','CB OFF');
    elseif ~isempty(strfind(XexParameters,'ON')),
           set(handles.PlotCB,'checked','on');
           fprintf('%s\n','CB ON');
    end
    
    PlotOK=0;
    return;
    
end

% SIG ON and SIG OFF

if (strcmpi(XexCommand,'SIG')), 

    EmptyCheck;
    if(PlotOK==0), return; end
   
    if ~isempty(strfind(XexParameters,'OFF')),
           set(handles.PlotSig,'checked','off');
           fprintf('%s\n','SIG OFF');
    elseif ~isempty(strfind(XexParameters,'ON')),
           set(handles.PlotSig,'checked','on');
           fprintf('%s\n','SIG ON');
    end
    
    PlotOK=0;
    return;
    
end

% CLEAR

if strcmpi(XexCommand,'CLEAR'),
    EmptyCheck;
    if(PlotOK==0), return; end

    if ~strcmpi(XexParameters,'ALL'),
        
    ClearAxList=str2num(XexParameters);

    if min(ClearAxList)<0 , ClearAxList(ClearAxList<0)=0;end
    if max(ClearAxList)>handles.NumberOfAxes, ClearAxList(ClearAxList>handles.NumberOfAxes)=handles.NumberOfAxes;end
    
for TempVar=ClearAxList
    eval(['axes(handles.axes' num2str(TempVar) ');']);
    cla; hold off;
eval(['if isfield(handles,''A' num2str(TempVar) '''), handles=rmfield(handles,''A' num2str(TempVar) ''');end']);
end

    else 
        
        for TempVar=1:(handles.NumberOfAxes)
    eval(['axes(handles.axes' num2str(TempVar) ');']);
    cla; hold off;
eval(['if isfield(handles,''A' num2str(TempVar) '''), handles=rmfield(handles,''A' num2str(TempVar) ''');end']);
end
        
    end
    
    PlotOK=0; return;

end

% CIRCLEGRAPH ON AND OFF

if (strcmpi(XexCommand,'CIRCLEGRAPH')), 
   
        EmptyCheck;
    if(PlotOK==0), return; end

    if ~isempty(strfind(XexParameters,'ON'))
    
    set(handles.GainGraph,'checked','on');
    
    if strcmp(get(handles.SixGraph,'Checked'),'on'),
        set(handles.SixGraph,'checked','off');
        makeVisible([handles.axes7 handles.axes8 handles.axes9]);
    end
    
         set_gainposits;
         fprintf('%s\n','CIRCLEGRAPH ON');
         PlotOK=0;
         return;
    
    elseif ~isempty(strfind(XexParameters,'OFF')), 
   
    set(handles.GainGraph,'checked','off');
    reset_gainposits;
    makeVisible([handles.Axis7Indicator handles.Axis8Indicator handles.Axis9Indicator]);
    
    PlotOK=0;
    fprintf('%s\n','CIRCLEGRAPH OFF');
    return;
    
    end
    
end

% ALIGN CODE

if (strcmpi(XexCommand,'ALIGN')),
    
        EmptyCheck;
    if(PlotOK==0), return; end

    if ~isempty(strfind(XexParameters,'RF1')) CurrentAlignString='RFOnTime';
   
            AlignCodeList=get(handles.AlignCode,'string');
            findrf= find(strcmp(AlignCodeList,'RF1'));
            if ~isempty(findrf), set(handles.AlignCode,'value',findrf);end

    elseif ~isempty(strfind(XexParameters,'SAC1')) CurrentAlignString='SacAlignTime1';
            AlignCodeList=get(handles.AlignCode,'string');
            findsac1= find(strcmp(AlignCodeList,'SacTime1'));
            if ~isempty(findsac1), set(handles.AlignCode,'value',findsac1);end
            
    elseif ~isempty(strfind(XexParameters,'RF2')) CurrentAlignString='RF2OnTime';
            AlignCodeList=get(handles.AlignCode,'string');
            findrf2= find(strcmp(AlignCodeList,'RF2'));
            if ~isempty(findrf2), set(handles.AlignCode,'value',findrf2);end

    end
    
    PlotOK=0;
    
    fprintf('%s\n',['Aligned to ' CurrentAlignString]);
    return;
    
end

% PLOT TYPE

if (strcmpi(XexCommand,'PLOTTYPE')),
    
        EmptyCheck;
    if(PlotOK==0), return; end

    if ~isempty(strfind(XexParameters,'IMAGE')) CurrentPlottingFile='ImageMap.m';
    elseif ~isempty(strfind(XexParameters,'CIRCLE')) CurrentPlottingFile='CircleMap.m';
    elseif ~isempty(strfind(XexParameters,'SPIKEDENSITY')) CurrentPlottingFile='SpikeDensity.m';
    elseif ~isempty(strfind(XexParameters,'TUNINGCURVE')) CurrentPlottingFile='DrawTuningCurve.m';
    elseif ~isempty(strfind(XexParameters,'ANGULAR')) CurrentPlottingFile='AngularTuningCurve.m';
    elseif ~isempty(strfind(XexParameters,'HIST')) CurrentPlottingFile='MakeHist.m';
    elseif ~isempty(strfind(XexParameters,'DISCHIST')) CurrentPlottingFile='DiscHist.m';
    elseif ~isempty(strfind(XexParameters,'PSTH')) CurrentPlottingFile='DrawPSTH.m';
    elseif ~isempty(strfind(XexParameters,'RASTER')) CurrentPlottingFile='DrawRasters.m';
    elseif ~isempty(strfind(XexParameters,'ISI')) CurrentPlottingFile='ISIH.m';
    elseif ~isempty(strfind(XexParameters,'KDE')) CurrentPlottingFile='DrawKDE.m';
    elseif ~isempty(strfind(XexParameters,'SCATTER')), CurrentPlottingFile='PlotScatter.m';
    else CurrentPlottingFile='DrawPSTH.m'; fprintf('%s\n ',[XexParameters '  is an invalid plotting file; changed to DrawPSTH.m']);
    end
    
    % ensures that PLOTTYPE just needs to be called once, and then resets current
    % plotting file until next call of PLOTTYPE
    
    PlottingFileList=get(handles.PlottingFileList,'string');
    findPlotFile=find(strcmp(PlottingFileList,CurrentPlottingFile));
    if ~isempty(findPlotFile), set(handles.PlottingFileList,'value',findPlotFile);end
    
    PlotOK=0;
    
%     getCurrentparameters; % not needed cos now doing it in xex plotdata
                                              %%     and in graphcommand processor
    
    fprintf('%s\n',['Plotting File is now ' CurrentPlottingFile]);

    return;
    
end

% Time window string

if (strcmpi(XexCommand,'WINDOW')), 
    EmptyCheck;
    if(PlotOK==0), return; end
    set(handles.StimulusAlignedTimeVector,'string',XexParameters);    
    PlotOK=0;
    return;
end

% XAxis variable, Yaxis variable, etc etc

if (strcmpi(XexCommand,'XAXISVAR')),
    
    EmptyCheck;
    if(PlotOK==0), return; end

    VarList=cellstr(get(handles.XAxisVariable,'string'));
    findvar=find(strcmp(VarList,XexParameters));
%     keyboard;
    if ~isempty(findvar),
        set(handles.XAxisVariable,'value',findvar);
    else fprintf('%s\n','Could not set XAxisVariable');
    end
    
    PlotOK=0;
    return;
end


if (strcmpi(XexCommand,'X1AXISVAR')),
    
    EmptyCheck;
    if(PlotOK==0), return; end

    VarList=cellstr(get(handles.X1AxisVariable,'string'));
    findvar=find(strcmp(VarList,XexParameters));
%     keyboard;
    if ~isempty(findvar),
        set(handles.X1AxisVariable,'value',findvar);
    else fprintf('%s\n','Could not set X1AxisVariable');
    end
    
    PlotOK=0;
    return;
end

if (strcmpi(XexCommand,'XAXISDISCRETIZE')), 
    EmptyCheck;
    if(PlotOK==0), return; end
    
    if ~isempty(strfind(XexParameters,'ON')),
        set(handles.XAxisDiscretize,'value',1);
    elseif ~isempty(strfind(XexParameters,'OFF')),
        set(handles.XAxisDiscretize,'value',0);
    end
        PlotOK=0;
        return;
end

if (strcmpi(XexCommand,'X1AXISDISCRETIZE')), 
    EmptyCheck;
    if(PlotOK==0), return; end
    
    if ~isempty(strfind(XexParameters,'ON')),
        set(handles.X1AxisDiscretize,'value',1);
    elseif ~isempty(strfind(XexParameters,'OFF')),
        set(handles.X1AxisDiscretize,'value',0);
    end
        PlotOK=0;
        return;
end

if (strcmpi(XexCommand,'XAXISCENTERS')), 
    EmptyCheck;
    if(PlotOK==0), return; end
    set(handles.XAxisCenters,'string',XexParameters);
    PlotOK=0;
    return;
end

if (strcmpi(XexCommand,'X1AXISCENTERS')), 
    EmptyCheck;
    if(PlotOK==0), return; end
    set(handles.X1AxisCenters,'string',XexParameters);
    PlotOK=0;
    return;
end


if (strcmpi(XexCommand,'YAXISVAR')),
    
    EmptyCheck;
    if(PlotOK==0), return; end

    VarList=cellstr(get(handles.YAxisVariable,'string'));
    findvar=find(strcmp(VarList,XexParameters));
%     keyboard;
    if ~isempty(findvar),
        set(handles.YAxisVariable,'value',findvar);
    else fprintf('%s\n','Could not set YAxisVariable');
    end
    
    PlotOK=0;
    return;
end

% BINWIDTH

if (strcmpi(XexCommand,'BINWIDTH')), 
    EmptyCheck;
    if(PlotOK==0), return; end
    
    CurBW=str2num(XexParameters);
    if CurBW>=0 && CurBW<=100
    set(handles.BinWidth,'value',CurBW);
    end
    
    PlotOK=0;
    return;
end

%BaseRate

if (strcmpi(XexCommand,'SETBASERATE')), 

    if (exist('FilterStringList','var')&&length(FilterStringList)>1)||(exist('CurrentGCommands','var')&&length(CurrentGCommands)>1)
    
%     EmptyCheck;
%     if(PlotOK==0), return; end
    
    NextCommandSetBaseRate=1;
    PlotOK=0;
    return;

    else fprintf('%s\n','Need a following filter. Ignoring SETBASERATE');
            PlotOK=0;
    return;
    end

elseif (strcmpi(XexCommand,'CLEARBASERATE')), 

%     EmptyCheck;

handles.BaselineFiringRate=NaN;
PlotOK=0;
fprintf('%s\n','Cleared Baseline Firing Rate');
    return;

end

% FILTER



% MARKER ETC


% MAKE PLOT % if existing filter is
% % empty, then set it to 1 or something like that






% CurrentDataFile
% CurrentPlotLatency
% CurrentLatInit
% CurrentUseProps
% CurrentAnalogCorrect
% CurrentUnitNumber
% CurrentRF
% CurrentBinWidth
% CurrentSliderValue