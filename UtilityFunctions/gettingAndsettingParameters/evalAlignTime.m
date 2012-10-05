if exist(CurrentAlignString,'var')
eval(['CurrentAlignTime=' CurrentAlignString ';']);
else
    fprintf('%s\n','"That AlignTime doesnt exist. Am trying to use FP instead" - EvalAlignTime');
eval(['CurrentAlignTime=FPOnTime;']);
    end