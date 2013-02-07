function spikesg=sdf(sigma,sfreq,spikes)
% sdf.m convolves a gaussian with spikes, outputs Spike Density Functions
% - sigma is the stdev of the gaussian

% - sfreq is the frequency of the events in 'spikes'. Usually 1msec

% - spikes must be in the form of a histogram. To have no edge effects you really

%			want a bin size of 1msec.
%
%	can also do a bunch of traces at one time, as long as it's a trace
%		a column

%
% Jay Edelman

% Nicholas Port  09/22/99

% JB				07/21/00


if nargin < 3,
	disp('usage:  spikesg=sdf(sigma,sfreq,spikes);')
	return
end

if sigma == 0
	spikesg = spikes;
	return
end

onerow = 0;

if size(spikes,1) == 1
	spikes = spikes';
	onerow = 1;
end


dt=1000/sfreq;
sigma=sigma/dt;

dist=(-(sigma*7):(sigma*7))';
gaus=1/(sigma*sqrt(2*pi))*exp(-((dist.^2)/(2*sigma^2)));
spikesg=conv2(spikes,gaus,'same');


%spikesg=spikesg(sigma*7+1:length(spikes)+(sigma*7));

if onerow
	spikesg = spikesg';
end

