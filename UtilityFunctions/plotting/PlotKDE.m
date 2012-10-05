
%	Script that plots kernel density estimates
%	Requires connection to R etc.

    FilterHere=1;
    TotalFilter=FilterHere&CurrentFilterVector;
    
    eval(['CurrentSelectedVals=' CurrentSelectedVariable ';']);
    if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentSelectedVals)));end;
   
    CurrentAlpha=((CurrentSliderValue+5)*10-rem( (CurrentSliderValue+5)*10,5))/100;
%     fprintf('Smoothing alpha is %2.2f\n',CurrentAlpha);
    set(handles.SliderValue,'string',['alpha=' num2str(CurrentAlpha,'%2.2f\n')]);
    PlotY=CurrentSelectedVals(TotalFilter);
%     keyboard;
    [PlotXVector,xsmooth,upC,lowC]=Rkde(PlotY,PlotXVector,CurrentAlpha,'locfit');
    TemporaryHandle=plot(PlotXVector,xsmooth,'k-');
    
    if CurrentPlotCB==1,
        hold on;
    TemporaryHandle(2)=plot(PlotXVector,upC,'k-');
        TemporaryHandle(3)=plot(PlotXVector,lowC,'k-');
end    

    
    %also need to use default slider intelligently, and not mess with stim
    %vector if it is kde. Bas.
    
    fprintf('%s\n',[num2str(length(find(TotalFilter))) ' Trials']);
     
    set(gca,'box','off','tickdir','out','xlim',[min(XVector) max(PlotXVector)]);
    set(TemporaryHandle(1),'linewidth',2);