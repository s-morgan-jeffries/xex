%      Script to produce a rasterplot. Does the hard work by itself
%      Have an analysis file for rasterplot; plots rasters and PSTHs. Raster will normalize dot length by height and number of trials :)  
%      See also: SpikeDensity
%      DrawRasters



detachvars;
% SwitchAxes;
eval(['CurrentFilterVector=' CurrentFilterString ';']); %this does the current logical filter vector
setAlignTime;
evalAlignTime;

%     'SRMat=BinSpikes(Trials,find(TotalFilter),RFOnTime,XVector,613)*1000/CurrentBinWidth;'...

EvalString=[ ...
    'FilterHere=1;'...
    'NewXVector=XVector(1):1:XVector(end);'...
    'TotalFilter=FilterHere&CurrentFilterVector;'...  %advantage is current filter, current rf etc can either be obtained from A1 or from menu...depending on update parameters
    'if length(TotalFilter)==1, TotalFilter=logical(ones(1,length(CurrentAlignTime)));end;'...
    'SRMat=BinSpikes(Trials,RFTrialIndex(TotalFilter),CurrentAlignTime(TotalFilter),NewXVector, CurrentUnitNumber, CurrentAnalogCorrect);'...  %notice use of 1 for raster    
    'Ylimits=get(gca,''ylim''); Yrange=Ylimits(2)-Ylimits(1); Ymat=linspace(Ylimits(1)+Yrange/100,Ylimits(2),100)''*ones(1,length(NewXVector));'...
    'SRMat(SRMat==0)=nan; if size(SRMat,1)>=100, Ymat=Ymat.*SRMat(1:100,:); else Ymat=Ymat(1:size(SRMat,1),:).*SRMat;end;'...
    'TemporaryHandle=plot(NewXVector,Ymat,''k+'');'...
    'set(TemporaryHandle,''markersize'',1.5);'...
    'set(gca,''box'',''off'',''tickdir'',''out'');'...
    ];

NextMarkerSet;
if isempty(NextMarker), NextMarker='k-';end
EvalString=[EvalString NextMarkerEvalString];  %this makes sure the marker is attached
LocalMarkerString=NextMarker; 
eval(EvalString);
% keyboard;
CurrentPlotType='Raster';
SetGObjectProperties;
clearvars;

