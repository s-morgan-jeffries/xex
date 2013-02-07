function [starts, stops] = findPeaks(signal, thresh, mindur)
% finds peaks in a signal
%       list = findPeaks(signal, thresh)
% where a peak is above thresh for mindur
% and the output is:
% starts = list of start indices
% stops = list of stop indices
%
% get the slope in steps of the index, ... 100 101 102 247 254 278 279 280 ...
% and detect the jump by more than one.

debug = 0;

ipos = find(signal > thresh);
ineg = find(signal < -thresh);
inum = union(ipos, ineg);

diff = zeros(size(inum));
diff(2:end) = inum(2:end) - inum(1:(end-1));
state = 0;	% state 0:  search for the first slope of 1
		% state 1:  search for the first slope != 1		
n = length(inum);
starts = [];
stops = [];
for i = 1:n
	if (state == 0)	% wait for first one
		if (diff(i) == 1)
			state = 1;
			start = inum(i);
		end
	elseif(state == 1)	% wait for a != 1 slope
		if (diff(i) ~= 1)
			stop = inum(i - 1);
			state = 0;
			if ((stop - start) > mindur)
				starts = [starts start];
				stops = [stops stop];
			end
		end
	end
end

if (state == 1)	% end of last one
	stop = inum(i - 1);
	state = 0;
	if ((stop - start) > mindur)
		starts = [starts start];
		stops = [stops stop];
	end
end

if (debug)
	figure(3);
	mn = min(signal);
	mx = max(signal);
	plot(signal);
	hold on;
	for i = 1:length(starts)
		h = plot([1 1]*starts(i), [mn mx], 'g');
		h = plot([1 1]*stops(i), [mn mx], 'r');
	end
	hold off;
	figure(1);
end
