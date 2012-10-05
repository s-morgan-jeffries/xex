
RUN  tempfilt = RFx==10;    % Runs everything that follows the RUN command.

NEWAXIS;    % goes to next axis from axis list

XLABEL myxlabel
YLABEL myylabel
XLIM   100 300
YLIM    10 20
TITLE    myplot

HOLD ON               %sets hold to on

CLEAR ALL             % clears 'em all
CLEAR 1 2              % clears axes 1 and 2

CIRCLEGRAPH ON
CIRCLEGRAPH OFF

COLORS ON          %sets use colors to on

YVAR  FirstSacLat   % sets Y variable in List of Variables; useful for hist, dischist, etc.

CB ON

ALIGN RF1
ALIGN SAC1

PLOTTYPE IMAGE
PLOTTYPE CIRCLE  % OTHER OPTIONS ARE: SPIKEDENSITY, TUNINGCURVE, ANGULAR, HIST, DISCHIST, PSTH, RASTER, ISI, KDE. Default is PSTH

WINDOW 100 300
WINDOW 10:10:100   % sets the time window value

BINWIDTH 10    %anything beteween 0 and 100

XAXISVAR                   % SETTING AXIS VARIABLES FOR THINGS LIKE TUNINGCURVE AND IMAGEMAP
XAXISDISCRETIZE
XAXISCENTERS
X1AXISVAR
X1AXISDISCRETIZE
X1AXISCENTERS
YAXISVAR

%Filter statement runs the appropriate plotting file

GoodTrial==1&PhotoBad~=1