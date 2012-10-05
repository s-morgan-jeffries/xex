function Curvature=AnalyzeCurvature(eyex,eyey,startx,endx,starty,endy)

%function [MaxDeviation,InitialAngle]=AnalyzeCurvature(eyex,eyey,startx,endx,starty,endy)
%eyex and eyey are the trajectories of the saccade
%InitialAngle needs to be calculated over some initial say 5-10 ms
%Rotation is picked up from the 4-quadrant angle: +ve for clockwise
%rotation and negative for anticlockwise rotation

%find slope and intercept of saccade

if endx-startx ~= 0
    slopeValue=(endy-starty)/(endx-startx);
    interceptValue=starty-slopeValue*startx;
    AValue=-1*slopeValue;
    BValue=1;
    CValue=-1*interceptValue;
else
    BValue=0;
    AValue=1;
    CValue=-1*AValue*startx;
end

%find perpendicular distance of each point on trajectory to line

DistanceVector= sqrt( (AValue*eyex+BValue*eyey+CValue).^2 / (AValue^2+BValue^2) );
MaxDeviation=nanmax(DistanceVector);

%find angle for each point in trajectory after starting point, relative to
%starting point
%assumes that trajector at least 2 samples long; is fine

AngleVector=atan2(eyey(2:end)-eyey(1),eyex(2:end)-eyex(1));
AngleVector(AngleVector<0)=2*pi-AngleVector(AngleVector<0);

SaccadeAngle=atan2(endy-starty,endx-startx);
if SaccadeAngle<0, SaccadeAngle=2*pi-SaccadeAngle;end

RotationVector=SaccadeAngle-AngleVector;

if length(RotationVector)>=10 
    InitialAngle=nanmean(RotationVector(1:10)); 
else InitialAngle=nan; end

Rotation=nanmean(RotationVector);

Curvature=[MaxDeviation,InitialAngle,Rotation];