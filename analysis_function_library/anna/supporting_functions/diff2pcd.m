function xdot = diff2pcd(x, sep)
% Two-Point Central Difference Derivative
% xdot = diff2pcd(x, separation)
%

% GET DERIVATIVE
% 2 point central difference, separation = 2 * sep = (1, 2, 3, etc.)
xdot = zeros(size(x));
a = sep + 1;
b = length(x) - sep;
n = a:b;
xdot(n) = (x(n+sep) - x(n-sep)) / (2 * sep);
r = 1:a;
xdot(r) = xdot(a) * ones(size(r));
r = b:length(x(:,1));
xdot(r) = xdot(b) * ones(size(r))';

xdot = 1000 * xdot;	% samples in msec
