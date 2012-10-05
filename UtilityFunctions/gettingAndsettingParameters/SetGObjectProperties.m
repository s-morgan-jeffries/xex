
% This script is used for setting GraphicsObjectProperties. Mainly calls MakeTempGraphix
  
NStr=num2str(CurrentAxis);

CurrentDisplayFilterString=CurrentFilterString;

MakeTempGraphix;
    
LocalEvalString=[...
    'if ~isfield(handles,''A' NStr '''), handles.A' NStr '(1)=TempGraphix;'...
    'else handles.A' NStr '(length(handles.A' NStr ')+1)=TempGraphix;end'...
    ];
       
    eval(LocalEvalString);
   