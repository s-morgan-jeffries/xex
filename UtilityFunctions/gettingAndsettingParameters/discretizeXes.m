
if CurrentXAxisDiscretize==1 &&isempty(strfind(CurrentXAxisVariableStr,'Discretized'))
    NewXAxisVariableString=['Discretized' CurrentXAxisVariableStr];
    eval([NewXAxisVariableString '=DiscretizeMe(' CurrentXAxisVariableStr ',' num2str(CurrentXAxisCentersStr) ');']); %these num2strs are silly, i think they are being supplied strings to start with
    CurrentXAxisVariableStr=NewXAxisVariableString;
elseif CurrentXAxisDiscretize==1 && ~isempty(strfind(CurrentXAxisVariableStr,'Discretized'))
    eval([CurrentXAxisVariableStr '=DiscretizeMe(' CurrentXAxisVariableStr(12:end) ',[' num2str(CurrentXAxisCentersStr) ']);']);
    end

if CurrentX1AxisDiscretize==1&&isempty(strfind(CurrentX1AxisVariableStr,'Discretized'))
    NewX1AxisVariableString=['Discretized' CurrentX1AxisVariableStr];
    eval([NewX1AxisVariableString '=DiscretizeMe(' CurrentX1AxisVariableStr ',' num2str(CurrentX1AxisCentersStr) ');']);
    CurrentX1AxisVariableStr=NewX1AxisVariableString;
elseif CurrentX1AxisDiscretize==1 && ~isempty(strfind(CurrentX1AxisVariableStr,'Discretized'))
    eval([CurrentX1AxisVariableStr '=DiscretizeMe(' CurrentX1AxisVariableStr(12:end) ',' num2str(CurrentX1AxisCentersStr) ');']);
    end
