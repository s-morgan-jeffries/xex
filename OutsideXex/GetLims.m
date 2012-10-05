function [NewXLim, NewYLim]= GetLims(Xlimit, Ylimit, XVector, YVector)

NewXLim(1)=nanmin([Xlimit(1) XVector]);
NewYLim(1)=nanmin([Ylimit(1) YVector]);

NewXLim(2)=nanmax([Xlimit(2) XVector]);
NewYLim(2)=nanmax([Ylimit(2) YVector]);
