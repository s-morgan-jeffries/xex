CurXVariables=cellstr(get(handles.XAxisVariable,'string'));
        if ~isempty(CurXVariables{1})
        CurXVariable=CurXVariables{get(handles.XAxisVariable,'value')};
        else CurXVariable='';
        end
        
                        CurX1Variables=cellstr(get(handles.X1AxisVariable,'string'));
        if ~isempty(CurX1Variables{1})
        CurX1Variable=CurX1Variables{get(handles.X1AxisVariable,'value')};
        else CurX1Variable='';
        end
        
                        CurYVariables=cellstr(get(handles.YAxisVariable,'string'));
        if ~isempty(CurYVariables{1})
        CurYVariable=CurYVariables{get(handles.YAxisVariable,'value')};
        else CurYVariable='';
        end

        
        if ~isempty(CurXVariable),

    CorrectValue=find(strcmp(MyVariableList,CurXVariable));
    
    if ~isempty(CorrectValue)
set(handles.XAxisVariable,'string',MyVariableList,'value',CorrectValue(1));
    else
        NewCorrectValue=find(strcmp(MyVariableList,'RFx'));
        if ~isempty(NewCorrectValue)
            set(handles.XAxisVariable,'string',MyVariableList,'value',NewCorrectValue(1));
        else
            set(handles.XAxisVariable,'string',MyVariableList,'value',1);
        end
    end
else
set(handles.XAxisVariable,'string',MyVariableList,'value',1);
end


if ~isempty(CurX1Variable),

    CorrectValue=find(strcmp(MyVariableList,CurX1Variable));
    
    if ~isempty(CorrectValue)
set(handles.X1AxisVariable,'string',MyVariableList,'value',CorrectValue(1));
    else
        NewCorrectValue=find(strcmp(MyVariableList,'RFy'));
        if ~isempty(NewCorrectValue)
            set(handles.X1AxisVariable,'string',MyVariableList,'value',NewCorrectValue(1));
        else
            set(handles.X1AxisVariable,'string',MyVariableList,'value',1);
        end
    end
else
set(handles.X1AxisVariable,'string',MyVariableList,'value',1);
end


if ~isempty(CurYVariable),

    CorrectValue=find(strcmp(MyVariableList,CurYVariable));
    
    if ~isempty(CorrectValue)
set(handles.YAxisVariable,'string',{'SpikeRate',MyVariableList{:}},'value',CorrectValue(1)+1);
    else
            set(handles.YAxisVariable,'string',{'SpikeRate' ,MyVariableList{:}},'value',1);
    end
else
set(handles.YAxisVariable,'string',{'SpikeRate',MyVariableList{:}},'value',1);
end


