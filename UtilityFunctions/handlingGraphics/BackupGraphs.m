
%	This script handles graph backup.
%	It is somewhat suspect at the moment (05/12/11)

TempGraphs=[];
for TempVar=1:(handles.NumberOfAxes)
    EvalString=[...
        'if isfield(handles,''A' num2str(TempVar) '''),TempGraphs.A' num2str(TempVar) '=handles.A' num2str(TempVar) ';end'...
        ];
    eval(EvalString);

%         EvalString=[...
%         'if isfield(handles,''A' num2str(TempVar) 'Annotations''),TempGraphs.A' num2str(TempVar) 'Annotations=handles.A' num2str(TempVar) 'Annotations;end'...
%         ];
%     eval(EvalString);


end

handles.OldGraphs=TempGraphs;
clear TempGraphs;
fprintf('%s\n','Backed up your graphs');
