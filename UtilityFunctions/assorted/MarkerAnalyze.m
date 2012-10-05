
    
    UniqueMarkers=un(MarkerCode);


    for UniqueMarkind=1:length(UniqueMarkers)

        CurMark=UniqueMarkers(UniqueMarkind);

        NowTrials=MarkerCode==CurMark;
        MarkerTrialNumber(NowTrials)=1:length(find(NowTrials));

if length(un(MarkerCode))>1

    summaryString=  [summaryString sprintf('%s\n','******************Marker Analyze************************************************')];

summaryString=[summaryString sprintf('Unique Marker %s\n',[num2str([UniqueMarkers(UniqueMarkind)])])];
summaryString=[summaryString sprintf('%s\n',[num2str([un(BGLum(MarkerCode==CurMark)) un(TargCheck(MarkerCode==CurMark)) un(NumStim(MarkerCode==CurMark))])])];
summaryString=[summaryString sprintf('%s\n',[num2str([un(TargRed(MarkerCode==CurMark)) un(TargBlue(MarkerCode==CurMark)) un(TargGreen(MarkerCode==CurMark))])])]; 
summaryString=[summaryString sprintf('%s\n',[num2str([un(PopRed(MarkerCode==CurMark)) un(PopBlue(MarkerCode==CurMark)) un(PopGreen(MarkerCode==CurMark))])])]; 
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(MarkerCode==CurMark))) '  trials'])];
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(GoodTrial==1&MarkerCode==CurMark))) '  Good Trials'])];
summaryString=[summaryString sprintf('%s\n',[num2str(length(find(BadTrial==1&MarkerCode==CurMark))),'  Bad Trials'])];
 summaryString=[summaryString sprintf('%s\n','TargX   TargY')];
 summaryString=[summaryString,sprintf('%3.3f\t%3.3f\n',[un([TargX(MarkerCode==CurMark)' TargY(MarkerCode==CurMark)'])]')];
 summaryString=[summaryString sprintf('%s\n','PopX   PopY')];
 summaryString=[summaryString,sprintf('%3.3f\t%3.3f\n',[un([PopX(MarkerCode==CurMark)' PopY(MarkerCode==CurMark)'])]')];
%  summaryString=[summaryString,'\n',[num2str(un([PopX' PopY']))]];

summaryString=[summaryString,sprintf('%s percent sacs to target',num2str(100*(length(find(GoodTrial==1&PhotoBad~=1&FSTargOrdist<=1&NowTrials)))/length(find(GoodTrial==1&PhotoBad~=1&NowTrials))))];
summaryString=[summaryString,sprintf('%s\n','')];
summaryString=[summaryString,sprintf('%s percent sacs to pop',num2str(100*(length(find(GoodTrial==1&PhotoBad~=1&FSPopOrdist<=1&NowTrials)))/length(find(GoodTrial==1&PhotoBad~=1&NowTrials))))];
summaryString=[summaryString,sprintf('%s\n','')];

  summaryString=[summaryString sprintf('%s\n','******************************************************************')];
%  RFmat=[RFx;RFy]';
%  RFmat=RFmat(~isnan(RFmat(:,1)),:);
%  RFmat=unique(RFmat,'rows');
%  summaryString=[summaryString sprintf('%s\n','RFx        RFy')];
%  
%  for printIndex=1:size(RFmat,1)
%      summaryString=[summaryString sprintf('%3.1f\t%3.1f\t',RFmat(printIndex,1),RFmat(printIndex,2))];
%       summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
% summaryString=[summaryString sprintf('%s\t','T-trials  ')];
%  summaryString=[summaryString sprintf('%s\t',[num2str(100*(length(find(GoodTrial==1&RFPat==29&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==29&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
%   summaryString=[summaryString sprintf('%s\t','Inverted T trials')];
%  summaryString=[summaryString sprintf('%s\n ',[num2str(100*(length(find(GoodTrial==1&RFPat==28&RFx==RFmat(printIndex,1)&RFy==RFmat(printIndex,2)))) / length(find((GoodTrial==1|BadTrial==1) & RFPat==28&RFx==RFmat(printIndex,1) & RFy==RFmat(printIndex,2))) ,'%3.2f')  ' % correct'])];
% 
%  end

    end
end
