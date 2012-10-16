function handles = SetVariables(handles, CurrentDataFile)
		
	% Trials = handles.(CurrentDataFile).Trials;
	% if isfield(handles.(CurrentDataFile),'Analysis')
	% 	% GoOn=1;
	% 	MyVariableList=handles.(CurrentDataFile).Analysis.MyVariableList;
	% else
	% 	disp('Analyze your dataset first');
	% 	% GoOn=0;
	% end
	% % if GoOn==1
	% % 	MyVariableList=handles.(CurrentDataFile).Analysis.MyVariableList;
	% % end
	
	% MyVariableList=handles.(CurrentDataFile).Analysis.MyVariableList;
	% if ~iscell(MyVariableList)
	% 	% TemporaryVariable{1}=MyVariableList;
	% 	% MyVariableList=TemporaryVariable;
	% 	% clear TemporaryVariable;
	% 	MyVariableList = {MyVariableList};
	% end
	
	
	VarField = 'XAxisVariable';
	DefaultValueName = 'RFx';
	handles = SetVarValue(handles, CurrentDataFile, VarField, DefaultValueName);
	
	VarField = 'X1AxisVariable';
	DefaultValueName = 'RFy';
	handles = SetVarValue(handles, CurrentDataFile, VarField, DefaultValueName);
	
	VarField = 'YAxisVariable';
	DefaultValueName = '';
	handles = SetVarValue(handles, CurrentDataFile, VarField, DefaultValueName);
	
	% CurVariables=cellstr(get(handles.(VarField),'string'));
	% if ~isempty(CurVariables{1})
	% 	CurVariable=CurVariables{get(handles.(VarField),'value')};
	% else
	% 	CurVariable='';
	% end
	% if ~isempty(CurVariable)
	% 	CorrectValue=find(strcmp(MyVariableList,CurVariable));
	% 	if ~isempty(CorrectValue)
	% 		set(handles.(VarField),'string',MyVariableList,'value',CorrectValue(1));
	% 	else
	% 		NewCorrectValue=find(strcmp(MyVariableList, CorrectValueName));
	% 		if ~isempty(NewCorrectValue)
	% 			set(handles.(VarField),'string',MyVariableList,'value',NewCorrectValue(1));
	% 		else
	% 			set(handles.(VarField),'string',MyVariableList,'value',1);
	% 		end
	% 	end
	% else
	% 	set(handles.(VarField),'string',MyVariableList,'value',1);
	% end
	
	
	
	% % Get X axis variable names
	% CurXVariables=cellstr(get(handles.XAxisVariable,'string'));
	% if ~isempty(CurXVariables{1})
	% 	CurXVariable=CurXVariables{get(handles.XAxisVariable,'value')};
	% else
	% 	CurXVariable='';
	% end
	% if ~isempty(CurXVariable)
	% 	CorrectValue=find(strcmp(MyVariableList,CurXVariable));
	% 	if ~isempty(CorrectValue)
	% 		set(handles.XAxisVariable,'string',MyVariableList,'value',CorrectValue(1));
	% 	else
	% 		NewCorrectValue=find(strcmp(MyVariableList,'RFx'));
	% 		if ~isempty(NewCorrectValue)
	% 			set(handles.XAxisVariable,'string',MyVariableList,'value',NewCorrectValue(1));
	% 		else
	% 			set(handles.XAxisVariable,'string',MyVariableList,'value',1);
	% 		end
	% 	end
	% else
	% 	set(handles.XAxisVariable,'string',MyVariableList,'value',1);
	% end

	% CurX1Variables=cellstr(get(handles.X1AxisVariable,'string'));
	% if ~isempty(CurX1Variables{1})
	% 	CurX1Variable=CurX1Variables{get(handles.X1AxisVariable,'value')};
	% else
	% 	CurX1Variable='';
	% end
	% if ~isempty(CurX1Variable)
	% 	CorrectValue=find(strcmp(MyVariableList,CurX1Variable));
	% 	if ~isempty(CorrectValue)
	% 		set(handles.X1AxisVariable,'string',MyVariableList,'value',CorrectValue(1));
	% 	else
	% 		NewCorrectValue=find(strcmp(MyVariableList,'RFy'));
	% 		if ~isempty(NewCorrectValue)
	% 			set(handles.X1AxisVariable,'string',MyVariableList,'value',NewCorrectValue(1));
	% 		else
	% 			set(handles.X1AxisVariable,'string',MyVariableList,'value',1);
	% 		end
	% 	end
	% else
	% 	set(handles.X1AxisVariable,'string',MyVariableList,'value',1);
	% end

	% 
	% CurYVariables=cellstr(get(handles.YAxisVariable,'string'));
	% if ~isempty(CurYVariables{1})
	% 	CurYVariable=CurYVariables{get(handles.YAxisVariable,'value')};
	% else
	% 	CurYVariable='';
	% end
	% if ~isempty(CurYVariable)
	% 	CorrectValue=find(strcmp(MyVariableList,CurYVariable));
	% 	if ~isempty(CorrectValue)
	% 		set(handles.YAxisVariable,'string',{'SpikeRate',MyVariableList{:}},'value',CorrectValue(1)+1);
	% 	else
	% 		set(handles.YAxisVariable,'string',{'SpikeRate' ,MyVariableList{:}},'value',1);
	% 	end
	% else
	% 	set(handles.YAxisVariable,'string',{'SpikeRate',MyVariableList{:}},'value',1);
	% end
	
end

function handles = SetVarValue(handles, CurrentDataFile, VarField, DefaultValueName)
	
	MyVariableList=handles.(CurrentDataFile).Analysis.MyVariableList;
	if ~iscell(MyVariableList)
		MyVariableList = {MyVariableList};
	end
	
	CurVariables=cellstr(get(handles.(VarField),'string'));
	if ~isempty(CurVariables{1})
		CurVariable=CurVariables{get(handles.(VarField),'value')};
	else
		CurVariable='';
	end
	if ~isempty(CurVariable)
		CorrectValue=find(strcmp(MyVariableList,CurVariable));
		if isempty(CorrectValue)
			if exist('DefaultValueName', 'var')
				CorrectValue = find(strcmp(MyVariableList, DefaultValueName));
			end
			if isempty(CorrectValue)
				CorrectValue = 1;
			end
		end
	end	
	set(handles.(VarField),'string',MyVariableList,'value',CorrectValue(1));
	
end