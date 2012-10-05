%	function to decide which objects should be visible based on currently selected parameters of gui
%   Deprecated; never called any more
% 	ShowSlider

ThingsToDo=get(handles.WhatToDo,'string');
WhatToDo=ThingsToDo{get(handles.WhatToDo,'value')};


switch(WhatToDo)
% %     case 'UpdateAxis',
% %         
% %         makeVisible([handles.SliderValue,handles.BinWidth]);
% %         makeInvisible([handles.SetAxisVariables]);
%         
%     case 'UpdateCell',
% 
% %                 makeInvisible([handles.SliderValue,handles.BinWidth,handles.SetAxisVariables]);
% 
%     case 'MakePlot',
% 
% Plotters=get(handles.PlottingFileList,'String');
% CurPlotter=Plotters{get(handles.PlottingFileList,'value')};
% 
% switch(CurPlotter),
%     case{'DrawPSTH.m','SpikeDensity.m'},
%         
% %         makeVisible([handles.SliderValue,handles.BinWidth]);
% %         makeInvisible([handles.SetAxisVariables]);
% 
%         
%     case {'DrawTuningCurve.m','AngularTuningCurve.m','PlotRFMap.m'}
% %                 makeInvisible([handles.SliderValue,handles.BinWidth]);
% %         makeVisible([handles.SetAxisVariables]);
%                 
%     case {'DrawRasters.m','ISIH.m'},
% %         makeInvisible([handles.SetAxisVariables, handles.SliderValue,handles.BinWidth]);
        
    case 'MakeHist.m',
% %         makeVisible([handles.text70,handles.VariablesList,handles.UnBut]);
% %         makeInvisible([handles.SetAxisVariables, handles.SliderValue,handles.BinWidth]);
%         
% %         CurVariables=cellstr(get(handles.XAxisVariable,'string'));
% %         if ~isempty(CurVariables{1})
% %         CurVariable=CurVariables{get(handles.XAxisVariable,'value')};
% %         else CurVariable='';
% %         end
%         
%  
% AnalLoadedFileScript;
% 
% % if ~strcmp(CurrentDataFile,'LoadedFiles')
% % 
% % eval(['Trials=handles.' CurrentDataFile '.Trials;']);
% % eval(['if ~isfield(handles.' CurrentDataFile ',''Analysis''), fprintf(''%s\n'',''Analyze your dataset first''); GoOn=0;else GoOn=1;end']);
% % eval(['if GoOn==1, MyVariableList=handles.' CurrentDataFile '.Analysis.MyVariableList;end']);
% % 
% % if ~iscell(MyVariableList), TemporaryVariable{1}=MyVariableList; MyVariableList=TemporaryVariable; clear TemporaryVariable; end
% % 
% % SetVariablesScript;
% % 
% % % if ~isempty(CurVariable),
% % % 
% % %     CorrectValue=find(strcmp(MyVariableList,CurVariable));
% % %     
% % %     if ~isempty(CorrectValue)
% % % set(handles.XAxisVariable,'string',MyVariableList,'value',CorrectValue(1));
% % % set(handles.X1AxisVariable,'string',MyVariableList,'value',CorrectValue(1));
% % %     else
% % % set(handles.XAxisVariable,'string',MyVariableList,'value',1);
% % % set(handles.X1AxisVariable,'string',MyVariableList,'value',1);
% % %     end
% % %     
% % % else
% % % set(handles.XAxisVariable,'string',MyVariableList,'value',1);
% % % set(handles.X1AxisVariable,'string',MyVariableList,'value',1);
% % % end
% % 
% % end
        
set(handles.BinWidth,'value',100);
% set(handles.UpdateSlider,'value',5);
% set(handles.SliderText,'string','SV=5');

%     case 'DrawKDE.m',
% 
% %         makeVisible([handles.text70,handles.VariablesList,handles.UnBut]);
% %         makeInvisible([handles.SetAxisVariables, handles.SliderValue,handles.BinWidth]);
%         
% 
% AnalLoadedFileScript;
% 
 
end
end