   %A little scriplet that does   
   %a little fiddling to take care of occasions where rex doenst drop an arrya code. details.
    % Verify this IMP
    
    TemporaryArrayNumber=find(CurrentCodes>=2000&CurrentCodes<=2060);
    if ~isempty(TemporaryArrayNumber)
        if length(TemporaryArrayNumber)==1 ArrayNumber(TrialIndex)=CurrentCodes(TemporaryArrayNumber)-2000; ArrayBak=[];
        elseif length(TemporaryArrayNumber)==2 ArrayNumber(TrialIndex)=CurrentCodes(TemporaryArrayNumber(1))-2000; ArrayBak=CurrentCodes(TemporaryArrayNumber(2))-2000;
        else ArrayNumber(TrialIndex)=-1; ArrayBak=[];
        end
    elseif ~isempty(ArrayBak) ArrayNumber(TrialIndex)=ArrayBak; ArrayBak=[];
    end