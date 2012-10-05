
% 	This script sets NextMarker and NextMarkerEvalString
% 	Also sets the LocalEvalString, which is then appended in the calling script to the EvalString for future use

if CurrentUseProps==1, 
  
NStr=num2str(CurrentAxis);

LocalEvalString=[...
    'NextMarker=Axis' NStr 'Markers((2*Axis' NStr 'MarkerPointer+1):(2*Axis' NStr 'MarkerPointer+2));'...
    'Axis' NStr 'MarkerPointer=Axis' NStr 'MarkerPointer+1;'...
    'if Axis' NStr 'MarkerPointer>(length(Axis' NStr 'Markers)/2 - 1), Axis' NStr 'MarkerPointer=0;end'...
    ];
        
    eval(LocalEvalString);
    
   
else
 NextMarker='';
end

 NextMarkerEvalString=[...
     'set(TemporaryHandle,''color'',NextMarker(1),''linestyle'',NextMarker(2));'...
    ];