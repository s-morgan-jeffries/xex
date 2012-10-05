HOLD ON
ALIGN SAC1
CB ON
PLOTTYPE PSTH
ALIGN RF1
WINDOW 4:1:10
XAXISVAR ArrayNumber
XAXISDISCRETIZE ON
XAXISCENTERS 1:10:22

% %BASIC
% PLOTTYPE PSTH
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1
% TITLE Targ in to/away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1
% TITLE Dist in to/away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1
% TITLE To;  targ/dist in
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1
% TITLE Away;  targ/dist in


% % *****************************T-type (!!!)
% PLOTTYPE PSTH
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==28
% % GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1
% TITLE up-T, down-T in RF, sac to
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==28
% TITLE distractor in RF, sac to, up-T/down-T out
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==28
% % GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1
% TITLE up-T, down-T in RF, sac away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==28
% TITLE distractor in RF, sac away, up-T/down-T out


% % 
% % %*********Latency effects
% PLOTTYPE PSTH
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat<250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat>250
% TITLE distractor in RF, sac to, short long lat
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&FirstSacLat<250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&FirstSacLat>250
% TITLE distractor in RF, sac away, short long lat
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&FirstSacLat<250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&FirstSacLat>250
% TITLE target in RF, sac to, short long lat
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&FirstSacLat<250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&FirstSacLat>250
% TITLE target in RF, sac away, short long lat
% NEWAXIS

% %*************KEY SECTION
% RUN tempfilt=GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1;
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat<nanmean(FirstSacLat(tempfilt))
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat>=nanmean(FirstSacLat(tempfilt))
% TITLE t2,ta,da,d2s,d2l: upT
% NEWAXIS
% ALIGN SAC1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat<nanmean(FirstSacLat(tempfilt))
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat>=nanmean(FirstSacLat(tempfilt))
% TITLE t2,ta,da,d2s,d2l: upT: sac

% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat<250&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&FirstSacLat>250&TargPat==28
% TITLE t2,ta,da,d2s,d2l downT

% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==29&FirstSacLat<=250
% TITLE short latency: correct to vs. wrong away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29&FirstSacLat<=250
% TITLE short latency: wrong to. vs. correct away
% NEWAXIS
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==29&FirstSacLat>300
% TITLE long latency: correct to vs. wrong away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==29&FirstSacLat>250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29&FirstSacLat>250
% TITLE long latency: wrong to. vs. correct away


% %******************Latency separated***************************
% % Early latencies: to vs. away, correct vs. wrong
% % Late latencies: to  vs. away, correct vs. wrong
% %THESE are both pooled versions
% 
% % RUN tempfilt=GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29;
% 
% ALIGN RF1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==2&FSAtTarg~=1)|(WhatInRF==3&FSAtTarg==1))&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==2&FSAtTarg==1)|(WhatInRF==3&FSAtTarg~=1))&TargPat==29&FirstSacLat<=250
% TITLE short latency: to vs. away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==3&FSAtTarg==1)|(WhatInRF==2&FSAtTarg~=1))&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==3&FSAtTarg~=1)|(WhatInRF==2&FSAtTarg==1))&TargPat==29&FirstSacLat<=250
% TITLE short latency good vs. bad
% NEWAXIS
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==2&FSAtTarg~=1)|(WhatInRF==3&FSAtTarg==1))&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==2&FSAtTarg==1)|(WhatInRF==3&FSAtTarg~=1))&TargPat==29&FirstSacLat<=250
% TITLE long latency: to vs. away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==3&FSAtTarg==1)|(WhatInRF==2&FSAtTarg~=1))&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&((WhatInRF==3&FSAtTarg~=1)|(WhatInRF==2&FSAtTarg==1))&TargPat==29&FirstSacLat<=250
% TITLE long latency good vs. bad

%******************Latency separated***************************
% Early latencies: to vs. away, correct vs. wrong
% Late latencies: to  vs. away, correct vs. wrong
%THESE are both pooled versions

% RUN tempfilt=GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29;

% ALIGN RF1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==29&FirstSacLat<=250
% TITLE short latency: correct to vs. wrong away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==29&FirstSacLat<=250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29&FirstSacLat<=250
% TITLE short latency: wrong to. vs. correct away
% NEWAXIS
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==29&FirstSacLat>250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==29&FirstSacLat>250
% TITLE long latency: correct to vs. wrong away
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==29&FirstSacLat>250
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29&FirstSacLat>250
% TITLE long latency: wrong to. vs. correct away




% %********************Up-T trials and down-T trials separately***********************************
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==29
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==29
% TITLE Up-T trials, D2, T2, Da, Ta
% NEWAXIS
% NEWAXIS
% NEWAXIS
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg~=1&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&TargPat==28
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg~=1&TargPat==28
% TITLE Down-T trials, D2, T2, Da, Ta
% 
% PLOTTYPE HIST
% YVAR FirstSacLat
% HOLD ON
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&TargPat==29&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&TargPat==28&FSAtTarg==1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&TargPat==29&FSAtTarg~=1
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&TargPat==28&FSAtTarg~=1
% TITLE Ut2,Dt2,Uta,Dta

% % NO GOOD: could not find effect where correct away was higher than correct
% % to
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==3&FSAtTarg==1&FirstSacLat>300
% GoodTrial==1&PhotoBad~=1&TrialNumber>100&TrialNumber<1100&WhatInRF==2&FSAtTarg==1&FirstSacLat>300
% TITLE long latency: correct to vs. correct away
