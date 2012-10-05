
%	This scriptlet is used in OneJump, for instance.
%	It sorts through a set of saccades and finds the intended saccade (TempSac) 
%	Also adds some extra fields to TempSac

    if ~isempty(find_the_sac)
        TempSac=SacStruct(find_the_sac(1));
        TempSac.rfdistance=EndAtRF(find_the_sac(1));
        TempSac.rf2distance=EndAtRF2(find_the_sac(1));
        TempSac.gaplatency=SacLat(find_the_sac(1))-GapTime(TrialIndex);
        TempSac.whichsac=find_the_sac(1);
        TempSac.angle=atan2(EndY(find_the_sac(1))-StartY(find_the_sac(1)),EndX(find_the_sac(1))-StartX(find_the_sac(1)));
    else
       TempSac=MakeSacStruct(2);
    end