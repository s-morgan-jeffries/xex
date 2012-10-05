function [Cods,Tims]=getCodesAndTimes(Trials,trialnum)

%	A very useful function that returns codes and times, of course.
%	 [Cods,Tims]=getCodesAndTimes(Trials,trialnum)

%function [Cods,Tims]=getCodesAndTimes(Trials,trialnum)

CurrentEvents=Trials(trialnum).Events;
Cods=double([CurrentEvents.Code]);
Tims=double([CurrentEvents.Time]);