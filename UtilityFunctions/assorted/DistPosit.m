function [Dx,Dy]=DistPosit(Sx,Sy,Distance)

%function to position distractor, given distance from saccade target, at
%same eccentricity
%function [Dx,Dy]=DistPosit(Sx,Sy,Distance)

Ecc=sqrt(SX.^2+Sy.^2);

Theta=acos(1-(Distance/(2*Ecc^2)));


