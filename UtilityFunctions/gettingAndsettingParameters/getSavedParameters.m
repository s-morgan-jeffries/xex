
%	This scriptlet gets saved parameters from CurrentObjects(ObjectIndex).

      SavedDataFile=CurrentObjects(ObjectIndex).dataset;  
        SavedEvalString=CurrentObjects(ObjectIndex).evalstring;
        SavedHandle=CurrentObjects(ObjectIndex).handle;
        SavedMarkerString=CurrentObjects(ObjectIndex).markerstring;
   
        SavedBinWidth=CurrentObjects(ObjectIndex).binwidth;
        SavedStimVector=CurrentObjects(ObjectIndex).timevector;
%         SavedSacVector=CurrentObjects(ObjectIndex).sacvector;
        SavedFilter=CurrentObjects(ObjectIndex).trialfilter;
        SavedRF=CurrentObjects(ObjectIndex).rf;
        SavedTimeWindowVector=CurrentObjects(ObjectIndex).timewindowvector;
       
        SavedXAxisVariableStr=CurrentObjects(ObjectIndex).xaxisvariablestr;
        SavedXAxisDiscretize=CurrentObjects(ObjectIndex).discretizex;
        SavedXAxisCentersStr=CurrentObjects(ObjectIndex).xaxiscenters;
        SavedX1AxisVariableStr=CurrentObjects(ObjectIndex).x1axisvariablestr;
        SavedX1AxisDiscretize=CurrentObjects(ObjectIndex).discretizex1;
        SavedX1AxisCentersStr=CurrentObjects(ObjectIndex).x1axiscenters;
        SavedYAxisVariableStr=CurrentObjects(ObjectIndex).yaxisvariablestr;
         
        SavedAlignString=CurrentObjects(ObjectIndex).alignstring;
        SavedUnitNumber=CurrentObjects(ObjectIndex).unitnumber;
        SavedSliderValue=CurrentObjects(ObjectIndex).slidervalue;
        SavedPlotType=CurrentObjects(ObjectIndex).plottype;
        SavedVariable=CurrentObjects(ObjectIndex).currentvariable;
        SavedErrorBarType=CurrentObjects(ObjectIndex).errorbartype;
        SavedPValue=CurrentObjects(ObjectIndex).pvalue;