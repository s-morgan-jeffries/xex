/*
 *  NOTICE:  This code was developed by the Laboratory of
 *  Sensorimotor Research in the National Eye Institute,
 *  a branch of the U.S. Government.  This code is
 *  distributed without copyright restrictions.  No
 *  individual, company, organization, etc., may copyright
 *  this code.  If it is passed on to others, this notice
 *  must be included.
 *  
 *  Any Modifications to this code, especially bug fixes,
 *  should be reported to LOPTICAN@NIH.GOV.
 * 
 *  Lance M. Optican, Ph.D.
 *  Laboratory of Sensorimotor Research
 *  Bldg 49 Rm 2A50
 *  National Eye Institute, NIH
 *  9000 Rockville Pike, Bethesda, MD, 20892-4435
 *  (301) 496-9375.
 * 
 *  May 17, 1999
 *-----------------------------------------------------------------------*
 *
 *  REX2MATLAB.H
 *  This file contains header information for a C-program
 *	that converts REX A- and E-files into a format
 *	readable by MATLAB, using Matlab's MX library calls.
 *
 *	The MAT-file contains an array of structures (Trials).
 *	Each structure contains information about the trial,
 *	as well as arrays or cell arrays containing the data.
 *
 *	To include the names of all the structure elements for
 *	MX-programs, #define MATLAB_NAMES before the include
 *	for rex2matlab.h.  For example:
 *
 *		#define MATLAB_NAMES
 *		#include "rex2matlab.h"
 *		#include "mex.h"
 *
 * !!!	WARNING:  The structure elements are named for			!!!
 * !!!		matlab usage in mrdd3.c below in the MATLAB_NAMES	!!!
 * !!!		section.  ALWAYS CHANGE STRUCTURES			!!!
 * !!!		AND NAMES IN BOTH PLACES!!				!!!
 *
 * 10may1999	LMO & JWM	create
 * 12may1999	LMO		change from linked lists to arrays
 */

#ifndef _MRDR_H_
#define _MRDR_H_

#include <stdio.h>

int mEvent_number_of_elts = 2;
const char *mEvent_elts_names[] = {
	"Code",
	"Time"
};

int mUnits_number_of_elts = 2;
const char *mUnits_elts_names[] = {
	"Code",
	"Times"
};

int mSignal_number_of_elts = 2;
const char *mSignal_elts_names[] = {
	"Signal",
	"Name"
};

int mTrials_number_of_elts = 9;
const char *mTrials_elts_names[] = {
	"trialNumber",
	"tStartTime",
	"aStartTime",
	"aEndTime",
	"tEndTime",
	"a2dRate",
	"Signals",
	"Events",
	"Units",
};

typedef struct {
	short int Code;		/* event code */
	long int Time;		/* long time */
} mEvent;

typedef struct {
	short int Code;			/* unit's e-code */
	int nTimes;
	long int *Times;		/* vector of times of occurrence for each spike */
} mUnit;

typedef struct msignal {
	char Name[64];			/* name of signal channel */
	int nPts;
	float *Signal;			/* Signal vector */
} mSignal;

static int mrdr_startCode = 1001;
static int mrdr_maxSampRate = 0;
static int mrdr_preTime = 0;
static int mrdr_absTime = -1;
static int mrdr_numTrials = 0;

typedef struct RexData {
	long int _trialNumber;	/* number of this trial */
	long int _tStartTime;	/* time of first event in trial in REX msec (may preceed aStartTime) */
	long int _aStartTime;	/* time of first point in signal */
	long int _aEndTime;		/* time of last point in signal */
	long int _tEndTime;		/* time of last event in trial in REX msec (may follow aEndTime) */
	float _a2dRate;			/* a/d sample rate in Hz, from  REX's STORE_RATE parameter*/

	int _nEvents;
	mEvent *_Events;		/* array of events for this trial */
	int _nUnits;
	mUnit *_Units;			/* array of rex units structure */
	int _nSignals;
	mSignal *_Signals;		/* array of signals for this trial */
} RexData_t;

void readData(int nNewTrials, int nPrevTrials);
void clearTrials(void);
void loadTrial(RexData_t *rd, int ti);
mxArray *cvt_trialNumber(RexData_t *rd);
mxArray *cvt_events(RexData_t *rd);
mxArray *cvt_units(RexData_t *rd);
mxArray *cvt_signals(RexData_t *rd);
mxArray *cvt_tStartTime(RexData_t *rd);
mxArray *cvt_aStartTime(RexData_t *rd);
mxArray *cvt_aEndTime(RexData_t *rd);
mxArray *cvt_tEndTime(RexData_t *rd);
mxArray *cvt_a2drate(RexData_t *rd);
mxArray *cvt_short(int npts, short *p);
mxArray *cvt_long(int npts, long *p);
mxArray *cvt_float(int npts, float *p);

#endif /*_MRDR_H_*/

