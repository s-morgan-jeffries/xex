
%	Plots ISIs

    FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
        TemPlotX=(XVector(1)):1:(XVector(end));

    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;
    [isi1s,isi2s]=ISISpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),[TemPlotX], CurrentUnitNumber, CurrentAnalogCorrect );  %1ms binning
    
    if ReturnMap==0
        
        isis=isi1s;
  
    CurrentHistBinWidth=(CurrentSliderValue+5)*10+1;
    [NumberOfISIs,CenterISI]=hist(isis,0:CurrentHistBinWidth:(max(isis)+100));

    TemporaryHandle(1)=plot(CenterISI,NumberOfISIs,'k-'); hold on;
    fprintf('%s\n',['Histogram Binwidth was ' num2str(CurrentHistBinWidth) ' ms']);
            
    TempVar=find(NumberOfISIs==max(NumberOfISIs));
   fprintf('%s\n',['Histogram mode at ' num2str( CenterISI( TempVar(1)))  ' ms']);
   fprintf('%s\n',[ num2str(100* length(find(isis<2))/ (length(find(~isnan(isis)))) ,'%3.2f' )  ' percent at 1 ms']);
%    fprintf('%s\n',[num2str( length(find(isis==0))) ' at 0 ms !!!']);
   
    set(TemporaryHandle(1),'linewidth',2);
     set(gca,'box','off','tickdir','out','xlim',[min(XVector) max(PlotXVector)]);
 
    else 
        
       TemporaryHandle=plot(isi1s,isi2s,'ko');
       set(TemporaryHandle,'markersize',2);
       set(gca,'xlim',[0 100],'ylim',[0 100],'box','off','tickdir','out');
       
        
    end
    

