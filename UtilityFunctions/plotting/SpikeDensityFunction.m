function [spikesOut,spikeSD,gaus]=SpikeDensityFunction(spikesIn,sigma,binwidth,errtype)

% 	SpikeDensityFunction.m convolves a gaussian with spikes, outputs Spike Density Functions
% 	- sigma is the stdev of the gaussian
%	Each trial is a row
% 	[spikesOut,spikeSD,gaus]=SpikeDensityFunction(spikesIn,sigma,binwidth,errtype)

% originally: Jay Edelman, followed by Nicholas Port (9/22/99) and JWB
% (7/21/00)
%SE code from chronux's PSTH function
%Various other modifications for data formatting purposes.

% keyboard;

if ~exist('sigma','var'), sigma=50;end
if ~exist('binwidth','var'), binwidth=1;end
NumberOfBootSamples=40;

spikes=spikesIn;  %converting to column format; each trial in one column; time in a row.  No, no need. No practical advantage to columns, though people claim there is.

if size(spikes,1)>size(spikes,2), fprintf('%s\n','More trials than time bins. Sure ?'); end

sigma=sigma/binwidth;

dist=(-(sigma*3):(sigma*3));  % Increased to 10 from 7, just because - BSK November 7 2005; no suffer from edge effects then. not so long
                                                %now with 5 ms smoothing,
                                                %lose 30 ms total only
gaus=1/(sigma*sqrt(2*pi))*exp(-((dist.^2)/(2*sigma^2)));
%  keyboard;
spikes=conv2(spikes,gaus);             %conv2C is luigi rossa's conv2olam from matlab central, 
                                                           % uses overlap add ffts. conv2B and conv2A suck.
                                                           %remember to extract the valid points out of this in plotpstd. conv2 is unpredictable: sometimes lightning, other times, seconds !! conv2C is more predictable.
                                                           %aaaargh. but it gets confused when there are NaNs. back to conv2
                                                           
spikesOut=nanmean(spikes) * 1000 / binwidth;  %mean PSTH in correct units

spikesOut=spikesOut+1e-10; %to remove tiny 1e-15 order negative values produced by conv2C


if ~exist('errtype','var') || errtype==1
%    std dev is sqrt(rate*(integral over kernal^2)/trials)     
%    for Gaussian integral over Kernal^2 is 1/(2*sig*srqt(pi))
%we should get the integral numerically and use that.
% so variance is sqrt ( rate * integral_of_kernelsquared ) / sqrt
% (numtrials)

%   poissSD= sqrt(spikesOut/(2*size(spikesOut,2)*sigma*sqrt(pi)));
nantester=spikes;
nantester(~isnan(nantester))=1;
summat=nansum(nantester);
summat(summat==0)=nan;

% poissSD=sqrt(spikesOut *  ( trapz(gaus.^2)  * 1000 / binwidth ) / size(spikes,1) );
poissSD=sqrt(spikesOut *  ( trapz(gaus.^2)  * 1000 / binwidth ) ./ summat  );
spikeSD=poissSD;
% if any(find(isnan(spikes))), keyboard;end

else
    %bootstrp takes in data with each row being one instance; so here each trial is a row.
    %then simply compute mean... this gives you a vector for that sample
    %each row will then contain the trial psth effectively
    %just calculate variance in one go at the end and include it
    %interestingly can compare mean to bootstrap mean; there should be no
    %bias :) or does boot show bias ?
    

BootMat=bootstrp(NumberOfBootSamples,'nanmean',spikes);
  bootSD=nanstd(BootMat);
  spikeSD=bootSD*1000/binwidth;  % also converted to right units now
end

% keyboard;    
