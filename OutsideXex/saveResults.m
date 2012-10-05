%go to the directory of itnerest (cd)
%Trials=doMrdd('z051125c11lm1',0);
%CurrentVariables=Preproc(Trials,'LineMotion');
%cd MyLmAnalyses
%save z051124c11lm1Results CurrentVariables Trials
function saveResults(FileList, FindDir, SaveDir, PreProcType, FileTag)

for i=1:length(FileList)
cd FindDir
Trials=doMrdd(num2str(FileList(i)),0);
CurrentVarialbe=Preproc(Trials,num2str(PreProcType));
cd SaveDir
save 'num2str(FileList(i))num2str(FileTag)' CurrentVariables Trials
end