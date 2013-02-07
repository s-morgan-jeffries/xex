function [lat, dur, plat, vpeak, ei, ef, amp] = saclat(eye)
%function [lat, dur, plat, vpeak, ei, ef, amp] = saclat(eye, iTarg) - old
% [lat, dur, plat, vpeak, ei, ef, amp] = saclat(eye, iTarg)
% Assumes eye trace is sampled at 1 KHz
% returns latency to first saccade,
% latency to peak velocity, and peak velocity
%
% Additional tests allow the user to set minimum and maximum
% acceptable latency values, and minimum and maximum
% acceptable eye velocities (in deg/sec).
% 
% A saccade defined as:
%	peak velocity is in range = [minpeak, maxpeak]
%   
% inputs:
%  eye = eye trace, sampled at 1KHz
%  iTarg = target table index
% outputs:
%  lat = latency in msec (relative to start of eye)
%  dur = saccadic duration
%  plat = latency to peak velocity
%  vpeak = peak velocity
%  ei = initial eye position
%  ef = final eye position
%  amp = saccade amplitude
%
% 12dec99 LMO
%

%global targetTable

if nargin < 1
   disp('[lat, dur, plat, vpeak, ei, ef, amp] = saclat(eye);');
   return;
end

debug = 0;
doplot = 0;

minlat = 0;	% no saccades earlier than this!
minamp = 1.5;	% smallest saccade
minpeak = 10;	% minimum acceptable saccadic velocity
maxpeak = 1200;	% maximum acceptable saccadic velocity
mindur = 8;	% minimum acceptable saccadic duration
maxdur = 150;	% maximum acceptable saccadic duration
minvel = 15;	% minimum velocity for saccade onset
pkfrac = 0.15;	% percent of peak for saccade offset

if (length(eye) < mindur)
	lat = 0;
	dur = 0;
	plat = 0;
	vpeak = 0;
	ei = 0;
	ef = 0;
	amp = 0;
	return;
end

% get velocity
eyedot = diff2pcd(eye, 2);

% determine velocity threshold
aedot = abs(eyedot);
j = find(aedot < 50);
minvel = max(minvel, 2*std(aedot(j)));
clear aedot;

% get all velocity peaks
% [lows highs] = findPeaks(eyedot, 10, 10);
[lows highs] = findpeaks(eyedot, 10, 10);
minvel = 10;

% FIND STARTING POINT FOR SACCADE
%
n = length(lows);
if (n == 0)
	lat = 0;
	dur = 0;
	plat = 0;
	vpeak = 0;
	ei = 0;
	ef = 0;
	amp = 0;
	if (debug)
		disp('N = 0');
	end
	return;
end

for i = 1:n
	peaktime = 0;
	latency = 0;
	vpeak = 0;

	lo = lows(i);
	hi = highs(i);
	ed = eyedot(lo:hi);

	% which direction?
	negv = min(ed);
	posv = max(ed);
	if (abs(negv) > abs(posv))
		sacneg = 1;
		eye = -eye;	% reverse
		eyedot = -eyedot;
		ed = eyedot(lo:hi);
	else
		sacneg = 0;
	end
	
	% set thresholds
	thv = minvel;
	ith = find(ed >= thv);

	if (length(ith))
		crossthresh = ith(1);
	else
		crossthresh = 1;
	end
	latency = crossthresh + lo -1;
	ei = eye(latency);
	
	% find crossing above threshold
	jstrt = crossthresh;
	jend = length(ed);
	ith = find(ed(jstrt:jend) >= thv);
	if (length(ith) == 0)
		lat = 0;
		dur = 0;
		plat = 0;
		vpeak = 0;
		ei = 0;
		ef = 0;
		amp = 0;
		if (debug)
			disp(['Never crossed thv = ', num2str(thv)]);
		end
	else
		jstrt = ith(1) + jstrt - 1;
		
		% find crossing below threshold
		[mx, imx] = max(ed([jstrt:jend]));
		thvlo = pkfrac * mx;

		a = jstrt + imx - 1;
		ith = find(ed(a:jend) < thvlo);

		if (length(ith))
			dur = ith(1) + imx - 1;
		else
			dur = 0;
		end
		if (dur == 0)
			dur = jend - jstrt;
		end
		jend = dur + jstrt;
		ef = eye(latency+dur);

		[mx, imx] = max(eyedot([jstrt:jend]+lo));
		if (length(imx))
			peaktime = imx(1) + jstrt - 1 + lo;
			vpeak = eyedot(peaktime);
		else
			peaktime = 0;
			vpeak = 0;
		end

		amp = abs(ef - ei);

		if (peaktime & (latency > minlat) & (dur >= mindur) & (dur <= maxdur) & (abs(amp) >= minamp))
			break;
		else
			if (debug)
				disp(sprintf('FAIL:  length(imx) = %d, lat = %d,  peaktime = %d, dur = %f, amp = %f', length(imx),latency, peaktime, dur, amp));
				disp(sprintf('minlat = %d, mindur = %d, maxdur = %d, minamp = %d', minlat, mindur, maxdur, minamp));
			end
			% if get to here, clear values so when fall through, they will be zero
			lat = 0;
			dur = 0;
			plat = 0;
			vpeak = 0;
			ei = 0;
			ef = 0;
			amp = 0;
		end
	end
end

% convert to output args
if (sacneg)
	vpeak = -vpeak;
end
plat = peaktime - 1;
lat = latency - 1;
if (debug)
disp(sprintf('saclat: lat = %d, dur = %d, amp = %d, vpeak: %f @ %d\n', lat, dur, amp, vpeak, peaktime));
end

% Plotting stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if (doplot)
figure(2);
	if (sacneg)
		eye = -eye;
		eyedot = -eyedot;
	end
%	hold off
	% PLOT EYE & Eyedot
	plot(eye);
	hold on;
%	plot(eyedot/10, ':');
	ax = axis;

	% draw target line
%	ampt = targetTable(iTarg, 2);
%	angt = targetTable(iTarg, 3) * pi / 180;
%	xt = ampt * cos(angt);
%	yt = ampt * sin(angt);
%[ampt, angt, xt, yt]
%	targvec = sqrt(xt.^2 + yt.^2);	
%	h = plot(ax(1:2), [1, 1].*targvec, 'g:');
%	set(h, 'linewidth', 3);

	% PLOT RED VERTICAL LINE AT LATENCY
	h = plot([latency latency], [ax(3) ax(4)], 'r');
	set(h, 'linewidth', 2);
	
	% PLOT A GREEN VERTICAL LINE AT PEAKTIME
%	h = plot([peaktime, peaktime], [ax(3), ax(4)], 'g');
	
	% plot duration line
	h = plot((latency+dur)* [1 1], [ax(3), ax(4)], 'r--');
	
	% PLOT THRESHOLD LINE
%	plot([ax(1), ax(2)], [thv, thv]/10, 'c');

	%str = sprintf('Tamp = %d: Tvec = %3.1f, Lat = %3.1f, dur = %3.1f,  amp = %3.1f peaktime = %3.1f, vpeak = %3.1f ', targetTable(iTarg, 2),targvec, latency, dur, amp, peaktime, vpeak);
	h = text(ax(1) + 0.025 * (ax(2) - ax(1)), ax(4) - 0.15 * (ax(4) - ax(3)), str);
	set(h, 'fontsize', 8);
	
	title('Eye & Eyedot');
	drawnow;
	hold off;
%figure(1);
	pause(2);
end
