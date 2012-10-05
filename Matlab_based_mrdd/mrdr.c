#include <ctype.h>
#include <string.h>

#if defined(_CONSOLE)
#include <io.h>
#else
#include <unistd.h>
#endif

#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "mex.h"
#include "matrix.h"
#include "mrdr.h"
#include "rex.h"

RexData_t *Trials = (RexData_t *)NULL;

void loadTrial(RexData_t *rd, int tn)
{
	RexInfo *ri;
	SignalList *psl;
	long int offset;
	long *pt;
	int ei;
	int ui;
	int ti;
	int si;
	int j;

	rd->_trialNumber = tn + 1;

	ri = rexGetTrial(rd->_trialNumber, 1);
	if(ri == (RexInfo *)NULL) {
		char msg[128];
		sprintf(msg, "Warning: rexGetTrial returned NULL for trial %d\n", ti);
		mexWarnMsgTxt(msg);
	}

	if(mrdr_absTime == -1) {
		rd->_tStartTime = ri->tStartTime;
		rd->_aStartTime = ri->aStartTime;
		rd->_aEndTime = ri->aEndTime;
		rd->_tEndTime = ri->tEndTime;
	}
	else {
		rd->_tStartTime = 0;
		rd->_aStartTime = ri->aStartTime - ri->tStartTime;
		rd->_aEndTime = ri->aEndTime - ri->tStartTime;
		rd->_tEndTime = ri->tEndTime - ri->tStartTime;
	}

	rd->_a2dRate = (float)ri->maxSampRate;

	/* copy the events */
	rd->_nEvents = ri->nEvents;
	rd->_Events = (mEvent *)mxMalloc(rd->_nEvents * sizeof(mEvent));

	for(ei = 0; ei < rd->_nEvents; ++ei) {
		rd->_Events[ei].Code = ri->events[ei].e_code;
		if(mrdr_absTime == -1) rd->_Events[ei].Time = ri->events[ei].e_key;
		else rd->_Events[ei].Time = ri->events[ei].e_key - ri->tStartTime;
	}

	/* copy the units */
	rd->_nUnits = ri->nUnits;
	rd->_Units = (mUnit *)mxMalloc(rd->_nUnits * sizeof(mUnit));
	for(ui = 0; ui < ri->nUnits; ++ui) {
		rd->_Units[ui].Code = ri->unitCodes[ui];

		rd->_Units[ui].nTimes = ri->rexunits->nTimes[ui];
		rd->_Units[ui].Times = (long int *)mxMalloc(rd->_Units[ui].nTimes * sizeof(long int));

		if(mrdr_absTime == -1) offset = 0;
		else offset = ri->tStartTime;

		pt = ri->rexunits->unitTimes[ui];
		for(ti = 0; ti < rd->_Units[ui].nTimes; ++ti) {
			rd->_Units[ui].Times[ti] = (pt[ti] - offset);
		}
	}

	/* copy the analog signals */
	rd->_nSignals = ri->nSignals;
	rd->_Signals = (mSignal *)mxMalloc(rd->_nSignals * sizeof(mSignal));
	si = 0;
	for(psl = ri->signalList; psl; psl = psl->next) {
		strcpy(rd->_Signals[si].Name, psl->sigLabel);
		rd->_Signals[si].nPts = psl->npts;
		rd->_Signals[si].Signal = (float *)mxMalloc(rd->_Signals[si].nPts * sizeof(float));

		for(j = 0; j < rd->_Signals[si].nPts; ++j) {
			rd->_Signals[si].Signal[j] = ((float)psl->signal[j] * psl->scale);
		}
		++si;
	}
}


void deleteTrial(RexData_t *rd)
{
	int ui;
	int si;

	mxFree(rd->_Events);

	for(ui = 0; ui < rd->_nUnits; ++ui) {
		mxFree(rd->_Units[ui].Times);
	}
	mxFree(rd->_Units);

	for(si = 0; si < rd->_nSignals; ++si) {
		mxFree(rd->_Signals[si].Signal);
	}
	mxFree(rd->_Signals);
}


