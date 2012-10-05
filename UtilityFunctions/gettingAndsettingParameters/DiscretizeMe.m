
function DiscretizedX=DiscretizeMe(X,CenterVector)

%	this function takes in a vector and discretizes it, by finding the closest
%	point in the supplied centervector
%	DiscretizedX=DiscretizeMe(X,CenterVector)

FirstVector=CenterVector(1:(end-1));
SecondVector=CenterVector(2:end);
SpacingVector=SecondVector-FirstVector;
MarginVector=[FirstVector(1)-(SpacingVector(1)/2) FirstVector+(SpacingVector/2) SecondVector(end)+SpacingVector(end)/2];  %to supply to histc

 [Numberof,WhichBin] = histc(X,MarginVector);
 WhichBin(WhichBin==length(MarginVector))=length(MarginVector)-1;

 
 DiscretizedX=NaN*X;
 DiscretizedX(WhichBin~=0)=CenterVector(WhichBin(WhichBin~=0));