function y=inbetween(x,a,b,li,gi)

%   a simple function to do interval checking
%   li and gi should be variables that control <= or < for either side; for
%   now, they have not been coded in yet
%   function y=inbetween(x,a,b,li,gi)

y= x>=a & x<b;