void clearTrials()
{
	int i;

	if(Trials != (RexData_t *)NULL) {
		for(i = 0; i < mrdr_numTrials; ++i) deleteTrial(&Trials[i]);
	}

	mxFree(Trials);
	Trials = (RexData_t *)NULL;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	char errmsg[512];
	char arg[512];
	char files[20][512];
	int argLen;
	int status;
	int nDims;
	int Dims[2];
	int nFiles;
	int newTrials;
	int rd;
	int i;

	if(nrhs < 2) {
		mexErrMsgTxt("You must enter at least one file");
	}

	mexPrintf("Trials = %x\n", Trials);

	/* register the exit function */
	mexAtExit(clearTrials);

	mrdr_absTime = 0;

	/* loop throught the right hand side and get the file names */
	nFiles = 0;
	for(i = 0; i < nrhs; ++i) {
		if(mxIsChar(prhs[i]) != 1) {
			sprintf(errmsg, "Input %d is not valid", i);
			mexErrMsgTxt(errmsg);
		}

		argLen = mxGetN(prhs[i]) + 1;
		status = mxGetString(prhs[i], arg, argLen);

		if(arg[0] == '-') {
			switch(arg[1]) {
			case 'a':
				mrdr_absTime = -1;
				break;
			case 'd':
				++i;
				argLen = mxGetN(prhs[i]) + 1;
				status = mxGetString(prhs[i], arg, argLen);
				strcpy(files[nFiles], arg);
				++nFiles;
				break;
			case 'f':
				++i;
				argLen = mxGetN(prhs[i]) + 1;
				status = mxGetString(prhs[i], arg, argLen);
				sscanf(arg, "%d", &mrdr_maxSampRate);
				break;
			case 'p':
				++i;
				argLen = mxGetN(prhs[i]) + 1;
				status = mxGetString(prhs[i], arg, argLen);
				sscanf(arg, "%d", &mrdr_preTime);
				break;
			case 's':
				++i;
				argLen = mxGetN(prhs[i]) + 1;
				status = mxGetString(prhs[i], arg, argLen);
				sscanf(arg, "%d", &mrdr_startCode);
				break;
			}
		}
	}

	/* get the data */
	/* split events and units */
	rexSplitEvents();

	/* open the file and get the number of trials*/
	mrdr_numTrials = 0;
	for(i = 0; i < nFiles; ++i) {
		newTrials = rexFileOpen(files[i], mrdr_maxSampRate, mrdr_startCode, mrdr_preTime);
		if(newTrials == 0) {
			mexErrMsgTxt("No trials found\n");
		}

		readData(newTrials, mrdr_numTrials);

		rexFileClose();
		mrdr_numTrials += newTrials;
	}

	/*  build the left had side */
	nDims = 2;
	Dims[0] = 1;
	Dims[1] = mrdr_numTrials;

	plhs[0] = mxCreateStructArray(nDims, Dims, mTrials_number_of_elts, mTrials_elts_names);
	if(plhs[0] == NULL) {
		mexErrMsgTxt("Could not create struct array: Probable cause - insufficient heap");
	}

	for(rd = 0; rd < mrdr_numTrials; ++rd) {
		mxSetField(plhs[0], rd, "trialNumber", cvt_trialNumber(&Trials[rd]));
		mxSetField(plhs[0], rd, "Signals", cvt_signals(&Trials[rd]));
		mxSetField(plhs[0], rd, "Events", cvt_events(&Trials[rd]));
		mxSetField(plhs[0], rd, "Units", cvt_units(&Trials[rd]));
		mxSetField(plhs[0], rd, "tStartTime", cvt_tStartTime(&Trials[rd]));
		mxSetField(plhs[0], rd, "aStartTime", cvt_aStartTime(&Trials[rd]));
		mxSetField(plhs[0], rd, "aEndTime", cvt_aEndTime(&Trials[rd]));
		mxSetField(plhs[0], rd, "tEndTime", cvt_tEndTime(&Trials[rd]));
		mxSetField(plhs[0], rd, "a2dRate", cvt_a2drate(&Trials[rd]));
	}

	clearTrials();

	return;
}

