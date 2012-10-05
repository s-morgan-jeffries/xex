function Myregstruct=myregress(x,y)

%regresses y=mx+c
%x and y are row vectors

if size(x,1)<size(x,2) & size(x,1)==1, x=x'; end
if size(y,1)<size(y,2) & size(y,1)==1, y=y'; end

[a,b,c,d,e]=regress(y,[x ones(length(x),1)]);

Myregstruct.co=a;
Myregstruct.coci=b;
Myregstruct.res=c;
Myregstruct.resci=d;
Myregstruct.stats=e;