void readData(int nNewTrials, int nPrevTrials)
{
	RexData_t *rd;
	int nTotalTrials;
	int i;

	nTotalTrials = nNewTrials + nPrevTrials;
	Trials = (RexData_t *)mxRealloc(Trials, (nTotalTrials * sizeof(RexData_t)));

	if(Trials == (RexData_t *)NULL) mexErrMsgTxt("Couldn't create Trials pointer array\n");
	
	for(i = 0; i < nNewTrials; ++i) {
		rd = &Trials[i + nPrevTrials];
		loadTrial(rd, i);
	}
}

mxArray *cvt_trialNumber(RexData_t *rd)
{
	long int *p;
	int nDims = 2;
	int Dims[] = { 1, 1 };
	mxArray *ptr;

	ptr = mxCreateNumericArray(nDims, Dims, mxINT32_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_trialNumber(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (long int *)mxGetData(ptr);

	*p = rd->_trialNumber;

	return(ptr);
}

mxArray *cvt_tStartTime(RexData_t *rd)
{
	long int *p;
	int nDims = 2;
	int Dims[] = { 1, 1 };
	mxArray *ptr;

	ptr = mxCreateNumericArray(nDims, Dims, mxINT32_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_tStartTime(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (long int *)mxGetData(ptr);

	*p = rd->_tStartTime;

	return(ptr);
}

mxArray *cvt_tEndTime(RexData_t *rd)
{
	long int *p;
	int nDims = 2;
	int Dims[] = { 1, 1 };
	mxArray *ptr;

	ptr = mxCreateNumericArray(nDims, Dims, mxINT32_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_tEndTime(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (long int *)mxGetData(ptr);

	*p = rd->_tEndTime;

	return(ptr);
}

mxArray *cvt_aStartTime(RexData_t *rd)
{
	long int *p;
	int nDims = 2;
	int Dims[] = { 1, 1 };
	mxArray *ptr;

	ptr = mxCreateNumericArray(nDims, Dims, mxINT32_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_aStartTime(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (long int *)mxGetData(ptr);

	*p = rd->_aStartTime;

	return(ptr);
}

mxArray *cvt_aEndTime(RexData_t *rd)
{
	long int *p;
	int nDims = 2;
	int Dims[] = { 1, 1 };
	mxArray *ptr;

	ptr = mxCreateNumericArray(nDims, Dims, mxINT32_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_aEndTime(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (long int *)mxGetData(ptr);

	*p = rd->_aEndTime;

	return(ptr);
}

mxArray *cvt_a2drate(RexData_t *rd)
{
	float *p;
	int nDims = 2;
	int Dims[] = { 1, 1 };
	mxArray *ptr;

	ptr = mxCreateNumericArray(nDims, Dims, mxSINGLE_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_a2drate(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (float *)mxGetData(ptr);

	*p = rd->_a2dRate;

	return(ptr);
}

mxArray *cvt_events(RexData_t *rd)
{
	mxArray *ptr;
	int nDims = 2;
	int Dims[2];
	int numEvnt = 0;
	int ei;
	int n;

	/* eliminate negative events, as these refer to A-file */
	for(ei = 0; ei < rd->_nEvents; ++ei) {
		if(rd->_Events[ei].Code >= 0) ++numEvnt;
	}

	Dims[0] = 1;		/* rows */
	Dims[1] = numEvnt;	/* colums */

	ptr = mxCreateStructArray(nDims, Dims, mEvent_number_of_elts, mEvent_elts_names);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_events(); Could not create struct array: Probable cause - insufficient heap");
	}
	
	n = 0;
	for(ei = 0; ei < rd->_nEvents; ++ei) {
		if(rd->_Events[ei].Code >= 0) {
			mxSetField(ptr, n, "Code", cvt_short(1, &rd->_Events[ei].Code));
			mxSetField(ptr, n, "Time", cvt_long(1, &rd->_Events[ei].Time));
			++n;
		}
	}

	return(ptr);
}

mxArray *cvt_units(RexData_t *rd)
{
	mxArray *ptr;
	int nDims = 2;
	int Dims[2];
	int ui;

	Dims[0] = 1;		/* rows */
	Dims[1] = rd->_nUnits;	/* colums */

	ptr = mxCreateStructArray(nDims, Dims, mUnits_number_of_elts, mUnits_elts_names);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_units() Could not create struct array: Probable cause - insufficient heap");
	}
	
	for(ui = 0; ui < rd->_nUnits; ++ui) {
		mxSetField(ptr, ui, "Code", cvt_short(1, &rd->_Units[ui].Code)); 
		mxSetField(ptr, ui, "Times", cvt_long(rd->_Units[ui].nTimes, rd->_Units[ui].Times)); 
	}

	return(ptr);
}

mxArray *cvt_signals(RexData_t *rd)
{
	mxArray *ptr;
	int nDims = 2;
	int Dims[2];
	int si;

	Dims[0] = 1;
	Dims[1] = rd->_nSignals;

	ptr = mxCreateStructArray(nDims, Dims, mSignal_number_of_elts, mSignal_elts_names);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_signals(); Could not create struct array: Probable cause - insufficient heap");
	}
	
	for(si = 0; si < rd->_nSignals; ++si) {
		mxSetField(ptr, si, "Name", mxCreateString(rd->_Signals[si].Name));
		mxSetField(ptr, si, "Signal", cvt_float(rd->_Signals[si].nPts, rd->_Signals[si].Signal)); 
	}

	return(ptr);
}

mxArray *cvt_short(int npts, short *d)
{
	mxArray *ptr;
	int nDim = 2;
	int Dims[2];
	short *p;
	short dummy = 0;

	if (npts < 1 || d == NULL) {
		npts = 1;
		d = &dummy;
	}

	Dims[0] = 1;
	Dims[1] = npts;

	ptr = mxCreateNumericArray(nDim, Dims, mxINT16_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_short(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (short *)mxGetData(ptr);

	memcpy(p, d, (npts * sizeof(short)));

	return(ptr);
}

mxArray *cvt_long(int npts, long *d)
{
	mxArray *ptr;
	int nDim = 2;
	int Dims[2];
	long *p;
	long dummy = 0;

	if (npts < 1 || d == NULL) {
		npts = 1;
		d = &dummy;
	}

	Dims[0] = 1;
	Dims[1] = npts;

	ptr = mxCreateNumericArray(nDim, Dims, mxINT32_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_long(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (long *)mxGetData(ptr);

	memcpy(p, d, (npts * sizeof(long)));

	return(ptr);
}

mxArray *cvt_float(int npts, float *d)
{
	mxArray *ptr;
	int nDim = 2;
	int Dims[2];
	float *p;
	float dummy = 0;

	if (npts < 1 || d == NULL) {
		npts = 1;
		d = &dummy;
	}

	Dims[0] = 1;
	Dims[1] = npts;

	ptr = mxCreateNumericArray(nDim, Dims, mxSINGLE_CLASS, mxREAL);
	if(ptr == NULL) {
		mexErrMsgTxt("cvt_float(); Could not create numeric array: Probable cause - insufficient heap");
	}

	p = (float *)mxGetData(ptr);

	memcpy(p, d, (npts * sizeof(float)));

	return(ptr);
}
