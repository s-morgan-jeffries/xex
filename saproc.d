/*
 * 
 * 12/14 -> adding colors to t-task for training
 *       -> adding a vsrch menu to handle the search task
 * 12/19 -> changing this to make it a vsrch flag to the t-task menu
  
 *11/27 -> dropping codes if linemotionmenu is on in fponstuff
 *         fixed bug so that rf2->obj[ and object[rf2-> x if displacedegs
 *         adding code for length variation with static rf2 in linemotion stuff
 *         added a random range in fillrf() for luminance and checksize
 *         added a direction randomizer in linemotion()
 */

/* 01/08 -> added display butt: a chonkin special */

/* changes on october 11
 * introduced noeyecheck to prevent dimon from checking eye
 * am going to introduce form and color distractors for mmn
 * have to make a jump stimulus as well NOW
 * 
 * a) chonkinflash is currently weird because the background is 
 * not reset and because task continues while flashes go on and off
 * : BUT FIX LATER
 * 
 * adding fprandom for ep task on 10/25 -s.
 * 
 * 
 * 
 * /

/* This is a combination of rfmap.d (weirdly enough, based on monkny.d
rather than on zigmonk.d) and oneframeet.d. If I can get them working in
combination, then this should be the omnibus version.


Many oneframeet aspects of this task have not been tested to be manyrf safe.
WATCH OUT.

*This is the current Ziggy paradigm for saccade-attention effects
 * Making these notes on June10 2005
 * Modified from zigwithdim.d to 
 * change insac to have a timer
 * remove windowdelay from fpon, moved to gap1
 * 6/30/05: added a local_window_delay = 0 line to interstuff; essential
 * to add bar release codes for release during dimon
 * finally, adjust sfptime to srf2delay+100, so that dimon starts with rf2on
 * ther is a july2 bak... but now i am going to mess with stimulus ons....
 * only turn on flag for fp, rf, rf2. BAS.
 * 
 * introducing an rf3, compared to hofsub; workingwith truehof, which has problems
 * 
 * OK.. figured out all the bugs
 * vexphoto has introduced several probelsm while dealing with mulitple stimuli
 * two things to do: 
 * remove all jmp and cue stimuli ons for now.. hardcode this. they just wont work
 * second: make sure nothing happens near suresh_turns_rfoff or near rfon. 
 * and dont use rfonflag to see if rf has turned on, do it locally near actual turning 
 * on of rf in vexflagcheck
 
 IS BASICALLY FINHOF WIHT HACKS FOR ONE FRAME
 
 orex version modified for 2 objects
 adding a counter for ziggy's automatic updating
 
 * */


/*
 *	NOGO paradigm has been added.
 *	Two Bars can be used.
 *	The presentationÿratio between arrays can be more than 1:1
 * 		This is set in the FP menu.
 *	Feb 2000, jwb
 *
 *	Can Change GLVex B/g luminance
 *	Added Annulus, Bar and Tiff (to GLVex Stuff)
 *	Added Help Menu
 *	Seeded rand() on time
 *	Dec 99, JWB
 *
 *      modified for GLvex:
 *	add #include GLvex
 *	change rinitf (add host, port, subnet)
 *	change SET_REX_SCALE in allOffStuff
 *	change locateObject
 *	add function called floatload
 *	take out pcm_rec_reset and pcm_rec_enable (in vex_set)
 *	Oct. 99, jgb
 *
 *      new arrays added to the FUNCTION(object pattern, position, and colors
 * 	vafs and mafs much simplified
	June 1998, meg
 *	new background shifter. Background struct has two objects:
 *	the zero object in a background struct is the default-
 *	object menus change this struct as well if they match
 *	filling the zeroth struct automatically changes the object
	Sept  28, meg

 *	split rf and rf2 chains so they run in parallel
 *	Sept 13 jgb
 *
 *	try to fix rf and rf2 chains so that the VEXBACKGROUND control works for them
 *	Sept 13 jgb
 *
 *	this also has cue2 chain,that probably does not work very well
 *	June '96 jgb
 *
 *	add time in the lastThings state of main chain to 
 *	allow collecting A recs for a little while after reward is given
 *	March '96 jgb
 *
 *	fix grass chain for electrical stimulation
 *	allow ZAP time to be linked to cue and ZAP frequency
 *	Feb 1996 by jgb
 *
 *	Add VEXBACKOFF control to turn off background 
 *	1995 by jgb
 *
 *	Add second rf stim (rf2)
 *	Fix double step saccade routine
 *	Dec. 6, 1995 by jgb and makoto
 */

/*monkvmeg.d  
 *   this version features the following: 
 *   	flashing and beeping fp
 *	mir1 ramp
 *
 *the inclusive on-line multichained paradigm
 */
 /*single pulse version, August 30, 1993*/

/* transfered to Allan Wu's lab (2D72D) on 9/28/93, modified
 * appropriately for the rack in this lab
 */
/*
 * $Log: monkvex.d,v $
# Revision 1.1  1995/03/17  19:10:36  root
# Initial revision
#
# Revision 1.2  1995/03/01  17:01:24  root
# fix background makeAngle
#
# Revision 1.1  1995/03/01  14:41:27  root
# Initial revision
#
#
 */

/*
static char monk_id[] = "$Id: monk3.d,v 1.1 1995/03/17 19:10:36 root Exp root $";
*/

#define VEX

/* special header includes*/
#include "../hdr/sac.h"
#include "../hdr/ramp.h"
#include <unistd.h>
#include <sys/types.h>
#include <time.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
/* #include <i86.h> not needed with Rex 7 */
/* #include "GLvex_com.c" old. replaced by ... */

/* I am going to include these to see if it works */
#include <GLcommand.h>
#include "/rex/act/vexActions.c"
#include <pcsSocket.h>

/*
 * $Log: monk3.d,v $
# Revision 1.1  1995/03/17  19:10:36  root
# Initial revision
#
# Revision 1.2  1995/03/01  17:01:24  root
# fix background makeAngle
#
# Revision 1.1  1995/03/01  14:41:27  root
# Initial revision
#
#
 */

/*
static char monk_id[] = "$Id: monkh.d,v 1.1 1995/03/17 19:10:36 root Exp root $";
*/

#define VEX

/*here follows all of the header block*/


#define PI 3.1416

/* object mode codes*/
#define PATTERN 0
#define TIFF 1
#define VEX_BAR 2
#define ANNULUS 3

/* DA control structs */
#define DA0 0   /* hmir1 */
#define DA1 5   /* vmir1 */
#define DA2 2   /* hmir2 */
#define DA3 3   /* vmir2 */
#define DA4 1   /* hplat */
#define DA5 4   /* vplat (not used) */

/*new codes*/
#define STRTCD	    1050
#define PAUSCD	    1099
#define DONECD	    1090

/* PhotoCell bit */
#define PHOTOIN 0x2000

/*BAR bit lines */
#define LEFTBAR  8 
#define RIGHTBAR 4
#define BOTHBARS 12
#define NOBAR 0

/*BAR values */
#define LEFT 2
#define RIGHT 1
#define BOTH 3
#define NEITHER 4
#define OFFTIME 50

/*devices*/
#define LED1	    0x20040001
#define LED1_DIM    0x20040003
#define LED2	    0x20040004
#define LED2_DIM    0x2004000c 
#define AMP         0x20060004
#define LED3	    Dio_id(PCDIO_DIO, 4, 0x10)
#define LED3_DIM    Dio_id(PCDIO_DIO, 4, 0x30)
#define REW	    Dio_id(PCDIO_DIO, 2, 0x10)
#define PHOTOOUT    Dio_id(PCDIO_DIO, 2, 0x2)
#define STIM	    Dio_id(PCDIO_DIO, 6, 0x08)
#define BEEPER	    Dio_id(PCDIO_DIO, 2, 0x40)
#define STIMSWITCH  0x80

/*Define E-codes*/
#define ARRNUMCD    2000  /* code to which the array number will be added */
#define LANCECD	    900 /* code general trial start code for grdd*/
#define RASONCD	    1000
#define MSTARTCD    1001
#define BARCD	    1002
#define FPONCD	    1003
#define GAP1CD      1004
#define JMP1CD	    1005
#define JMP1OFFCD   1006
#define RFONCD	    1007  
#define RF2ONCD	    1047
#define TGONCD	    1008
#define TGOFFCD     1009
#define	RFOFFCD	    1010
#define	RF2OFFCD    1040
#define DIMCD	    1011
#define RWCD	    1012
#define ERRORCD	    1013
#define DISABLECD   1014
#define GAP2CD	    1015
#define CUEONCD	    1016
#define CUEOFFCD    1017
#define BAROFFCD    1020  /*from monkny 3-2/03*/
#define CUE2ONCD    1018
#define CUE2OFFCD   1019
#define TRIALONCD   1032
#define EYECD	    1027
#define GRASSONCD   1030
#define GRASSOFFCD  1031
#define BACKON1CD   1032
#define BACKON2CD   1033
#define JMP2CD	    1034
#define JMP2OFFCD   1035
#define VEXBGONCD   1043
#define VEXBGOFFCD  1044
#define SACON1CD    1061
#define SACON2CD    1062
#define SACONCD	    1064
#define SACOFF1CD   1071
#define SACOFF2CD   1072
#define SACOFFCD    1074
#define STIMCD      1080
#define STOFFCD	    1081
#define ERROR1CD    1085

#define ABTLCD	    1090 /*Abort Trial Code */
#define FBRKCD	    1091 /*Fixation Break Code */
#define PBADCD	    1092 /*Photocell got out of sync */
#define BARERRCD    1093 /*Bar released too early or late */
#define BARERR2CD   1094 /*for imp_task. Hard trials, no bar, cor sac */
#define ARRAYMAX 128

#define PATNUMCD    3000 /* Num of objects */
#define PATONCD	    7000
#define THRESHOLDCD 4000
#define PATRCD	    5000
#define PATGCD      5300
#define PATBCD	    5600

#define PATXCD      6000
#define PATYCD      6500
#define PATCHECKCD   10000 /* currently not used */
#define PATMODCD 10100 /*check less than 100 assumption*/
#define PATVAR1CD 10200 /*assume var1<500*/
#define PATVAR2CD 10700 /*assume var2<100*/
#define PATVAR3CD 10800 /*ditto*/

#define CDELCD	   11000 /* cue delay code -suresh 12/04/03*/

#define DESCRIPTORSIZE 30
#define ARRAYSIZE  289
#define MAXDIFFTASKS 100

/* for routines to determine whether or not to drop code or defer
 *until vex returns
 */
/*FUNCTION interface flags*/
#define BLUEBOX 0
#define TV 1

/*used to decode the trial flag in the array*/
#define SHIFT_RFFLAG 	0
#define RFFLAG		000000000001
#define NORFFLAG	037777777776
#define SHIFT_JMP1FLAG 	1 
#define JMP1FLAG	000000000002
#define NOJMP1FLAG	037777777775
#define SHIFT_GRASSFLAG 2
#define GRASSFLAG	000000000004
#define NOGRASSFLAG	037777777773
#define SHIFT_JMP2FLAG  3
#define JMP2FLAG	000000000010
#define NOJMP2FLAG	037777777767
#define SHIFT_JMP2SAC 	4
#define JMP2SAC		000000000020
#define NOJMP2SAC	037777777757
#define SHIFT_BACKON1 	5
#define BACKON1		000000000740
#define NOBACKON1	037777777037
#define SHIFT_BACKON2 	9
#define BACKON2		000000017000
#define NOBACKON2	037777760777
#define SHIFT_JMP1CUEFLAG  13
#define JMP1CUEFLAG	000000020000
#define NOJMP1CUEFLAG	037777757777
#define SHIFT_JMP2CUEFLAG 14
#define JMP2CUEFLAG	000000040000
#define NOJMP2CUEFLAG	037777737777
#define SHIFT_RF2FLAG 	15
#define RF2FLAG		000000100000
#define NORF2FLAG	037777677777
#define SHIFT_JMP1CUE2FLAG  16
#define JMP1CUE2FLAG	000000200000
#define NOJMP1CUE2FLAG	037777577777
#define SHIFT_JMP2CUE2FLAG 17
#define JMP2CUE2FLAG	000000400000
#define NOJMP2CUE2FLAG	037777377777
#define SHIFT_NOGOFLAG 	18
#define NOGOFLAG	000001000000
#define NONOGOFLAG	037776777777
#define SHIFT_BARFLAG 	19
#define BARFLAG		000006000000
#define NOBARFLAG	037771777777
#define FLAGLEFTBAR	000004000000
#define FLAGRIGHTBAR	000002000000
#define FLAGBOTHBARS	BARFLAG
#define SHIFT_BAROFFFLAG 21
#define BAROFFFLAG	000030000000
#define NOBAROFFFLAG	037747777777
#define FLAGLEFTBAROFF	000020000000
#define FLAGRIGHTBAROFF	000010000000
#define FLAGBOTHBAROFFS	BAROFFFLAG
#define SHIFT_FIXJMPCUEFLAG 24
#define FIXJMPCUEFLAG   000100000000
#define NOFIXJMPCUEFLAG 037677777777
#define SHIFT_RFSHUFFLEFLAG 25 
#define RFSHUFFLEFLAG   000200000000
#define NORFSHUFFLEFLAG 037577777777
#define SHIFT_CUEBARFLAG 26
#define	CUEBARFLAG      001400000000
#define NOCUEBARFLAG    036377777777
/* next shift should be 28 */


/*above are all flag*/
/*saccade flag values*/
#define SACCADE1 1
#define SACCADE2 2

/*control flag values*/
#define NOMIRROR 0
#define MIR1_ARRAY 1
#define MIR1_STATIC 2
#define MIR1_JOY 3
#define MIR2_ARRAY 4
#define MIR2_STATIC 5
#define MIR2_JOY 6
#define JOYNARRAY_MIR1 7
#define JOYNARRAY_MIR2 8
#define ZAP 9
#define MIR1_RAMP 10
#define MIR2_RAMP 11
/*#define FUNCOBJECT 16*/
#define VEXARRAY 12
#define VEXSTATIC 13
#define VEXJOY 14
#define VEXBACKGROUND 15
#define VEXBACKOFF 16
#define VEXCUE     17
#define VEXCUE2    18
#define VEXBGRF    19
#define THRESHOLD 20
#define MCSTHRESH 21 /* Method of Constant Stimulus */
#define CONTROLMAX MCSTHRESH /* CONTROLMAX always = 
				* greatest control flag value
				*/

/*rfswitch flags*/
#define NO 0
#define ON1 1
#define ON0 2

#define VEXMAX 9096 /*highest value of vexbuf*/
/*vex stuff*/
#define OBJECTNUMBER 31 /*should be 31*/
#define JOYNUMBER 6 /*maximum objects movalbe by joystick*/
#define OBJECTMIN 100
#define BACKGROUNDNUMBER 14 /*maximum objects in background. Could be OBJECTNUMBER  -4 */
#define PATTERNSIZE 1 /*default pattern size*/
/* Jackies lab*/
#define REXSCALE 0.76 

/*Jason's lab */
/*#define REXSCALE 0.576; 1.10 before; with gain of 1.45*/
			
/*flags for vexOnFlag*/
#define VEXCURRENT 	000000000001
#define NOVEXCURRENT 	037777777776 
#define VEXCURRENTJOY 	000000000002
#define NOVEXCURRENTJOY	037777777775 
#define VEXRF 		000000000004
#define NOVEXRF		037777777773 
#define VEXRFJOY  	000000000010
#define NOVEXRFJOY	037777777767 
#define VEXGAP1 	000000000020
#define NOVEXGAP1	037777777757 
#define VEXJMP1 	000000000040
#define NOVEXJMP1	037777777737 
#define VEXJMP1JOY 	000000000100
#define NOVEXJMP1JOY	037777777677 
#define VEXJMP2 	000000000200
#define NOVEXJMP2	037777777577 
#define VEXJMP2JOY 	000000000400
#define NOVEXJMP2JOY	037777777377 
#define VEXBGD		000000001000
#define NOVEXBGD	037777776777 
#define VEXCURRENTDIM	000000002000
#define NOVEXCURRENTDIM	037777775777 
#define VEXFP  		000000004000
#define NOVEXFP		037777773777 
#define VEXFPJOY 	000000010000
#define NOVEXFPJOY	037777767777 
#define VEXCUBE		000000020000
#define NOVEXCUBE	037777757777
#define VEXCUEJOY	000000040000
#define NOVEXCUEJOY	037777737770 
#define VEXOLDBG	000000100000
#define NOVEXOLDBG	037777677770 
#define VEXRF2 		000001000000
#define NOVEXRF2	037776777777 
#define VEXRF2JOY  	000002000000
#define NOVEXRF2JOY	037775777777 
#define VEXCUBE2	000004000000
#define NOVEXCUBE2	037773777777 
#define VEXCUE2JOY	000010000000
#define NOVEXCUE2JOY	037767777770
#define CODENUMBER OBJECTNUMBER

#define PI 3.1416

/*sequence flag values*/
#define S_SHUFFLE 2
#define A_SHUFFLE 4
#define S_SEQUENCE 1
#define A_SEQUENCE 3
#define S_NULL 0

/*backon control flag values*/
#define B_GOODSAC 1
#define B_WINDOW 2
#define B_DOUBLEJUMP 8

/*window check bits*/
#define IN_DELAY 1
#define IN_WINDOW 2


/*macro definitions*/

#define TRIAL_END 1
#define SHUFFLE_END 1
#define SQUAREX 600
#define SQUAREY 600
#define RANDNUMBER 20
#define FUNCOBJECT 32  /* redoing this from 16 on january 2005, justnoticed - suresh */

/*here follow key struct definitions*/

typedef struct {
	int x;
	int y;
	int pattern;
	int sign;
	int checksize;
	int fgl; /*foreground luminance*/
	int bgl; /*background luminance*/
	int fgr; /*foreground red*/
	int fgg; /*foreground green*/
	int fgb; /*foreground blue*/
	int bgr; /*background red*/
	int bgg; /*background green*/
	int bgb; /*background blue*/
	int mode; /*could be TIFF, ANNULUS, VEX_BAR, PATTERN */ 
	int var1; /*angle for bar, out for annulus*/
	int var2; /*width for bar, in for annulus*/
	int var3; /*length for bar, null for annulus*/
	int thlink; /*Links to staircase if not 0 */
} OBJECT;

/*THRESHOLD STRUCT*/
typedef struct {
	int tv1; /*values for threshold*/
	int tv2;
	int tp1;/*code for device - think of it as a pointeroid*/
	int tp2;
}
THRESHARRAY;

typedef struct {
	int  x;
	int  y;
	long device;
	long device_dim;
	int  control;
	int  delay;
	int  time;
	int  windowx;
	int  windowy;	
	int object[FUNCOBJECT];
	OBJECT obj[FUNCOBJECT];
	THRESHARRAY thresh[FUNCOBJECT];
	int objectNumber;
	int object_dim;
	int background;
	int interface;
	int falsereward;
	int RandFlag;  /*These 3 are for Surseh's random jump paradigm*/
	int NumRandJumps;
	int RandJumpSize;
	int counter;
} FUNCTION;

/* NB: fp->background is used for the ratio of shuffles */

typedef struct {
	int      index;
	FUNCTION fp;
	FUNCTION rf;
	FUNCTION rf2; 
	FUNCTION jmp1;
	FUNCTION jmp2;
	FUNCTION rmp;   /* added to control ramp */
	FUNCTION cue; /*for VEX*/
	FUNCTION cue2; /*for VEX*/
	FUNCTION gap;
	FUNCTION spare;
	int flag;
	int flag2;
/*	int jmp1randflag; */
	int fprandflag;
	int fprandsize;
	int jmp2RwdFlag; /* morgan addn */
} ARRAY;
typedef struct {
	char  header[80];
	int   array_max;
	int   array_index;
	long  array_flag;
	int   array_number;
	int   array_descriptors[DESCRIPTORSIZE];
	ARRAY tbl[ARRAYSIZE];
} ARRAY_BLOCK;

typedef struct {
	int object[2];
	OBJECT bgobj[2];
} BACKGROUND;

	
int localgood[ARRAYSIZE];  /* Keeps track of staircase levels */
int localbad[ARRAYSIZE];

struct rff {int rfx; int rfy; double ind;};

ARRAY_BLOCK array = {0}; /*initialize the array block*/

/*declarations for vex*/
EVENT vexEvent[10*CODENUMBER] = {0}; /* array of codes for int code handler */
short int vexCode[10*CODENUMBER] = {0};
#ifdef FOOTNOTE
/* This is art's typedef for event: */
typedef struct {
   unsigned short int	e_seqnum;/* event sequence number in E file */
   short int		e_code;  /* event code; see event.h */
   long			e_key;   /* a long time; or if this event references
			          *an analog record in the A file, a long
			          *address */
#endif

/*here follow function declarations*/
/*vex function declarations*/
int debugcount = 0;
int agoo= 0x1234;
/* int locateObject(char *count, int objectNumber, int objectx, int objecty); */
int eyewinCheck(int winx,int winy,int centerx,int centery); 
int vexbackoff();/*JG*/
int backoffcheck();/*JG*/
void fixCurrentDim(FUNCTION *fpx);

/*vex globals*/
int vexCodeCount = 0; /*flag for  int code handler*/
int vexOnFlag = 0; /*flag to initiate vex job*/
int vexOffFlag = 0; /*flag to turn off vex stimulus*/
int vexAllOffFlag = 0; /*flag to turn off all objects*/
int vexCancelFlag = 0; /*flag to tell last_things to turn off vex objects*/
int newObjectFlag = 0; /*flag to initiate new set of objects*/
int vexJoyFlag = 0; /*contains vex object currently hooked to joystick*/
int backgroundNumber = 0; /*number in current background*/
int objNumber = OBJECTNUMBER; /*number of  current objects*/
int patternSize = PATTERNSIZE; /*number of pixels per pattern check*/
int vexIndex = 0; /*index into vexbuf*/

char vary1[20]; /* Will tell us the varying Parameter on the staircase */
char vary2[20]; /* Will tell us the varying Parameter on the staircase */

int last[20]; /* for running %correct */
int cfl = 0; /* clock for last[cfl] */
int count_first_twenty = 0;
   
   int buttOnFlag=0;
   int buttOffFlag=0;
   int buttCancelFlag=0;
   int myVexFlag=0;
   int aminButt=0;

   int wasButtOn=0;
   int wasButtOff=0;
   
/*
BACKGROUND background[BACKGROUNDNUMBER] = {
	0,	100,	1,	112,
	100,	0,	3, 	112,
	0,	-100,	5,	112,
	-100,	0,	7,	112,
	105,	105,	9,	112,
	105,	-105,	11,	112, -105,	-105,	13,	112,
	-105,	105,	15,	112,
	0,	200,	17,	112,
	200,	0,	19,	112,
	0,	-200,	21,	112,
	-200,	0,	23,	112,
	200,	0,	25,	112,
	-200,	0,	27,	112,
};
*/
	
BACKGROUND background[BACKGROUNDNUMBER] = {0};
/*
BACKGROUND background1[BACKGROUNDNUMBER] = {
	0,	50,	1,	113,
	50,	0,	3,	113,
	0,	-50,	5,	113,
	-50,	0,	7,	113,
	55,	55,	9,	113,
	55,	-55,	11,	113,
	-55,	-55,	13,	113,
	-55,	55,	15,	113,
	0,	100,	17,	113,
	100,	0,	19,	113,
	0,	-100,	21,	113,
	-100,	0,	23,	113,
	100,	0,	25,	113,
	-100,	0,	27,	113,
};
*/
	
BACKGROUND background1[BACKGROUNDNUMBER] = {0};
int objectStack [OBJECTNUMBER] = {0};
int switchOnStack [OBJECTNUMBER] = {0};
int switchOffStack [OBJECTNUMBER] = {0};
int switchOnFlag = 0;
int switchOffFlag = 0;
int vexOnStack[OBJECTNUMBER] = {0};
int vexObjectFlag = 0;
int locateStack[OBJECTNUMBER] = {0};
int vexLocateFlag = 0;
/*
OBJECT object[OBJECTNUMBER +1] = {
	   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,0,0,0,
	   0, 100, 101,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0, 100, 101,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 100,   0, 102,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 100,   0, 102,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0,-100, 103,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0,-100, 103,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-100,   0, 104,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-100,   0, 104,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 105, 105, 105,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 105, 105, 105,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 105,-105, 106,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 105,-105, 106,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-105,-105, 107,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-105,-105, 107,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-105, 105, 108,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-105, 105, 108,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0, 200, 109,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0, 200, 109,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 200,   0, 110,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 200,   0, 110,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0,-200, 111,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0,-200, 111,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-200,   0, 112,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-200,   0, 112,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 141, 141, 113,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 141, 141, 113,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	 141,-141, 210,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-141,-141, 220,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	-141, 141, 220,   1,   1,   4,   4, 255, 255, 255, 100, 100, 100,   0,0,0,0,
	   0,  10,   1,   1,   3,   4,   4, 200,   0,   0, 100, 100, 100,   0,0,0,0,
	   0,   0,   1,   1,   6,   0,   0, 255,   0,   0,   0,   0,   0,   0,0,0,0,
};
*/	
OBJECT object[OBJECTNUMBER +1] = {0};
OBJECT klugeObject = {0}; /*for menu use*/
THRESHARRAY klugeThresh[FUNCOBJECT] = {0};
int klugeBackground = 0; /*ditto*/
int klugeObjectNumber = 0;
int klugeObjNumber = 0;
int klugeBackgroundNumber = 0;
BACKGROUND klugebg = {0};
int bkgd_lum = 128;
int bkgd_lumX = 200;
int old_bglum;
int correctTrials = 0;
int rwdtime = 110;
int orwdtime=300;
int whichreward=0;
int timeouttime=1;
int dimtime;

int fbrk = 0;  /* No of Fix Breaks */
int abttrl = 0; /* No of abort trials - ie. monkey did not start trial */ 
int hyes = 0; /* No of correct button presses by human */
int percent_cor = 0;  /* Will give % correct for whole session */
int tot_num_trials = 0; /* Total number of completed trials for whole session */


short int fpoffCode = GAP1CD;
/* global declarations*/
int thisWindow = -1;

int tablepointer[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,
31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50};

int shuff_array_max = 1; /* total number of tasks */ 

/* flags. usually a pair, one set by menu, the other copied 
 * locally per trial
 */

int sacCheckFlag = NO;
int nowincheckflag=NO;
int photoCancelFlag = NO;
int cueOnFlag = NO;
int cueBarRelease = NO;
int goodsacFlag = 0; 
int arrayIndex = 0;
int abortFlag = NO; /*can be set yes by anyone to halt a trial*/
int jmp1Flag = NO; /*used by main chain to signal if it wants
                           *a saccade trial*/
int falseflag = NO;
int local_jmp1Flag = NO; 
int jmp1cueflag = NO;
int jmp1cue2flag = NO;
int jmp2cueflag = NO;
int jmp2cue2flag = NO;
int local_cueflag = NO; /*used by main chain to signal if it wants
                           *a cue*/
int local_cue2flag = NO; 
int jmp2Flag = NO; /*used by main chain to signal if it wants
                           *a saccade trial*/
int jmp1Sacflag = NO;
int jmp2Sacflag = NO;

/* flags etc for jmp2Rwd */
int local_jmp2RwdFlag = NO;
int menu_jmp2RwdFlag = NO;
int jmp2RwdDelay = 0;
int menu_jmp2RwdDelay = 0;
int givejmp2Rwd = NO;

int local_jmp2Sacflag = NO;
int pulseFlag = NO;
int rfswitchflag = ON1;
int rfflag = NO;	/*used by main chain to signal if it wants*/
int rf2flag = NO;       /*a receptive field stimulus*/

   int newrfflag=0; /*suresh's kluge to enable rf on with fp*/
   int local_newrfflag=0;
   int new_fponflag=0;
   int new_trialFlag=0;
   int new_rfonflag=0;
   
   int trialOn=0;
   
   int monkeyhasacquired=0;
   int endonacquire=0;
   int startacquire=0;
   
   int mmnmenuon=0;
   int mgspercentage=100;
   int mmnpassiveflag=0;
   int mmnactiveflag=0;
   int mgsmenuflag=0;
   int basepattern=0;
   int basecheck=0;
   int basered=0;
   int basegreen=0;
   int baseblue=0;
   int devpattern=0;
   int devcheck=0;
   int devred=0;
   int devgreen=0;
   int devblue=0;
   int devprob=0;
   
   int epmenuflag=0;
   int j1num=1;
   int j1xarr[10]={0,0,0,0,0,0,0,0,0,0,0};
   int j1yarr[10]={0,0,0,0,0,0,0,0,0,0,0};
   int ep_fpxbegin=0;
   int ep_fpxinc=10;
   int ep_fpxnum=10;
   int ep_fpybegin=0;
   int ep_fpyinc=10;
   int ep_fpynum=10;
   int ep_jtargdur=100;
   int ep_fixdur=500;
   int ep_rf2del=100;
   int ep_fprand;
   int ep_j1rand;
   int ep_j1num;
   int ep_usestatic;
   int ep_j1xbegin; int ep_j1ybegin; int ep_j1xinc; int ep_j1yinc; int ep_j1xnum; int ep_j1ynum;
   
   int shufflenowflag=0;
   
   int chonkinflash=0;
   int chonkinflashon=0;
   int waschonkinflash=0;
   int chonkinflashontime=100;
   int chonkinflashofftime=100;
   int beepontime=100;

   int photowarn=0;
   int oneframemode=0;
   
   int etrandflag=0;
   int etvalper=0;
   
   int et_counter=0;
   int et_marker=0;
   int et_autoshuf=0;
   int isab=0; int isfb=0;
  
  long leftlatarray[10]={150,150,150,150,150,150,150,150,150,150};
  long rightlatarray[10]={150,150,150,150,150,150,150,150,150,150};
  int leftind=0;
  int rightind=0;
  long go_time=0;
  long fin_time=0;
  int lefttrial=0;
  int latcorrect=0;
  
  int angarray[7]={0,45,90,135,180,225,270,315};
  
   int rfHasAppeared=NO;
   int sureshrfoff=NO;
   int rfreallyappeared=NO;
   int prfonflag=NO;
   int wait_for_rfoff=NO;
   int askfpoff=0;
   
   int islast=0;
   
   int isrf3=1; int rf3object=25; /*setting up for mask*/
   int turnonrf3=1; int rf3turnedon=1; /*flags to monitor rf3*/
   
   int vexclean=0;
   int reflexive_sipercentage=0;
   
   int skippattern=0;
   int skipprop=0;
   int skipobj=0;
   int otherskipobj=0;
   int otherskipprop=0;
   int skipthisnum=1;
   int skipthisnumflag=1;
   
   int jittertim=0;
   int jitterprob=0;
   
   int rfnextval=250;
   int rfmap_rfdelay=100;
   int rfmap_rftime=50;
   int rfmap_trialtime=2000;
   int rfmap_numflashes=20;
   int seenflashes=0;
   int seenflashflag=NO;

int cuebarrwd = 0; /* If set (in state menu) this will give the given percent of the
	reward when monk releases bar in cuebar trials */
int cuebarrwd_flag = NO; /* used to go into reward loop */ 
int local_rfflag = NO;
   int rfdelayFlag=NO;
   int rfnextFlag=NO;
int local_rf2flag = NO;
int backon1flag = NO; 
int rfonflag = NO;
int rfon2flag = NO;
int local_backon1flag = NO; 
int jmp1CheckFlag = YES; /*flag to abort if first saccade 
				 *is not significant in double step*/

long local_cuedel=0; /* am using tosignal which cue delay is operating*/

int backon2flag = NO; 
int local_backon2flag = NO; 
int backonControlFlag = NO;
int trialFlag = NO;
int jmp1NowFlag = NO;
int jmp1WinNowFlag = NO;
int jmp1timer=50;
int jmp2NowFlag = NO;
int jmp2WinNowFlag = NO;
int gap1nowFlag = NO;
int sac1Flag = NO;
int sac2Flag = NO;
int barflag = NO;
int baroffflag = NO;
int cuebarflag = NO;
int minnoflash = 9;  /* This is the minimum cue threshold level that 
	cuebbarXFlag will not trigger. ie. levels 0-8 will have an error if
	the bar is not released, but levels 9 and up won't */
int cuebarXFlag = NO;
int sequenceflag = 0;
int windowflag = 0;
int noCheat = 75;
int shufflecount = 0;
int rewardflag = NO;

   int rfind=0;
   int rfxarr[8]={0,0,0,0,0,0,0,0
   };
   int rfyarr[8]={0,0,0,0,0,0,0,0
   };
   
   int rfrandmap=0;
   int rfxmin=0; int rfxmax=0; int rfxinc=0;
   int rfymin=0; int rfymax=0; int rfyinc=0;
   
   int rfPropertiesChanged=0;
   
/*   int rf_fourpos=0;
   int rf_fourposx=0;
   int rf_fourposy=0;
   int rf_fourposquad=0;
   
   int bigrewardquad=0;
   int bigrewardprob=0;
   int bigrewardval=100;
   int smallrewardval=50;*/

int mgsinc=45; int mgsecc=150; int mgstart=0;
   int mgseccinc=0; int mgseccnum=0;
   int mgsrand=1;
   int mgsnum=1;
int mgsj1delay=500; int mgsj1time=500;
int mgsrfdelay=50; int mgsrftime=50;
   int mgsrftimeinc=0;
   int mgsrftimenum=1;
   
   int oldrfx=0; int oldrfy=0;
   
   int mgsrfx=0; int mgsrfy=100;
   int mgsfpx=0; int mgsfpy=0; int mgsfpxinc=0; int mgsfpxnum=1;
   int mgsfpyinc=0; int mgsfpynum=1;
   
   int fprelflag=0;

   int twospotmenuflag=0;
   int twospot_rf2x=0;
   int twospot_rf2y=0;
   int twospot_rf2on=50;
   int twospot_rf2lat=100;
   int twospot_rf2inc=100;
   int twospot_rf2num=1;
   int twospot_rf2pat=111;
   int twospot_rf2check=6;
   int twospot_rf2fgr=255;
   int twospot_rf2fgg=255;
   int twospot_rf2fgb=255;
   int twospot_rfblankprob=5;
   int twospot_rfbakcheck=6;
   
   int turnonrequested=0;
   
   int showbuttOn=0;
   int ButtObject=13;
   int Buttimagestart=71;
   int Buttimageinc=1;
   int Buttimagenum=5;
   int Buttimagedur=500;

   
   int t_oldflag=1; /* i think this mapping is correct of flag to pat */
   int t_oldpat=29;
   int t_oldred=0;
   int t_oldgreen=0;
   int t_oldblue=0;
     
   int ttask_fpon=500;
   int ttask_fpinc=0;
   int ttask_fpnum=1;
   
   int ttask_menuon=0;
   int ttask_x=100;
   int ttask_y=100;
   int ttask_T2x=400;
   int ttask_T2y=400;
   
   int otherbarignore=0;
   int linkrftofp=0;
   
/*   int ttask_pop1=-1;
   int ttask_pop2=-1;
   int ttask_pop3=-1;*/
   
   int ttask_targlocstart=0;
   int ttask_targlocinc=0;
   int ttask_targlocnum=1;
   int ttask_poplocstart=0;
   int ttask_poplocinc=0;
   int ttask_poplocnum=1;
   int ttask_showallpops=0;
   
   int ttask_prob=50;
   int ttask_tprob=50;
   int ttask_tdur=1;
   
   int ttask_catchprob=0;
   int ttask_catchdimtime=0;
   int ttask_dimtime=0;

   int ttask_tcatchprob=0;
   int ttask_tcatchdur=0;
   int ttask_tdurinc=0;
   int ttask_tdurnum=1;
   int ttask_ofmode=1;
   int ttask_vexclean=1;
   int ttask_onetprob=0;
   int ttask_tpat=29;
   int ttask_itpat=28;
   
   int ttask_tred=255;
   int ttask_tgreen=255;
   int ttask_tblue=255;
   int ttask_itred=255;
   int ttask_itgreen=255;
   int ttask_itblue=255;
   
   int ttask_dpat=40;
   int ttask_mindpat=41;
   int ttask_maxdpat=48;
     int odist_prob=0;
     int ttask_odistart=1;
     int ttask_odistinc=0;
     int ttask_odistnum=1;

  int ttask_targpop=0;
  int ttask_stimnum=16;
  int ttask_pred=255;
  int ttask_pblue=255;
  int ttask_pgreen=255;
   
   int linemotionMenu=0;
   int linemotionRFon=50;
   int linemotionRFoninc=0;
   int linemotionRFonnum=1;
   int linemotionRFdelay=100;
   int linemotionRF2on=50;
   int linemotionRF2oninc=0;
   int linemotionRF2onnum=1;
   int linemotionRF2lat=100;
   int linemotionRF2latinc=0;
   int linemotionRF2latnum=0;
   int linemotionRFx=0;
   int linemotionRFy=0;
   int linemotionRFang=0;
   int linemotionRFoang=0;
   int linemotionRFoangprob=0;
   int linemotionRFlen=10;
   
   int linemotionDinprob=0;
   
   int linemotionRFleninc=0;
   int linemotionRFlennum=1;
   int linemotionRF2x=0;
   int linemotionRF2y=0;
   int linemotionRF2xinc=0;
   int linemotionRF2xnum=0;
   int linemotionRF2yinc=0;
   int linemotionRF2ynum=0;
   
   int linemotionRFwidth=10;
   int linemotionRFmidx=0;
   int linemotionRFmidy=0;
   int linemotionDisplace=0;
   int linemotionDisplaceDegs=0;
     int linemotionDisplaceDegsInc=0;
    int linemotionDisplaceDegsNum=0;
   int linemotionRF2prob=0;
   int linemotionRF1prob=0;
   int linemotionRF2pat=111;
   int linemotionRF2fgr=255;
   int linemotionRF2fgg=255;
   int linemotionRF2fgb=255;
   int linemotionRF2check=3;
   
   int tdistractorMenu=0;
   int fixrf2_wrt_rf=0;
   int tdistractorRFdelay=750;
   int tdistractorRFlatinc=0;
   int tdistractorRFlatnum=1;
   int tdistractorRF2on=50;
   int tdistractorRF2oninc=0;
   int tdistractorRF2onnum=1;
   int tdistractorRF2lat=100;
   int tdistractorRF2latinc=0;
   int tdistractorRF2latnum=1;
   int tdistractorx=100;
   int tdistractory=100;
   int tdistractorRF2prob=0;
   int tdistractorRF2pat=111;
   int tdistractorRF2fgr=255;
   int tdistractorRF2fgg=255;
   int tdistractorRF2fgb=255;
   int tdistractorRF2check=3;
   int tdistractorRF2num=1;
   int tdistractorRF2posprob=100;
  int tdistractorpredict=0;
  int tdist_dimlink=0;
   /* these contain the strings and integer arrays for listing of positions*/

/*   char slistfpx[300]="N";
   char slistrfx[900]="N";
   char slistrf2x[300]="N";
   char slistjumpx[300]="N";

   char slistfpy[300]="N";
   char slistrfy[300]="N";
   char slistrf2y[300]="N";
   char slistjumpy[300]="N";
 */
 
   int listfpx[300];
   int listrfx[300];
   int listrf2x[300];
   int listjumpx[300];
   
   int listfpy[300];
   int listrfy[300];
   int listrf2y[300];
   int listjumpy[300];
   
   int numlistfpxs=0;
   int numlistrfxs=0;
   int numlistrf2xs=0;
   int numlistjumpxs=0;
   
   int numlistfpys=0;
   int numlistrfys=0; 
   int numlistrf2ys=0;
   int numlistjumpys=0;
   
   int remap_menuon=0;
   int remap_fpx=0;
   int remap_fpy=0;
   int remap_fpxinc=0;
   int remap_fpxnum=0;
   int remap_fpyinc=0;
   int remap_fpynum=0;
   int remap_jumpx=200;
   int remap_jumpy=0;
   int remap_jumpxinc=0;
   int remap_jumpxnum=0;
   int remap_jumpyinc=0;
   int remap_jumpynum=0;
   int remap_rfx=0;
   int remap_rfy=0;
   int remap_rfxinc=0; int remap_rfyinc=0;
   int remap_rfxnum=1; int remap_rfynum=1;
   int remap_ojumpx=-200;
   int remap_ojumpy=0;
   int remap_ojumpxinc=0;
   int remap_ojumpxnum=0;
   int remap_ojumpyinc=0;
   int remap_ojumpynum=0;
   int remap_ojumprob=0;
   int remap_blankprob=0;
   int remap_jumpdelay=500;
   int remap_jumpdelay_inc=0;
   int remap_jumpdelay_num=1;
   int remap_trialtime=1500;
   int remap_jumptime=1000;
   int remap_ofmode=0;
   int remap_vexclean=0;
   int remap_windowdelay=500;
   
   int remap_rf2duration=3000;
   int remap_rf2durinc=0;
   int remap_rf2durnum=1;
   
   int rfduration=1;

   int rftimeinit=0;
   int rftimeinc=0;
   int rftimenum=1;
   

   int rffillFlag;
int rfchksize;
int rfchksizeinc;
int rfchksizenum;
int rffgr; int rffgg; int rffgb;
   
   int rflumnum;
   int rrfluminc; 
      int grfluminc; 
      int brfluminc; 
   
   int rfori;
   int rforinc;
   int rforinum;
   int rfstartpattern;
   int rfendpattern;
   int rflength; int rflengthinc; int rflengthnum;
   int rfwidth; int rfwidthinc; int rfwidthnum;
   
int rfnums;
int frfpattern;
int frfopattern1;
int frfopattern2;
int frfopatternprob;

/*   int rfxvec[128];
   int rfyvec[128];*/
   struct rff rffar[128];
   
   int rfnumlocs=0;
   int rflocind=0;

/* These are my new flag to deal with random jmp1 shifts -Suresh 3/4/03*/

int jRandFlag = 0; /*default is set to zero*/
int NumJmp1s=0; /*Need to set this from the MENU*/
int curNumJmp1s=0; /* will be set trial-by-trial*/
int r_jmp1NowFlag = YES;
int r_jmp1WinShiftFlag = NO;
int jRandINDEX = 0;
int jRandEndFlag=NO;
int randXArr[100]; /*UGLY UGLY UGLY: max of 100 jumps... kluge*/
int randYArr[100];
int jRandOver=0;
int MaxJmp1Size=150;

int fpRandSize=150;
int fpRandFlag=0;
int rfrandflag=0;
int barcodedrop=0;
/********
int continueflag = NO;
*/
int fpoffFlag = NO;
int fpgoneoff=NO;
int grassflag = NO;
int grassflag2 = NO;
int rfgrassflag = NO;
int rf2grassflag = NO;
int local_grassflag = NO;
int errorCorrectFlag = YES;
/*int righthand_off = 10;*/
int repeatFlagOn = YES;
int grassFreebieFlag = NO;
int goodFlag =YES;
   int mygoodFlag=YES;
int repeatFlag = NO;
int printArrayFlag = NO;
int printSacFlag = NO;
int photocellFlag = YES;
int humbutflag = NO;

int window_delay = 500;
int local_window_delay = 0;
int ramp_window_delay = 50;
int jmpCheckDelay = 50;
int local_jmpCheckDelay = 50;

int localPulsenum = 0;
int pulsenum = 0;
int grasscount = 0;
int grass_set = 0;
int testFlag = NO;
int flashFlag = NO; /* This will be error for cuebarflag */
int barflashFlag = NO; /* This is suresh's flash mechanism for barerrro*/
int localflashFlag = NO;
int localflashFlag2 = NO;
int beepFlag = NO;  /* Beep flag is NOW used to signal a fixation break */
		    /*   JB - 16/01/03 ***/
int localBeepFlag = NO;

int manyrfFlag=0;
int nobarcheck=0;
   int noeyecheck=0;
   int infowarn=0;

  int StopMapOnJump=0;
   
int rfwason=0;
int skipthis=0;
int numrfobjects=4;

int percorFlag = NO;
int disp_threshFlag = NO;
int resetit = NO; /* reset online percent correct */
int nogoflag = NO; /* indicates if current trial is a nogo trial */
int rfshuffleflag = NO;  /* This will indicate to shuffle rf locations */
int fixjmpcueflag = NO; /* Trials that have a random jmp delay component but
                    want a fixed time between cueon and gapon */

int docode = YES; /* When Jmp is used, but no stimulus is used, docode = NO
		i.e. Do not write the Code if there is no stimulus */

int truncationFlag = 0;
int hormov1 = 0;
int vermov1 = 0; /*desired saccade values*/
int hormov2 = 0;
int vermov2 = 0;
int fudge1h = 80;
int fudge2h = 80;
int fudge1v = 80;
int fudge2v = 80;
int BGLumFlag = NO;


int klugepointer;

/*DA control structs*/
DA_CNTRL_ARG mirrorOff[] =  {
	{0,DA_STBY,0},
	{1,DA_STBY,0},
	{2,DA_STBY,0},
	{3,DA_STBY,0}
};


/*inline device pointers*/
long testDevice = LED1;
long flashDevice = LED1;
long rewardDevice = REW;
long photooutDevice = PHOTOOUT;
long ampSwitch = AMP;
long grassDevice = STIM;
long beepDevice = BEEPER;

/*for menu usage*/
ARRAY kluge;
	
/*accessed by coordinate submenu*/
FUNCTION *fp = &kluge.fp;
FUNCTION *rf = &kluge.rf;
FUNCTION *rf2 = &kluge.rf2;
FUNCTION *jmp1 = &kluge.jmp1;
FUNCTION *jmp2 = &kluge.jmp2;
FUNCTION *rmp = &kluge.rmp;
FUNCTION *gap = &kluge.gap;
FUNCTION *cue = &kluge.cue;
FUNCTION *cue2 = &kluge.cue2;
FUNCTION *current  = &kluge.fp;
/*each FUNCTION has .x, .y, .device, device_dim, .control, .time, .delay values*/

int kluge_array_max;
int kluge_good;
int kluge_bad;
int kluge_array_index;
int kluge_array_number;
int kluge_grassflag;
int kluge_nogoflag;
int kluge_rfshuffleflag;
int kluge_fixjmpcueflag;
int kluge_barflag;
int kluge_baroffflag;
int kluge_cuebarflag;
int kluge_rf_flag;
int kluge_rf2_flag;
int kluge_cueflag;
int kluge_cue2flag;
int kluge_jmp1cueflag;
int kluge_jmp2cueflag;
int kluge_jmp1cue2flag;
int kluge_jmp2cue2flag;
int kluge_jmp2sacflag;
int kluge_jmp1Flag;
int kluge_jmp2Flag;
int kluge_backon1flag;
int kluge_backon2flag;

int kluge_fpRandFlag;
int kluge_fpRandSize;
   
/*int kluge_jRandFlag;*/
int kluge_descriptor[DESCRIPTORSIZE];

/*spare array for saving values*/
char arg0[8]  = {0};	
char arg1[8]  = {0};	
char arg2[8]  = {0};	
char arg3[8]  = {0};	
char arg4[8]  = {0};	
char arg5[8]  = {0};	
char arg6[8]  = {0};	
char arg7[8]  = {0};	
char arg8[8]  = {0};	
char arg9[8]  = {0};	

/*function prototypes*/
/*vex function declarations*/
/* int locateObject(char *count, int objectNumber, int objectx, int objecty); */
int vexbackoff();/*JG*/
int backoffcheck();/*JG*/
int rand();
void srand();
int awind(long code);
char *tgscup(int line, int cold, char *sp, char *ep);
void tputs (char *p);
char *itoa(int value, char *buffer, int radix);
int start_check() ;
int bar_check();
int fork_check();
int fork_check2();
int fixcuetime();
   int hasheacquired();
int dimbar_check();
int window_check();
int dimerrorcheckfn();
int abortCheck() ;
int vexbackoff();
int backoffcheck();
void shuffle();
void readshuffle();

void sendVex(int vex_number);
int allOffStuff();
int clearScreen();
void makeVexObject(int objectNumber);
int vexClearStuff();
int vexLocateStuff();
int objDoneStuff();
int makeObjStuff();
void switchObject(unsigned char *count, int objectNumber, unsigned char onOrOff);
int locateObject(unsigned char *count, int objectNumber, int objectx, int objecty);
int vexLocateCheck();
int vexObjCheck();
int vexAllOffCheck();
int minvexFlagCheck();

int vexPhotoStuff();
   int waitingForRf();
/*int photoClear1();
int photoClear2(); James commented out*/
int sendVexNow();
int sendVexNowB();
int startStuff();
int backon1FlagCheck();
int backon2FlagCheck();
int backon1Check();
int backon2Check();
int backon1WaitStuff();
int backon2WaitStuff();
int backon1OnStuff();
int backon2OnStuff();
int cheatCheck();
int cueOnStuff();
int cue2OnStuff();
void makeObjDelta(int *objlist, int xdelta, int ydelta, int objectNumber);
void switchbg();
int rfonStuff();
int rfshuf();
int rf2onStuff();
int rfoffStuff();
int bugprint();

/*   int debugprint();
   int debugprintB();
  int debugprintC();*/

int suresh_turnsoff_rf();
int rf2offStuff();
int cueOffStuff();
int cue2OffStuff();
int cueDelayStuff();
int cue2DelayStuff();
int rfdelayStuff();
int rf2delayStuff();
int interStuff();
int intertrialStuff();
int trialwaitStuff();
int fponStuff();
int barfpon();
int dimStuff();
int jmp1delayStuff();
int setlocal_cueflag();
int gap1Stuff();
int jmp1onStuff();
int jmp1offStuff();
int jmp1WinCheck();
int jmp1WinStuff();
int jmp2WinStuff();
int gap2Stuff();
int jmp2onStuff();
int jmp2offStuff();
int grassonStuff();
int grassZapStuff();
int grassUnzapStuff();
int rewardStuff();
int dimonStuff();
int reward1Stuff();
int rewardOffStuff();

  int StopOnJump();
   int CopyMyString(char* str1, char* str2, int numchar);
   int ParseMyString(char* str1, int* arr1, int numints);
   int ShowArr(char* str1, int* arr1, int numlists );

int MMNStuff();   
int mgsStuff();
   int twospotOnceStuff();
   int twospotRepStuff();
   int epStuff();
   int linemotionStuff();
  int tdistractorStuff();
   int infowarnMe();
   
int remapStuff();
   int ttaskStuff();
   int ShowbuttStuff();
   int FillRF();
   int manyRFstuff();
   
int nostart();  /* if monkey doesn't initiate trial */
int dimerrorStuff();
int barerrorStuff();

int hum_resp_check();
int check_answer();
int humrightstuff();

int fbStuff(); /* Fixation Break */

int errorStuff();
int flashwaitStuff();
int flashOnStuff();
  int displaybutt();
  int turnoffbutt();
int chonkinflashCheck();
int flashOffStuff();
int cflashOnStuff();
int cflashOffStuff();
   int cbeepOffStuff();

int testOnStuff();
int testOffStuff();
int lastThings();
int sacStartStuff();
int sacWaitStuff();
int sacEndStuff();

void rinitf(void);

int checkarray(char *astr);
int *getXVptr(char name, int *number);
int *getXptr (char name, int base);
int *getYptr (char name, int base);
void makeObjAngle (char name, double angle);
void makeAngle(char name, double angle); /*make a vector from 0 to  array 0*/
void transpose(char name);
void makeLinear(char name, double delta);
void makeSquare(char name, int delta);
void makeObjSquare(int delta, int choice);
void n_object(char *vstr, char *astr);
void n_array(char *vstr, char *astr);
void poslistproc(char poslist[1000]);
void deviceCheck(FUNCTION *func); 
firstcheck(char *astr);
objcheck(char *astr);

/*here follows all of the menu stuff*/

/*menu3.d, contains only menu related functions: menus, nouns, fills, mafs, vafs, rgfs*/

/* VLIST declarations */

VLIST rfobjects_vl[];
VLIST cr_vl[];
VLIST cg_vl[];
VLIST cb_vl[];
VLIST fgr_vl[];
VLIST fgg_vl[];
VLIST fgb_vl[];
VLIST rchecksizes_vl[];
VLIST cchecksizes_vl[];
VLIST patterns_vl[];
VLIST yrfobjects_vl[];
VLIST ycueobjects_vl[];
VLIST tv1_vl[];
VLIST tv2_vl[];
VLIST tp1_vl[];
VLIST tp2_vl[];
VLIST xrfobjects_vl[];
VLIST xcueobjects_vl[];
VLIST bgr_vl[];
VLIST bgg_vl[];
VLIST bgb_vl[];
VLIST rmode_vl[];
VLIST rv1_vl[];   /* angle for VEX_BAR, outer for ANNULUS */
VLIST rv2_vl[];   /* width for VEX_BAR, inner for ANNULUS */
VLIST rv3_vl[];   /* length for VEX_BAR */
VLIST tlink_vl[];
VLIST rf2objects_vl[];
VLIST jmp1objects_vl[];
VLIST jmp2objects_vl[];
VLIST cueobjects_vl[];
VLIST cue2objects_vl[];
VLIST devices_vl[];
VLIST saccades_vl[];
VLIST array_vl[];
VLIST descriptor_vl[];
VLIST limit_vl[];
VLIST objects_vl[];
VLIST robjects_vl[];
VLIST backgrounds_vl[];
VLIST perf_vl[];
VLIST times_vl[];
VLIST cue_vl[];
VLIST cue2_vl[];
VLIST gap_vl[];
VLIST rf_vl[];
VLIST rf2_vl[];
VLIST jmp1_vl[];
VLIST jmp2_vl[];
VLIST fp_vl[];
VLIST ramp_vl[];
VLIST interface_vl[];
VLIST flags_vl[];
VLIST cflags_vl[];
VLIST state_vl[];
VLIST listest_vl[];
VLIST assorted_vl[];
VLIST rfmap_vl[];
   VLIST rfFill_vl[];
VLIST MMN_vl[];
VLIST mgs_vl[];
VLIST twospot_vl[];
VLIST ep_vl[];
VLIST linemotion_vl[];
VLIST tdistractor_vl[];
VLIST remapping_vl[];
VLIST randpos_vl[];
VLIST TTask_vl[];
VLIST VSrch_vl[];   
VLIST Showbutt_vl[];
   
/*MENU declarations*/
MENU rxfobjects;
MENU robjects;
MENU cobjects;
MENU bgrs;
MENU bggs;
MENU bgbs;
MENU rcs;
MENU gcs;
MENU bcs;
MENU rmode;
MENU rv1;
MENU rv2;
MENU rv3;
MENU tlink;
MENU fgrs;
MENU fggs;
MENU fgbs;
MENU rxchecksizes;
MENU cxchecksizes;
MENU rxpatterns;
MENU cpatterns;
MENU yrfobjects;
MENU ycueobjects;
MENU xrfobjects;
MENU tv1;
MENU tv2;
MENU tp1;
MENU tp2;
MENU cxueobjects;
MENU rxf2objects;
MENU cxue2objects;
MENU jxmp1objects;
MENU jxmp2objects;
MENU objects;
MENU robjects;
MENU object0;
MENU object1;
MENU performance;
MENU backgrounds;
MENU saccades;
MENU devices;
MENU state;
MENU listest;
MENU rfmap;
   MENU rfFill;
MENU MMN;
MENU mgs;
   MENU twospot;
   MENU ep;
   MENU linemotion;
   MENU tdistractor;
   MENU remapping;
   MENU randpos;
   MENU TTask;
   MENU VSrch;
   MENU Showbutt;
MENU assorted;
MENU flags;
MENU cflags;
MENU interface;
MENU times;
MENU limit;
MENU descriptor;

/*maf prototypes*/
int maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int flags_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int objects_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int object0_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int object1_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int backgrounds_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int descriptor_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int state_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int listest_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int assorted_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int MMN_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
   int mgs_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
   int twospot_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
   int ep_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
      int remapping_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
   int randpos_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
   int TTask_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int VSrch_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);   
   int Showbutt_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int rfmap_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
int rfFill_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp);
   
/*vaf prototypes*/

int objects_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int compareobject(OBJECT *from, OBJECT *to);
int object0_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int object1_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int backgrounds_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int bgobject0_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int bgobject1_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int bglum_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rwdtime_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
/*int listpos_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);*/
int dimtime_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int timeouttime_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int kluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int okluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int ckluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int fkluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rfobj_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rfobjx_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int fpcontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rfcontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rf2control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int cuecontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int cue2control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rmpcontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp1control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int array_max_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int array_index_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int joyh_gain_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int joyh_offset_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int joyv_gain_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int joyv_offset_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int descriptor_4_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int descriptor_5_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int descriptor_6_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int descriptor_7_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int grassflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rf_flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int nogoflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int fixjmpcueflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int rf2_flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2sacflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2RwdFlag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2RwdDelay_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int backon1flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int backon2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp1cueflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2cueflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp1cue2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2cue2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp1flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int jmp2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
int fprand_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);
/*int jrandflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);*/
int cuebarflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd);

/*fill prototypes*/

void fillobject(char name, int pf_flag);
void fillarray(char name, int pf_flag);
void duparray(char name, int pf_flag); /* Only used for (p)f e a */
void duplicate(char *name, char *from, char *to);
void filldevice(char name, int pf_flag);
void fillcontrol(char name, int pf_flag);
void fillwindow(char name, int pf_flag);
void filldelay(char name, int pf_flag);
void filltime(char name, int pf_flag);
void fillthresh(char name, int pf_flag);
void fillinterface(char name, int pf_flag);
void fillarrobject(char name, int pf_flag);
void fillarrobj(char name, int pf_flag);
void fillnumber_of_Objects(char name, int pf_flag);
void fill(char name);

/*rgf prototypes*/

int array_rgf(int call_cnt, MENU *mp, char *astr);
int nbit_rgf(int call_cnt, MENU *mp, char *astr);
int objects_rgf(int call_cnt, MENU *mp, char *astr);
int robjects_rgf(int call_cnt, MENU *mp, char *astr);
int backgrounds_rgf(int call_cnt, MENU *mp, char *astr);
int objectArray_rgf(int call_cnt, MENU *mp, char *astr);
/*here follow noun and verb functions*/

int checkarray(char *astr) {
	/*check to see if astr is a valid array name*/
	if (*astr == '\0') {
		rxerr("int: NO file name");
		return(-1);
	}
	if ((astr[0] !='a') || (astr[1] != 'r') || (astr[2] != 'r')) {
		rxerr("int: Array files must begin with 'arr'");
		return (-1);
	}
	return(1);
}

#pragma off (unreferenced)
	/*here follow the parts of n_object*/
void
fillobject(char name, int pf_flag) {
	/*fills all instances of a given object entry with the object[0] value*/
	/* or fills the rest of the objects with the current object values */
	/* if a partial fill 'pf ob ...' */
	int n, start;
	char wop[10];

	if (pf_flag == 0)
		start = 1;
	else
		start = klugepointer;

	switch (name) {
	case 's':
		for (n = start; n < objNumber+1;n++) {
			object[n].sign= object[start].sign;
		}
		break;
	case 'c':
		for (n = start; n < objNumber+1;n++) {
			object[n].checksize= object[start].checksize;
		}
		break;
	case '0':
		for (n = start; n < objNumber+1;n++) {
			object[n].fgl= object[start].fgl;
		}
		break;
	case '1':
		for (n = start; n < objNumber+1;n++) {
			object[n].fgr= object[start].fgr;
		}
		break;
	case '2':
		for (n = start; n < objNumber+1;n++) {
			object[n].fgg= object[start].fgg;
		}
		break;
	case '3':
		for (n = start; n < objNumber+1;n++) {
			object[n].fgb= object[start].fgb;
		}
		break;
	case '4':
		for (n = start; n < objNumber+1;n++) {
			object[n].bgl= object[start].bgl;
		}
		break;
	case '5':
		for (n = start; n < objNumber+1;n++) {
			object[n].bgr= object[start].bgr;
		}
		break;
	case '6':
		for (n = start; n < objNumber+1;n++) {
			object[n].bgg= object[start].bgg;
		}
		break;
	case '7':
		for (n = start; n < objNumber+1;n++) {
			object[n].bgb= object[start].bgb;
		}
		break;
	case 'p':
		for (n = start; n < objNumber+1;n++) {
			object[n].pattern= object[start].pattern;
		}
	case 'm':
		for (n = start; n < objNumber+1;n++) {
			object[n].mode= object[start].mode;
		}
		break;
	case 'o':
		for (n = start; n < objNumber+1;n++) {
			object[n].var1= object[start].var1;
		}
		break;
	case 'i':
		for (n = start; n < objNumber+1;n++) {
			object[n].var2= object[start].var2;
		}
		break;
	case 'l':
		for (n = start; n < objNumber+1;n++) {
			object[n].var3= object[start].var3;
		}
		break;

	case 'a':
		rxerr("fill all object\n");
		fillobject('c', pf_flag);
		fillobject('s', pf_flag);
		fillobject('0', pf_flag);
		fillobject('1', pf_flag);
		fillobject('2', pf_flag);
		fillobject('3', pf_flag);
		fillobject('4', pf_flag);
		fillobject('5', pf_flag);
		fillobject('6', pf_flag);
		fillobject('7', pf_flag);
		fillobject('m', pf_flag);
		fillobject('p', pf_flag);
		fillobject('o', pf_flag);
		fillobject('i', pf_flag);
		fillobject('l', pf_flag);
		break;
	} /*switch(type)*/
}
#pragma off (unreferenced)
	/*here follow the parts of n_array*/

void 
duplicate(char *name, char *from, char *to) {

/* Sets all parameters in Fn array 'to' with those from
		Fn array 'from' */

	int f, t;
	
	f = atoi(from);
	t = atoi (to);
	switch (*name) {


		case 'f': /* copies fp from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].fp = array.tbl[f].fp;
		break;


		case 'r': /* copies rf from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].rf = array.tbl[f].rf;
		break;


		case 'R': /* copies rf2 from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].rf2 = array.tbl[f].rf2;
		break;


		case 'j': /* copies jmp1 from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].jmp1 = array.tbl[f].jmp1;
		break;


		case 'J': /* copies jmp2 from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].jmp2 = array.tbl[f].jmp2;
		break;


		case 'c': /* copies cue from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].cue = array.tbl[f].cue;
		break;

		case 'C':  /* copies cue2 from array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE))
			rxerr("argument too large to duplicate struct");
		else array.tbl[t].cue2 = array.tbl[f].cue2;
		break;

		case 'a': /* copies whole array 'f' to array 't' */
		if (( f >= ARRAYSIZE) || (t >= ARRAYSIZE)) 
			rxerr("argument too large to duplicate struct");
		 else array.tbl[t] = array.tbl[f];
		break;



	} /* Switch */
}

void
fillarray(char name, int pf_flag) {
	/*fills all instances of a given array entry with the array.tbl[0] value*/
	int n, start;
	char wop[10];

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.x = array.tbl[start].fp.x;
			array.tbl[n].fp.y = array.tbl[start].fp.y;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.obj[0].x = array.tbl[start].rf.obj[0].x;
			array.tbl[n].rf.obj[0].y = array.tbl[start].rf.obj[0].y;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.obj[0].x = array.tbl[start].rf2.obj[0].x;
			array.tbl[n].rf2.obj[0].y = array.tbl[start].rf2.obj[0].y;
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.obj[0].x = array.tbl[start].jmp1.obj[0].x;
			array.tbl[n].jmp1.obj[0].y = array.tbl[start].jmp1.obj[0].y;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.obj[0].x = array.tbl[start].jmp2.obj[0].x;
			array.tbl[n].jmp2.obj[0].y = array.tbl[start].jmp2.obj[0].y;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.obj[0].x = array.tbl[start].cue.obj[0].x;
			array.tbl[n].cue.obj[0].y = array.tbl[start].cue.obj[0].y;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.obj[0].x = array.tbl[start].cue2.obj[0].x;
			array.tbl[n].cue2.obj[0].y = array.tbl[start].cue2.obj[0].y;
		}
		break;
	case 'l':
		for (n = start; n < array.array_max; n++) 
			array.tbl[n].flag = array.tbl[start].flag;
			array.tbl[n].jmp2RwdFlag = array.tbl[start].jmp2RwdFlag;
		break;

	case 'g':
		for (n = start; n < array.array_max; n++){ 
			array.tbl[n].gap.time = array.tbl[start].gap.time;
			array.tbl[n].gap.delay = array.tbl[start].gap.delay;
			array.tbl[n].gap.windowx = array.tbl[start].gap.windowx;
			array.tbl[n].gap.windowy = array.tbl[start].gap.windowy;
		} /*end for loop*/
		break;


	case 'a':
		fillarray('f', pf_flag);
		fillarray('r', pf_flag);
	        fillarray('R', pf_flag);
		fillarray('j', pf_flag);
		fillarray('J', pf_flag);
		fillarray('c', pf_flag);
		fillarray('C', pf_flag);
		fillarray('l', pf_flag);
		break;
	} /*switch(type)*/
}

void
duparray(char name, int pf_flag) {
	/*fills all arrays with all the variables from a given array (0 or start)*/
	int n, start;
	char wop[10];
	char st[5];
	char num[5];

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	itoa(start, st, 10);
	switch (name) {
	case 'f':
	case 'r':
	case 'R':
	case 'j':
	case 'J':
	case 'c':
	case 'C':
	case 'a':
		for (n = start; n < array.array_max; n++) {
			itoa(n, num, 10);
			duplicate(&name,st,num);
		}
		break;
	} /*switch(type)*/
}


void
filldevice(char name, int pf_flag) {
	/*fills all instances of a given array device with the array.tbl[0] value*/
	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.device = array.tbl[start].fp.device;
			array.tbl[n].fp.device_dim = array.tbl[start].fp.device_dim;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.device = array.tbl[start].rf.device;
			array.tbl[n].rf.device_dim = array.tbl[start].rf.device_dim;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.device = array.tbl[start].rf2.device;
			array.tbl[n].rf2.device_dim = array.tbl[start].rf2.device_dim;
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.device = array.tbl[start].jmp1.device;
			array.tbl[n].jmp1.device_dim = array.tbl[start].jmp1.device_dim;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.device = array.tbl[start].jmp2.device;
			array.tbl[n].jmp2.device_dim = array.tbl[start].jmp2.device_dim;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.device = array.tbl[start].cue.device;
			array.tbl[n].cue.device_dim = array.tbl[start].cue.device_dim;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.device = array.tbl[start].cue2.device;
			array.tbl[n].cue2.device_dim = array.tbl[start].cue2.device_dim;
		}
		break;
	case 'a':
		filldevice('f', pf_flag);
		filldevice('r', pf_flag);
	        filldevice('R', pf_flag);
		filldevice('j', pf_flag);
		filldevice('J', pf_flag);
		filldevice('c', pf_flag);
		filldevice('C', pf_flag);
		break;
	} /*switch(type)*/
}

void
fillcontrol(char name, int pf_flag) {
/*fills all instances of a given array control flag with the array.tbl[start] value*/
	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.control = array.tbl[start].fp.control;
			if (array.tbl[n].fp.control < VEXARRAY)
				array.tbl[n].fp.interface = BLUEBOX;
			else array.tbl[n].fp.interface = TV;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.control = array.tbl[start].rf.control;
			if (array.tbl[n].rf.control < VEXARRAY)
				array.tbl[n].rf.interface = BLUEBOX;
			else array.tbl[n].rf.interface = TV;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.control = array.tbl[start].rf2.control;
			if (array.tbl[n].rf2.control < VEXARRAY)
				array.tbl[n].rf2.interface = BLUEBOX;
			else array.tbl[n].rf2.interface = TV;
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.control = array.tbl[start].jmp1.control;
			if (array.tbl[n].jmp1.control < VEXARRAY)
				array.tbl[n].jmp1.interface = BLUEBOX;
			else array.tbl[n].jmp1.interface = TV;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.control = array.tbl[start].jmp2.control;
			if (array.tbl[n].jmp2.control < VEXARRAY)
				array.tbl[n].jmp2.interface = BLUEBOX;
			else array.tbl[n].jmp2.interface = TV;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.control = array.tbl[start].cue.control;
			if (array.tbl[n].cue.control < VEXARRAY)
				array.tbl[n].cue.interface = BLUEBOX;
			else array.tbl[n].cue.interface = TV;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.control = array.tbl[start].cue2.control;
			if (array.tbl[n].cue2.control < VEXARRAY)
				array.tbl[n].cue2.interface = BLUEBOX;
			else array.tbl[n].cue2.interface = TV;
		}
		break;
	case 'a':
		fillcontrol('f', pf_flag);
		fillcontrol('r', pf_flag);
                fillcontrol('R', pf_flag);
		fillcontrol('j', pf_flag);
		fillcontrol('J', pf_flag);
		fillcontrol('c', pf_flag);
		fillcontrol('C', pf_flag);
		break;
	} /*switch(type)*/
}

void
fillwindow(char name, int pf_flag) {
/*fills all instances of a given array device with the array.tbl[start] value*/
	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.windowx = array.tbl[start].fp.windowx;
			array.tbl[n].fp.windowy = array.tbl[start].fp.windowy;
		}
		break;
        case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.windowx = array.tbl[start].rf.windowx;
			array.tbl[n].rf.windowy = array.tbl[start].rf.windowy;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.windowx = array.tbl[start].rf2.windowx;
			array.tbl[n].rf2.windowy = array.tbl[start].rf2.windowy;
		}
		break;

	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.windowx = array.tbl[start].jmp1.windowx;
			array.tbl[n].jmp1.windowy = array.tbl[start].jmp1.windowy;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.windowx = array.tbl[start].jmp2.windowx;
			array.tbl[n].jmp2.windowy = array.tbl[start].jmp2.windowy;
		}
		break;
	case 'a':
		fillwindow('f', pf_flag);
		fillwindow('r', pf_flag);
                fillwindow('R', pf_flag);
		fillwindow('j', pf_flag);
		fillwindow('J', pf_flag);
		break;
	} /*switch(type)*/
}

void
fillnumber_of_Objects(char name, int pf_flag) {
/*fills all instances of a given array device with the array.tbl[start] value*/
	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
        case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.objectNumber = array.tbl[start].rf.objectNumber;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.objectNumber = array.tbl[start].rf2.objectNumber;
		}
		break;
 
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.objectNumber = array.tbl[start].cue.objectNumber;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.objectNumber = array.tbl[start].cue2.objectNumber;
		}
		break;


	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.objectNumber = array.tbl[start].jmp1.objectNumber;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.objectNumber = array.tbl[start].jmp2.objectNumber;
		}
		break;
	case 'a':
		fillwindow('r', pf_flag);
                fillwindow('R', pf_flag);
		fillwindow('c', pf_flag);
                fillwindow('C', pf_flag);
		fillwindow('j', pf_flag);
		fillwindow('J', pf_flag);
		break;
	} /*switch(type)*/
}

void
filldelay(char name, int pf_flag) {
/*fills all instances of a given array delay with the array.tbl[start] value*/
/*  NB: If filling jmp1, then it will also fill jmp1.falsereward, which
 *	is the delay time added on randomly */


	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.delay = array.tbl[start].fp.delay;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.delay = array.tbl[start].rf.delay;
		}
		break;
        case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.delay = array.tbl[start].rf2.delay;
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.delay = array.tbl[start].jmp1.delay;
			array.tbl[n].jmp1.falsereward = array.tbl[start].jmp1.falsereward;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.delay = array.tbl[start].jmp2.delay;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.delay = array.tbl[start].cue.delay;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.delay = array.tbl[start].cue2.delay;
		}
		break;
	case 'a':
		filldelay('f', pf_flag);
		filldelay('r', pf_flag);
		filldelay('R', pf_flag);
		filldelay('j', pf_flag);
		filldelay('J', pf_flag);
		filldelay('c', pf_flag);
		filldelay('C', pf_flag);
		break;
	} /*switch(type)*/
}

void
fillthresh(char name, int pf_flag) {
/* This fills all threshold variables - tv* and tp* (NB:tl is part of the
 * object struct) with theÿthreshold variables from array.tbl[start] value.
 * It also fills the 'staircase_size' variable of cue.counter. */

	int n, start;
	int i;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'c':
		for (n = start; n < array.array_max; n++) {
			for (i = 0; i < FUNCOBJECT; i++) {
				array.tbl[n].cue.thresh[i] = array.tbl[start].cue.thresh[i];
			}
			array.tbl[n].cue.counter = array.tbl[start].cue.counter;
		}
		break;
	} /*switch(type)*/
}

void
filltime(char name, int pf_flag) {
/*fills all instances of a given array time with the array.tbl[start] value*/
	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.time = array.tbl[start].fp.time;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.time = array.tbl[start].rf.time;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.time = array.tbl[start].rf2.time;
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.time = array.tbl[start].jmp1.time;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.time = array.tbl[start].jmp2.time;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.time = array.tbl[start].cue.time;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.time = array.tbl[start].cue2.time;
		}
		break;
	case 'a':
		filltime('f', pf_flag);
		filltime('r', pf_flag);
                filltime('R', pf_flag);
		filltime('j', pf_flag);
		filltime('J', pf_flag);
		filltime('c', pf_flag);
		filltime('C', pf_flag);
		break;
	} /*switch(type)*/
}

void
fillinterface(char name, int pf_flag) {
	/*fills all instances of a given array interface with the array.tbl[0] value*/
	int n, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.interface = array.tbl[start].fp.interface;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf.interface = array.tbl[start].rf.interface;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].rf2.interface = array.tbl[start].rf2.interface;
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp1.interface = array.tbl[start].jmp1.interface;
		}
		break;
	case 'J':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].jmp2.interface = array.tbl[start].jmp2.interface;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue.interface = array.tbl[start].cue.interface;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].cue2.interface = array.tbl[start].cue2.interface;
		}
		break;
	case 'a':
		fillinterface('f', pf_flag);
		fillinterface('r', pf_flag);
                fillinterface('R', pf_flag);
		fillinterface('j', pf_flag);
		fillinterface('J', pf_flag);
		fillinterface('c', pf_flag);
		fillinterface('C', pf_flag);
		break;
	} /*switch(type)*/
}

void
fillarrobj(char name, int pf_flag) {
	/*fills all instances of a given array object with the array.tbl[0] value*/
	int n,i, start;

		start = 0;  /* you cannot partial fill objects within an array */

	switch (name) {
	case 'f':
		for (n = start; n < array.tbl[arrayIndex].fp.objectNumber; n++) {
			array.tbl[arrayIndex].fp.obj[n] = array.tbl[arrayIndex].fp.obj[0];
		}
		break;
	case 'r':
		for (n = start; n < array.tbl[arrayIndex].rf.objectNumber; n++) {
			array.tbl[arrayIndex].rf.obj[n] = array.tbl[arrayIndex].rf.obj[0];
		}
		break;
	case 'R':
		for (n = start; n < array.tbl[arrayIndex].rf2.objectNumber; n++) {
			array.tbl[arrayIndex].rf2.obj[n] = array.tbl[arrayIndex].rf2.obj[0];
		}
		break;
	case 'j':
		for (n = start; n < array.tbl[arrayIndex].jmp1.objectNumber; n++) {
			array.tbl[arrayIndex].jmp1.obj[n] = array.tbl[arrayIndex].jmp1.obj[0];
		}
		break;
	case 'J':
		for (n = start; n < array.tbl[arrayIndex].jmp2.objectNumber; n++) {
			array.tbl[arrayIndex].jmp2.obj[n] = array.tbl[arrayIndex].jmp2.obj[0];
		}
		break;
	case 'c':
		for (n = start; n < array.tbl[arrayIndex].cue.objectNumber; n++) {
			array.tbl[arrayIndex].cue.obj[n] = array.tbl[arrayIndex].cue.obj[0];
		}
		break;
	case 'C':
		for (n = start; n < array.tbl[arrayIndex].cue2.objectNumber; n++) {
			array.tbl[arrayIndex].cue2.obj[n] = array.tbl[arrayIndex].cue2.obj[0];
		}
		break;
	case 'a':
		fillarrobj('f', pf_flag);
		fillarrobj('r', pf_flag);
	        fillarrobj('R', pf_flag);
		fillarrobj('j', pf_flag);
		fillarrobj('J', pf_flag);
		fillarrobj('c', pf_flag);
		fillarrobj('C', pf_flag);
		break;
	} /*switch(type)*/
}
void
fillarrobject(char name, int pf_flag) {
	/*fills all instances of a given array object with the array.tbl[0] value*/
	int n,i, start;

	if (pf_flag == 0)
		start = 0;
	else
		start = klugepointer;

	switch (name) {
	case 'f':
		for (n = start; n < array.array_max; n++) {
			array.tbl[n].fp.object[0] = array.tbl[start].fp.object[0];
			array.tbl[n].fp.object_dim = array.tbl[start].fp.object_dim;
			array.tbl[n].fp.objectNumber = array.tbl[start].fp.objectNumber;
		}
		break;
	case 'r':
		for (n = start; n < array.array_max; n++) {
		   array.tbl[n].rf.objectNumber = array.tbl[start].rf.objectNumber;
		   for (i = 0; i < array.tbl[start].rf.objectNumber; i++)
			array.tbl[n].rf.object[i] = array.tbl[start].rf.object[i];
		array.tbl[n].rf.object_dim = array.tbl[start].rf.object_dim;
		}
		break;
	case 'R':
		for (n = start; n < array.array_max; n++) {
	  	   array.tbl[n].rf2.object_dim = array.tbl[start].rf2.object_dim;
		   for (i = 0; i < array.tbl[start].rf2.objectNumber; i++)
			array.tbl[n].rf2.object[i] = array.tbl[start].rf2.object[i];
		}
		break;
	case 'j':
		for (n = start; n < array.array_max; n++) {
		array.tbl[n].jmp1.objectNumber = array.tbl[start].jmp1.objectNumber;
		   for (i = 0; i < array.tbl[start].jmp1.objectNumber; i++)
			array.tbl[n].jmp1.object[i] = array.tbl[start].jmp1.object[i];
			array.tbl[n].jmp1.object_dim = array.tbl[start].jmp1.object_dim;
		}
		break;
	case 'J':
		array.tbl[n].jmp2.objectNumber = array.tbl[start].jmp2.objectNumber;
		for (n = start; n < array.array_max; n++) {
		   for (i = 0; i < array.tbl[start].jmp2.objectNumber; i++)
			array.tbl[n].jmp2.object[i] = array.tbl[start].jmp2.object[i];
		   array.tbl[n].jmp2.object_dim = array.tbl[start].jmp2.object_dim;
		}
		break;
	case 'c':
		for (n = start; n < array.array_max; n++) {
		array.tbl[n].cue.objectNumber = array.tbl[start].cue.objectNumber;
		   for (i = 0; i < array.tbl[start].rf.objectNumber; i++)
			array.tbl[n].cue.object[i] = array.tbl[start].cue.object[i];
		   array.tbl[n].cue.object_dim = array.tbl[start].cue.object_dim;
		}
		break;
	case 'C':
		for (n = start; n < array.array_max; n++) {
		array.tbl[n].cue2.objectNumber = array.tbl[start].cue2.objectNumber;
		   for (i = 0; i < array.tbl[start].rf.objectNumber; i++)
			array.tbl[n].cue2.object[i] = array.tbl[start].cue2.object[i];
		   array.tbl[n].cue2.object_dim = array.tbl[start].cue2.object_dim;
		}
		break;
	case 'a':
		fillarrobject('f', pf_flag);
		fillarrobject('r', pf_flag);
	        fillarrobject('R', pf_flag);
		fillarrobject('j', pf_flag);
		fillarrobject('J', pf_flag);
		fillarrobject('c', pf_flag);
		fillarrobject('C', pf_flag);
		break;
	} /*switch(type)*/
}
int 
*getXVptr(char name, int *number) 
{
	int *pointer = NP;
	if (name == 'r') {
		pointer = &array.tbl[array.array_index].rf.object[0];
		*number =  array.tbl[array.array_index].rf.objectNumber;
	}
	else if (name == 'R') {
		pointer = &array.tbl[array.array_index].rf2.object[0];
		*number =  array.tbl[array.array_index].rf2.objectNumber;
	}
	else if (name == 'j') {
		pointer = &array.tbl[array.array_index].jmp1.object[0];
		*number =  array.tbl[array.array_index].jmp1.objectNumber;
	}
	else if (name == 'J') {
		pointer = &array.tbl[array.array_index].jmp2.object[0];
		*number =  array.tbl[array.array_index].jmp2.objectNumber;
	}
	else if (name == 'c') {
		pointer = &array.tbl[array.array_index].cue.object[0];
		*number =  array.tbl[array.array_index].cue.objectNumber;
	}    
	else if (name == 'C') {
		pointer = &array.tbl[array.array_index].cue2.object[0];
		*number =  array.tbl[array.array_index].rf.objectNumber;
	}
	else return(NP);
	return(pointer);
}

int
*getXptr (char name, int base)
{
	int *pointer;

	unsigned delta;

	if (name == 'f') pointer = &(array.tbl[0].fp.x);
	else if (name == 'r') pointer = &array.tbl[0].rf.obj[0].x;
	else if (name == 'R') pointer = &array.tbl[0].rf2.obj[0].x;
	else if (name == 'j') pointer = &array.tbl[0].jmp1.obj[0].x;
	else if (name == 'J') pointer = &array.tbl[0].jmp2.obj[0].x;
	else if (name == 'c') pointer = &array.tbl[0].cue.obj[0].x;
	else if (name == 'C') pointer = &array.tbl[0].cue2.obj[0].x;
	else return(NP);
	delta = (unsigned)&array.tbl[base].index;
	delta += (unsigned)pointer - (unsigned)&array.tbl[0].index;
	return ((int *)delta);
}		

int
*getYptr (char name, int base)
{
	int *pointer;

	unsigned delta;

	if (name == 'f') pointer = &(array.tbl[0].fp.y);
	else if (name == 'r') pointer = &array.tbl[0].rf.obj[0].y;
	else if (name == 'R') pointer = &array.tbl[0].rf2.obj[0].y;
        else if (name == 'j') pointer = &array.tbl[0].jmp1.obj[0].y;
	else if (name == 'J') pointer = &array.tbl[0].jmp2.obj[0].y;
	else if (name == 'c') pointer = &array.tbl[0].cue.obj[0].y;
	else if (name == 'C') pointer = &array.tbl[0].cue2.obj[0].y;
	else return(NP);
	delta = (unsigned)&array.tbl[base].index;
	delta += (unsigned)pointer - (unsigned)&array.tbl[0].index;
	return ((int *)delta);
}		

void 
makeObjAngle (char name, double angle)
{
	/*like makeAngle, except for the objects in the object array for name[0]*/

	double d2r = 57.2957795; 
	double theta, radius, hor, ver;
	double newtheta,delta;
	int n,i;
	int *obj;
	int objectNumber = 0;
	int endX, endY;
	int *x, *y;

dprintf("calculating angle for object list %c\n ",name);
	obj = getXVptr(name,&objectNumber); /*endpoint of vector from array 0*/
	/*if name is 'r, obj = rf.object[0] for the zeroth array*/
	endX = object[*obj].x;
	endY = object[*obj].y;
	hor = (double)(endX);
	ver = (double)(endY);
	radius = sqrt(hor*hor + ver*ver);
	if ((hor == 0) && (ver >= 0)) theta = 1.5707963; /*pi/2*/
	else if ((hor == 0) && (ver < 0)) theta = -1.5707963; /*3pi/2*/
	else theta = atan2(ver,hor);
	for (n = 1; n < (objectNumber/2 + objectNumber%2); n++) {
		delta = (double)(n);
		delta *= angle/d2r;
		newtheta = theta + delta;
		ver = radius * sin(newtheta);
		hor = radius * cos(newtheta);
		object[obj[n]].x = (int)hor;
		object[obj[n]].y = (int)ver;
	} /*for n = > 1*/
	/*now go and fill second half of array going backward from main vector*/	
	for (i = 1; n < (objectNumber); n++) {
		delta = -(double)(i++);
		delta *= angle/d2r;
		newtheta = theta + delta;
		ver = radius * sin(newtheta);
		hor = radius * cos(newtheta);
		object[obj[n]].x = (int)hor;
		object[obj[n]].y = (int)ver;
	} /*for i = 1*/
	
}
void 
makeRfAngle (char name, double angle, int choice)
{
	/*like makeAngle, except for the objects in the object array for name[0]*/

	double d2r = 57.2957795; 
	double theta, radius, hor, ver;
	double newtheta,delta;
	int n,i;
	int *obj;
	int objectNumber = 0;
	int endX, endY;
	int *x, *y;

dprintf("calculating angle for rf for array %d\n ",choice);
	/*uses rf->obj[0].x,.y   for the zeroth array*/
	endX = array.tbl[choice].rf.obj[0].x;
	endY = array.tbl[choice].rf.obj[0].y;
	hor = (double)(endX);
	ver = (double)(endY);
	radius = sqrt(hor*hor + ver*ver);
	if ((hor == 0) && (ver >= 0)) theta = 1.5707963; /*pi/2*/
	else if ((hor == 0) && (ver < 0)) theta = -1.5707963; /*3pi/2*/
	else theta = atan2(ver,hor);
	for (n = 1; n < (array.tbl[choice].rf.objectNumber/2 + array.tbl[choice].rf.objectNumber%2); n++) {
		delta = (double)(n);
		delta *= angle/d2r;
		newtheta = theta + delta;
		ver = radius * sin(newtheta);
		hor = radius * cos(newtheta);
		array.tbl[choice].rf.obj[n].x = (int)hor;
		array.tbl[choice].rf.obj[n].y = (int)ver;
	} /*for n = > 1*/
	/*now go and fill second half of array going backward from main vector*/	
	for (i = 1; n < (array.tbl[choice].rf.objectNumber); n++) {
		delta = -(double)(i++);
		delta *= angle/d2r;
		newtheta = theta + delta;
		ver = radius * sin(newtheta);
		hor = radius * cos(newtheta);
		array.tbl[choice].rf.obj[n].x = (int)hor;
		array.tbl[choice].rf.obj[n].y = (int)ver;
	} /*for i = 1*/
	
}
void
makeAngle(char name, double angle) {
	/*make a vector from 0 to  array 0*/
	/* fill array 0 through number-1 with radial vectors spaced an angle away*/
	/* set array_may = number */
	
	
	double d2r = 57.2957795; 
	double theta, radius, hor, ver;
	double newtheta,delta;
	int endX, endY;
	int *x, *y;
	int n,i;

dprintf("filling %c\n ",name);
	/*theta is now the angle of radius*/
	/* fill first half of array going forward from main vector (radius)*/
	if((name == 'b') || (name == 'B')) {
		if (name == 'b') {
			endX = background[0].bgobj[0].x; 
			endY = background[0].bgobj[0].y; 
		}
		else {
			endX = background[0].bgobj[1].x; 
			endY = background[0].bgobj[1].y; 
		}
		hor = (double)(endX);
		ver = (double)(endY);
		radius = sqrt(hor*hor + ver*ver);
		if ((hor == 0) && (ver >= 0)) theta = 1.5707963; /*pi/2*/
		else if ((hor == 0) && (ver < 0)) theta = 1.5707963; /*3pi/2*/
		else theta = atan2(ver,hor);
		for (n = 1; n < (backgroundNumber/2 + backgroundNumber%2); n++) {
	  		delta = (double)(n);
			delta *= angle/d2r;
			newtheta = theta + delta;
			ver = radius * sin(newtheta);
			hor = radius * cos(newtheta);
			if (name == 'b') {
				background[n].bgobj[0].x = hor;
				background[n].bgobj[0].y = ver;
				/*since bg 0, fill real object also */
				object[background[n].object[0]].x = hor;
				object[background[n].object[0]].y= ver;
			}
			else {
				background[n].bgobj[1].x = hor;
				background[n].bgobj[1].y = ver;
				object[background[n].object[1]].x = hor;
				object[background[n].object[1]].y= ver;
			}
				
		} /*for n = 1*/
		/*now go and fill second half of array going backward from main vector*/	
		for (i = 1; n < backgroundNumber; n++) {
			delta = -(double)(i++);
			delta *= angle/d2r;
			newtheta = theta + delta;
			ver = radius * sin(newtheta);
			hor = radius * cos(newtheta);
			if (name == 'b') {
				background[n].bgobj[0].x = hor;
				background[n].bgobj[0].y = ver;
				/*since bg 0, fill real object also */
				object[background[n].object[0]].x = hor;
				object[background[n].object[0]].y= ver;
			}
			else {
				background[n].bgobj[1].x = hor;
				background[n].bgobj[1].y = ver;
				object[background[n].object[1]].x = hor;
				object[background[n].object[1]].y= ver;
			}
		}
		vexOnFlag |= VEXBGD;
		vexOffFlag |= VEXOLDBG;
	}
	else {
		x = getXptr(name,0); /*endpoint of vector from array 0*/
		y = getYptr(name,0);
		endX = *x;
		endY = *y;
		hor = (double)(endX);
		ver = (double)(endY);
		radius = sqrt(hor*hor + ver*ver);
		if ((hor == 0) && (ver >= 0)) theta = 1.5707963; /*pi/2*/
		else if ((hor == 0) && (ver < 0)) theta = 1.5707963; /*3pi/2*/
		else theta = atan2(ver,hor);
	/*theta is now the angle of radius*/
	/* fill first half of array going forward from main vector (radius)*/
		for (n = 1; n < (array.array_max/2 + array.array_max%2); n++) {
	  		delta = (double)(n);
			delta *= angle/d2r;
			newtheta = theta + delta;
			ver = radius * sin(newtheta);
			hor = radius * cos(newtheta);
			x = getXptr(name,n); /*get the pointer to the x value for
				      *the current function(fp etc) and index
				      */
			y = getYptr(name,n);
			*x = hor;
			*y = ver;
		} /*for n = 1*/
		/*now go and fill second half of array going backward from main vector*/	
		for (i = 1; n < array.array_max; n++) {
			delta = -(double)(i++);
			delta *= angle/d2r;
			newtheta = theta + delta;
			ver = radius * sin(newtheta);
			hor = radius * cos(newtheta);
			x = getXptr(name,n); /*get the pointer to the x value for
				      *the current function(fp etc) and index
				      */
			y = getYptr(name,n);
			*x = hor;
			*y = ver;
		} /*for i = 1*/
	}

} /*makeAngle*/

void
fill(char name) {
/*replace each instance of array with current value for array 0 */

	
	
	int xdelta, ydelta;
	int *x, *y;
	int n;

	n = ARRAYSIZE -1;
	x= getXptr(name,0); /*find pointer to the zeroth X value*/
	y= getYptr(name,0);
	xdelta = *x; /*this is now the value for the entire array*/
	ydelta = *y;
	for (n = 1; n < array.array_max; n++) {
		x = getXptr(name,n); /*find pointer for nth value*/
		y = getYptr(name,n);
		*x = xdelta; /*change value*/
		*y = ydelta;
	}
}

void
transpose(char name) {
/*add first argument to x and second argument to y of 
 *each instance of the specified array number
 * set array_max = number */

	
	int xdelta, ydelta;
	int *x, *y, n;
	
	xdelta = atoi(arg0); /*first two arguments are x and y transposition*/
	ydelta = atoi(arg1);
	for (n = 0; n < array.array_max; n++) {
		x = getXptr(name,n);
		y = getYptr(name,n);
		*x += xdelta;
		*y += ydelta;
	}
}

void
makeLinear(char name, double delta) {
	/*make a vector from 0,0 to array 0*/
	/* fill array 0 through number-1 with radial vectors space delta away*/

	
	
	double theta, radius, hor, ver;
	double h,v;
	double sign = 1;
	double xdelta, ydelta;
	int endX, endY;
	int *x, *y;
	int n,i;

	x = getXptr(name,0);
	y = getYptr(name,0);
	endX = *x;
	endY = *y;
	hor = (double)(endX);
	ver = (double)(endY);
	radius = sqrt(hor*hor + ver*ver);
	if ((hor == 0) && (ver >= 0)) theta = 1.5707963; /*pi/2*/
	else if ((hor == 0) && (ver < 0)) theta = 1.5707963; /*3pi/2*/
	else theta = atan2(ver,hor);
	ydelta = delta*sin(theta);
	xdelta = delta*cos(theta); /*we have now computed appropriate deltas for
				    *increment along the radius*/
	for (n = 1; n < array.array_max; n++) {
		i = (n+1)/2;	
		h = xdelta;
		h *= (double)(i);
		h *= sign;
		v = ydelta;
		v *= (double)(i);
		v *= sign;
		sign *= -1;	
		x = getXptr(name,n);
		y = getYptr(name,n);
		*x = (int)(h + endX);
		*y = (int)(v + endY);
	}
}

void
makeSquare(char name, int delta) {
	int i,j;
	int n = 0;
	int limit;
	int *x, *y;
	int leftx, lefty;
	int number;

	if (array.array_max <=9) {
		array.array_max = 9;
		number = 3;
	}
	else if (array.array_max <=25) {
		array.array_max = 25;
		number = 5;
	}
	else if (array.array_max <=ARRAYMAX) {
		array.array_max = ARRAYMAX;
		number = 7;
	}
	x = getXptr(name,0);
	y = getYptr(name,0);
	n = 0;
	limit = (number/2); /*int division*/	
	leftx = *x - limit*delta;
	lefty = *y - limit*delta;
	for (i = 0;  i < number; i++) {
	   for (j = 0; j < number; n++,j++) {	
		x = getXptr(name,n);
		y = getYptr(name,n);
		*x = leftx + j*delta;
		*y = lefty + i*delta;
	   }
	}
}
void
makeObjSquare(int delta, int choice) {
	int i,j,k;
	int limit;
	int leftx, lefty;
	int number;

	if (array.tbl[choice].rf.objectNumber <=9) {
		array.tbl[choice].rf.objectNumber = 9;
		number = 3;
	}
	else if (array.tbl[choice].rf.objectNumber <=25) {
		array.tbl[choice].rf.objectNumber = 25;
		number = 5;
	}
	else if (array.tbl[choice].rf.objectNumber <=49) {
		array.tbl[choice].rf.objectNumber = 49;
		number = 7;
	}
	limit = ((number-1)/2); /*int division*/	
	leftx =   array.tbl[choice].rf.obj[0].x - limit*delta;
	lefty =   array.tbl[choice].rf.obj[0].y - limit*delta;
	k = 0;
	for (i = 0;  i < number; i++) {
	   for (j = 0; j < number; j++) {	
		array.tbl[choice].rf.obj[k].x = leftx + j*delta;
		array.tbl[choice].rf.obj[k++].y = lefty + i*delta;
dprintf("x value for %d is %d\n",k,array.tbl[choice].rf.obj[k].x);
	   }
	}
}
#pragma off (unreferenced)
void
n_object(char *vstr, char *astr)
/*
 * this noun turns on or off a given object.  n f turns it on, 
 * but not the file verbs
 */
#pragma on (unreferenced)
{
	char name;
	static char *bargp[10];
	int i,j;
	int src, dest;
	int src1, dest1;
	char *currentString;
	int argumentNumber = 0;
	int pf_flag;
	char fromobj, toobj;

	pf_flag = 0;

	bargp[0] = arg0;
	bargp[1] = arg1;
	bargp[2] = arg2;
	bargp[3] = arg3;
	bargp[4] = arg4;
	bargp[5] = arg5;
	bargp[6] = arg6;
	bargp[7] = arg7;
	bargp[8] = arg8;
	bargp[9] = arg9;
/*first parse argument string to accept up to 10 arguments*/
	for (i = 0; i < 10; i++) {
	   currentString = bargp[i];
/*clear the bargp arrays*/
	   for (j = 0; j < 8; j++) *currentString++ = 0;
	}

	for (i = 0; i < 10; i++) {
	   currentString = bargp[i];
	   while (*astr == ' ') *astr++;
	   if (*astr == 0) break;
   	   while ((*astr != ' ') && (*astr != 0)) *currentString++ = *astr++;
	   argumentNumber += 1;
/* dprintf("bargp[%d] is %s argnumber is %d \n",i, bargp[i],argumentNumber); */
	   if (*astr == 0) break; /*end of string*/
	}

	switch (*vstr) {
			
	case 'c': /*copy object n to object m*/
		if (argumentNumber < 3){ 
			rxerr("object: c o o/c/r n1 n2 o/c/r n3 n4");
			break;
		}
		currentString = bargp[3];
		toobj = currentString[0];
		currentString = bargp[0];
		fromobj = currentString[0];
dprintf("toobj type is %c fromobj type is %c\n", toobj, fromobj);
		if ((fromobj != 'o') && (fromobj != 'r') && (fromobj != 'c') &&
		  (toobj != 'o') && (toobj != 'o') && (toobj != 'r')) {
			rxerr(" must use 'o', 'c' or 'r' to identify object type");
			break;
		}
		src = atoi(bargp[1]); /*source*/
		src1 = atoi(bargp[2]); /*source*/
		dest = atoi(bargp[4]); /*destination*/
		dest1 = atoi(bargp[5]); /*destination*/
		if ((j > OBJECTNUMBER) || (i > OBJECTNUMBER)) {
			rxerr("objectnumber too large");
			break;
		}

		switch (toobj){

		case 'o':
			switch (fromobj){
			
			case 'o':
				object[dest] = object[src];
dprintf ("copying parameters from Object %d to Object %d.\n",src,dest);
				break; /*fromobj = o */

			case 'r':
				object[dest] = array.tbl[src1].rf.obj[src];
dprintf("copying parameters from array[%d].rf.obj[%d] to Object %d\n", src1,src,dest);
				break; /*fromobj = r */

			case 'c':
				object[dest] = array.tbl[src1].cue.obj[src];
dprintf("copying parameters from array[%d].cue.obj[%d] to Object %d\n", src1,src,dest);
				break; /*fromobj = c */

			} /* switch (fromobj) */
			break; /* toobject = o */

		case 'r':
			switch (fromobj){
			
			case 'o':
				array.tbl[dest1].rf.obj[dest] =  object[src];
dprintf ("copying parameters from Object %d to array[%d].rf.obj[%d].\n",src,dest1,dest);
				break; /*fromobj = o */

			case 'r':
				array.tbl[dest1].rf.obj[dest] = array.tbl[src1].rf.obj[src];
dprintf("copying parameters from array[%d].rf.obj[%d] to array[%d].rf.obj[%d].\n", src1,src,dest1,dest);
				break; /*fromobj = r */

			case 'c':
				array.tbl[dest1].rf.obj[dest] = array.tbl[src1].cue.obj[src];
dprintf("copying parameters from array[%d].cue.obj[%d] to array[%d].rf.obj[%d].\n", src1,src,dest1,dest);
				break; /*fromobj = c */

			} /* switch (fromobj) */
			break; /* toobject = r */

		case 'c':
			switch (fromobj){
			
			case 'o':
				array.tbl[dest1].cue.obj[dest] =  object[src];
dprintf ("copying parameters from Object %d to array[%d].cue.obj[%d].\n",src,dest1,dest);
				break; /*fromobj = o */

			case 'r':
				array.tbl[dest1].cue.obj[dest] = array.tbl[src1].rf.obj[src];
dprintf("copying parameters from array[%d].rf.obj[%d] to array[%d].cue.obj[%d].\n", src1,src,dest1,dest);
				break; /*fromobj = r */

			case 'c':
				array.tbl[dest1].cue.obj[dest] = array.tbl[src1].cue.obj[src];
dprintf("copying parameters from array[%d].cue.obj[%d] to array[%d].cue.obj[%d].\n", src1,src,dest1,dest);
				break; /*fromobj = c */

			} /* switch (fromobj) */
			break; /* toobject = c */
		} /* switch (toobj) */
		break;
	case 'o': /*'off objects*/
		vexAllOffFlag = YES;
		break;
	case 'p':
	   pf_flag = 1; /*NB if p then fills forward objects with current values */
	case 'f': /*crude fills*/
	   if (argumentNumber == 0) {
		rxerr("object: must use format 'f ob parameter'");
		break;
	   } /* if argumentNumber*/
	   for (i = 0; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		switch (name) {
		case 'c':
			fillobject('c',pf_flag);
			break;
		case 's':
			fillobject('s',pf_flag);
			break;
		
		case 'm':
			fillobject('m',pf_flag);
			break;

		case 'p':
			fillobject('p',pf_flag);
			break;

		case 'o':
			fillobject('o',pf_flag);
			break;

		case 'i':
			fillobject('i',pf_flag);
			break;

		case 'l':
			fillobject('l',pf_flag);
			break;

		case 'a':
			fillobject('a',pf_flag);
			break;
		case 'f':
			switch (*currentString) {
			case 'l':
				fillobject('0',pf_flag);
				break;
			case 'r':
				fillobject('1',pf_flag);
				break;
			case 'g':
				fillobject('2',pf_flag);
				break;
			case 'b':
				fillobject('3',pf_flag);
				break;
			} /*switch currentString*/
		case'b':
			switch (*currentString) {
			case 'l':
				fillobject('4',pf_flag);
				break;
			case 'r':
				fillobject('5',pf_flag);
				break;
			case 'g':
				fillobject('6',pf_flag);
				break;
			case 'b':
				fillobject('7',pf_flag);
				break;
			} /*switch currentString*/
		default:
			rxerr("Invalid Parameter");
			rxerr	("fi ob [fl fr fg fb bl br bg bb a c s p m o i l]\n");
		}/*switch name*/

          } /*for i,,,*/
        break;
	default:
	rxerr("n_object: bad verb\n");
	}; /*switch *vstr*/

}	

#pragma off (unreferenced)
   void poslistproc(char poslist[1000])
#pragma on (unreferenced)
      {

	    char localteststring[1000];
	      char delims[]=" ,/.=";
      char* p;
      int i;
	 
	/*here use the string to vary the listpos int arrays*/
	
	 if( strcmpi(poslist,"ShowMe")==0){
	    
	    ShowArr("FPx",listfpx,numlistfpxs);
	    ShowArr("FPy",listfpy,numlistfpys);
	    ShowArr("RFx",listrfx,numlistrfxs);
	    ShowArr("RFy",listrfy,numlistrfys);
	    ShowArr("RF2x",listrf2x,numlistrf2xs);
	    ShowArr("RF2y",listrf2y,numlistrf2ys);	    
	    ShowArr("Jumpx",listjumpx,numlistjumpxs);
	    ShowArr("Jumpy",listjumpy,numlistjumpys);
	    
	    dprintf("%s\n","showed you values");
	    
	    return;
	 } else  /*if not show me*/
	   {
	 
	 /*MAKE SURE NUMINTS IN PARSEMYSTRING NOT LONGER THAN 300*/
	 
	 CopyMyString(poslist,localteststring,1000);
	 p=strtok(localteststring,delims);
	 if(p!=NULL) {
	    
	    if (strcmpi(p,"FPx")==0) {

	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistfpxs=ParseMyString(localteststring,listfpx,300);
	   dprintf("FPx set to %s\n", poslist);
	} else numlistfpxs=0;	       
	    }
	    else if (strcmpi(p,"FPy")==0) {
	       
	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistfpys=ParseMyString(localteststring,listfpy,300);
	   dprintf("FPy set to %s\n", poslist);
	} else numlistfpys=0;
	    }
	    
	    else if (strcmpi(p,"RFx")==0) {

	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistrfxs=ParseMyString(localteststring,listrfx,300);
	   dprintf("RFx set to %s\n", poslist);
	} else numlistrfxs=0;	       
	    }
	    
	    else if (strcmpi(p,"RFy")==0){

	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistrfys=ParseMyString(localteststring,listrfy,300);
	   dprintf("RFy set to %s\n", poslist);
	} else numlistrfys=0;	       
	    }
	    
	    else if (strcmpi(p,"RF2x")==0){
	       
	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistrf2xs=ParseMyString(localteststring,listrf2x,300);
	   dprintf("RF2x set to %s\n", poslist);
	} else numlistrf2xs=0;	       
	    }
	    
	    else if (strcmpi(p,"RF2y")==0){
	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistrf2ys=ParseMyString(localteststring,listrf2y,300);
	   dprintf("RF2y set to %s\n", poslist);
	} else numlistrf2ys=0;	       
	    }	       	       
	 
	    else if (strcmpi(p,"Jumpx")==0){
	       
	       	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistjumpxs=ParseMyString(localteststring,listjumpx,300);
	   dprintf("Jumpx set to %s\n", poslist);
	} else numlistjumpxs=0;
	    }

	    else if (strcmpi(p,"Jumpy")==0){
	    	       	if(poslist[0]!='\0'&&poslist[0]!='N'&&poslist[0]!='n'){
	   CopyMyString(poslist,localteststring,1000);
	   numlistjumpys=ParseMyString(localteststring,listjumpy,300);
	   dprintf("Jumpy set to %s\n", poslist);
	} else numlistjumpys=0;	       
	    }
	 }
	  else {dprintf("%s\n","something is wrong; initial space perhaps ?");
	 return;
	  }
	   }
      }

   
#pragma off (unreferenced)
void
n_array(char *vstr, char *astr)
/*
 * this noun contains all of array manipulating verbs
 * buyt not the file verbs
 */
#pragma on (unreferenced)
{
	char name;
	double theta;
	int delta;
	int choice;
	static char *bargp[10];
	int i,j,k;
	char *structname, *from, *to;
	char *currentString;
	int argumentNumber = 0;
	int pf_flag;

	pf_flag = 0;

	bargp[0] = arg0;
	bargp[1] = arg1;
	bargp[2] = arg2;
	bargp[3] = arg3;
	bargp[4] = arg4;
	bargp[5] = arg5;
	bargp[6] = arg6;
	bargp[7] = arg7;
	bargp[8] = arg8;
	bargp[9] = arg9;
/*first parse argument string to accept up to 10 arguments*/
	for (i = 0; i < 10; i++) {
	   currentString = bargp[i];
	   for (j = 0; j < 8; j++) *currentString++ = 0;
	}
	for (i = 0; i < 10; i++) {
	   currentString = bargp[i];
	   while (*astr == ' ') if (*astr++ == 0) break;
   	   while ((*astr != ' ') && (*astr != 0)) *currentString++ = *astr++;
	   argumentNumber += 1;
	   if (*astr == 0) break; /*end of string*/
	}
       

	switch (*vstr) {
	case 'd': /*d ar Fn f t. Copies Function (f,r,R,j,J,c,C,) 
		   * of	array f to array t
		   */
		if (argumentNumber < 3) {
			rxerr("du ar Function from to");	
			break;
		}
		structname = bargp[0];
		from = bargp[1];
		to = bargp[2];
		duplicate(structname,from,to);
		break;		
	case 'j': /*fill specified member of current array (array_index) with
		   *joystick values
 		   */
	/*first make sure array.array index is OK*/
		if (array.array_index >=ARRAYSIZE) array.array_index = ARRAYSIZE-1;
		if (array.array_index < 0) array.array_index = 0;
		if (array.array_max < 1) array.array_max = 1;
		if (array.array_max > ARRAYSIZE) array.array_max = ARRAYSIZE;
	   for (i = 0; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		switch (name) {
		case 'f':
			array.tbl[array.array_index].fp.x = joyh >> 2;
			array.tbl[array.array_index].fp.y = joyv >> 2;
			break;
		case 'r':
			array.tbl[array.array_index].rf.obj[0].x = joyh >> 2;
			array.tbl[array.array_index].rf.obj[0].y = joyv >> 2;
			break;
		case 'R':
			array.tbl[array.array_index].rf2.obj[0].x = joyh >> 2;
			array.tbl[array.array_index].rf2.obj[0].y = joyv >> 2;
			break;
		case 'j':
			array.tbl[array.array_index].jmp1.obj[0].x = joyh >> 2;
			array.tbl[array.array_index].jmp1.obj[0].y = joyv >> 2;
			break;
		case 'J':
			array.tbl[array.array_index].jmp2.obj[0].x = joyh >> 2;
			array.tbl[array.array_index].jmp2.obj[0].y = joyv >> 2;
			break;
		case 'c':
			array.tbl[array.array_index].cue.obj[0].x = joyh >> 2;
			array.tbl[array.array_index].cue.obj[0].y = joyv >> 2;
			break;
		case 'C':
			array.tbl[array.array_index].cue2.obj[0].x = joyh >> 2;
			array.tbl[array.array_index].cue2.obj[0].y = joyv >> 2;
			break;
		default: 
			rxerr("array: must use j ar [f,r,R,j,J,c or C] for a joystick fill");

		};	
	   }
		break;	
		
	case 't': /*transpose: add the of the first two arguments to each
		   *instance of specified entries
		   */
	   if (argumentNumber < 3) { 
		rxerr("array: must use format 't arr x y function'");
		break;
	   }
	   for (i = 2; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		switch (name) {
		case 'r':
	        case 'R':
		case 'f':
		case 'j':
		case 'J':
		case 'c':
		case 'C':
			transpose(name);
			break;
		case 'a':
			transpose('f');
			transpose('r');
	                transpose('R');
			transpose('j');
			transpose('J');
			transpose('c');
			transpose('C');
			break;
		default: 
		rxerr("array: must use f,r,R,j,J,c,C or a for transpose");
		};	
	   }
	   break;	
		
	case 'l': /*linear fills: l arrÿ45 a fills array_max steps  along the
		   *line array0 -arrayARRAYSIZE -1. 
		   *First step is increase, second decrease
		   */
	
	   if (argumentNumber < 2 ) { 
		rxerr("array: must use format 'l arr n function '");
		break;
	   }
	   theta = atof (arg0);
	   for (i = 1; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		switch (name) {
		case 'r':
                case 'R':
		case 'f':
		case 'j':
		case 'J':
		case 'c':
		case 'C':
			makeLinear(name, theta);
			break;
		case 'a':
			makeLinear('f',theta);
			makeLinear('r',theta);
                        makeLinear('R',theta);
			makeLinear('j',theta);
			makeLinear('J',theta);
			makeLinear('c',theta);
			makeLinear('C',theta);
			break;
		default: 
			rxerr("array: must use f,r,R,j,J,c,C or a for linear fill");
		};	
	   }
		break;	
	case 'a': /*angular fills: a arr 45 f fills steps through array_max
		   *first step is an angle clockwise, second is an angle
                   *counter clockwize. Initial vector is array 0 - array ARRAYSIZE -1.*/
	   if (argumentNumber < 2) { 
		rxerr("array: must use format 'a arr n function'");
		break;
	   }
	   theta = atof (arg0);
	   for (i = 1; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		switch (name) {
		case 'x': /*fill the objects in a single array rf*/
			currentString = bargp[++i];	
			choice = atoi(currentString);
			makeRfAngle(name, theta,choice);
			break;
		case 'r':
                case 'R':
		case 'f':
		case 'j':
		case 'J':
		case 'b':
		case 'B':
		case 'c':
		case 'C':
			makeAngle(name, theta);
			break;
		case 'a':
			makeAngle('f',theta);
			makeAngle('r',theta);
	                makeAngle('R',theta);
			makeAngle('j',theta);
			makeAngle('J',theta);
			makeAngle('b',theta);
			makeAngle('B',theta);
			makeAngle('c',theta);
			makeAngle('C',theta);
			break;
		default: 
			rxerr("array: must use b,B,f,r,R,1,2,c,C,x or a");
		};	
	   }
	   break;	
	case 's': /*square fills: s a 60 f fills the largest possible
		   *square around tb0 fixation point with
		   * points separated by 6 degrees
		   * The new tbl0 is the lower left of the square.
		   * It lso fills r, j1, j2 thus s a j2100 fills j2 with
		   * a square 10 degrees between dots.
                   */
	   if (argumentNumber < 2) { 
		rxerr("array: must use format 's arr n function'");
		break;
	   }
	   delta = atof (arg0);
	   for (i = 1; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		if (name == 'x') {
			currentString = bargp[++i];
			choice = atoi(currentString);
			makeObjSquare(delta,choice);
		}
		else
			makeSquare(name, delta);
	   }
	   break;

	case 'v': /*Vex angular fills: v arr 45 rf fills the objects pointed to
		   *by the object array of rf[array.array_index] (current array)
		   *first step is an angle clockwise, second is an angle
                   *counter clockwize. Initial vector is array 0 - array ARRAYSIZE -1.*/
	   if (argumentNumber < 2) { 
		rxerr("array: must use format 'v arr angle(degrees) function'");
		break;
	   }
	   theta = atof (arg0);
	   for (i = 1; i < argumentNumber; i++) {
		currentString = bargp[i];
		name = *currentString++;
		switch (name) {
		case 'r':
                case 'R':
		case 'j':
		case 'J':
		case 'c':
		case 'C':
		makeObjAngle(name, theta);
			break;
		case 'a':
			makeObjAngle('r',theta);
	                makeObjAngle('R',theta);
			makeObjAngle('j',theta);
			makeObjAngle('J',theta);
			makeObjAngle('c',theta);
			makeObjAngle('C',theta);
			break;
		default: 
			rxerr("array: must use r,R,j,J,c,C or a");
		};	
	   }
	   break;	

	case 'p': /* partial crude fills */
		pf_flag = 1;
	case 'f': /*crude fills*/
	   if (argumentNumber < 2) 
	   { 
		if ((arg0[0] != 'l') && (arg0[0] != 'y') && (arg0[0] != 'x'))
		{
			rxerr("array: must use format 'f arr parameter function'");
			rxerr("            or ........'f arr x' [t + fl + c + i]");
			break;
		}
	   }

	   switch(arg0[0]) {
	   case 'a': /*i for the numeric array values and flags*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
			if ((name == 'f') && (*currentString == 'l')) 
				name = 'l';
			/*name now a, f, r,R, j, or J, or l*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'l': /*flags, special for 'a' */
			case 'J':
			case 'g': /*gap times, special for 'a' */
			case 'c':
			case 'C':
				fillarray(name, pf_flag);
				break;
			default: rxerr ("arrays only 'f', 'r','R', 'j' 'J', 'c', 'C', 'fl', 'g' or 'a'");
			};
		}
		break;

	   case 'e': /*i for the numeric array values and flags*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
			/*name now a, f, r,R, j, J, c, or C*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				duparray(name, pf_flag);
				break;
			default: rxerr ("arrays only 'f', 'r','R', 'j' 'J', 'c', 'C', or 'a'");
			};
		}
		break;

	   case 'i': /*i for the interface devices*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				filldevice(name, pf_flag);
				fillinterface(name, pf_flag);
				break;
			default: rxerr ("devices and flags only 'f', 'r', 'R','j' 'J', 'c', 'C' or 'a'");
			};
		}
		break;
	   case 'c': /*c for the control flags*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				fillcontrol(name, pf_flag);
				break;
			default: rxerr ("control flags only 'f', 'r', 'R','j' 'J', 'c', 'C' or 'a'");
			};
		}
		break;
	   case 'w': /*w for the windows (limits)*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
				fillwindow(name, pf_flag);
				break;
			default: rxerr ("window flags only 'f', 'r', 'R', 'j' 'J' or 'a'");
			};
		}
		break;
	   case 'n': /*w for the number of objects */
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, c, C, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'c':
			case 'C':
			case 'j':
			case 'J':
				fillnumber_of_Objects(name, pf_flag);
				break;
			default: rxerr ("Num of Objs: 'r' 'R' 'c' 'C' 'j' 'J' or 'a'");
			};
		}
		break;
	   case 't': /*t for the times*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				filltime(name, pf_flag);
				break;
	default: rxerr ("times only 'f','r','R','j','J','c','C' or 'a'");
			};
		}
		break;

	   case 's': /*s for the staircase (thresholds) */
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
			switch (name) {
			case 'c':
				fillthresh(name, pf_flag);
				break;
	default: rxerr ("Staircases only for cue. (p)f a s c");
			};
		}
		break;
		
	   case 'd': /*d for the delays*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				filldelay(name, pf_flag);
				break;
			default: rxerr ("delay only 'f', 'r', 'R','j' 'J', 'c', 'C' or 'a'");
			};
		}
		break;
				
	   case 'o': /*o for the objects*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				fillarrobject(name, pf_flag);
				break;
			default: rxerr ("object only 'f', 'r', 'R','j' 'J', 'c', 'C' or 'a'");
			};
		}
	   case 'O': /*O for the object arrays*/
	   	for (i = 1; i < argumentNumber; i++) {
			currentString = bargp[i];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'a': 
			case 'r':
                        case 'R':
			case 'f':
			case 'j':
			case 'J':
			case 'c':
			case 'C':
				fillarrobj(name, pf_flag);
				break;
			default: rxerr ("object only 'f', 'r', 'R','j' 'J', 'c', 'C' or 'a'");
			};
		}
		break;
				
	   case 'y':   /* fill everyting except amps and windows */
		filltime('a', pf_flag);
		filldelay('a', pf_flag);
		fillcontrol('a', pf_flag);
		filldevice('a', pf_flag);
		fillarray ('l', pf_flag);
		fillinterface('a', pf_flag);
		break;
	   case 'x':
		/*fill all rf or cue object arrays from array 0*/
		/* allow partial fills*/
		if (pf_flag == 0) choice = 1;
		else choice = klugepointer;
	   	for (k = 1; k < argumentNumber; k++) {
			currentString = bargp[k];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'r':
				for (i = choice; i < array.array_max; i++) {
					array.tbl[i].rf.objectNumber = array.tbl[0].rf.objectNumber;
					array.tbl[i].rf.x = array.tbl[0].rf.obj[0].x;
					array.tbl[i].rf.y = array.tbl[0].rf.obj[0].y;
					for (j = 0; j < array.tbl[0].rf.objectNumber;j++){
					array.tbl[i].rf.obj[j] = array.tbl[0].rf.obj[j];
					array.tbl[i].rf.object[j] = array.tbl[0].rf.object[j];
					} /* for j */
				} /* for i */
				break;
			case 'c':
				for (i = choice; i < array.array_max; i++) {
					array.tbl[i].cue.objectNumber = array.tbl[0].cue.objectNumber;
					array.tbl[i].cue.x = array.tbl[0].cue.obj[0].x;
					array.tbl[i].cue.y = array.tbl[0].cue.obj[0].y;
					for (j = 0; j < array.tbl[0].cue.objectNumber;j++){
					array.tbl[i].cue.obj[j] = array.tbl[0].cue.obj[j];
					array.tbl[i].cue.object[j] = array.tbl[0].cue.object[j];
					} /* for j */
				} /* for i */
				break;
			default: rxerr ("fill object array only 'r' or 'c'");
			} /* switch */
		} /* for k */
		break;
	   case 'k':
		/* Fill checksizes for rf or cue objects from array 0, obj[0]*/
		/*    This will fill all obj[x] in all arrays */ 
		/* allow partial fills*/
		if (pf_flag == 0) choice = 0;
		else choice = klugepointer;
	   	for (k = 1; k < argumentNumber; k++) {
			currentString = bargp[k];
			name = *currentString++;
				 /*name now r or c*/
			switch (name) {
			case 'r':
				for (i = choice; i < array.array_max; i++) {
					for (j = 0; j < array.tbl[i].rf.objectNumber;j++){
					array.tbl[i].rf.obj[j].checksize = array.tbl[choice].rf.obj[0].checksize;
					} /* for j */
				} /* for i */
				break;
			case 'c':
				for (i = choice; i < array.array_max; i++) {
					for (j = 0; j < array.tbl[i].cue.objectNumber;j++){
					array.tbl[i].cue.obj[j].checksize = array.tbl[choice].cue.obj[0].checksize;
					} /* for j */
				} /* for i */
				break;
			default: rxerr ("fill object all checksizes only 'r' or 'c'");
			} /* switch */
		} /* for k */
		break;

	   case 'l':
		/*location*/
		/*fill all rf or cue object array x and y values only from array 0*/
		/* allow partial fills*/
		if (pf_flag == 0) choice = 1;
		else choice = klugepointer;

	   	for (k = 1; k < argumentNumber; k++) {
			currentString = bargp[k];
			name = *currentString++;
				 /*name now a, f, r, j, or J*/
			switch (name) {
			case 'r':
				for (i = choice; i < array.array_max; i++) {
					array.tbl[i].rf.objectNumber = array.tbl[choice].rf.objectNumber;
					array.tbl[i].rf.x = array.tbl[choice].rf.obj[0].x;
					array.tbl[i].rf.y = array.tbl[choice].rf.obj[0].y;
					for (j = 0; j < array.tbl[choice].rf.objectNumber;j++){
						array.tbl[i].rf.obj[j].x = array.tbl[choice].rf.obj[j].x;
						array.tbl[i].rf.obj[j].y = array.tbl[choice].rf.obj[j].y;
					} /* for j */
				} /* for i */
				break;
			case 'c':
				for (i = choice; i < array.array_max; i++) {
					array.tbl[i].cue.objectNumber = array.tbl[choice].cue.objectNumber;
					array.tbl[i].cue.x = array.tbl[choice].cue.obj[0].x;
					array.tbl[i].cue.y = array.tbl[choice].cue.obj[0].y;
					for (j = 0; j < array.tbl[choice].cue.objectNumber;j++){
						array.tbl[i].cue.obj[j].x = array.tbl[choice].cue.obj[j].x;
						array.tbl[i].cue.obj[j].y = array.tbl[choice].cue.obj[j].y;
					} /* for j */
				} /* for i */
				break;
			default: rxerr ("fill object array only 'r' or 'c'");
			} /* switch */
		} /* for k */
		break;

	   default:
		rxerr("array: can't fill. Format is fi ar variable function");
		}; /*switch name*/
  	   break;
	default:
	badverb();
	}; /*switch *vstr*/
}

/*
 *	User menu table.
 */


#pragma off (unreferenced)
void
deviceCheck(FUNCTION *func) 
{
#pragma on (unreferenced)
	switch (func->control) {
		case NOMIRROR:
		case VEXARRAY:
		case VEXJOY:
		case VEXSTATIC:
		case VEXBACKGROUND:
		case VEXCUE:
		case VEXCUE2:
		case VEXBACKOFF:
		case VEXBGRF:
		case THRESHOLD:
		case MCSTHRESH:
			func->interface = TV;
			break;
		default:
			func->interface = BLUEBOX;
	};
}

#pragma off (unreferenced)
int
array_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)

	if(call_cnt >= array.array_max) {

		/*
		 * Done.  Return null to terminate writing of root for
		 * this menu.
		 */
		*astr= '\0';
	} else itoa_RL(call_cnt, 'd', astr, &astr[P_ISLEN]);
	return(0);
}

#pragma off (unreferenced)
int
objects_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)

	if(call_cnt > objNumber) {

		/*
		 * Done.  Return null to terminate writing of root for
		 * this menu.
		 */
		*astr= '\0';
	} else itoa_RL(call_cnt, 'd', astr, &astr[P_ISLEN]);
	return(0);
}
#pragma off (unreferenced)
int
backgrounds_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)

	if((call_cnt > 0)&&(call_cnt >= backgroundNumber)) {

		/*
		 * Done.  Return null to terminate writing of root for
		 * this menu.
		 */
		*astr= '\0';
	} else itoa_RL(call_cnt, 'd', astr, &astr[P_ISLEN]);
	return(0);
}

#pragma off (unreferenced)
int
robjects_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)

	if(call_cnt >= FUNCOBJECT) {

		/*
		 * Done.  Return null to terminate writing of root for
		 * this menu.
		 */
		*astr= '\0';
	} else itoa_RL(call_cnt, 'd', astr, &astr[P_ISLEN]);
	return(0);
}

#pragma off (unreferenced)
int
objectArray_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)

	if(call_cnt >= array.array_max) {

		/*
		 * Done.  Return null to terminate writing of root for
		 * this menu.
		 */
		*astr= '\0';
	} else itoa_RL(call_cnt, 'd', astr, &astr[P_ISLEN]);
	return(0);
}

#pragma off (unreferenced)
int
klugeobjectArray_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)
/*don't write robject etc roots*/
	return(0);
}

/*
 *access function for array menu
 */
objcheck(char *astr) {
/*this is common to all the array accessing menus (array, interface,flag)
 *and chooses the index into the tbl array.
 */
	static lastpointer = 0;

	if(!astr) {
		klugepointer = 0;
		return;
	}

	switch (*astr) {
	case  '\0':
	case '\\':
		klugepointer = lastpointer;
		break;
	case '-':
		klugepointer = lastpointer - 1;
		break;
	case '=': /*lowercase of +*/
		klugepointer = lastpointer + 1;
		break;
	default:
		klugepointer = atoi(astr);
	};
	if (klugepointer >= FUNCOBJECT) klugepointer = FUNCOBJECT -1;
	if (klugepointer < 0) klugepointer = 0;
	lastpointer = klugepointer;
/*note:the menu actually accesses kluge, and the various vllist access
 *functions change the menu variables back
 */
	kluge_array_max = array.array_max;
	kluge_array_index = array.array_index;
}

firstcheck(char *astr) {
/*this is common to all the array accessing menus (array, interface,flag)
 *and chooses the index into the tbl array.
 */
	static lastpointer = 0;

	if(!astr) {
		klugepointer = 0;
		return;
	}

	switch (*astr) {
	case  '\0':
		klugepointer = lastpointer;
		break;
	case '-':
		klugepointer = lastpointer - 1;
		break;
	case '=': /*lowercase of +*/
		klugepointer = lastpointer + 1;
		break;
	case '\\':
		klugepointer = array.array_index;
		break;
	default:
		klugepointer = atoi(astr);
	};
	if (klugepointer >= ARRAYSIZE) klugepointer = ARRAYSIZE -1;
	if (klugepointer < 0) klugepointer = 0;
	lastpointer = klugepointer;
	if (array.array_max < 1) array.array_max = 1;
	if (array.array_max > ARRAYSIZE) array.array_max = ARRAYSIZE;
/*note:the menu actually accesses kluge, and the various vllist access
 *functions change the menu variables back
 */
	kluge_array_max = array.array_max;
	if (array.array_index >= array.array_max) array.array_index = array.array_max-1;
	kluge_array_index = array.array_index;
}

#pragma off (unreferenced)
int
maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	firstcheck(astr);
	kluge = array.tbl[klugepointer];
	kluge.index = klugepointer;
	klugeObjectNumber = kluge.rf.object[klugepointer];
	kluge_good = array.tbl[0].cue.windowx;
	kluge_bad = array.tbl[0].cue.windowy;

	/* for jmp2RwdFlag, in j2 menu only */
	menu_jmp2RwdFlag = array.tbl[klugepointer].jmp2RwdFlag;
	menu_jmp2RwdDelay = jmp2RwdDelay;

	return(0);
}
#pragma off (unreferenced)
int
omaf(int flag, MENU *mp, char *astr, ME_RECUR *rp)

#pragma on (unreferenced)
/*this menu uses the current array pointer, and klugepointer is the
 *object number within the RF array
 */ 

{
	objcheck(astr);
	kluge_array_index = arrayIndex;
	klugeObject = rf->obj[klugepointer];
	klugeObjectNumber = rf->object[klugepointer];
	return(0);
}

#pragma off (unreferenced)
int
cmaf(int flag, MENU *mp, char *astr, ME_RECUR *rp)

#pragma on (unreferenced)
/*this menu uses the current array pointer, and klugepointer is the
 *object number within the RF array
 */ 

{
	objcheck(astr);
	kluge_array_index = arrayIndex;
	kluge = array.tbl[arrayIndex];
	klugeObject = kluge.cue.obj[klugepointer];
	klugeObjectNumber = kluge.cue.object[klugepointer];
	return(0);
}


#pragma off (unreferenced)
int
fmaf(int flag, MENU *mp, char *astr, ME_RECUR *rp)

#pragma on (unreferenced)
/*this menu uses the current array pointer, and klugepointer is the
 *object number within the RF array
 */ 

{
	objcheck(astr);
	kluge_array_index = arrayIndex;
	kluge = array.tbl[arrayIndex];
	klugeObject = kluge.fp.obj[klugepointer];
	klugeObjectNumber = kluge.fp.object[klugepointer];
	return(0);
}

/*VEX vaf's and maf's*/

/*first vafs for background*/

#pragma off (unreferenced)
int
backgrounds_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
/*Make sure background number is realistic*/
	if (klugeBackgroundNumber > BACKGROUNDNUMBER)
		klugeBackgroundNumber = BACKGROUNDNUMBER;
	backgroundNumber = klugeBackgroundNumber;
	vexOnFlag |= VEXBGD;
	vexOffFlag |= VEXOLDBG;
	return(0);
}
#pragma off (unreferenced)
int
bgobject0_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{

/*special needs for object[0] - have to copy object into bg copy, and turn on new bg */
	background[klugepointer].object[0] = klugebg.object[0];
	background[klugepointer].bgobj[0] = 
		object[background[klugepointer].object[0]];
	  /*turn on new background*/
	vexOnFlag |= VEXBGD;
	vexOffFlag |= VEXOLDBG;
	return(0);
}


#pragma off (unreferenced)
int
bgobject1_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
/*for bg 1, just copy object into bg copy */
	background[klugepointer].object[1] = klugebg.object[1];
	background[klugepointer].bgobj[1] =
		 object[background[klugepointer].object[1]];
	return(0);
}


#pragma off (unreferenced)
int
objects_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)
{
	static lastpointer = 0;
	switch (*astr) {
	case  '\0':
		klugepointer = lastpointer;
		break;
	case '-':
		klugepointer = lastpointer - 1;
		break;
	case '=': /*lowercase of +*/
		klugepointer = lastpointer + 1;
		break;
	default:
		klugepointer = atoi(astr);
	};
	if (klugepointer > OBJECTNUMBER) klugepointer = OBJECTNUMBER;
	if (klugepointer < 1) klugepointer = 1;
	lastpointer = klugepointer;
	klugeObjNumber = objNumber;
	klugeObject = object[klugepointer];
	return(0);
}


#pragma off (unreferenced)
int
object0_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
#pragma on (unreferenced)
{
/*this vaf reads the entire menu into the object. */
/*klugepointer already points to the background*/

	int objpointer;

	objpointer = klugebg.object[0];
	background[klugepointer].bgobj[0] = klugebg.bgobj[0];
	/*change the real object because this is background 0 */
	object[objpointer] = klugebg.bgobj[0];
	objectStack[vexObjectFlag++] = objpointer;
	vexOnFlag |= VEXBGD;
	vexOffFlag |= VEXOLDBG;
	
	return(0);
}


#pragma off (unreferenced)
int
object1_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
#pragma on (unreferenced)
{


	background[klugepointer].bgobj[1] = klugebg.bgobj[1];
	return(0);
}

#pragma off (unreferenced)
int
object0_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)
{
	klugebg.bgobj[0] = background[klugepointer].bgobj[0];
	return(0);
}

#pragma off (unreferenced)

int
object1_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)
{
	klugebg.bgobj[1] = background[klugepointer].bgobj[1];
	return(0);
}

#pragma off (unreferenced)
int
backgrounds_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)
{
	static lastpointer = 0;

	switch (*astr) {
	case  '\0':
		klugepointer = lastpointer;
		break;
	case '-':
		klugepointer = lastpointer - 1;
		break;
	case '=': /*lowercase of +*/
		klugepointer = lastpointer + 1;
		break;
	default:
		klugepointer = atoi(astr);
	};

	if (klugepointer >= BACKGROUNDNUMBER) klugepointer = BACKGROUNDNUMBER -1;
	if (klugepointer < 0) klugepointer = 0;
	lastpointer = klugepointer;
	kluge.index = klugepointer;
	klugeBackgroundNumber = backgroundNumber;
	klugebg.object[0] = background[klugepointer].object[0];
	klugebg.object[1] = background[klugepointer].object[1];
/*
	klugebg.bgobj[0] = background[klugepointer].bgobj[0];
	klugebg.bgobj[1] = background[klugepointer].bgobj[1];
*/

	return(0);
}



#pragma off (unreferenced)
int
compareobject(OBJECT *from, OBJECT *to) 
#pragma on (unreferenced)
{
/*compare the from object into the to object */
/*return NO if there is a difference */

	 if (to->pattern != from->pattern) return(NO);
	 if (to->x != from->x) return(NO);
	 if (to->y != from->y) return(NO);
	 if (to->sign != from->sign) return(NO);
	 if (to->checksize != from->checksize) return(NO);
	 if (to->fgl != from->fgl) return(NO);
	 if (to->bgl != from->bgl) return(NO);
	 if (to->fgr != from->fgr) return(NO);
	 if (to->fgb != from->fgb) return(NO);
	 if (to->fgg != from->fgg) return(NO);
	 if (to->bgr != from->bgr) return(NO);
	 if (to->bgg != from->bgg) return(NO);
	 if (to->bgb != from->bgb) return(NO);
	 if (to->mode != from->mode) return(NO);
	 if (to->var1 != from->var1) return(NO);
	 if (to->var2 != from->var2) return(NO);
	 if (to->var3 != from->var3) return(NO);
	 return(YES);
}

#pragma off (unreferenced)
int
objects_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
#pragma on (unreferenced)
{
/*this vaf reads the entire menu into the object. */

	int i;

	objNumber = klugeObjNumber;
	if (backgroundNumber > objNumber) backgroundNumber = objNumber;
	if (objNumber > OBJECTNUMBER) objNumber = OBJECTNUMBER; 

	object[klugepointer] = klugeObject;
	objectStack[vexObjectFlag++] = klugepointer; /*effect object change*/
	/*now check if this object is any background 0 object*/
	/*if so change it*/
	for (i = 0; i < backgroundNumber; i++) {
		if (background[i].object[0] == klugepointer) 
			background[i].bgobj[0] = klugeObject;
		else if (background[i].object[1] == klugepointer) 
			background[i].bgobj[1] = klugeObject;
	}
	return(0);
}

#pragma off (unreferenced)
void
zooge() 
{
#pragma on (unreferenced)

	kluge.rf.x = kluge.rf.obj[0].x;
	kluge.rf.y = kluge.rf.obj[0].y;
	kluge.fp.x = kluge.fp.obj[0].x;
	kluge.fp.y = kluge.fp.obj[0].y;
	kluge.rf2.x = kluge.rf2.obj[0].x;
	kluge.rf2.y = kluge.rf2.obj[0].y;
	kluge.cue.x = kluge.cue.obj[0].x;
	kluge.cue.y = kluge.cue.obj[0].y;
	kluge.cue2.x = kluge.cue2.obj[0].x;
	kluge.cue2.y = kluge.cue2.obj[0].y;
	kluge.jmp1.x = kluge.jmp1.obj[0].x;
	kluge.jmp1.y = kluge.jmp1.obj[0].y;
	kluge.jmp2.x = kluge.jmp2.obj[0].x;
	kluge.jmp2.y = kluge.jmp2.obj[0].y;
	array.tbl[klugepointer] = kluge;
	array.tbl[0].cue.windowx = kluge_good;
	array.tbl[0].cue.windowy = kluge_bad;
}

#pragma off (unreferenced)
int
kluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
/* first do object_dim check */
/*NO NEED: IF YOU MAKE MISTAKES, PAY FOR IT :) :) 
if ((kluge.fp.object_dim > OBJECTNUMBER) || (kluge.fp.object_dim < 1)) {
		kluge.fp.object_dim = kluge.fp.object[0] + 1;
	}
*/

/*zooge gets around a rex bug dealing with arrays within arrays*/
	zooge();
	return(0);
}

#pragma off (unreferenced)
okluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
/******	I have removed this so that robj and cobj menus can be placed
	anywhere in umenu
	int i;
	kluge.rf.obj[klugepointer] = klugeObject;
	kluge.rf.object[klugepointer] = klugeObjectNumber;
	array.tbl[array.array_index] = kluge;
*/	
	return(0);
}

#pragma off (unreferenced)
ckluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
#pragma on (unreferenced)
{
/******	I have removed this so that robj and cobj menus can be placed
	anywhere in umenu
	int i;
	kluge.cue.obj[klugepointer] = klugeObject;
	kluge.cue.object[klugepointer] = klugeObjectNumber;
	array.tbl[arrayIndex] = kluge;
*/
	return(0);
}

#pragma off (unreferenced)
fkluge_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
	int i;
#pragma on (unreferenced)
	kluge.fp.obj[klugepointer] = klugeObject;
	kluge.fp.object[klugepointer] = klugeObjectNumber;
	array.tbl[arrayIndex] = kluge;
	return(0);
}

#pragma off (unreferenced)
bglum_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (bkgd_lum > 255) bkgd_lum = 255;
	if (bkgd_lum < 0) bkgd_lum = 0;
	if (bkgd_lumX > 255) bkgd_lumX = 255;
	if (bkgd_lumX < 0) bkgd_lumX = 0;
	BGLumFlag = YES;
	return(0);
}

#pragma off (unreferenced)
rwdtime_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (rwdtime < 0) rwdtime = 50;
	sreward_on.preset = rwdtime;
	scuebar_rwd.preset = (int)(rwdtime*cuebarrwd/100);
	return(0);
}

   /*
#pragma off (unreferenced)
listpos_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
   char* localteststring[300];
#pragma on (unreferenced)

	if(slistfpx[0]!='\0'&&slistfpx[0]!='N'&&slistfpx[0]!='n'){

	   CopyMyString(slistfpx,localteststring,300);
	   numlistfpxs=ParseMyString(localteststring,listfpx,100);
	   dprintf("FPx set to %s\n",slistfpx);
	} else numlistfpxs=0;
   
   	if(slistfpy[0]!='\0'&&slistfpy[0]!='N'&&slistfpy[0]!='n'){

	   CopyMyString(slistfpy,localteststring,300);
           numlistfpys=ParseMyString(localteststring,listfpy,100);
	   dprintf("FPy set to %s\n",slistfpy);
	} else numlistfpys=0;
   

   	if(slistrfx[0]!='\0'&&slistrfx[0]!='N'&&slistrfx[0]!='n'){

	   CopyMyString(slistrfx,localteststring,300);
           numlistrfxs=ParseMyString(localteststring,listrfx,100);
	   dprintf("RFx set to %s\n",slistrfx);
	} else numlistrfxs=0;
   
   	if(slistrfy[0]!='\0'&&slistrfy[0]!='N'&&slistrfy[0]!='n'){

	   CopyMyString(slistrfy,localteststring,300);
	   numlistrf2ys=ParseMyString(localteststring,listrf2y,100);	   
	   dprintf("RFy set to %s\n",slistrfy);
	} else numlistrfys=0;
   
      	if(slistrf2x[0]!='\0'&&slistrf2x[0]!='N'&&slistrf2x[0]!='n'){

	   CopyMyString(slistrf2x,localteststring,300);
           numlistrf2xs=ParseMyString(localteststring,listrf2x,100);
	   dprintf("RF2x set to %s\n", slistrf2x);
	} else numlistrf2xs=0;
   
   	if(slistrf2y[0]!='\0'&&slistrf2y[0]!='N'&&slistrf2y[0]!='n'){

	   CopyMyString(slistrf2y,localteststring,300);
           numlistrf2ys=ParseMyString(localteststring,listrf2y,100);
	   dprintf("RF2y set to %s\n", slistrf2y);
	} else numlistrf2ys=0;

	if(slistjumpx[0]!='\0'&&slistjumpx[0]!='N'&&slistjumpx[0]!='n'){

	   CopyMyString(slistjumpx,localteststring,300);
	   numlistjumpxs=ParseMyString(localteststring,listjumpx,100);
	   dprintf("jmpx set to %s\n",slistjumpx);
	} else numlistjumpxs=0;
   
   	if(slistjumpy[0]!='\0'&&slistjumpy[0]!='N'&&slistjumpy[0]!='n'){

	   CopyMyString(slistjumpy,localteststring,300);
           numlistjumpys=ParseMyString(localteststring,listjumpy,100);
	   dprintf("jmpy set to %s\n",slistjumpy);
	} else numlistjumpys=0;
   
  	return(0);

}

*/
   
#pragma off (unreferenced)
timeouttime_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (timeouttime < 0) timeouttime = 1;
	stimeout.preset = timeouttime;
	return(0);
}

#pragma off (unreferenced)
dimtime_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (dimtime < 0) dimtime = 0;
	sdimon.preset = dimtime;
	return(0);
}


#pragma off (unreferenced)

rfobjx_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	array.tbl[klugepointer] = kluge;
	array.tbl[klugepointer].rf.x = array.tbl[klugepointer].rf.obj[0].x;
	array.tbl[klugepointer].rf.y = array.tbl[klugepointer].rf.obj[0].y;
	return(0);
}

#pragma off (unreferenced)
int
rfobj_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
	int i;
#pragma on (unreferenced)
	array.tbl[klugepointer] = kluge;
	for (i = 0; i< kluge.rf.objectNumber; i++) {
		object[rf->object[i]].x = rf->obj[i].x;
		object[rf->object[i]].y = rf->obj[i].y;
		object[rf->object[i]].bgr = rf->obj[i].bgr;
		object[rf->object[i]].bgg = rf->obj[i].bgg;
		object[rf->object[i]].bgb = rf->obj[i].bgb;
		object[rf->object[i]].fgr = rf->obj[i].fgr;
		object[rf->object[i]].fgg = rf->obj[i].fgg;
		object[rf->object[i]].fgb = rf->obj[i].fgb;
		object[rf->object[i]].pattern = rf->obj[i].pattern;
		object[rf->object[i]].checksize = rf->obj[i].checksize;
		objectStack[vexObjectFlag++] = rf->object[i]; /*effect object change*/
	} /*for i = 0*/
	return(0);
}


#pragma off (unreferenced)
int
fpcontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge.fp.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].fp.control = kluge.fp.control;
	deviceCheck(&array.tbl[klugepointer].fp);
	return(0);
}

#pragma off (unreferenced)
int
rfcontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge.rf.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].rf.control = kluge.rf.control;
	deviceCheck(&array.tbl[klugepointer].rf);
	return(0);
}


#pragma off (unreferenced)

int
rf2control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge.rf2.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].rf2.control = kluge.rf2.control;
	deviceCheck(&array.tbl[klugepointer].rf2);
	return(0);
}


#pragma off (unreferenced)

int
cuecontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge.cue.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].cue.control = kluge.cue.control;
	deviceCheck(&array.tbl[klugepointer].cue);
	return(0);
}

#pragma off (unreferenced)

int
cue2control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge.cue2.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].cue2.control = kluge.cue2.control;
	deviceCheck(&array.tbl[klugepointer].cue2);
	return(0);
}

#pragma off (unreferenced)
int
rmpcontrol_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.tbl[klugepointer].rmp.control = kluge.rmp.control;
	return(0);
}

#pragma off (unreferenced)
int
jmp1control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge.jmp1.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].jmp1.control = kluge.jmp1.control;
	deviceCheck(&array.tbl[klugepointer].jmp1);
	return(0);
}

#pragma off (unreferenced)
int
jmp2control_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge.jmp2.control > CONTROLMAX) {
		rxerr ("Control flag too big");
		return(0);
	}
	array.tbl[klugepointer].jmp2.control = kluge.jmp2.control;
	deviceCheck(&array.tbl[klugepointer].jmp2);
	return(0);
}

#pragma off (unreferenced)
int
array_max_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_array_max > ARRAYSIZE) kluge_array_max = ARRAYSIZE;
	if (kluge_array_max < 1) kluge_array_max = 1;
	array.array_max = kluge_array_max;
	return(0);
}
#pragma off (unreferenced)
int
array_index_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_array_index >= ARRAYSIZE) kluge_array_index = ARRAYSIZE-1;
	if (kluge_array_index < 0) kluge_array_index = 0;
	arrayIndex = array.array_index = kluge_array_index;
	return(0);
}



/*the following four vafs do the joystick gains and offsets(descriptor
 *table 0-3
 */
#pragma off (unreferenced)
int
joyh_gain_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[0] =kluge_descriptor[0];
	return(0);
}
#pragma off (unreferenced)
int
joyh_offset_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[1] =kluge_descriptor[1];
	return(0);
}
#pragma off (unreferenced)
int
joyv_gain_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[2] =kluge_descriptor[2];
	return(0);
}
#pragma off (unreferenced)
int
joyv_offset_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[3] =kluge_descriptor[3];
	return(0);
}
#pragma off (unreferenced)
int
descriptor_4_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[4] =kluge_descriptor[4];
	return(0);
}
#pragma off (unreferenced)
int
descriptor_5_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[5] =kluge_descriptor[5];
	return(0);
}
#pragma off (unreferenced)
int
descriptor_6_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[6] =kluge_descriptor[6];
	return(0);
}
#pragma off (unreferenced)
int
descriptor_7_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.array_descriptors[7] =kluge_descriptor[7];
	return(0);
}


/*
 *access function for descriptor menu
 */
#pragma off (unreferenced)
int
descriptor_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	int i;
	firstcheck(astr);
	for(i = 0; i < DESCRIPTORSIZE; i++)
		kluge_descriptor[i] = array.array_descriptors[i];
	return(0);
}

#pragma off (unreferenced)
int
state_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
/*	rwdtime = sreward_on.preset;*/
	dimtime = sdimon.preset;
	timeouttime=stimeout.preset;
	return(0);
}

#pragma off (unreferenced)
int
listest_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{

       return(0);
}


#pragma off (unreferenced)
int
rfmap_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
   #pragma off (unreferenced)
int
rfFill_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
#pragma off (unreferenced)
int
MMN_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
   #pragma off (unreferenced)
int
mgs_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
      #pragma off (unreferenced)
   
   int
twospot_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
      #pragma off (unreferenced)
int
ep_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
      #pragma off (unreferenced)
int
remapping_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
         #pragma off (unreferenced)
int
randpos_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
      
         #pragma off (unreferenced)
int
TTask_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   

#pragma off (unreferenced)
   
   int
VSrch_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   

#pragma off (unreferenced)
   
   int
Showbutt_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   
   
#pragma off (unreferenced)

int
assorted_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)

{
	return(0);
}   

#pragma off (unreferenced)
int
flags_maf(int flag, MENU *mp, char *astr, ME_RECUR *rp)
#pragma on (unreferenced)
{

	firstcheck(astr);
	kluge.index = klugepointer;
	kluge.fp.control = array.tbl[klugepointer].fp.control;
	kluge.rf.control = array.tbl[klugepointer].rf.control;
        kluge.rf2.control = array.tbl[klugepointer].rf2.control;
	kluge.jmp1.control = array.tbl[klugepointer].jmp1.control;
	kluge.cue.control = array.tbl[klugepointer].cue.control;
	kluge.cue2.control = array.tbl[klugepointer].cue2.control;
	kluge.jmp2.control = array.tbl[klugepointer].jmp2.control;
	kluge.flag = array.tbl[klugepointer].flag;
	kluge_rf_flag = array.tbl[klugepointer].flag & RFFLAG;
	kluge_nogoflag = (array.tbl[klugepointer].flag & NOGOFLAG) >> SHIFT_NOGOFLAG;
	kluge_rfshuffleflag = (array.tbl[klugepointer].flag & RFSHUFFLEFLAG) >> SHIFT_RFSHUFFLEFLAG;
	kluge_fixjmpcueflag = (array.tbl[klugepointer].flag & FIXJMPCUEFLAG) >> SHIFT_FIXJMPCUEFLAG;
	kluge_rf2_flag = (array.tbl[klugepointer].flag & RF2FLAG) >> SHIFT_RF2FLAG;
	kluge_jmp2sacflag = (array.tbl[klugepointer].flag & JMP2SAC) >> SHIFT_JMP2SAC;
	kluge_jmp1Flag = (array.tbl[klugepointer].flag & JMP1FLAG) >> SHIFT_JMP1FLAG;
/*	kluge_jRandFlag=array.tbl[klugepointer].jmp1randflag;*/
	kluge_fpRandFlag=array.tbl[klugepointer].fprandflag;
	kluge_fpRandSize=array.tbl[klugepointer].fprandsize;
	kluge_jmp2Flag = (array.tbl[klugepointer].flag & JMP2FLAG) >> SHIFT_JMP2FLAG;
	kluge_grassflag = (array.tbl[klugepointer].flag & GRASSFLAG) >> SHIFT_GRASSFLAG;
	kluge_jmp1cueflag = (array.tbl[klugepointer].flag & JMP1CUEFLAG) >> SHIFT_JMP1CUEFLAG;
	kluge_jmp2cueflag = (array.tbl[klugepointer].flag & JMP2CUEFLAG) >> SHIFT_JMP2CUEFLAG;
	kluge_jmp1cue2flag = (array.tbl[klugepointer].flag & JMP1CUE2FLAG) >> SHIFT_JMP1CUE2FLAG;
	kluge_jmp2cue2flag = (array.tbl[klugepointer].flag & JMP2CUE2FLAG) >> SHIFT_JMP2CUE2FLAG;
	kluge_backon1flag = (array.tbl[klugepointer].flag & BACKON1) >> SHIFT_BACKON1;
	kluge_backon2flag = (array.tbl[klugepointer].flag & BACKON2) >> SHIFT_BACKON2;
	kluge_barflag = (array.tbl[klugepointer].flag & BARFLAG) >> SHIFT_BARFLAG;
	kluge_baroffflag = (array.tbl[klugepointer].flag & BAROFFFLAG) >> SHIFT_BAROFFFLAG;
	kluge_cuebarflag = (array.tbl[klugepointer].flag & CUEBARFLAG) >> SHIFT_CUEBARFLAG;
	kluge_cueflag = kluge_jmp1cueflag | kluge_jmp2cueflag;
	kluge_cue2flag = kluge_jmp1cue2flag | kluge_jmp2cue2flag;
	return(0);
}
#pragma off (unreferenced)

#pragma off (unreferenced)
int
flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.tbl[klugepointer].flag = kluge.flag;
	return(0);
}

#pragma off (unreferenced)
int
fprand_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.tbl[klugepointer].fprandflag = kluge_fpRandFlag;
	array.tbl[klugepointer].fprandsize = kluge_fpRandSize;
	return(0);
}

#pragma off (unreferenced)
int
grassflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_grassflag == 1) 
		array.tbl[klugepointer].flag |= GRASSFLAG;
	else if (kluge_grassflag == 0)
		array.tbl[klugepointer].flag &= NOGRASSFLAG;
	return(0);
}

#pragma off (unreferenced)
int
rf_flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_rf_flag == 1) 
		array.tbl[klugepointer].flag |= RFFLAG;
	else if (kluge_rf_flag == 0)
		array.tbl[klugepointer].flag &= NORFFLAG;
	return(0);
}
#pragma off (unreferenced)

#pragma off (unreferenced)
int
cuebarflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	array.tbl[klugepointer].flag &= NOCUEBARFLAG;
	if (kluge_cuebarflag == 1) 
		array.tbl[klugepointer].flag |= 000400000000;
	else if (kluge_cuebarflag == 2)
		array.tbl[klugepointer].flag |= 001000000000;
	return(0);
}


int
baroffflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_baroffflag > 3) {
		rxerr("_baroffflag must be 3 or less");
		return(0);
	}
	array.tbl[klugepointer].flag &= NOBAROFFFLAG;
	switch (kluge_baroffflag) {
	case LEFT:
		array.tbl[klugepointer].flag |= FLAGLEFTBAROFF;
		break;
	case RIGHT:
		array.tbl[klugepointer].flag |= FLAGRIGHTBAROFF;
		break;
	case BOTH:
		array.tbl[klugepointer].flag |= FLAGBOTHBAROFFS;
		break;
	case NO:
		array.tbl[klugepointer].flag &= NOBAROFFFLAG;
		break;
	};
	return(0);
}


int
barflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_barflag > 3) {
		rxerr("_barflag must be 3 or less");
		return(0);
	}
	array.tbl[klugepointer].flag &= NOBARFLAG;
	switch (kluge_barflag) {
	case LEFT:
		array.tbl[klugepointer].flag |= FLAGLEFTBAR;
		break;
	case RIGHT:
		array.tbl[klugepointer].flag |= FLAGRIGHTBAR;
		break;
	case BOTH:
		array.tbl[klugepointer].flag |= FLAGBOTHBARS;
		break;
	case NO:
		array.tbl[klugepointer].flag &= NOBARFLAG;
		break;
	};
	return(0);
}
#pragma off (unreferenced)

int
rfshuffleflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_rfshuffleflag == 1) 
		array.tbl[klugepointer].flag |= RFSHUFFLEFLAG;
	else if (kluge_rfshuffleflag == 0)
		array.tbl[klugepointer].flag &= NORFSHUFFLEFLAG;
	return(0);
}
#pragma off (unreferenced)

int
nogoflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_nogoflag == 1) 
		array.tbl[klugepointer].flag |= NOGOFLAG;
	else if (kluge_nogoflag == 0)
		array.tbl[klugepointer].flag &= NONOGOFLAG;
	return(0);
}
#pragma off (unreferenced)

int
fixjmpcueflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_fixjmpcueflag == 1) 
		array.tbl[klugepointer].flag |= FIXJMPCUEFLAG;
	else if (kluge_fixjmpcueflag == 0)
		array.tbl[klugepointer].flag &= NOFIXJMPCUEFLAG;
	return(0);
}
#pragma off (unreferenced)


int
rf2_flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_rf2_flag == 1) 
		array.tbl[klugepointer].flag |= RF2FLAG;
	else if (kluge_rf2_flag == 0)
		array.tbl[klugepointer].flag &= NORF2FLAG;
	return(0);
}
#pragma off (unreferenced)

int
jmp2sacflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (kluge_jmp2sacflag == 1)
		array.tbl[klugepointer].flag |= JMP2SAC;
	else if (kluge_jmp2sacflag == 0)
		array.tbl[klugepointer].flag &= NOJMP2SAC;
	return(0);
}
#pragma off (unreferenced)

int
jmp2RwdDelay_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (menu_jmp2RwdDelay < 0) {
		jmp2RwdDelay = 0;
	}
	else
		jmp2RwdDelay = menu_jmp2RwdDelay;
	return(0);
}

#pragma off (unreferenced)

int
jmp2RwdFlag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)
	if (menu_jmp2RwdFlag >= 1) array.tbl[klugepointer].jmp2RwdFlag = 1;
	else array.tbl[klugepointer].jmp2RwdFlag = 0;
	return(0);
}
#pragma off (unreferenced)


int
backon1flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_backon1flag > 15) {
		rxerr("backonflags must be 0..15");
		return(0);
	}
	else if (kluge_backon1flag >= 0 ) {
		array.tbl[klugepointer].flag &= NOBACKON1; /*clear flag*/
		array.tbl[klugepointer].flag |= (kluge_backon1flag << SHIFT_BACKON1);
	}
	return(0);
}

#pragma off (unreferenced)
int
backon2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_backon2flag > 15) {
		rxerr("backonflags must be 0..15");
		return(0);
		}
	else if (kluge_backon2flag >= 0 ) {
		array.tbl[klugepointer].flag &= NOBACKON2; /*clear flag*/
		array.tbl[klugepointer].flag |= (kluge_backon2flag << SHIFT_BACKON2);
	}
	return(0);
}


#pragma off (unreferenced)
int
jmp1cueflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_jmp1cueflag == 1) 
		array.tbl[klugepointer].flag |= JMP1CUEFLAG;
	else if (kluge_jmp1cueflag == 0)
		array.tbl[klugepointer].flag &= NOJMP1CUEFLAG;
	return(0);
}
#pragma off (unreferenced)
int
jmp2cueflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_jmp2cueflag == 1) 
		array.tbl[klugepointer].flag |= JMP2CUEFLAG;
	else if (kluge_jmp2cueflag == 0)
		array.tbl[klugepointer].flag &= NOJMP2CUEFLAG;
	return(0);
}


#pragma off (unreferenced)
int
jmp1cue2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_jmp1cue2flag == 1) 
		array.tbl[klugepointer].flag |= JMP1CUE2FLAG;
	else if (kluge_jmp1cue2flag == 0)
		array.tbl[klugepointer].flag &= NOJMP1CUE2FLAG;
	return(0);
}
#pragma off (unreferenced)
int
jmp2cue2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_jmp2cue2flag == 1) 
		array.tbl[klugepointer].flag |= JMP2CUE2FLAG;
	else if (kluge_jmp2cue2flag == 0)
		array.tbl[klugepointer].flag &= NOJMP2CUE2FLAG;
	return(0);
}

#pragma off (unreferenced)
int
jmp1flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_jmp1Flag == 1) 
		array.tbl[klugepointer].flag |= JMP1FLAG;
	else if (kluge_jmp1Flag == 0)
		array.tbl[klugepointer].flag &= NOJMP1FLAG;
	return(0);
}
#pragma off (unreferenced)
int
jmp2flag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

	if (kluge_jmp2Flag == 1) 
		array.tbl[klugepointer].flag |= JMP2FLAG;
	else if (kluge_jmp2Flag == 0)
		array.tbl[klugepointer].flag &= NOJMP2FLAG;
	return(0);
}
/*#pragma off (unreferenced)
int jrandflag_vaf(int flag, MENU *mp, char *astr, VLIST *vlp, int *tvadd)
{
#pragma on (unreferenced)

array.tbl[klugepointer].jmp1randflag=kluge_jRandFlag;

}*/


VLIST rfpatterns_vl[]  =

{
"rf.obj[0].pattern",		&kluge.rf.obj[0].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].pattern",		&kluge.rf.obj[1].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].pattern",		&kluge.rf.obj[2].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].pattern",		&kluge.rf.obj[3].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].pattern",		&kluge.rf.obj[4].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].pattern",		&kluge.rf.obj[5].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].pattern",		&kluge.rf.obj[6].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].pattern",		&kluge.rf.obj[7].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].pattern",		&kluge.rf.obj[8].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].pattern",		&kluge.rf.obj[9].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].pattern",	&kluge.rf.obj[10].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].pattern",	&kluge.rf.obj[11].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].pattern",	&kluge.rf.obj[12].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].pattern",	&kluge.rf.obj[13].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].pattern",	&kluge.rf.obj[14].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].pattern",	&kluge.rf.obj[15].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST cr_vl[]  =

{
"cue.obj[0].fgr",	&kluge.cue.obj[0].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].fgr",	&kluge.cue.obj[1].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].fgr",	&kluge.cue.obj[2].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].fgr",	&kluge.cue.obj[3].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].fgr",	&kluge.cue.obj[4].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].fgr",	&kluge.cue.obj[5].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].fgr",	&kluge.cue.obj[6].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].fgr",	&kluge.cue.obj[7].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].fgr",	&kluge.cue.obj[8].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].fgr",	&kluge.cue.obj[9].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].fgr",	&kluge.cue.obj[10].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].fgr",	&kluge.cue.obj[11].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].fgr",	&kluge.cue.obj[12].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].fgr",	&kluge.cue.obj[13].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].fgr",	&kluge.cue.obj[14].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].fgr",	&kluge.cue.obj[15].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST cg_vl[]  =

{
"cue.obj[0].fgg",	&kluge.cue.obj[0].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].fgg",	&kluge.cue.obj[1].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].fgg",	&kluge.cue.obj[2].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].fgg",	&kluge.cue.obj[3].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].fgg",	&kluge.cue.obj[4].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].fgg",	&kluge.cue.obj[5].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].fgg",	&kluge.cue.obj[6].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].fgg",	&kluge.cue.obj[7].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].fgg",	&kluge.cue.obj[8].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].fgg",	&kluge.cue.obj[9].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].fgg",	&kluge.cue.obj[10].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].fgg",	&kluge.cue.obj[11].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].fgg",	&kluge.cue.obj[12].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].fgg",	&kluge.cue.obj[13].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].fgg",	&kluge.cue.obj[14].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].fgg",	&kluge.cue.obj[15].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST fgr_vl[]  =

{
"rf.obj[0].fgr",	&kluge.rf.obj[0].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].fgr",	&kluge.rf.obj[1].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].fgr",	&kluge.rf.obj[2].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].fgr",	&kluge.rf.obj[3].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].fgr",	&kluge.rf.obj[4].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].fgr",	&kluge.rf.obj[5].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].fgr",	&kluge.rf.obj[6].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].fgr",	&kluge.rf.obj[7].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].fgr",	&kluge.rf.obj[8].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].fgr",	&kluge.rf.obj[9].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].fgr",	&kluge.rf.obj[10].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].fgr",	&kluge.rf.obj[11].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].fgr",	&kluge.rf.obj[12].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].fgr",	&kluge.rf.obj[13].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].fgr",	&kluge.rf.obj[14].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].fgr",	&kluge.rf.obj[15].fgr, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST fgg_vl[]  =

{
"rf.obj[0].fgg",	&kluge.rf.obj[0].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].fgg",	&kluge.rf.obj[1].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].fgg",	&kluge.rf.obj[2].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].fgg",	&kluge.rf.obj[3].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].fgg",	&kluge.rf.obj[4].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].fgg",	&kluge.rf.obj[5].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].fgg",	&kluge.rf.obj[6].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].fgg",	&kluge.rf.obj[7].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].fgg",	&kluge.rf.obj[8].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].fgg",	&kluge.rf.obj[9].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].fgg",	&kluge.rf.obj[10].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].fgg",	&kluge.rf.obj[11].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].fgg",	&kluge.rf.obj[12].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].fgg",	&kluge.rf.obj[13].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].fgg",	&kluge.rf.obj[14].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].fgg",	&kluge.rf.obj[15].fgg, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST xcueobjects_vl[]  =

{
"cue.obj[0].x",		&kluge.cue.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].x",		&kluge.cue.obj[1].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].x",		&kluge.cue.obj[2].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].x",		&kluge.cue.obj[3].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].x",		&kluge.cue.obj[4].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].x",		&kluge.cue.obj[5].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].x",		&kluge.cue.obj[6].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].x",		&kluge.cue.obj[7].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].x",		&kluge.cue.obj[8].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].x",		&kluge.cue.obj[9].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].x",	&kluge.cue.obj[10].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].x",	&kluge.cue.obj[11].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].x",	&kluge.cue.obj[12].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].x",	&kluge.cue.obj[13].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].x",	&kluge.cue.obj[14].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].x",	&kluge.cue.obj[15].x, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST tv1_vl[]  =

{
"cue.thresh[0].tv1",	&kluge.cue.thresh[0].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[1].tv1",	&kluge.cue.thresh[1].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[2].tv1",	&kluge.cue.thresh[2].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[3].tv1",	&kluge.cue.thresh[3].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[4].tv1",	&kluge.cue.thresh[4].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[5].tv1",	&kluge.cue.thresh[5].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[6].tv1",	&kluge.cue.thresh[6].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[7].tv1",	&kluge.cue.thresh[7].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[8].tv1",	&kluge.cue.thresh[8].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[9].tv1",	&kluge.cue.thresh[9].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[10].tv1",	&kluge.cue.thresh[10].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[11].tv1",	&kluge.cue.thresh[11].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[12].tv1",	&kluge.cue.thresh[12].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[13].tv1",	&kluge.cue.thresh[13].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[14].tv1",	&kluge.cue.thresh[14].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[15].tv1",	&kluge.cue.thresh[15].tv1, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST tv2_vl[]  =

{
"cue.thresh[0].tv2",	&kluge.cue.thresh[0].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[1].tv2",	&kluge.cue.thresh[1].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[2].tv2",	&kluge.cue.thresh[2].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[3].tv2",	&kluge.cue.thresh[3].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[4].tv2",	&kluge.cue.thresh[4].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[5].tv2",	&kluge.cue.thresh[5].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[6].tv2",	&kluge.cue.thresh[6].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[7].tv2",	&kluge.cue.thresh[7].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[8].tv2",	&kluge.cue.thresh[8].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[9].tv2",	&kluge.cue.thresh[9].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[10].tv2",	&kluge.cue.thresh[10].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[11].tv2",	&kluge.cue.thresh[11].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[12].tv2",	&kluge.cue.thresh[12].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[13].tv2",	&kluge.cue.thresh[13].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[14].tv2",	&kluge.cue.thresh[14].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[15].tv2",	&kluge.cue.thresh[15].tv2, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST tp1_vl[]  =

{
"cue.thresh[0].tp1",	&kluge.cue.thresh[0].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[1].tp1",	&kluge.cue.thresh[1].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[2].tp1",	&kluge.cue.thresh[2].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[3].tp1",	&kluge.cue.thresh[3].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[4].tp1",	&kluge.cue.thresh[4].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[5].tp1",	&kluge.cue.thresh[5].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[6].tp1",	&kluge.cue.thresh[6].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[7].tp1",	&kluge.cue.thresh[7].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[8].tp1",	&kluge.cue.thresh[8].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[9].tp1",	&kluge.cue.thresh[9].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[10].tp1",	&kluge.cue.thresh[10].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[11].tp1",	&kluge.cue.thresh[11].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[12].tp1",	&kluge.cue.thresh[12].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[13].tp1",	&kluge.cue.thresh[13].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[14].tp1",	&kluge.cue.thresh[14].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[15].tp1",	&kluge.cue.thresh[15].tp1, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST tp2_vl[]  =

{
"cue.thresh[0].tp2",	&kluge.cue.thresh[0].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[1].tp2",	&kluge.cue.thresh[1].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[2].tp2",	&kluge.cue.thresh[2].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[3].tp2",	&kluge.cue.thresh[3].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[4].tp2",	&kluge.cue.thresh[4].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[5].tp2",	&kluge.cue.thresh[5].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[6].tp2",	&kluge.cue.thresh[6].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[7].tp2",	&kluge.cue.thresh[7].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[8].tp2",	&kluge.cue.thresh[8].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[9].tp2",	&kluge.cue.thresh[9].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[10].tp2",	&kluge.cue.thresh[10].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[11].tp2",	&kluge.cue.thresh[11].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[12].tp2",	&kluge.cue.thresh[12].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[13].tp2",	&kluge.cue.thresh[13].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[14].tp2",	&kluge.cue.thresh[14].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.thresh[15].tp2",	&kluge.cue.thresh[15].tp2, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST xrfobjects_vl[]  =

{
"rf.obj[0].x",	&kluge.rf.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].x",	&kluge.rf.obj[1].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].x",	&kluge.rf.obj[2].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].x",	&kluge.rf.obj[3].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].x",	&kluge.rf.obj[4].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].x",	&kluge.rf.obj[5].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].x",	&kluge.rf.obj[6].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].x",	&kluge.rf.obj[7].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].x",	&kluge.rf.obj[8].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].x",	&kluge.rf.obj[9].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].x",	&kluge.rf.obj[10].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].x",	&kluge.rf.obj[11].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].x",	&kluge.rf.obj[12].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].x",	&kluge.rf.obj[13].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].x",	&kluge.rf.obj[14].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].x",	&kluge.rf.obj[15].x, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST ycueobjects_vl[]  =

{
"cue.obj[0].y",	&kluge.cue.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].y",	&kluge.cue.obj[1].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].y",	&kluge.cue.obj[2].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].y",	&kluge.cue.obj[3].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].y",	&kluge.cue.obj[4].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].y",	&kluge.cue.obj[5].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].y",	&kluge.cue.obj[6].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].y",	&kluge.cue.obj[7].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].y",	&kluge.cue.obj[8].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].y",	&kluge.cue.obj[9].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].y",	&kluge.cue.obj[10].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].y",	&kluge.cue.obj[11].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].y",	&kluge.cue.obj[12].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].y",	&kluge.cue.obj[13].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].y",	&kluge.cue.obj[14].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].y",	&kluge.cue.obj[15].y, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST yrfobjects_vl[]  =

{
"rf.obj[0].y",	&kluge.rf.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].y",	&kluge.rf.obj[1].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].y",	&kluge.rf.obj[2].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].y",	&kluge.rf.obj[3].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].y",	&kluge.rf.obj[4].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].y",	&kluge.rf.obj[5].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].y",	&kluge.rf.obj[6].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].y",	&kluge.rf.obj[7].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].y",	&kluge.rf.obj[8].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].y",	&kluge.rf.obj[9].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].y",	&kluge.rf.obj[10].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].y",	&kluge.rf.obj[11].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].y",	&kluge.rf.obj[12].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].y",	&kluge.rf.obj[13].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].y",	&kluge.rf.obj[14].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].y",	&kluge.rf.obj[15].y, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST cpatterns_vl[]  =

{
"cue.obj[0].ptrn",	&kluge.cue.obj[0].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].ptrn",	&kluge.cue.obj[1].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].ptrn",	&kluge.cue.obj[2].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].ptrn",	&kluge.cue.obj[3].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].ptrn",	&kluge.cue.obj[4].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].ptrn",	&kluge.cue.obj[5].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].ptrn",	&kluge.cue.obj[6].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].ptrn",	&kluge.cue.obj[7].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].ptrn",	&kluge.cue.obj[8].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].ptrn",	&kluge.cue.obj[9].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].ptrn",	&kluge.cue.obj[10].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].ptrn",	&kluge.cue.obj[11].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].ptrn",	&kluge.cue.obj[12].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].ptrn",	&kluge.cue.obj[13].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].ptrn",	&kluge.cue.obj[14].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].ptrn",	&kluge.cue.obj[15].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST rpatterns_vl[]  =

{
"rf.obj[0].ptrn",	&kluge.rf.obj[0].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].ptrn",	&kluge.rf.obj[1].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].ptrn",	&kluge.rf.obj[2].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].ptrn",	&kluge.rf.obj[3].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].ptrn",	&kluge.rf.obj[4].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].ptrn",	&kluge.rf.obj[5].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].ptrn",	&kluge.rf.obj[6].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].ptrn",	&kluge.rf.obj[7].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].ptrn",	&kluge.rf.obj[8].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].ptrn",	&kluge.rf.obj[9].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].ptrn",	&kluge.rf.obj[10].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].ptrn",	&kluge.rf.obj[11].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].ptrn",	&kluge.rf.obj[12].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].ptrn",	&kluge.rf.obj[13].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].ptrn",	&kluge.rf.obj[14].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].ptrn",	&kluge.rf.obj[15].pattern, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

/*this is the good one*/
VLIST cchecksizes_vl[]  =

{
"cue.obj[0].chksize",	&kluge.cue.obj[0].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].chksize",	&kluge.cue.obj[1].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].chksize",	&kluge.cue.obj[2].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].chksize",	&kluge.cue.obj[3].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].chksize",	&kluge.cue.obj[4].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].chksize",	&kluge.cue.obj[5].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].chksize",	&kluge.cue.obj[6].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].chksize",	&kluge.cue.obj[7].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].chksize",	&kluge.cue.obj[8].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].chksize",	&kluge.cue.obj[9].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].chksize",	&kluge.cue.obj[10].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].chksize",	&kluge.cue.obj[11].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].chksize",	&kluge.cue.obj[12].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].chksize",	&kluge.cue.obj[13].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].chksize",	&kluge.cue.obj[14].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].chksize",	&kluge.cue.obj[15].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST rchecksizes_vl[]  =

{
"rf.obj[0].chksize",	&kluge.rf.obj[0].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].chksize",	&kluge.rf.obj[1].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].chksize",	&kluge.rf.obj[2].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].chksize",	&kluge.rf.obj[3].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].chksize",	&kluge.rf.obj[4].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].chksize",	&kluge.rf.obj[5].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].chksize",	&kluge.rf.obj[6].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].chksize",	&kluge.rf.obj[7].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].chksize",	&kluge.rf.obj[8].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].chksize",	&kluge.rf.obj[9].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].chksize",	&kluge.rf.obj[10].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].chksize",	&kluge.rf.obj[11].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].chksize",	&kluge.rf.obj[12].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].chksize",	&kluge.rf.obj[13].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].chksize",	&kluge.rf.obj[14].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].chksize",	&kluge.rf.obj[15].checksize, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST cb_vl[]  =

{
"cue.obj[0].fgb",	&kluge.cue.obj[0].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].fgb",	&kluge.cue.obj[1].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].fgb",	&kluge.cue.obj[2].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].fgb",	&kluge.cue.obj[3].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].fgb",	&kluge.cue.obj[4].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].fgb",	&kluge.cue.obj[5].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].fgb",	&kluge.cue.obj[6].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].fgb",	&kluge.cue.obj[7].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].fgb",	&kluge.cue.obj[8].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].fgb",	&kluge.cue.obj[9].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].fgb",	&kluge.cue.obj[10].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].fgb",	&kluge.cue.obj[11].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].fgb",	&kluge.cue.obj[12].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].fgb",	&kluge.cue.obj[13].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].fgb",	&kluge.cue.obj[14].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].fgb",	&kluge.cue.obj[15].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST fgb_vl[]  =

{
"rf.obj[0].fgb",	&kluge.rf.obj[0].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].fgb",	&kluge.rf.obj[1].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].fgb",	&kluge.rf.obj[2].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].fgb",	&kluge.rf.obj[3].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].fgb",	&kluge.rf.obj[4].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].fgb",	&kluge.rf.obj[5].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].fgb",	&kluge.rf.obj[6].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].fgb",	&kluge.rf.obj[7].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].fgb",	&kluge.rf.obj[8].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].fgb",	&kluge.rf.obj[9].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].fgb",	&kluge.rf.obj[10].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].fgb",	&kluge.rf.obj[11].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].fgb",	&kluge.rf.obj[12].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].fgb",	&kluge.rf.obj[13].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].fgb",	&kluge.rf.obj[14].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].fgb",	&kluge.rf.obj[15].fgb, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST bgr_vl[]  =

{
"rf.obj[0].bgr",	&kluge.rf.obj[0].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].bgr",	&kluge.rf.obj[1].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].bgr",	&kluge.rf.obj[2].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].bgr",	&kluge.rf.obj[3].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].bgr",	&kluge.rf.obj[4].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].bgr",	&kluge.rf.obj[5].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].bgr",	&kluge.rf.obj[6].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].bgr",	&kluge.rf.obj[7].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].bgr",	&kluge.rf.obj[8].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].bgr",	&kluge.rf.obj[9].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].bgr",	&kluge.rf.obj[10].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].bgr",	&kluge.rf.obj[11].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].bgr",	&kluge.rf.obj[12].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].bgr",	&kluge.rf.obj[13].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].bgr",	&kluge.rf.obj[14].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].bgr",	&kluge.rf.obj[15].bgr, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST bgg_vl[]  =

{
"rf.obj[0].bgg",&kluge.rf.obj[0].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].bgg",&kluge.rf.obj[1].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].bgg",&kluge.rf.obj[2].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].bgg",&kluge.rf.obj[3].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].bgg",&kluge.rf.obj[4].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].bgg",&kluge.rf.obj[5].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].bgg",&kluge.rf.obj[6].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].bgg",&kluge.rf.obj[7].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].bgg",&kluge.rf.obj[8].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].bgg",&kluge.rf.obj[9].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].bgg",&kluge.rf.obj[10].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].bgg",&kluge.rf.obj[11].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].bgg",&kluge.rf.obj[12].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].bgg",&kluge.rf.obj[13].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].bgg",&kluge.rf.obj[14].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].bgg",&kluge.rf.obj[15].bgg, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST bgb_vl[]  =

{
"rf.obj[0].bgb",	&kluge.rf.obj[0].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].bgb",	&kluge.rf.obj[1].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].bgb",	&kluge.rf.obj[2].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].bgb",	&kluge.rf.obj[3].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].bgb",	&kluge.rf.obj[4].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].bgb",	&kluge.rf.obj[5].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].bgb",	&kluge.rf.obj[6].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].bgb",	&kluge.rf.obj[7].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].bgb",	&kluge.rf.obj[8].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].bgb",	&kluge.rf.obj[9].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].bgb",	&kluge.rf.obj[10].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].bgb",	&kluge.rf.obj[11].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].bgb",	&kluge.rf.obj[12].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].bgb",	&kluge.rf.obj[13].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].bgb",	&kluge.rf.obj[14].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].bgb",	&kluge.rf.obj[15].bgb, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};



VLIST rmode_vl[]  =

{
"rf.obj[0].mode",&kluge.rf.obj[0].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].mode",&kluge.rf.obj[1].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].mode",&kluge.rf.obj[2].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].mode",&kluge.rf.obj[3].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].mode",&kluge.rf.obj[4].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].mode",&kluge.rf.obj[5].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].mode",&kluge.rf.obj[6].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].mode",&kluge.rf.obj[7].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].mode",&kluge.rf.obj[8].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].mode",&kluge.rf.obj[9].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].mode",&kluge.rf.obj[10].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].mode",&kluge.rf.obj[11].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].mode",&kluge.rf.obj[12].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].mode",&kluge.rf.obj[13].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].mode",&kluge.rf.obj[14].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].mode",&kluge.rf.obj[15].mode, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST tlink_vl[]  =

{
"cue.obj[0].thlink",&kluge.cue.obj[0].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[1].thlink",&kluge.cue.obj[1].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[2].thlink",&kluge.cue.obj[2].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[3].thlink",&kluge.cue.obj[3].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[4].thlink",&kluge.cue.obj[4].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[5].thlink",&kluge.cue.obj[5].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[6].thlink",&kluge.cue.obj[6].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[7].thlink",&kluge.cue.obj[7].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[8].thlink",&kluge.cue.obj[8].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[9].thlink",&kluge.cue.obj[9].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[10].thlink",&kluge.cue.obj[10].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[11].thlink",&kluge.cue.obj[11].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[12].thlink",&kluge.cue.obj[12].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[13].thlink",&kluge.cue.obj[13].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[14].thlink",&kluge.cue.obj[14].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.obj[15].thlink",&kluge.cue.obj[15].thlink, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST rv1_vl[]  =

{
"rf.obj[0].var1",&kluge.rf.obj[0].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].var1",&kluge.rf.obj[1].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].var1",&kluge.rf.obj[2].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].var1",&kluge.rf.obj[3].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].var1",&kluge.rf.obj[4].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].var1",&kluge.rf.obj[5].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].var1",&kluge.rf.obj[6].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].var1",&kluge.rf.obj[7].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].var1",&kluge.rf.obj[8].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].var1",&kluge.rf.obj[9].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].var1",&kluge.rf.obj[10].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].var1",&kluge.rf.obj[11].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].var1",&kluge.rf.obj[12].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].var1",&kluge.rf.obj[13].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].var1",&kluge.rf.obj[14].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].var1",&kluge.rf.obj[15].var1, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST rv2_vl[]  =

{
"rf.obj[0].var2",&kluge.rf.obj[0].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].var2",&kluge.rf.obj[1].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].var2",&kluge.rf.obj[2].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].var2",&kluge.rf.obj[3].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].var2",&kluge.rf.obj[4].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].var2",&kluge.rf.obj[5].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].var2",&kluge.rf.obj[6].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].var2",&kluge.rf.obj[7].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].var2",&kluge.rf.obj[8].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].var2",&kluge.rf.obj[9].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].var2",&kluge.rf.obj[10].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].var2",&kluge.rf.obj[11].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].var2",&kluge.rf.obj[12].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].var2",&kluge.rf.obj[13].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].var2",&kluge.rf.obj[14].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].var2",&kluge.rf.obj[15].var2, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST rv3_vl[]  =

{
"rf.obj[0].var3",&kluge.rf.obj[0].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[1].var3",&kluge.rf.obj[1].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[2].var3",&kluge.rf.obj[2].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[3].var3",&kluge.rf.obj[3].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[4].var3",&kluge.rf.obj[4].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[5].var3",&kluge.rf.obj[5].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[6].var3",&kluge.rf.obj[6].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[7].var3",&kluge.rf.obj[7].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[8].var3",&kluge.rf.obj[8].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[9].var3",&kluge.rf.obj[9].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[10].var3",&kluge.rf.obj[10].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[11].var3",&kluge.rf.obj[11].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[12].var3",&kluge.rf.obj[12].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[13].var3",&kluge.rf.obj[13].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[14].var3",&kluge.rf.obj[14].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.obj[15].var3",&kluge.rf.obj[15].var3, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST rfobjects_vl[]  =

{
"rf.object[0]",		&kluge.rf.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[1]",		&kluge.rf.object[1], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[2]",		&kluge.rf.object[2], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[3]",		&kluge.rf.object[3], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[4]",		&kluge.rf.object[4], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[5]",		&kluge.rf.object[5], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[6]",		&kluge.rf.object[6], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[7]",		&kluge.rf.object[7], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[8]",		&kluge.rf.object[8], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[9]",		&kluge.rf.object[9], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[10]",	&kluge.rf.object[10], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[11]",	&kluge.rf.object[11], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[12]",	&kluge.rf.object[12], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[13]",	&kluge.rf.object[13], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[14]",	&kluge.rf.object[14], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.object[15]",	&kluge.rf.object[15], NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};



VLIST rf2objects_vl[]  = { 

"rf2.object[0]",	&kluge.rf2.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[1]",	&kluge.rf2.object[1], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[2]",	&kluge.rf2.object[2], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[3]",	&kluge.rf2.object[3], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[4]",	&kluge.rf2.object[4], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[5]",	&kluge.rf2.object[5], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[6]",	&kluge.rf2.object[6], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[7]",	&kluge.rf2.object[7], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[8]",	&kluge.rf2.object[8], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[9]",	&kluge.rf2.object[9], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[10]",	&kluge.rf2.object[10], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[11]",	&kluge.rf2.object[11], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[12]",	&kluge.rf2.object[12], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[13]",	&kluge.rf2.object[13], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[14]",	&kluge.rf2.object[14], NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.object[15]",	&kluge.rf2.object[15], NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST jmp1objects_vl[]  = {

"jmp1.object[0]",	&kluge.jmp1.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[1]",	&kluge.jmp1.object[1], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[2]",	&kluge.jmp1.object[2], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[3]",	&kluge.jmp1.object[3], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[4]",	&kluge.jmp1.object[4], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[5]",	&kluge.jmp1.object[5], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[6]",	&kluge.jmp1.object[6], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[7]",	&kluge.jmp1.object[7], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[8]",	&kluge.jmp1.object[8], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[9]",	&kluge.jmp1.object[9], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[10]",	&kluge.jmp1.object[10], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[11]",	&kluge.jmp1.object[11], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[12]",	&kluge.jmp1.object[12], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[13]",	&kluge.jmp1.object[13], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[14]",	&kluge.jmp1.object[14], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.object[15]",	&kluge.jmp1.object[15], NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST jmp2objects_vl[]  = {

"jmp2.object[0]",	&kluge.jmp2.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[1]",	&kluge.jmp2.object[1], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[2]",	&kluge.jmp2.object[2], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[3]",	&kluge.jmp2.object[3], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[4]",	&kluge.jmp2.object[4], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[5]",	&kluge.jmp2.object[5], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[6]",	&kluge.jmp2.object[6], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[7]",	&kluge.jmp2.object[7], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[8]",	&kluge.jmp2.object[8], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[9]",	&kluge.jmp2.object[9], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[10]",	&kluge.jmp2.object[10], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[11]",	&kluge.jmp2.object[11], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[12]",	&kluge.jmp2.object[12], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[13]",	&kluge.jmp2.object[13], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[14]",	&kluge.jmp2.object[14], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.object[15]",	&kluge.jmp2.object[15], NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST cueobjects_vl[]  = {

"cue.object[0]",	&kluge.cue.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[1]",	&kluge.cue.object[1], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[2]",	&kluge.cue.object[2], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[3]",	&kluge.cue.object[3], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[4]",	&kluge.cue.object[4], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[5]",	&kluge.cue.object[5], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[6]",	&kluge.cue.object[6], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[7]",	&kluge.cue.object[7], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[8]",	&kluge.cue.object[8], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[9]",	&kluge.cue.object[9], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[10]",	&kluge.cue.object[10], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[11]",	&kluge.cue.object[11], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[12]",	&kluge.cue.object[12], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[13]",	&kluge.cue.object[13], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[14]",	&kluge.cue.object[14], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.object[15]",	&kluge.cue.object[15], NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST cue2objects_vl[]  = {

"cue2.object[0]",	&kluge.cue2.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[1]",	&kluge.cue2.object[1], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[2]",	&kluge.cue2.object[2], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[3]",	&kluge.cue2.object[3], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[4]",	&kluge.cue2.object[4], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[5]",	&kluge.cue2.object[5], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[6]",	&kluge.cue2.object[6], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[7]",	&kluge.cue2.object[7], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[8]",	&kluge.cue2.object[8], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[9]",	&kluge.cue2.object[9], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[10]",	&kluge.cue2.object[10], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[11]",	&kluge.cue2.object[11], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[12]",	&kluge.cue2.object[12], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[13]",	&kluge.cue2.object[13], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[14]",	&kluge.cue2.object[14], NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.object[15]",	&kluge.cue2.object[15], NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


VLIST perf_vl[] = {
"correct",	&tyes,	NP,	NP,	0,	ME_DEC,
"wrong",	&tno,	NP,	NP,	0,	ME_DEC,
"fix_breaks",	&fbrk,	NP,	NP,	0,	ME_DEC,
"aborts",	&abttrl,NP,	NP,	0,	ME_DEC,
NS,
};

RTVAR rtvars[] = {
{"percent correct", &percent_cor},
{"num. trials",	&tot_num_trials},
{"correct",	&tyes},
{"wrong",	&tno},
{"fix_breaks",	&fbrk},
{"aborts",	&abttrl},
{"array index",	&arrayIndex},
{"",0},
};


/*stateset menus and arrays*/
VLIST devices_vl[];

VLIST devices_vl[] = {
"testDevice",		&testDevice,   NP, NP, 0, ME_LHEX,
"flashDevice",		&flashDevice,  NP, NP, 0, ME_LHEX,
"beepDevice",		&beepDevice,   NP, NP, 0, ME_LHEX,
"rewardDevice",		&rewardDevice, NP, NP, 0, ME_LHEX,
"photooutDevice",	&photooutDevice, NP, NP, 0, ME_LHEX,
/*"ampSwitch",		&ampSwitch,    NP, NP, 0, ME_LHEX,
"grassDevice",		&grassDevice,  NP, NP, 0, ME_LHEX,*/
NS,
};
 
VLIST saccades_vl[] = { 
"hormov1",			&hormov1, NP, NP,0, ME_DEC,
"vermov1",			&vermov1, NP, NP,0, ME_DEC,
"hormov2",			&hormov2, NP, NP,0, ME_DEC,
"vermov2",			&vermov2, NP, NP,0, ME_DEC,
"fudge1h",			&fudge1h, NP, NP,0, ME_DEC,
"fudge1v",			&fudge1v, NP, NP,0, ME_DEC,
"fudge2h",			&fudge2h, NP, NP,0, ME_DEC,
"fudge2v",			&fudge2v, NP, NP,0, ME_DEC,
NS,
};

char hm_thresh[] = "\n\
1 x position \n\
2 y position \n\
3 luminance \n\
4 pattern \n\
5 checksize \n\
"
;

char hm_flags_vl[] =  "\n\
Mirror control flags:\n\
0 No mirror 0 \n\
1 Mir1 from array\n\
2 Mir1 from joy\n\
3 Joy moves Mir1\n\
4 Mir2 from array\n\
5 Mir2 from joy \n\
6 Joy moves Mir2\n\
7 Mir1 to arr + joy\n\
8 Mir2 to arr + joy\n\
9 Stimulate (rf only)\n\
Bar Flag Codes\n\
0 No Bar\n\
1 Right Bar\n\
2 Left Bar\n\
3 Both Bars\n\
"
;


/* Menu: "array"*/
VLIST array_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf, ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf, ME_AFT, ME_DEC,
"index",		&kluge.index,	NP, NP,		0,	ME_DEC,
"fpx",			&kluge.fp.obj[0].x,	NP, kluge_vaf,	ME_AFT,	ME_DEC,
"fpy",			&kluge.fp.obj[0].y,	NP, kluge_vaf,	ME_AFT,	ME_DEC,
"rfx",			&kluge.rf.obj[0].x,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"rfy",			&kluge.rf.obj[0].y,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"rf2x",			&kluge.rf2.obj[0].x,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"rf2y",			&kluge.rf2.obj[0].y,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"jmp1x",		&kluge.jmp1.obj[0].x,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"jmp1y",		&kluge.jmp1.obj[0].y,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"jmp2x",		&kluge.jmp2.obj[0].x,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"jmp2y",		&kluge.jmp2.obj[0].y,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"cuex",			&kluge.cue.obj[0].x,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"cuey",			&kluge.cue.obj[0].y,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"cue2x",		&kluge.cue2.obj[0].x,	NP, kluge_vaf,	ME_AFT, ME_DEC,
"cue2y",		&kluge.cue2.obj[0].y,	NP, kluge_vaf,	ME_AFT, ME_DEC,
NS,
};

/* Menu: "descriptor"*/
VLIST descriptor_vl[]  = {
"joyh_gain",		&kluge_descriptor[0], NP, joyh_gain_vaf,ME_AFT, ME_DEC,
"joyh_offset",		&kluge_descriptor[1], NP, joyh_offset_vaf,ME_AFT, ME_DEC,
"joyv_gain",		&kluge_descriptor[2], NP, joyv_gain_vaf,ME_AFT, ME_DEC,
"joyv_offset",		&kluge_descriptor[3], NP, joyv_offset_vaf,ME_AFT, ME_DEC,
"sequence_flag",	&kluge_descriptor[4], NP, descriptor_4_vaf,ME_AFT, ME_DEC,
"window_delay",		&kluge_descriptor[5], NP, descriptor_5_vaf,ME_AFT, ME_DEC,
"error_correct",	&kluge_descriptor[6], NP, descriptor_6_vaf,ME_AFT, ME_DEC,
"descriptor_7",		&kluge_descriptor[7], NP, descriptor_7_vaf,ME_AFT, ME_DEC,
NS,
};

/* Menu: "limit"*/
VLIST limit_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"current_array_index",	&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"this_index",		&kluge.index, NP,NP,0,ME_DEC,
"fpwindowx",		&kluge.fp.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpwindowy",		&kluge.fp.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2windowx",		&kluge.rf2.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2windowy",		&kluge.rf2.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1windowx",		&kluge.jmp1.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1windowy",		&kluge.jmp1.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2windowx",		&kluge.jmp2.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2windowy",		&kluge.jmp2.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST objects_vl[]  = {
"object_number ",	&klugepointer, NP, NP,0, ME_DEC,
"object_max ",		&klugeObjNumber, NP, objects_vaf,ME_AFT, ME_DEC,
"obj_x",		&klugeObject.x, NP, objects_vaf,ME_AFT, ME_DEC,
"obj_y",		&klugeObject.y, NP, objects_vaf,ME_AFT, ME_DEC,
"file",			&klugeObject.pattern, NP, objects_vaf,ME_AFT, ME_DEC,
"sign",			&klugeObject.sign, NP, objects_vaf, ME_AFT, ME_DEC,
"checksize",		&klugeObject.checksize, NP, objects_vaf, ME_AFT, ME_DEC,
"fg_luminance",		&klugeObject.fgl, NP, objects_vaf, ME_AFT, ME_DEC,
"bg_luminance",		&klugeObject.bgl, NP, objects_vaf, ME_AFT, ME_DEC,
"fg_red",		&klugeObject.fgr, NP, objects_vaf, ME_AFT, ME_DEC,
"fg_blue",		&klugeObject.fgb, NP, objects_vaf, ME_AFT, ME_DEC,
"fg_green",		&klugeObject.fgg, NP, objects_vaf, ME_AFT, ME_DEC,
"bg_red",		&klugeObject.bgr, NP, objects_vaf, ME_AFT, ME_DEC,
"bg_blue",		&klugeObject.bgb, NP, objects_vaf, ME_AFT, ME_DEC,
"bg_green",		&klugeObject.bgg, NP, objects_vaf, ME_AFT, ME_DEC,
"mode",			&klugeObject.mode, NP, objects_vaf, ME_AFT, ME_DEC,
"outer_radius",		&klugeObject.var1, NP, objects_vaf, ME_AFT, ME_DEC,
"inner_radius",		&klugeObject.var2, NP, objects_vaf, ME_AFT, ME_DEC,
"angle",	 	&klugeObject.var1, NP, objects_vaf, ME_AFT, ME_DEC,
"width",		&klugeObject.var2, NP, objects_vaf, ME_AFT, ME_DEC,
"length",		&klugeObject.var3, NP, objects_vaf, ME_AFT, ME_DEC,
NS,
};			


VLIST robjects_vl[]  = {
"current_array_index",	&arrayIndex, NP, NP,0, ME_DEC,
"rf_object_number ",	&klugepointer, NP, NP,0, ME_DEC,
"object",		&klugeObjectNumber, NP, okluge_vaf, ME_AFT, ME_DEC,
"obj_x",		&klugeObject.x, NP, okluge_vaf,ME_AFT, ME_DEC,
"obj_y",		&klugeObject.y, NP, okluge_vaf,ME_AFT, ME_DEC,
"file",			&klugeObject.pattern, NP, okluge_vaf,ME_AFT, ME_DEC,
"sign",			&klugeObject.sign, NP, okluge_vaf, ME_AFT, ME_DEC,
"checksize",		&klugeObject.checksize, NP, okluge_vaf, ME_AFT, ME_DEC,
"fg_luminance",		&klugeObject.fgl, NP, okluge_vaf, ME_AFT, ME_DEC,
"bg_luminance",		&klugeObject.bgl, NP, okluge_vaf, ME_AFT, ME_DEC,
"fg_red",		&klugeObject.fgr, NP, okluge_vaf, ME_AFT, ME_DEC,
"fg_blue",		&klugeObject.fgb, NP, okluge_vaf, ME_AFT, ME_DEC,
"fg_green",		&klugeObject.fgg, NP, okluge_vaf, ME_AFT, ME_DEC,
"bg_red",		&klugeObject.bgr, NP, okluge_vaf, ME_AFT, ME_DEC,
"bg_blue",		&klugeObject.bgb, NP, okluge_vaf, ME_AFT, ME_DEC,
"bg_green",		&klugeObject.bgg, NP, okluge_vaf, ME_AFT, ME_DEC,
"mode",			&klugeObject.mode, NP, okluge_vaf, ME_AFT, ME_DEC,
"outer_radius",		&klugeObject.var1, NP, okluge_vaf, ME_AFT, ME_DEC,
"inner_radius",		&klugeObject.var2, NP, okluge_vaf, ME_AFT, ME_DEC,
"angle",	 	&klugeObject.var1, NP, okluge_vaf, ME_AFT, ME_DEC,
"width",		&klugeObject.var2, NP, okluge_vaf, ME_AFT, ME_DEC,
"length",		&klugeObject.var3, NP, okluge_vaf, ME_AFT, ME_DEC,
NS,
};			

VLIST cobjects_vl[]  = {
"current_array_index",	&arrayIndex, NP, NP,0, ME_DEC,
"cue_object_number ",	&klugepointer, NP, NP,0, ME_DEC,
"object",		&klugeObjectNumber, NP, ckluge_vaf, ME_AFT, ME_DEC,
"obj_x",		&klugeObject.x, NP, ckluge_vaf,ME_AFT, ME_DEC,
"obj_y",		&klugeObject.y, NP, ckluge_vaf,ME_AFT, ME_DEC,
"file",			&klugeObject.pattern, NP, ckluge_vaf,ME_AFT, ME_DEC,
"sign",			&klugeObject.sign, NP, ckluge_vaf, ME_AFT, ME_DEC,
"checksize",		&klugeObject.checksize, NP, ckluge_vaf, ME_AFT, ME_DEC,
"fg_luminance",		&klugeObject.fgl, NP, ckluge_vaf, ME_AFT, ME_DEC,
"bg_luminance",		&klugeObject.bgl, NP, ckluge_vaf, ME_AFT, ME_DEC,
"fg_red",		&klugeObject.fgr, NP, ckluge_vaf, ME_AFT, ME_DEC,
"fg_blue",		&klugeObject.fgb, NP, ckluge_vaf, ME_AFT, ME_DEC,
"fg_green",		&klugeObject.fgg, NP, ckluge_vaf, ME_AFT, ME_DEC,
"bg_red",		&klugeObject.bgr, NP, ckluge_vaf, ME_AFT, ME_DEC,
"bg_blue",		&klugeObject.bgb, NP, ckluge_vaf, ME_AFT, ME_DEC,
"bg_green",		&klugeObject.bgg, NP, ckluge_vaf, ME_AFT, ME_DEC,
"mode",			&klugeObject.mode, NP, ckluge_vaf, ME_AFT, ME_DEC,
"outer_radius",		&klugeObject.var1, NP, ckluge_vaf, ME_AFT, ME_DEC,
"inner_radius",		&klugeObject.var2, NP, ckluge_vaf, ME_AFT, ME_DEC,
"angle",	 	&klugeObject.var1, NP, ckluge_vaf, ME_AFT, ME_DEC,
"width",		&klugeObject.var2, NP, ckluge_vaf, ME_AFT, ME_DEC,
"length",		&klugeObject.var3, NP, ckluge_vaf, ME_AFT, ME_DEC,
NS,
};			


/* Menu: "object0"*/
VLIST object0_vl[]  = {
"background_number ",	&klugepointer, NP, NP,0, ME_DEC,
"object0_number ",	&klugebg.object[0], NP, NP,0, ME_DEC,
"obj_x",		&klugebg.bgobj[0].x, NP, object0_vaf,ME_AFT, ME_DEC,
"obj_y",		&klugebg.bgobj[0].y, NP, object0_vaf,ME_AFT, ME_DEC,
"pattern",		&klugebg.bgobj[0].pattern, NP, object0_vaf,ME_AFT, ME_DEC,
"sign",			&klugebg.bgobj[0].sign, NP, object0_vaf, ME_AFT, ME_DEC,
"checksize",		&klugebg.bgobj[0].checksize, NP, object0_vaf, ME_AFT, ME_DEC,
"fg_luminance",		&klugebg.bgobj[0].fgl, NP, object0_vaf, ME_AFT, ME_DEC,
"bg_luminance",		&klugebg.bgobj[0].bgl, NP, object0_vaf, ME_AFT, ME_DEC,
"fg_red",		&klugebg.bgobj[0].fgr, NP, object0_vaf, ME_AFT, ME_DEC,
"fg_blue",		&klugebg.bgobj[0].fgb, NP, object0_vaf, ME_AFT, ME_DEC,
"fg_green",		&klugebg.bgobj[0].fgg, NP, object0_vaf, ME_AFT, ME_DEC,
"bg_red",		&klugebg.bgobj[0].bgr, NP, object0_vaf, ME_AFT, ME_DEC,
"bg_blue",		&klugebg.bgobj[0].bgb, NP, object0_vaf, ME_AFT, ME_DEC,
"bg_green",		&klugebg.bgobj[0].bgg, NP, object0_vaf, ME_AFT, ME_DEC,
"mode",			&klugebg.bgobj[0].mode, NP, object0_vaf, ME_AFT, ME_DEC,
NS,
};			

/* Menu: "object1"*/
VLIST object1_vl[]  = {
"background_number ",	&klugepointer, NP, NP,0, ME_DEC,
"object1_number ",	&klugebg.object[1], NP, NP,0, ME_DEC,
"obj_x",		&klugebg.bgobj[1].x, NP, object1_vaf,ME_AFT, ME_DEC,
"obj_y",		&klugebg.bgobj[1].y, NP, object1_vaf,ME_AFT, ME_DEC,
"pattern",		&klugebg.bgobj[1].pattern, NP, object1_vaf,ME_AFT, ME_DEC,
"sign",			&klugebg.bgobj[1].sign, NP, object1_vaf, ME_AFT, ME_DEC,
"checksize",		&klugebg.bgobj[1].checksize, NP, object1_vaf, ME_AFT, ME_DEC,
"fg_luminance",		&klugebg.bgobj[1].fgl, NP, object1_vaf, ME_AFT, ME_DEC,
"bg_luminance",		&klugebg.bgobj[1].bgl, NP, object1_vaf, ME_AFT, ME_DEC,
"fg_red",		&klugebg.bgobj[1].fgr, NP, object1_vaf, ME_AFT, ME_DEC,
"fg_blue",		&klugebg.bgobj[1].fgb, NP, object1_vaf, ME_AFT, ME_DEC,
"fg_green",		&klugebg.bgobj[1].fgg, NP, object1_vaf, ME_AFT, ME_DEC,
"bg_red",		&klugebg.bgobj[1].bgr, NP, object1_vaf, ME_AFT, ME_DEC,
"bg_blue",		&klugebg.bgobj[1].bgb, NP, object1_vaf, ME_AFT, ME_DEC,
"bg_green",		&klugebg.bgobj[1].bgg, NP, object1_vaf, ME_AFT, ME_DEC,
"mode",			&klugebg.bgobj[1].mode, NP, object1_vaf, ME_AFT, ME_DEC,
NS,
};			


/* Menu: "backgrounds" */
VLIST backgrounds_vl[]  = {
"bg_luminance",		&bkgd_lum, NP, bglum_vaf, ME_AFT, ME_DEC,
"bg_for_flash",		&bkgd_lumX, NP, bglum_vaf, ME_AFT, ME_DEC,
"background_number",	&kluge.index, NP, NP,0, ME_DEC,
"background_max",	&klugeBackgroundNumber, NP, backgrounds_vaf,ME_AFT, ME_DEC,
"bg_object0_number",	&klugebg.object[0], NP, bgobject0_vaf,ME_AFT, ME_DEC,
"bg_object1_number",	&klugebg.object[1], NP, bgobject1_vaf,ME_AFT, ME_DEC,
/*"object0_menu",		&object0, NP, NP,0, ME_SUBMENU,
"object1_menu",		&object1, NP, NP,0, ME_SUBMENU,*/
NS,
};

char hm_backgrounds[] =  "\n\
Use odd number object\n\
for background\n\
(1, 3, 5, 7,...23)\n\n\
"
;


/*menu:times*/
VLIST times_vl[]  = {
"array_max",		&kluge_array_max,  NP, array_max_vaf, ME_AFT, ME_DEC,
"array_index",		&kluge_array_index,NP, array_index_vaf,ME_AFT,ME_DEC,
"index",		&kluge.index,      NP, NP,            0,      ME_DEC,
"trial(fp)time",	&kluge.fp.time,    NP, kluge_vaf,    ME_AFT, ME_DEC,
"ITI",			&kluge.fp.delay,   NP, kluge_vaf,   ME_AFT, ME_DEC,
"rftime",		&kluge.rf.time,    NP, kluge_vaf,    ME_AFT, ME_DEC,
"rfdelay",		&kluge.rf.delay,   NP, kluge_vaf,   ME_AFT, ME_DEC,
"rf2time",		&kluge.rf2.time,   NP, kluge_vaf,    ME_AFT, ME_DEC,
"rf2delay",		&kluge.rf2.delay,  NP, kluge_vaf,   ME_AFT, ME_DEC,
"jmp1time",		&kluge.jmp1.time,  NP, kluge_vaf,  ME_AFT, ME_DEC,
"jmp1delay", 		&kluge.jmp1.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2time",		&kluge.jmp2.time,  NP, kluge_vaf,  ME_AFT, ME_DEC,
"jmp2delay",		&kluge.jmp2.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"cuetime",		&kluge.cue.time,   NP, kluge_vaf,   ME_AFT, ME_DEC,
"cuedelay",		&kluge.cue.delay,  NP, kluge_vaf,  ME_AFT, ME_DEC,
"cue2time",		&kluge.cue2.time,   NP, kluge_vaf,   ME_AFT, ME_DEC,
"cue2delay",		&kluge.cue2.delay,  NP, kluge_vaf,  ME_AFT, ME_DEC,
NS,
};

/*menu: cue */
VLIST cue_vl[]  = {
"array_max",		&kluge_array_max,   NP,  array_max_vaf,    ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP,  array_index_vaf,  ME_AFT, ME_DEC,
"index",		&kluge.index,       NP,  NP,               0,      ME_DEC,
"obj[0].x",		&kluge.cue.obj[0].x, NP,kluge_vaf, ME_AFT, ME_DEC,		
"obj[0].y",		&kluge.cue.obj[0].y, NP,kluge_vaf, ME_AFT, ME_DEC,		
"cuex",			&kluge.cue.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cuey",			&kluge.cue.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue.device",		&kluge.cue.device,  NP,  kluge_vaf,    ME_AFT, ME_LHEX,
"threshold",		&kluge.cue.falsereward,  NP,  kluge_vaf, ME_AFT, ME_DEC,
"cuetime",		&kluge.cue.time,    NP,  kluge_vaf,      ME_AFT, ME_DEC,
"cuedelay",		&kluge.cue.delay,   NP,  kluge_vaf,     ME_AFT, ME_DEC,
"cuecontrol",		&kluge.cue.control, NP,  kluge_vaf,   ME_AFT, ME_DEC,
"threshold_good",	&kluge_good, NP, kluge_vaf, ME_AFT, ME_DEC,
"threshold_bad",	&kluge_bad, NP, kluge_vaf, ME_AFT, ME_DEC,
"cueinterface",		&kluge.cue.interface,NP, kluge_vaf, ME_AFT, ME_DEC,
"cueNum_of_Objects",	&kluge.cue.objectNumber, NP, kluge_vaf, ME_AFT, ME_DEC,
"cuebackground",	&kluge.cue.background,NP,kluge_vaf,ME_AFT, ME_DEC,
"threshold_group",	&kluge.cue.object_dim,  NP,  kluge_vaf, ME_AFT, ME_DEC,
"staircase_size",	&kluge.cue.counter, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};


/*menu: cue2 */
VLIST gap_vl[]  = {
"array_max",		&kluge_array_max,   NP,  array_max_vaf,    ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP,  array_index_vaf,  ME_AFT, ME_DEC,
"index",		&kluge.index,       NP,  NP,               0,      ME_DEC,
"gap1time",		&kluge.gap.time,    NP,  kluge_vaf,      ME_AFT, ME_DEC,
"gap2time",		&kluge.gap.delay,   NP,  kluge_vaf,     ME_AFT, ME_DEC,
"backOn_gap1",		&kluge.gap.windowx, NP,  kluge_vaf,	ME_AFT, ME_DEC,
"backOn_gap2",		&kluge.gap.windowy, NP,  kluge_vaf,	ME_AFT, ME_DEC,
NS,
};			

VLIST cue2_vl[]  = {
"array_max",		&kluge_array_max,   NP,  array_max_vaf,    ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP,  array_index_vaf,  ME_AFT, ME_DEC,
"index",		&kluge.index,       NP,  NP,               0,      ME_DEC,
"obj[0].x",		&kluge.cue2.obj[0].x, NP,kluge_vaf, ME_AFT, ME_DEC,		
"obj[0].y",		&kluge.cue2.obj[0].y, NP,kluge_vaf, ME_AFT, ME_DEC,		
"cue2x",		&kluge.cue2.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2y",		&kluge.cue2.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2.device",		&kluge.cue2.device,  NP,  kluge_vaf,    ME_AFT, ME_LHEX,
"cue2device_dim",	&kluge.cue2.device_dim,NP,kluge_vaf,ME_AFT, ME_LHEX,
"cue2time",		&kluge.cue2.time,    NP,  kluge_vaf,      ME_AFT, ME_DEC,
"cue2delay",		&kluge.cue2.delay,   NP,  kluge_vaf,     ME_AFT, ME_DEC,
"cue2control",		&kluge.cue2.control, NP,  kluge_vaf,   ME_AFT, ME_DEC,
"cue2windowx",		&kluge.cue2.windowx, NP,  kluge_vaf,   ME_AFT, ME_DEC,
"cue2windowy",		&kluge.cue2.windowy, NP,  kluge_vaf,   ME_AFT, ME_DEC,
"cue2interface",	&kluge.cue2.interface,NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2Num_of_Objects",	&kluge.cue2.objectNumber, NP, kluge_vaf, ME_AFT, ME_DEC,
"cue2background",	&kluge.cue2.background,NP,kluge_vaf,ME_AFT, ME_DEC,
NS,
};			

/*menu: rf */
VLIST rf_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"pointer",		&klugepointer, NP,NP,0,ME_DEC,
"obj[0].x",		&kluge.rf.obj[0].x, NP,kluge_vaf, ME_AFT, ME_DEC,		
"obj[0].y",		&kluge.rf.obj[0].y, NP,kluge_vaf, ME_AFT, ME_DEC,		
"rfx",			&kluge.rf.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfy",			&kluge.rf.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf.device",		&kluge.rf.device, NP, kluge_vaf, ME_AFT, ME_LHEX,
"rfdevice_dim",		&kluge.rf.device_dim, NP, kluge_vaf, ME_AFT, ME_LHEX,
"rftime",		&kluge.rf.time, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfdelay",		&kluge.rf.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfcontrol",		&kluge.rf.control, NP, kluge_vaf, ME_AFT, ME_DEC,
"threshold_good",	&kluge_good, NP, kluge_vaf, ME_AFT, ME_DEC,
"threshold_bad",	&kluge_bad, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfwindowy",		&kluge.rf.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfinterface",		&kluge.rf.interface, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfNum_of_Objects",	&kluge.rf.objectNumber, NP, kluge_vaf, ME_AFT, ME_DEC,
"rfbackground",		&kluge.rf.background,NP,kluge_vaf,ME_AFT, ME_DEC,
NS,
};			

VLIST jmp1_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"obj[0].x",		&kluge.jmp1.obj[0].x, NP,kluge_vaf, ME_AFT, ME_DEC,		
"obj[0].y",		&kluge.jmp1.obj[0].y, NP,kluge_vaf, ME_AFT, ME_DEC,		
"jmp1x",		&kluge.jmp1.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1y",		&kluge.jmp1.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1.device",		&kluge.jmp1.device, NP, kluge_vaf, ME_AFT, ME_LHEX,
"jmp1device_dim",	&kluge.jmp1.device_dim, NP, kluge_vaf, ME_AFT, ME_LHEX,
"jmp1time",		&kluge.jmp1.time, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1delay",		&kluge.jmp1.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1control",		&kluge.jmp1.control, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1windowx",		&kluge.jmp1.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1windowy",		&kluge.jmp1.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1interface",	&kluge.jmp1.interface, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1_object",		&kluge.jmp1.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1_object_dim",	&kluge.jmp1.object_dim, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1Num_of_Objects",	&kluge.jmp1.objectNumber, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1addrand",		&kluge.jmp1.falsereward, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1RandFlag",		&kluge.jmp1.RandFlag, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1NumRandJumps",	&kluge.jmp1.NumRandJumps, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp1RandJumpSize",	&kluge.jmp1.RandJumpSize, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};			


/*menu: rf2 */
VLIST rf2_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"obj[0].x",		&kluge.rf2.obj[0].x, NP,kluge_vaf, ME_AFT, ME_DEC,		
"obj[0].y",		&kluge.rf2.obj[0].y, NP,kluge_vaf, ME_AFT, ME_DEC,		
"rf2x",			&kluge.rf2.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2y",			&kluge.rf2.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2.device",		&kluge.rf2.device, NP, kluge_vaf, ME_AFT, ME_LHEX,
"rf2device_dim",	&kluge.rf2.device_dim, NP, kluge_vaf, ME_AFT, ME_LHEX,
"rf2time",		&kluge.rf2.time, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2delay",		&kluge.rf2.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2control",		&kluge.rf2.control, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2windowx",		&kluge.rf2.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2windowy",		&kluge.rf2.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2interface",	&kluge.rf2.interface, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2Num_of_Objects",	&kluge.rf2.objectNumber, NP, kluge_vaf, ME_AFT, ME_DEC,
"rf2background",	&kluge.rf2.background,NP,kluge_vaf,ME_AFT, ME_DEC,
NS,
};			


VLIST jmp2_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"obj[0].x",		&kluge.jmp2.obj[0].x, NP,kluge_vaf, ME_AFT, ME_DEC,		
"obj[0].y",		&kluge.jmp2.obj[0].y, NP,kluge_vaf, ME_AFT, ME_DEC,		
"jmp2x",		&kluge.jmp2.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2y",		&kluge.jmp2.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2.device",		&kluge.jmp2.device, NP, kluge_vaf, ME_AFT, ME_LHEX,
"jmp2device_dim",	&kluge.jmp2.device_dim, NP, kluge_vaf, ME_AFT, ME_LHEX,
"jmp2time",		&kluge.jmp2.time, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2delay",		&kluge.jmp2.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2control",		&kluge.jmp2.control, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2windowx",		&kluge.jmp2.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2windowy",		&kluge.jmp2.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2interface",	&kluge.jmp2.interface, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2Num_of_Objects",	&kluge.jmp2.objectNumber, NP, kluge_vaf, ME_AFT, ME_DEC,
"jmp2RwdFlag",		&menu_jmp2RwdFlag, NP, jmp2RwdFlag_vaf, ME_AFT, ME_DEC,
"jmp2RewardDelay",      &menu_jmp2RwdDelay,NP,jmp2RwdDelay_vaf, ME_AFT, ME_DEC,
NS,
};			

VLIST fp_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"fpx",			&kluge.fp.obj[0].x, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpy",			&kluge.fp.obj[0].y, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpdevice",		&kluge.fp.device, NP, kluge_vaf, ME_AFT, ME_LHEX,
"fpdevice_dim",		&kluge.fp.device_dim, NP, kluge_vaf, ME_AFT, ME_LHEX,
"trial(fp)time",	&kluge.fp.time, NP, kluge_vaf, ME_AFT, ME_DEC,
"ITI",			&kluge.fp.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpcontrol",		&kluge.fp.control, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpwindowx", 		&kluge.fp.windowx, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpwindowy",		&kluge.fp.windowy, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpinterface",		&kluge.fp.interface, NP, kluge_vaf, ME_AFT, ME_DEC,
"fpobject",		&kluge.fp.object[0], NP, kluge_vaf, ME_AFT, ME_DEC,
"fp_object_dim",	&kluge.fp.object_dim, NP, kluge_vaf, ME_AFT, ME_DEC,
"fp_falsereward",	&kluge.fp.falsereward, NP, kluge_vaf, ME_AFT, ME_DEC,
"ratio_for_shuffle",	&kluge.fp.background, NP, kluge_vaf, ME_AFT, ME_DEC,
NS,
};	

VLIST ramp_vl[]  = {
"array_max", 		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"length",		&kluge.rmp.x, NP, kluge_vaf, ME_AFT, ME_DEC,
"angle",		&kluge.rmp.y, NP, kluge_vaf, ME_AFT, ME_DEC,
"velocity",		&kluge.rmp.delay, NP, kluge_vaf, ME_AFT, ME_DEC,
"type",			&kluge.rmp.control, NP, kluge_vaf, ME_AFT,ME_OCT,
NS,
};

VLIST interface_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"fpdevice",		&kluge.fp.device, NP, kluge_vaf, ME_AFT, ME_LHEX,
"fpdevice_dim",		&kluge.fp.device_dim, NP, kluge_vaf, ME_AFT, ME_LHEX,
"rfdevice",		&kluge.rf.device, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"rfdevice_dim",	&kluge.rf.device_dim, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"rf2device",		&kluge.rf2.device, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"rf2device_dim",	&kluge.rf2.device_dim, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"jmp1device",		&kluge.jmp1.device, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"jmp1device_dim",	&kluge.jmp1.device_dim, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"jmp2device",		&kluge.jmp2.device, NP,  kluge_vaf, ME_AFT, ME_LHEX,
"jmp2device_dim",	&kluge.jmp2.device_dim, NP,  kluge_vaf, ME_AFT, ME_LHEX,
NS,
};			

VLIST flags_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"arrayflag",		&kluge.flag, NP, flag_vaf, ME_AFT, ME_OCT,
"rfflag",		&kluge_rf_flag, NP, rf_flag_vaf, ME_AFT, ME_DEC,
"rf2flag",		&kluge_rf2_flag, NP, rf2_flag_vaf, ME_AFT, ME_DEC,
"jmp1flag",		&kluge_jmp1Flag, NP, jmp1flag_vaf, ME_AFT, ME_DEC,
/*"jmp1randflag",         &kluge_jRandFlag, NP, jrandflag_vaf, ME_AFT,
ME_DEC,*/
"jmp1cueflag",		&kluge_jmp1cueflag, NP, jmp1cueflag_vaf, ME_AFT, ME_DEC,
"jmp1cue2flag",		&kluge_jmp1cue2flag, NP, jmp1cue2flag_vaf, ME_AFT, ME_DEC,
"jmp2flag",		&kluge_jmp2Flag, NP, jmp2flag_vaf, ME_AFT, ME_DEC,
"jmp2cueflag",		&kluge_jmp2cueflag, NP, jmp2cueflag_vaf, ME_AFT, ME_DEC,
"jmp2cue2flag",		&kluge_jmp2cue2flag, NP, jmp2cue2flag_vaf, ME_AFT, ME_DEC,
"grassflag",		&kluge_grassflag, NP, grassflag_vaf, ME_AFT, ME_DEC,
"fixjmpcueflag",       	&kluge_fixjmpcueflag, NP, fixjmpcueflag_vaf, ME_AFT, ME_DEC,
"jmp2sacflag",		&kluge_jmp2sacflag, NP, jmp2sacflag_vaf, ME_AFT, ME_DEC,
"backon1flag",		&kluge_backon1flag, NP, backon1flag_vaf, ME_AFT, ME_OCT,
"backon2flag",		&kluge_backon2flag, NP, backon2flag_vaf, ME_AFT, ME_OCT,
"nogoflag",		&kluge_nogoflag, NP, nogoflag_vaf, ME_AFT, ME_DEC,
"barflag",		&kluge_barflag, NP, barflag_vaf, ME_AFT, ME_DEC,
"baroffflag",		&kluge_baroffflag, NP, baroffflag_vaf, ME_AFT, ME_DEC,
"cuebarflag",		&kluge_cuebarflag, NP, cuebarflag_vaf, ME_AFT, ME_DEC,
"rfshuffle",		&kluge_rfshuffleflag, NP, rfshuffleflag_vaf, ME_AFT, ME_DEC,
"fpRandFlag",		&kluge_fpRandFlag, NP, fprand_vaf, ME_AFT, ME_DEC,
"fpRandSize",		&kluge_fpRandSize, NP, fprand_vaf, ME_AFT, ME_DEC,
NS,
};

VLIST cflags_vl[]  = {
"array_max",		&kluge_array_max, NP, array_max_vaf,ME_AFT, ME_DEC,
"array_index",		&kluge_array_index, NP, array_index_vaf,ME_AFT, ME_DEC,
"index",		&kluge.index, NP,NP,0,ME_DEC,
"fpcontrol",		&kluge.fp.control, NP, fpcontrol_vaf, ME_AFT, ME_DEC,
"rfcontrol",		&kluge.rf.control, NP, rfcontrol_vaf, ME_AFT, ME_DEC,
"rf2control",		&kluge.rf2.control, NP, rf2control_vaf, ME_AFT, ME_DEC,
"jmp1control",		&kluge.jmp1.control, NP, jmp1control_vaf, ME_AFT, ME_DEC,
"jmp2control",		&kluge.jmp2.control, NP, jmp2control_vaf, ME_AFT, ME_DEC,
"cuecontrol",		&kluge.cue.control, NP, cuecontrol_vaf, ME_AFT, ME_DEC,
"cue2control",		&kluge.cue2.control, NP, cue2control_vaf, ME_AFT, ME_DEC,
NS,
};			

/*
VLIST listest_vl[]={
"FPx",		&slistfpx, NP, listpos_vaf, ME_AFT, ME_STR,
"FPy",		&slistfpy, NP, listpos_vaf, ME_AFT, ME_STR,
"RFx",		&slistrfx, NP, listpos_vaf, ME_AFT, ME_STR,
"RFy",		&slistrfy, NP, listpos_vaf, ME_AFT, ME_STR,
"RF2x",		&slistrf2x, NP,listpos_vaf, ME_AFT, ME_STR,
"RF2y",		&slistrf2y, NP,listpos_vaf, ME_AFT, ME_STR,
"Jmpx",		&slistjumpx, NP,listpos_vaf, ME_AFT, ME_STR,
"Jmpy",		&slistjumpy, NP,listpos_vaf, ME_AFT, ME_STR,     
NS,
};

 */

VLIST state_vl[] = {
/*"no_of_pulses",			&pulsenum,NP,NP,0,ME_DEC,*/
"seqmarker",                  &et_marker,NP,NP,0,ME_DEC,
"window_delay",			&window_delay,NP,NP,0,ME_DEC,
/*"ramp_window_delay",		&ramp_window_delay,NP,NP,0,ME_DEC,*/
/*
"cheat_window_size",		&noCheat,NP,NP,0,ME_DEC,
"cheat_window_time",		&jmpCheckDelay,NP,NP,0,ME_DEC,
"continuous_trials",		&continueflag, NP, NP, 0, ME_DEC,
*/
/*
"barflag",			&barflag,NP,NP,0,ME_DEC,
*/
"reward_time",			&rwdtime,   NP, rwdtime_vaf, ME_AFT, ME_DEC,
"oreward_time",			&orwdtime,   NP, rwdtime_vaf, ME_AFT, ME_DEC,
"timeout_time",			&timeouttime,   NP, timeouttime_vaf, ME_AFT, ME_DEC,
/*"cuebarrwd_percent",		&cuebarrwd,   NP, rwdtime_vaf, ME_AFT, ME_DEC,*/
"dimon_time",			&dimtime,   NP, dimtime_vaf, ME_AFT, ME_DEC,
/*"grassFreebieFlag",		&grassFreebieFlag,NP,NP,0,ME_DEC,*/
/*"printArrayFlag",		&printArrayFlag, NP, NP,0, ME_DEC,
"printSacFlag",			&printSacFlag, NP, NP,0, ME_DEC,*/
"sequenceflag",			&sequenceflag, NP, NP,0, ME_DEC,
"errorCorrectFlag",		&errorCorrectFlag, NP, NP,0, ME_DEC,
"BarcodeDrop",                  &barcodedrop,NP,NP,0,ME_DEC,
/*"RightHand_Off",                &righthand_off,NP,NP,0,ME_DEC,*/
/*"jmp1RandomFlag",		&jRandFlag,NP,NP,0,ME_DEC,
"Number of Random Jmp1s",	&NumJmp1s,NP,NP,0,ME_DEC,
"Mag of random jmp1s",		&MaxJmp1Size,NP,NP,0,ME_DEC, */ /* above 3 have been
     	       						     	moved to the
								    jmp1 menu*/

"photocellFlag" ,		&photocellFlag,NP,NP,0,ME_DEC,
"photoWarn",                  &photowarn,NP,NP,0,ME_DEC,
"New_RF_flag",                  &newrfflag,NP,NP,0,ME_DEC,
"Nobarcheck",                  &nobarcheck,NP,NP,0,ME_DEC,
"NoEyecheck",                  &noeyecheck,NP,NP,0,ME_DEC,
"InfoWarn",                  &infowarn,NP,NP,0,ME_DEC,
/*"RFRAND",			&rfrandflag,NP,NP,0,ME_DEC,*/
/*"isrf3",                  &isrf3,NP,NP,0,ME_DEC,
"rf3object",                  &rf3object,NP,NP,0,ME_DEC,*/
/*"etrandflag",                  &etrandflag,NP,NP,0,ME_DEC,     
"etvalper",                  &etvalper,NP,NP,0,ME_DEC,
"et_autoshuf",		      &et_autoshuf,NP,NP,0,ME_DEC,*/
/*"bigrewardprob",		      &bigrewardprob,NP,NP,0,ME_DEC,
"bigrewardquad",		      &bigrewardquad,NP,NP,0,ME_DEC,
"bigrewardval",		      &bigrewardval,NP,NP,0,ME_DEC,
"smallrewardval",		      &smallrewardval,NP,NP,0,ME_DEC,*/
NS,
};

VLIST assorted_vl[]={
"latcorrect",                  &latcorrect,NP,NP,0,ME_DEC,     
"testDeviceFlag",			&testFlag,NP,NP,0,ME_DEC,   
"Display_%Corr",		&percorFlag,NP,NP,0,ME_DEC,
"Reset_%Corr",			&resetit,NP,NP,0,ME_DEC,
"Display_Thresholds",		&disp_threshFlag,NP,NP,0,ME_DEC,   
"Human_Button_Box",             &humbutflag, NP, NP, 0, ME_DEC,
"minnoflash",			&minnoflash,NP,NP,0,ME_DEC,
"repeatFlagOn",			&repeatFlagOn, NP, NP, 0, ME_DEC,
"flashFlag",			&flashFlag,NP,NP,0,ME_DEC,
"barflashFlag",			&barflashFlag,NP,NP,0,ME_DEC,
"ChonkinFlash",                  &chonkinflash,NP,NP,0,ME_DEC,
"FlashOnTime",                  &chonkinflashontime,NP,NP,0,ME_DEC,
"FlashOffTime",                  &chonkinflashofftime,NP,NP,0,ME_DEC,
"BeepOnTime",                  &beepontime,NP,NP,0,ME_DEC,     
"beepFlag",			&beepFlag,NP,NP,0,ME_DEC,
NS,
};


VLIST MMN_vl[] = {
"MmnMenuOn",			&mmnmenuon,NP,NP,0,ME_DEC,
"MmnPassiveOn",			&mmnpassiveflag,NP,NP,0,ME_DEC,
"MmnActiveOn",			&mmnactiveflag,NP,NP,0,ME_DEC,
"BasePattern",			&basepattern,NP,NP,0,ME_DEC,
"BaseCheck",			&basecheck,NP,NP,0,ME_DEC,
"BaseRed",			&basered,NP,NP,0,ME_DEC,
"BaseGreen",			&basegreen,NP,NP,0,ME_DEC,
"BaseBlue",			&baseblue,NP,NP,0,ME_DEC,
"DevPattern",			&devpattern,NP,NP,0,ME_DEC,
"DevCheck",			&devcheck,NP,NP,0,ME_DEC,
"DevRed",			&devred,NP,NP,0,ME_DEC,
"DevGreen",			&devgreen,NP,NP,0,ME_DEC,
"DevBlue",			&devblue,NP,NP,0,ME_DEC,     
"DevProb",			&devprob,NP,NP,0,ME_DEC,     
"SkipPattern",		&skippattern,NP,NP,0,ME_DEC,
"SkipThisNum",		&skipthisnum,NP,NP,0,ME_DEC,
"SkipThisNumFlag",		&skipthisnumflag,NP,NP,0,ME_DEC,     
"NumRFObjects",		&numrfobjects,NP,NP,0,ME_DEC,
"SkipProp",		&skipprop,NP,NP,0,ME_DEC,
"SkipObj",		&skipobj,NP,NP,0,ME_DEC,
"OtherSkipprop",	&otherskipprop,NP,NP,0,ME_DEC,
"OtherSkipObj",		&otherskipobj,NP,NP,0,ME_DEC,
"JitterProb",	&jitterprob,NP,NP,0,ME_DEC,
"JitterTim",	&jittertim,NP,NP,0,ME_DEC,
NS,
};

VLIST twospot_vl[]={
"twospotMenu",  &twospotmenuflag,NP,NP,0,ME_DEC,   
"RF2x",     		&twospot_rf2x,NP,NP,0,ME_DEC,   
"RF2x",     		&twospot_rf2y,NP,NP,0,ME_DEC,   
"RF2on",         		&twospot_rf2on,NP,NP,0,ME_DEC,   
"RF2lat",     		&twospot_rf2lat,NP,NP,0,ME_DEC,
"RF2inc",     		&twospot_rf2inc,NP,NP,0,ME_DEC,   
"RF2num",     		&twospot_rf2num,NP,NP,0,ME_DEC,   
"RF2pat",               &twospot_rf2pat,NP,NP,0,ME_DEC,                
"RF2check",             &twospot_rf2check,NP,NP,0,ME_DEC,                
"RF2fgr",               &twospot_rf2fgr,NP,NP,0,ME_DEC,                
"RF2fgg",               &twospot_rf2fgg,NP,NP,0,ME_DEC,                
"RF2fgb",               &twospot_rf2fgb,NP,NP,0,ME_DEC,                     
"RFblankprob",               &twospot_rfblankprob,NP,NP,0,ME_DEC,
   NS,
};

VLIST mgs_vl[]={
"MGSParadigm?",  &mgsmenuflag,NP,NP,0,ME_DEC,   
"MGSpercentage", &mgspercentage,NP,NP,0,ME_DEC,     
"SaccGoalX",     		&mgsrfx,NP,NP,0,ME_DEC,
"SaccGoalY",               &mgsrfy,NP,NP,0,ME_DEC,
"isRandom?",     		&mgsrand,NP,NP,0,ME_DEC,
"StartingAngle",		&mgstart,NP,NP,0,ME_DEC,
"AngleIncrement",		&mgsinc,NP,NP,0,ME_DEC,     
"NumberOfAngles",     		&mgsnum,NP,NP,0,ME_DEC,     
"StartingEcc",		&mgsecc,NP,NP,0,ME_DEC,
"EccIncrement",		&mgseccinc,NP,NP,0,ME_DEC,
"NumberOfEccs",		&mgseccnum,NP,NP,0,ME_DEC,
"DelayPeriodDuration",		&mgsj1delay,NP,NP,0,ME_DEC,
"TimeAtSaccGoal",		&mgsj1time,NP,NP,0,ME_DEC,
"FlashDelay",		&mgsrfdelay,NP,NP,0,ME_DEC,
"FlashDuration",		&mgsrftime,NP,NP,0,ME_DEC,
"FlashDurationInc",		&mgsrftimeinc,NP,NP,0,ME_DEC,
"FlashDurationNum",		&mgsrftimenum,NP,NP,0,ME_DEC,     
"FixationX",     		&mgsfpx,NP,NP,0,ME_DEC,
"FixXIncrement",     		&mgsfpxinc,NP,NP,0,ME_DEC,
"NumberOfFixX",     		&mgsfpxnum,NP,NP,0,ME_DEC,
"FixY",     		&mgsfpy,NP,NP,0,ME_DEC,
"FixYIncrement",     		&mgsfpyinc,NP,NP,0,ME_DEC,
"NumberOfFixY",     		&mgsfpynum,NP,NP,0,ME_DEC,     
"FPrelativeRF",     		&fprelflag,NP,NP,0,ME_DEC,
"EndOnAcquire",          	&endonacquire,NP,NP,0,ME_DEC,
NS,
};

VLIST ep_vl[]={
"epMenuOn", &epmenuflag,NP,NP,0,ME_DEC,      
"J1Num",  &j1num,NP,NP,0,ME_DEC,      
"JX1",  &j1xarr[0],NP,NP,0,ME_DEC,      
"JY1",  &j1yarr[0],NP,NP,0,ME_DEC,         
"JX2",  &j1xarr[1],NP,NP,0,ME_DEC,      
"JY2",  &j1yarr[1],NP,NP,0,ME_DEC,         
"JX3",  &j1xarr[2],NP,NP,0,ME_DEC,      
"JY3",  &j1yarr[2],NP,NP,0,ME_DEC,              
"JX4",  &j1xarr[3],NP,NP,0,ME_DEC,      
"JY4",  &j1yarr[3],NP,NP,0,ME_DEC,              
"JX5",  &j1xarr[4],NP,NP,0,ME_DEC,      
"JY5",  &j1yarr[4],NP,NP,0,ME_DEC,                   
"JX6",  &j1xarr[5],NP,NP,0,ME_DEC,      
"JY6",  &j1yarr[5],NP,NP,0,ME_DEC,              
"J1Rand", &ep_j1rand,NP,NP,0,ME_DEC,
"EPJNUM", &ep_j1num,NP,NP,0,ME_DEC,     
"UseStatic", &ep_usestatic,NP,NP,0,ME_DEC,     
"J1XStart",  &ep_j1xbegin,NP,NP,0,ME_DEC,                   
"J1XInc",  &ep_j1xinc,NP,NP,0,ME_DEC,                   
"J1XNum",  &ep_j1xnum,NP,NP,0,ME_DEC,                        
"J1YStart",  &ep_j1ybegin,NP,NP,0,ME_DEC,                   
"J1YInc",  &ep_j1yinc,NP,NP,0,ME_DEC,                   
"J1YNum",  &ep_j1ynum,NP,NP,0,ME_DEC,     
"FPRand", &ep_fprand,NP,NP,0,ME_DEC,     
"FPXStart",  &ep_fpxbegin,NP,NP,0,ME_DEC,                   
"FPXInc",  &ep_fpxinc,NP,NP,0,ME_DEC,                   
"FPXNum",  &ep_fpxnum,NP,NP,0,ME_DEC,                        
"FPYStart",  &ep_fpybegin,NP,NP,0,ME_DEC,                   
"FPYInc",  &ep_fpyinc,NP,NP,0,ME_DEC,                   
"FPYNum",  &ep_fpynum,NP,NP,0,ME_DEC,
"TargDel",  &ep_rf2del,NP,NP,0,ME_DEC,     
"TargDur",  &ep_jtargdur,NP,NP,0,ME_DEC,     
"FixDur",  &ep_fixdur,NP,NP,0,ME_DEC,          
     NS,
};

VLIST linemotion_vl[]={
"linemotionMenuOn", &linemotionMenu,NP,NP,0,ME_DEC,      
"RFdelay", &linemotionRFdelay,NP,NP,0,ME_DEC,      
"RFOn", &linemotionRFon,NP,NP,0,ME_DEC,      
"RFOnInc", &linemotionRFoninc,NP,NP,0,ME_DEC,      
"RFOnNum", &linemotionRFonnum,NP,NP,0,ME_DEC,           
"ReceptiveX", &linemotionRFx,NP,NP,0,ME_DEC,      
"ReceptiveY", &linemotionRFy,NP,NP,0,ME_DEC,           
"RFCenterX", &linemotionRFmidx,NP,NP,0,ME_DEC,           
"RFCenterY", &linemotionRFmidy,NP,NP,0,ME_DEC,           
"RFang", &linemotionRFang,NP,NP,0,ME_DEC,           
"ORFang", &linemotionRFoang,NP,NP,0,ME_DEC,           
"ORFangProb", &linemotionRFoangprob,NP,NP,0,ME_DEC,           
"RFlen", &linemotionRFlen,NP,NP,0,ME_DEC,           
"RFwidth", &linemotionRFwidth,NP,NP,0,ME_DEC,           
"RF2lat", &linemotionRF2lat,NP,NP,0,ME_DEC,      
"RF2latinc", &linemotionRF2latinc,NP,NP,0,ME_DEC,      
"RF2latnum", &linemotionRF2latnum,NP,NP,0,ME_DEC,           
"RF2On", &linemotionRF2on,NP,NP,0,ME_DEC,                
"RF2OnInc", &linemotionRF2oninc,NP,NP,0,ME_DEC,      
"RF2OnNum", &linemotionRF2onnum,NP,NP,0,ME_DEC,           
"Displace",&linemotionDisplace,NP,NP,0,ME_DEC,                
"DisplaceDegs",&linemotionDisplaceDegs,NP,NP,0,ME_DEC,                
"DegsInc",&linemotionDisplaceDegsInc,NP,NP,0,ME_DEC,                
"DegsNum",&linemotionDisplaceDegsNum,NP,NP,0,ME_DEC,                     
"RFLenInc",&linemotionRFleninc,NP,NP,0,ME_DEC,                          
"RFLenNum",&linemotionRFlennum,NP,NP,0,ME_DEC,                     
"RF2x",&linemotionRF2x,NP,NP,0,ME_DEC,                     
"RF2xinc",&linemotionRF2xinc,NP,NP,0,ME_DEC,                     
"RF2xnum",&linemotionRF2xnum,NP,NP,0,ME_DEC,                          
"RF2y",&linemotionRF2y,NP,NP,0,ME_DEC,                          
"RF2yinc",&linemotionRF2yinc,NP,NP,0,ME_DEC,                               
"RF2ynum",&linemotionRF2ynum,NP,NP,0,ME_DEC,                               
"RF1blankprob",&linemotionRF1prob,NP,NP,0,ME_DEC,                
"RF2prob",&linemotionRF2prob,NP,NP,0,ME_DEC,                
"SymmRF2prob",&linemotionDinprob,NP,NP,0,ME_DEC,                     
"RF2pat",&linemotionRF2pat,NP,NP,0,ME_DEC,                
"RF2check",&linemotionRF2check,NP,NP,0,ME_DEC,                
"RF2fgr",&linemotionRF2fgr,NP,NP,0,ME_DEC,                
"RF2fgg",&linemotionRF2fgg,NP,NP,0,ME_DEC,                
"RF2fgb",&linemotionRF2fgb,NP,NP,0,ME_DEC,                     
   NS,
};
VLIST tdistractor_vl[]={
"tdistractorMenuOn", &tdistractorMenu,NP,NP,0,ME_DEC,      
"FixRF2time_wrt_RF",&fixrf2_wrt_rf,NP,NP,0,ME_DEC,      
 "RFlat",&tdistractorRFdelay,NP,NP,0,ME_DEC,      
"RFlatinc",&tdistractorRFlatinc,NP,NP,0,ME_DEC,  
"RFlatnum",&tdistractorRFlatnum,NP,NP,0,ME_DEC,      
"RF2lat", &tdistractorRF2lat,NP,NP,0,ME_DEC,      
"RF2latinc", &tdistractorRF2latinc,NP,NP,0,ME_DEC,      
"RF2latnum", &tdistractorRF2latnum,NP,NP,0,ME_DEC,           
"RF2On", &tdistractorRF2on,NP,NP,0,ME_DEC,                
"RF2OnInc", &tdistractorRF2oninc,NP,NP,0,ME_DEC,      
"RF2OnNum", &tdistractorRF2onnum,NP,NP,0,ME_DEC,                          
"RF2x",&tdistractorx,NP,NP,0,ME_DEC,                         
"RF2y",&tdistractory,NP,NP,0,ME_DEC,                          
"RF2posnum",&tdistractorRF2num,NP,NP,0,ME_DEC,               
 "RF2posprob",&tdistractorRF2posprob,NP,NP,0,ME_DEC,             
"RF2prob",&tdistractorRF2prob,NP,NP,0,ME_DEC,                
"RF2predict",&tdistractorpredict,NP,NP,0,ME_DEC,            
"RF2pat",&tdistractorRF2pat,NP,NP,0,ME_DEC,                
"RF2check",&tdistractorRF2check,NP,NP,0,ME_DEC,                
"RF2fgr",&tdistractorRF2fgr,NP,NP,0,ME_DEC,                
"RF2fgg",&tdistractorRF2fgg,NP,NP,0,ME_DEC,                
"RF2fgb",&tdistractorRF2fgb,NP,NP,0,ME_DEC,                     
"LinkFPOn_to_RFDelay",&tdist_dimlink,NP,NP,0,ME_DEC,                          
   NS,
};
VLIST randpos_vl[]={
"FPx",                     &remap_fpx,NP,NP,0,ME_DEC,
"FPxInc",                     &remap_fpxinc,NP,NP,0,ME_DEC,
"FPxNum",                     &remap_fpxnum,NP,NP,0,ME_DEC,     
"FPy",                     &remap_fpy,NP,NP,0,ME_DEC,     
"FPyInc",                     &remap_fpyinc,NP,NP,0,ME_DEC,
"FPyNum",                     &remap_fpynum,NP,NP,0,ME_DEC,     
"Jmpx",                     &remap_jumpx,NP,NP,0,ME_DEC,
"JmpxInc",                     &remap_jumpxinc,NP,NP,0,ME_DEC,
"JmpxNum",                     &remap_jumpxnum,NP,NP,0,ME_DEC,     
"Jmpy",                     &remap_jumpy,NP,NP,0,ME_DEC, 
"JmpyInc",                     &remap_jumpyinc,NP,NP,0,ME_DEC,
"JmpyNum",                     &remap_jumpynum,NP,NP,0,ME_DEC,     
"OJmpx",                     &remap_ojumpx,NP,NP,0,ME_DEC,
"OJmpxInc",                     &remap_ojumpxinc,NP,NP,0,ME_DEC,
"OJmpxNum",                     &remap_ojumpxnum,NP,NP,0,ME_DEC,     
"OJmpy",                     &remap_ojumpy,NP,NP,0,ME_DEC, 
"OJmpyInc",                     &remap_ojumpyinc,NP,NP,0,ME_DEC,
"OJmpyNum",                     &remap_ojumpynum,NP,NP,0,ME_DEC,               
"RFxInit",                     &remap_rfx,NP,NP,0,ME_DEC,
"RFxInc",                     &remap_rfxinc,NP,NP,0,ME_DEC,
"RFxNum",                     &remap_rfxnum,NP,NP,0,ME_DEC,
"RFyInit",                     &remap_rfy,NP,NP,0,ME_DEC,      
"RFyInc",                     &remap_rfyinc,NP,NP,0,ME_DEC,
"RFyNum",                     &remap_rfynum,NP,NP,0,ME_DEC,
NS,
};

VLIST remapping_vl[]={
"RemapMenu",                     &remap_menuon,NP,NP,0,ME_DEC,   
"OJmpProb",                     &remap_ojumprob,NP,NP,0,ME_DEC,      
"BlankProb",                     &remap_blankprob,NP,NP,0,ME_DEC,
"JmpDelay",                     &remap_jumpdelay,NP,NP,0,ME_DEC,               
"JmpDelayInc",                 &remap_jumpdelay_inc,NP,NP,0,ME_DEC,               
"JmpDelayNum",                 &remap_jumpdelay_num,NP,NP,0,ME_DEC,               
"JmpTime",                 &remap_jumptime,NP,NP,0,ME_DEC,               
"WindowDelay",             &remap_windowdelay,NP,NP,0,ME_DEC,               
"TrialTime",                     &remap_trialtime,NP,NP,0,ME_DEC,               
"RF2Duration",                  &remap_rf2duration,NP,NP,0,ME_DEC,     
"RF2DurInc",                  &remap_rf2durinc,NP,NP,0,ME_DEC,
"RF2DurNum",                  &remap_rf2durnum,NP,NP,0,ME_DEC,     
"RFtimeinit",		       &rftimeinit,NP,NP,0,ME_DEC,
"RFtimeInc",                  &rftimeinc,NP,NP,0,ME_DEC,
"RFtimeNum",                  &rftimenum,NP,NP,0,ME_DEC,
"RFDuration",                  &rfduration,NP,NP,0,ME_DEC,     
"OneFrameMode",                  &remap_ofmode,NP,NP,0,ME_DEC,
"vexclean",                  &remap_vexclean,NP,NP,0,ME_DEC,
"reflx_sipercent",                  &reflexive_sipercentage,NP,NP,0,ME_DEC,
     NS,
};

VLIST Showbutt_vl[]={
"ShowbuttOn",                     &showbuttOn,NP,NP,0,ME_DEC,
"ButtObject",                     &ButtObject,NP,NP,0,ME_DEC,
"ButtImageStart",                     &Buttimagestart,NP,NP,0,ME_DEC,   
"ButtImageInc",                     &Buttimageinc,NP,NP,0,ME_DEC,   
"ButtImageNum",                     &Buttimagenum,NP,NP,0,ME_DEC,        
"ButtImageDuration",                     &Buttimagedur,NP,NP,0,ME_DEC,        
     NS,
};

VLIST TTask_vl[]={
"TTaskMenu",                     &ttask_menuon,NP,NP,0,ME_DEC,
"Tx",                          &ttask_x,NP,NP,0,ME_DEC,
"Ty",                          &ttask_y,NP,NP,0,ME_DEC,     
"T2x",                          &ttask_T2x,NP,NP,0,ME_DEC,
"T2y",                          &ttask_T2y,NP,NP,0,ME_DEC,          
"TProb",                         &ttask_prob,NP,NP,0,ME_DEC,     
"UpTProb",                       &ttask_tprob,NP,NP,0,ME_DEC,     
"CatchProb",                       &ttask_catchprob,NP,NP,0,ME_DEC,          
"DimTime",                       &ttask_dimtime,NP,NP,0,ME_DEC,          
"CatchDimTime",                       &ttask_catchdimtime,NP,NP,0,ME_DEC,          
"TDur",                          &ttask_tdur,NP,NP,0,ME_DEC,     
"TDurInc",                          &ttask_tdurinc,NP,NP,0,ME_DEC,
"TDurNum",                          &ttask_tdurnum,NP,NP,0,ME_DEC,     
"TDurCatchProb",                          &ttask_tcatchprob,NP,NP,0,ME_DEC,
"TCatchDur",                          &ttask_tcatchdur,NP,NP,0,ME_DEC,          
"OneFrameMode",                  &ttask_ofmode,NP,NP,0,ME_DEC,
"vexclean",                  &ttask_vexclean,NP,NP,0,ME_DEC,
"OneTprob",                      &ttask_onetprob,NP,NP,0,ME_DEC,
"Tpattern",                          &ttask_tpat,NP,NP,0,ME_DEC,
"Tred",                          &ttask_tred,NP,NP,0,ME_DEC,
"Tgreen",                          &ttask_tgreen,NP,NP,0,ME_DEC,
"Tblue",                          &ttask_tblue,NP,NP,0,ME_DEC,     
"InvTPat",                    &ttask_itpat,NP,NP,0,ME_DEC,          
"InvTred",                          &ttask_itred,NP,NP,0,ME_DEC,
"InvTgreen",                          &ttask_itgreen,NP,NP,0,ME_DEC,
"InvTblue",                          &ttask_itblue,NP,NP,0,ME_DEC,     
"DistPat",                    &ttask_dpat,NP,NP,0,ME_DEC,               
"StimNum",                &ttask_stimnum,NP,NP,0,ME_DEC,               
"TargLocStart",              &ttask_targlocstart,NP,NP,0,ME_DEC,
"TargLocInc",                &ttask_targlocinc,NP,NP,0,ME_DEC,
"TargLocNum",                &ttask_targlocnum,NP,NP,0,ME_DEC,
"OtherBarIgnore",         &otherbarignore,NP,NP,0,ME_DEC,
"LinkRFtoFP",         &linkrftofp,NP,NP,0,ME_DEC,     
"FPOnTime",         &ttask_fpon,NP,NP,0,ME_DEC,     
"FPOnInc",         &ttask_fpinc,NP,NP,0,ME_DEC,     
"FPOnNum",         &ttask_fpnum,NP,NP,0,ME_DEC,          
NS,
};

VLIST VSrch_vl[]={
"TargPop",                &ttask_targpop,NP,NP,0,ME_DEC,                  
"PopoutRed",              &ttask_pred,NP,NP,0,ME_DEC,               
"PopoutGreen",            &ttask_pgreen,NP,NP,0,ME_DEC,               
"PopoutBlue",             &ttask_pblue,NP,NP,0,ME_DEC,                  
"PopLocStart",               &ttask_poplocstart,NP,NP,0,ME_DEC,
"PopLocInc",                 &ttask_poplocinc,NP,NP,0,ME_DEC,
"PopLocNum",                 &ttask_poplocnum,NP,NP,0,ME_DEC,        
"ShowAllPops",                 &ttask_showallpops,NP,NP,0,ME_DEC,             
"ODisProb",                   &odist_prob,NP,NP,0,ME_DEC,          
"MinDisRange",                &ttask_mindpat,NP,NP,0,ME_DEC,               
"MaxDisRange",                &ttask_maxdpat,NP,NP,0,ME_DEC,               
"ODistart",                   &ttask_odistart,NP,NP,0,ME_DEC,          
"ODistinc",                   &ttask_odistinc,NP,NP,0,ME_DEC,          
"ODistnum",                   &ttask_odistnum,NP,NP,0,ME_DEC,          
   NS,
};



  /* rf initial location; then fill; 
    * then targpat1, targpat2, targcheck, targfgr, fgg, fgb, size
    * then distpat1, distpat2, distpat3, distpat4, distfgr, fgg, fgb, size
    * maybe experiment with stringparse for these things ?
*/

VLIST rfFill_vl[]={
"RFfill",		&rffillFlag,NP,NP,0,ME_DEC,
"CheckSize",		&rfchksize,NP,NP,0,ME_DEC,
"CheckSizeInc",		&rfchksizeinc,NP,NP,0,ME_DEC,
"CheckSizeNum",		&rfchksizenum,NP,NP,0,ME_DEC,
"FGRed",		&rffgr,NP,NP,0,ME_DEC,
"FGGreen",		&rffgg,NP,NP,0,ME_DEC,
"FGBlue",		&rffgb,NP,NP,0,ME_DEC,
"Lumnum",		&rflumnum,NP,NP,0,ME_DEC,     
"RLuminc",		&rrfluminc,NP,NP,0,ME_DEC,
"GLuminc",		&grfluminc,NP,NP,0,ME_DEC,
"BLuminc",		&brfluminc,NP,NP,0,ME_DEC,
"Pattern",		&frfpattern,NP,NP,0,ME_DEC,
"OPattern",		&frfopattern1,NP,NP,0,ME_DEC,
"OPattern2",		&frfopattern2,NP,NP,0,ME_DEC,
"OPatternProb",		&frfopatternprob,NP,NP,0,ME_DEC,
"RFNumber",		&rfnums,NP,NP,0,ME_DEC,
"Length",		&rflength,NP,NP,0,ME_DEC,
"LengthInc",		&rflengthinc,NP,NP,0,ME_DEC,
"LengthNum",		&rflengthnum,NP,NP,0,ME_DEC,     
"Width",	        &rfwidth,NP,NP,0,ME_DEC,
"WidthInc",	        &rfwidthinc,NP,NP,0,ME_DEC,
"WidthNum",	        &rfwidthnum,NP,NP,0,ME_DEC,     
"Orientation",		&rfori,NP,NP,0,ME_DEC,
"OrientationInc",	&rforinc,NP,NP,0,ME_DEC,
"OrientationNum",	&rforinum,NP,NP,0,ME_DEC,
"StartPattern",     	&rfstartpattern,NP,NP,0,ME_DEC,
"EndPattern",     	&rfendpattern,NP,NP,0,ME_DEC,
   NS,
};

VLIST rfmap_vl[] = {
"ManyRfFlag",                   &manyrfFlag, NP, NP, 0, ME_DEC,
"OneFrameMode",                  &oneframemode,NP,NP,0,ME_DEC,
"vexclean",                  &vexclean,NP,NP,0,ME_DEC,
"stopOnJump",                  &StopMapOnJump,NP,NP,0,ME_DEC,
"RFNextVal",	&rfnextval,NP,NP,0,ME_DEC,
"RFdelay",      &rfmap_rfdelay,NP,NP,0,ME_DEC,
"RFTime",      &rfmap_rftime,NP,NP,0,ME_DEC,     
"TrialTime",      &rfmap_trialtime,NP,NP,0,ME_DEC,     
"NumFlashes",      &rfmap_numflashes,NP,NP,0,ME_DEC,     
"rf1x",			&rfxarr[0],NP,NP,0,ME_DEC,
"rf1y",			&rfyarr[0],NP,NP,0,ME_DEC,
"rf2x",			&rfxarr[1],NP,NP,0,ME_DEC,
"rf2y",			&rfyarr[1],NP,NP,0,ME_DEC,
"rf3x",			&rfxarr[2],NP,NP,0,ME_DEC,
"rf3y",			&rfyarr[2],NP,NP,0,ME_DEC,
"rf4x",			&rfxarr[3],NP,NP,0,ME_DEC,
"rf4y",			&rfyarr[3],NP,NP,0,ME_DEC,
"rf5x",			&rfxarr[4],NP,NP,0,ME_DEC,
"rf5y",			&rfyarr[4],NP,NP,0,ME_DEC,     
"rf6x",			&rfxarr[5],NP,NP,0,ME_DEC,     
"rf6y",			&rfyarr[5],NP,NP,0,ME_DEC,     
"rf7x",			&rfxarr[6],NP,NP,0,ME_DEC,     
"rf7y",			&rfyarr[6],NP,NP,0,ME_DEC,     
"rf8x",			&rfxarr[7],NP,NP,0,ME_DEC,     
"rf8y",			&rfyarr[7],NP,NP,0,ME_DEC,     
"randmap",		&rfrandmap,NP,NP,0,ME_DEC,
"rfxmin",		&rfxmin,NP,NP,0,ME_DEC,
"rfxmax",		&rfxmax,NP,NP,0,ME_DEC,
"rfxinc",		&rfxinc,NP,NP,0,ME_DEC,
"rfymin",		&rfymin,NP,NP,0,ME_DEC,
"rfymax",		&rfymax,NP,NP,0,ME_DEC,
"rfyinc",		&rfyinc,NP,NP,0,ME_DEC,
"ShuffleNow",			&shufflenowflag,NP,NP,0,ME_DEC,
NS,
};

char hm_cflags[] =  "\n\
Control flags:\n\
0  No mirror 0 \n\
1,2  Mir1,2 from array\n\
3,6  Joy moves Mir1,2\n\
4,5  Mir1,2 from array\n\
7,8  Mir1,2 array + joy\n\
9  Stimulate (rf. only)\n\
10,11 Mir1,2 ramp\n\
12 Vex from Array\n\
13 Vex from Joy \n\
14 Joy moves Vex \n\
15 Vex from Background\n\
17 Vex from CUE\n\
18 VEX from CUE2\n\
19 RF flips BG\n\
20 Threshold\n\
21 MCS Threshold\n\
";

char hm_rmodes[] =  "\n\
This is Object Info\n\
for rf.object[]\n\
object modes:\n\
0  VEX PATTERN \n\
1  TIFF \n\
2  BAR\n\
3  ANNULUS\n\
";

char hm_vex_vars[] =  "\n\
Menus rv1, rv2 and rv3\n\
are VEX Variable Menus \n\
\n\
mode 0: VEX PATTERN\n\
     rv1: N/A\n\
     rv2: N/A\n\
     rv3: N/A\n\
mode 1: TIFF\n\
     rv1: N/A\n\
     rv2: N/A\n\
     rv3: N/A\n\
mode 2: BAR\n\
     rv1: Angle\n\
     rv2: Width\n\
     rv3: Length\n\
mode 3: ANNULUS\n\
     rv1: Outer rad\n\
     rv2: Inner rad\n\
     rv3: N/A\n\
";

char hm_modes[] =  "\n\
object modes:\n\
0  VEX PATTERN \n\
1  TIFF \n\
2  BAR\n\
3  ANNULUS\n\
";

char hm_rmphlp[] = "\n\
Ramp Type (ORable):\n\
01  No 25ms accel dist\n\
02  (x,y) is ramp center\n\
04  (x,y) is ramp beginning\n\
010 (x,y) is ramp end\n\
\n\
Length = HALF length of ramp\n"
;

char hm_flags[] =  "\n\
Backon flags:\n\
0 No backon  \n\
1 backon for desired saccade \n\
2 backon for window \n\
4 backon for any saccade\n\
10 for double saccade\n\
Bar Flag Codes\n\
0 No Bar\n\
1 Right Bar\n\
2 Left Bar\n\
3 Both Bars\n\
Flags can be or'd\n\
Cue Bar Flag\n\
0 No cuebarflag
1 cuebarflag - trial continues\n\
2 cuebarflag - trial finishes\n"
;

char hm_ttask_vl[]="\n\

		    \n"
;


char hm_sv_vl[] =  "\n\
Backon control flags:\n\
0 No backon\n\
1 Desired saccade\n\
2 Window\n\
3 Window or desired saccade\n\
4 Any saccade\n\
\n\
Sequence control flags\n\
0 No change \n\
1 Sequential rotation\n\
2 Shuffled rotation\n\
\n\
Jmp1RandomFlag\n\
0 No Random \n\
1 Fixed no. jmps\n\
2 Random no. jmps; max set by user\n"
;

USER_FUNC ufuncs[]= {
	{"array",	&n_array}, /*MONK*/
	{"object",       &n_object}, /*VEX*/
	{"poslist",      &poslistproc},
	{"",	0},
};


#pragma off (unreferenced)
int
nbit_rgf(int call_cnt, MENU *mp, char *astr)
{
#pragma on (unreferenced)
	return(0);
}


/*
 * Menus.
 */
/*MENU declarations*/
MENU bgrs = {		
"x",				&bgr_vl, NP,NP, 0, NP, NS,};

MENU bggs = {		
"x",				&bgg_vl, NP,NP, 0, NP, NS,};

MENU bgbs = {		
"x",				&bgb_vl, NP,NP, 0, NP, NS,};

MENU rcs = {		
"x",				&cr_vl, NP,NP, 0, NP, NS,};

MENU gcs = {		
"x",				&cg_vl, NP,NP, 0, NP, NS,};

MENU fgrs = {		
"x",				&fgr_vl, NP,NP, 0, NP, NS,};

MENU fggs = {		
"x",				&fgg_vl, NP,NP, 0, NP, NS,};

MENU rmode = {		
"x",				&rmode_vl, NP,NP, 0, NP, NS,};

MENU rv1 = {		
"x",				&rv1_vl, NP,NP, 0, NP, NS,};

MENU rv2 = {		
"x",				&rv2_vl, NP,NP, 0, NP, NS,};

MENU rv3 = {		
"x",				&rv3_vl, NP,NP, 0, NP, NS,};

MENU tlink = {		
"x",				&tlink_vl, NP,NP, 0, NP, NS,};

MENU rxpatterns = {		
"x",				&rpatterns_vl, NP,NP, 0, NP, NS,};

MENU cpatterns = {		
"x",				&cpatterns_vl, NP,NP, 0, NP, NS,};

MENU rxchecksizes = {		
"x",				&rchecksizes_vl, NP,NP, 0, NP, NS,};

MENU cxchecksizes = {		
"x",				&cchecksizes_vl, NP,NP, 0, NP, NS,};

MENU bcs = {		
"x",				&cb_vl, NP,NP, 0, NP, NS,};

MENU fgbs = {		
"x",				&fgb_vl, NP,NP, 0, NP, NS,};

MENU yrfobjects = {		
"y",				&yrfobjects_vl, NP,NP, 0, NP, NS,};

MENU ycueobjects = {		
"y",				&ycueobjects_vl, NP,NP, 0, NP, NS,};

MENU xrfobjects = {		
"x",				&xrfobjects_vl, NP,NP, 0, NP, NS,};

MENU tv1 = {		
"x",				&tv1_vl, NP,NP, 0, NP, NS,};

MENU tv2 = {		
"x",				&tv2_vl, NP,NP, 0, NP, NS,};

MENU tp1 = {		
"x",				&tp1_vl, NP,NP, 0, NP, NS,};

MENU tp2 = {		
"x",				&tp2_vl, NP,NP, 0, NP, NS,};

MENU xcueobjects = {		
"x",				&xcueobjects_vl, NP,NP, 0, NP, NS,};

MENU rxfobjects = {		
"rxfobjects",	&rfobjects_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS, };

MENU robjects = {		
"robjects",	&robjects_vl,  NP, omaf,    ME_BEF, klugeobjectArray_rgf, NS, };

MENU cobjects = {		
"cobjects",	&cobjects_vl,  NP, cmaf,    ME_BEF, klugeobjectArray_rgf, NS, };

MENU cxueobjects = {		
"x",				&cueobjects_vl, NP,NP, 0, NP, NS,};

MENU rxf2objects = {		
"x",				&rf2objects_vl, NP,NP, 0, NP, NS,};

MENU cxue2objects = {		
"x",				&cue2objects_vl, NP,NP, 0, NP, NS,};

MENU jxmp1objects = {		
"x",				&jmp1objects_vl, NP,NP, 0, NP, NS,};

MENU jxmp2objects = {		
"x",				&jmp2objects_vl, NP,NP, 0, NP, NS,};


MENU object0 = {		
"x",				&object0_vl, NP,object0_maf, ME_BEF, NP, NS,};

MENU object1 = {		
"x",				&object1_vl, NP,object1_maf, ME_BEF, NP, NS,};

MENU performance = {		
"x",				&perf_vl, NP,NP, 0, NP, NS,};


MENU umenus[]= {
/*"performance",	&perf_vl,	NP, NP,		0,	NP,	NS,*/
"state",	&state_vl,      NP, state_maf, ME_BEF,   NP,  NS,
"flags",	&flags_vl,      NP, flags_maf,  ME_BEF, array_rgf, NS,
"backgrounds",	&backgrounds_vl,NP, backgrounds_maf,	ME_BEF, backgrounds_rgf, NS,
"objects",	&objects_vl, 	NP, objects_maf,ME_BEF, objects_rgf, NS,
"rfFill",	&rfFill_vl,      NP, rfFill_maf, ME_BEF,   NP,  NS,
"separator", 	NP,		NP, NP,		0,	NP,	NS,
"rfmap",	&rfmap_vl,      NP, rfmap_maf, ME_BEF,   NP,  NS,
"mgs",    &mgs_vl,      NP, mgs_maf, ME_BEF,   NP,  NS,
"remapping",    &remapping_vl,      NP, remapping_maf, ME_BEF,   NP,  NS,
"randpos",    &randpos_vl,      NP, randpos_maf, ME_BEF,   NP,  NS,
"MMN",   	&MMN_vl,        NP, MMN_maf, ME_BEF,   NP,  NS,
"TTask",   	&TTask_vl,        NP, TTask_maf, ME_BEF,   NP,  NS,
"VSrch",   	&VSrch_vl,        NP, VSrch_maf, ME_BEF,   NP,  NS,     
"ep",    &ep_vl,      NP, ep_maf, ME_BEF,   NP,  NS,
"LMotion",    &linemotion_vl,      NP, ep_maf, ME_BEF,   NP,  NS,     
"TDist",    &tdistractor_vl,      NP, ep_maf, ME_BEF,   NP,  NS,     
"TwoSpot",         &twospot_vl,      NP, twospot_maf, ME_BEF,   NP,  NS,     
/*"PosLists",	&listest_vl,      NP, listest_maf, ME_BEF,   NP,  NS,*/
"ShowButt",         &Showbutt_vl,      NP, Showbutt_maf, ME_BEF,   NP,  NS,          
"separator", 	NP,		NP, NP,		0,	NP,	NS,
"fp",		&fp_vl,         NP, maf,       	ME_BEF, array_rgf, NS,
"rf",		&rf_vl,         NP, maf,       	ME_BEF, array_rgf, NS,
"rf2",		&rf2_vl,        NP, maf,       	ME_BEF, array_rgf, NS,
"cue",		&cue_vl,        NP, maf,        ME_BEF, array_rgf, NS,
"cue2",		&cue2_vl,       NP, maf,        ME_BEF, array_rgf, NS,
"j1",		&jmp1_vl,       NP, maf,       	ME_BEF, array_rgf, NS,
"j2",		&jmp2_vl,       NP, maf,       	ME_BEF, array_rgf, NS,
"gap",		&gap_vl,       NP, maf,        	ME_BEF, array_rgf, NS,
"separator", 	NP,		NP, NP,		0,	NP,	NS,
"robjects",	&robjects_vl, 	NP, omaf,ME_BEF, klugeobjectArray_rgf,NS,
"rxfobjects",	&rfobjects_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"xrfobjects",	&xrfobjects_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"yrfobjects",	&yrfobjects_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rxpatterns",	&rpatterns_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rxchecksizes",	&rchecksizes_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"fgrs",		&fgr_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"fggs",		&fgg_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"fgbs",		&fgb_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"bgrs",		&bgr_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"bggs",		&bgg_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"bgbs",		&bgb_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rmode",	&rmode_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rv1",		&rv1_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rv2",		&rv2_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rv3",		&rv3_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rxf2objects",	&rf2objects_vl, NP, maf,    ME_BEF, objectArray_rgf, NS,
"separator", 	NP,		NP, NP,		0,	NP,	NS,
"jxmp1objects",	&jmp1objects_vl, NP, maf,   ME_BEF, objectArray_rgf, NS,
"jxmp2objects",	&jmp2objects_vl, NP, maf,   ME_BEF, objectArray_rgf, NS,
"separator", 	NP,		NP, NP,		0,	NP,	NS,
"cobjects",	&cobjects_vl, 	NP, cmaf,ME_BEF, klugeobjectArray_rgf, NS,
"cxueobjects",	&cueobjects_vl,  NP, maf,   ME_BEF, objectArray_rgf, NS,
"xcueobjects",	&xcueobjects_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"ycueobjects",	&ycueobjects_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"cpatterns",	&cpatterns_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"cxchecksizes",	&cchecksizes_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"rcs",		&cr_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"gcs",		&cg_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"bcs",		&cb_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"tp1",		&tp1_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"tp2",		&tp2_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"tv1",		&tv1_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"tv2",		&tv2_vl,  NP, maf,    ME_BEF, objectArray_rgf, NS,
"tlink",	&tlink_vl,	NP, maf,	ME_BEF, objectArray_rgf, NS,
"cxue2objects",	&cue2objects_vl, NP, maf,   ME_BEF, objectArray_rgf, NS,
"separator", 	NP,		NP, NP,		0,	NP,	NS,
"devices",	&devices_vl, 	NP, NP,	 	0, 	NP, 	NS,
"saccades",	&saccades_vl, 	NP, NP, 	0, 	NP, 	NS,
"descriptor",	&descriptor_vl, NP, descriptor_maf, 	ME_BEF, array_rgf, NS,
"times",	&times_vl,      NP, maf,      	ME_BEF, array_rgf, NS,
"limit",	&limit_vl,      NP, maf,      	ME_BEF, array_rgf, NS,
"array",	&array_vl,      NP, maf, 	ME_BEF, array_rgf, NS,
"cflags",	&cflags_vl,     NP, flags_maf,  ME_BEF, array_rgf, NS,
"interface",	&interface_vl,  NP, maf,  	ME_BEF, array_rgf, NS,
"rp",		&ramp_vl,       NP, maf,       	ME_BEF, array_rgf, NS,
"assorted",   	&assorted_vl,        NP, assorted_maf, ME_BEF,   NP,  NS,
NS,
};

/*
 *functions called by several states
 */

int eyewinCheck(int winx, int winy, int centerx,int centery) {
	int x,y;
	int leftwinx, rightwinx,leftwiny, rightwiny;

	x = eyeh/4;
	y = eyev/4;
	leftwinx = centerx-winx;
	rightwinx = centerx+winx;
	leftwiny = centery-winy;
	rightwiny = centery+winy;
	
	if ((leftwinx < x) && (x < rightwinx) 
	   && (leftwiny < y) && (y < rightwiny))
		return(YES);
	else return(NO); 
}


/* functions for bar and window checking*/
int start_check() {

	int x,y, centerx, centery;
	int test;
/*
	static int localtest = 99;

if (test != localtest) {
dprintf("startcheck:old test %o drinput %o test %o RIGHTBAR %o LEFTBAR %o\n", 
	localtest,drinput, test, RIGHTBAR, LEFTBAR);
localtest = test;
}
*/
	test = drinput & BOTHBARS;

/*
	if (continueflag) 
		return(YES); *continue flag has continuous trials*
*/
/*if no bar, then eye in window starrts trial*/ 
/*else trial starts if bar is pressed*/
	switch (barflag) {
	case NO:
		y = fp->windowy;
		centery	= fp->y;
		x = fp->windowx;
		centerx	= fp->x;
		if (eyewinCheck(x,y,centerx,centery) == YES)
			return(YES);
		else return(NO);
		break;
	
	case LEFT:
		if (test  == LEFTBAR) 
		return(YES);
		break;
	case RIGHT:
		if (test ==  RIGHTBAR) 
		return(YES);
		break;
	case BOTH:
		if (test ==  BOTHBARS) 
		return(YES);
		break;
	} /*switch*/;
	return(NO); /*NO if bar not pressed*/
}

/*the following checks to see if bar is in play*/
int fork_check() {

	if ((cuebarflag)&&(cueOnFlag)) return(NO); /* Bar has already been released */ 
	if (barflag == NO)
		return(NO);
	else
		return(YES);
}

/* The following check to see if trial should go to dimon */
int fork_check2() {

	if (cuebarflag) return(NO); /* either bar has been released or catch trial */ 
	if (barflag == NO)
		return(NO);
	else
		return(YES);
}

int hasheacquired(){
   
      if(endonacquire==YES && monkeyhasacquired==YES) return(YES);
else return(NO);

}

int fixcuetime()
{
    if ((fixjmpcueflag)&&(gap1nowFlag)) return (YES);
               /* if fixjmpcueflag and the fix point has gone out then there is a set time
		  that the monkey must maintain fixation of the target location for */
    return(NO);
}

int hum_resp_check ()
{
    if  (((humbutflag)&&(jmp1NowFlag))&&(baroffflag != NO)) return (YES);
               /* If we are using a human button box AND the jump has been made AND
		  there is a possible bar answer then check for the response */

    return (NO);
}

int check_answer()
{
   	int test;
	static int left = OFFTIME; /*offtime is usually 50 ms*/
	static int right = OFFTIME;

/*here follows flaky bar kluge - bar must be released for
 * 100 ms to be really off
 */

	test = drinput & BOTHBARS;
	if ((test & LEFTBAR) == 0)	
		left -= 1;
	else left = OFFTIME;
	if ((test & RIGHTBAR) == 0)	
		right -= 1;
	else right = OFFTIME;
	switch (baroffflag) {
	case NO:
		left = right = OFFTIME;
		return(YES);
		break;
	case LEFT:
		if (right <= 0) {
			left = right = OFFTIME;
			abortFlag = YES;
			return(NO);
		}
		if (left <= 0)  {
			left = right = OFFTIME;
			return(YES);
		}
			 
/* Human has pushed left button*/
		
		break;
	case RIGHT:
		if (left <= 0) {
			abortFlag = YES;
			left = right = OFFTIME;
			return(NO);
		}
		if (right <= 0)  {
			left = right = OFFTIME;
			return(YES);
		}
/* Human has pushed right button*/
		break;
	case BOTH:
		if ((right <= 0) && (left <= 0)) {
			left = right = OFFTIME;
			return(YES);
		}
		break;
	} /*switch*/;
	
	return(NO);
	
}

int humrightstuff()
{
    hyes = YES;
    return(0);
}

int bar_check() 
/*if barflag is set returns YES if bar is pressed or NO if bar released
 *if barflag is not set returns YES in all cases
 */
{
	/* We have made consecutiveBad 50ms, because it is giving us a
	**	problem at 100ms (monk is losing with 5-10 ms left
	*/ 

	long codeTime; /* These 3 variables are for CueBar being released */
	int j;
	long code = BAROFFCD;

	static int consecutiveBad = 50;
	int test;

			if(nobarcheck==1&&rfwason==1) return(YES);

	/* If monk has already released bar in a cuebarflag trial then
		don't do bar_check  */

	if (((cuebarflag)&&(cueOnFlag))&&(cueBarRelease)) {
                consecutiveBad=50;	   						   
		return(YES);
		} /* end if */
	
	test = drinput & BOTHBARS;
/*
dprintf(" consecutiveBad %d barchecktop: drinput %o, test %o RIGHTBAR %o LEFTBAR %o\n", 
	consecutiveBad,drinput, test, RIGHTBAR, LEFTBAR);
*/
	switch (barflag) {
	case NO:
		consecutiveBad = 50;
		return(YES);
		break;
	case LEFT:
		if (test  == LEFTBAR) {
		consecutiveBad = 50;
		return(YES);
		}
		break;
	case RIGHT:
		if (test ==  RIGHTBAR) {
		consecutiveBad = 50;
		return(YES);
		}
		break;
	case BOTH:
		if (test ==  BOTHBARS) {
		consecutiveBad = 50;
		return(YES);
		}
		break;
	} /*switch*/;
/*here follows flaky bar kluge - bar must be released for
 * 50 ms to be really off
 */
	if (--consecutiveBad <= 0) {
/*
dprintf("barcheck:drinput %o test %o RIGHTBAR %o LEFTBAR %o\n", drinput, test, RIGHTBAR, LEFTBAR);
*/
		if ((cuebarflag)&&(cueOnFlag)) {
			cueBarRelease = YES;
			j = code; /* DROP BAROFFCD */
			codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
			vexEvent[0].e_code = code; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
			if (cuebarrwd > 0) cuebarrwd_flag = YES;

			if (cuebarflag == 2) givejmp2Rwd = YES; /* Short cut out of FPON */
			return(YES);
		}

		consecutiveBad = 50; 
		return(NO); 
	}
		else return(YES);
		
 
}

int dimbar_check() /*This function has been refactored fully - 01/10/05*/
/*looks at baroffflag - if baroffflag is LEFT, returns YES if left bar released
 *if baroffflag is RIGHT, returns YES if right bar released
 *consectuvieBad kluge is built in, to ignore bar fluctuations
 */

{
	int test;

/*	static int left = OFFTIME;
	static int right = OFFTIME;*/
        static int left = OFFTIME;
        static int right = 10;
	if(nobarcheck==1&&rfwason==1) return(YES);
		
   /* this outputs two numbers for how long the bars have been off */
   
	test = drinput & BOTHBARS;
	if ((test & LEFTBAR) == 0)	
		left -= 1;
	else left = OFFTIME; /*this line means that if reheld: then reset to 50*/
	if ((test & RIGHTBAR) == 0)	
		right -= 1;
	else right = OFFTIME; 

   /* now decide based on baroff flag */
   
	switch (baroffflag) {
	case NO:             /* DONT CHECK BARS, JUST RETURN YES AT OUTSET */
		left = right = OFFTIME;
		return(YES);
		break;
	case LEFT:          /*LEFT BAR RELEASE*/
	
	     	if(otherbarignore==1){ /*SIMPLY WAIT FOR LEFT BAR RELEASE*/
		
		   if(left<=0) return(YES); else return(NO);
		
		} else {  /*GIVE ERROR IF RIGHT BAR RELEASE*/
		
		   if (right <= 0) {
			left = right = OFFTIME;
			abortFlag = YES;
			return(NO);
		   }

		if ((left <= 0) && (right==OFFTIME))  {
			left = right = OFFTIME;
			return(YES);
		} /*This setup has side-effect of preventing right release within 50 ms of left*/

		}
	   
/* monkey has released left bar */
		
		break;

	 case RIGHT:
	
	if(otherbarignore==1){

	   if(right<=0) return(YES); else return(NO);

	} else{
		if (left <= 0) {
			abortFlag = YES;
			left = right = OFFTIME;
			return(NO);
		}
	   
		if ((right <= 0)&&(left==OFFTIME))  {
			left = right = OFFTIME;
			return(YES);
		}
	}
	   
/* monkey has released right bar*/
		break;

	 case BOTH:
	   
	   if(otherbarignore==1) dprintf("%s\n","***Otherbarignore + Both bar weirdness !!!!");

	   if ((right <= 0) && (left <= 0)) {
			left = right = OFFTIME;
			return(YES);
		}

	   break;
	   
	 case NEITHER:
	 
	      	   if(otherbarignore==1) dprintf("%s\n","***Otherbarignore + Both bar weirdness !!!!");
		 
		 if ((left <= 0)||(right<=0)) {
			abortFlag = YES;
			left = right = OFFTIME;
			return(NO);
		}  
		break;

	} /*switch*/;
	
	return(NO);
 
}

int dimonStuff() {
		int j; 
		long code =  DIMCD;
		
/*assumes that the current FUNCTION is the current FP*/
		j = code;
   if(noeyecheck==1) nowincheckflag=YES;

if(vexclean==0){		vexOffFlag |= VEXCURRENT; 
		vexOnFlag |= VEXCURRENTDIM;
		vexCode[vexCodeCount++]=j;
		j = 0;}

		return(j);
}


int dimerrorcheckfn(){

if(baroffflag==4) return(YES); else return(NO);

}

int window_check() {

	int x,y;
	int leftwinx,rightwinx,leftwiny,rightwiny;
	int ismonkin = NO;
	static int local_jmp2RwdDelay = 0;
	long codeTime;

   if(nowincheckflag==YES) {return(YES); /*to stop recording eye position after achieving j1*/
/*   dprintf("%d\n",nowincheckflag);*/}
   
	/* start by checking if eye is in window */
	x = eyeh/4;
	y = eyev/4;
	leftwiny = current->y - current->windowy;
	rightwiny = current->y + current->windowy;
	leftwinx = current->x - current->windowx;
	rightwinx = current->x + current->windowx;
	if ((leftwinx < x) && (x < rightwinx) 
	   && (leftwiny < y) && (y < rightwiny))
		ismonkin = YES;
	else ismonkin = NO;
   
   if(ismonkin==YES&& startacquire==YES) monkeyhasacquired=YES; else monkeyhasacquired=NO;

	/* If the jmp2RwdFlag is on, the jmp2 window is on, and the monkey is in 
	 * the window, a counter counts down.  Once it reaches zero, a flag is set
	 * so that the trial ends and the monkey receives his reward. */

	if (local_jmp2RwdFlag) {
		if (jmp2WinNowFlag && ismonkin) {
			if (--local_jmp2RwdDelay <=0) givejmp2Rwd = YES;
		}
		else local_jmp2RwdDelay = jmp2RwdDelay;
	}


	/* If jmp1Win has started AND jmp2Sacflag is set AND monk is in window
		then switch on sacCheckFlag and return YES */

	if ((jmp1WinNowFlag)&&(local_jmp2Sacflag)&&(ismonkin)) {
        /* adding a 50 ms timer; hope it is sufficient*/
	if(--jmp1timer<=0){
/*		sacCheckFlag = YES;*/
	   nowincheckflag=YES;
	   		codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
			if(fin_time==0) {fin_time=codeTime; /*dprintf("fin_time %ld\n",jmp1timer);*/
		return(YES);}
	}
/*	dprintf("%d\n",jmp1timer);*/
	}

	/* If not a nogo trial, check if the allowable reaction time is over*/

	if (nogoflag == NO) {
		if (--local_window_delay > 0)  {
			return(YES);
		} /* window delay */
	} /* nogoflag */

	/* After window delay, just return ismonkin */
/*	if(ismonkin==NO) dprintf("%s\n","windowerror");*/
	return(ismonkin);	

/*
	localeyeflag = eyeflag & 3;
	if(localeyeflag & WD0_XY){
		 return(NO);
	}
		return (YES);
*/
}

int abortCheck() {
	if (abortFlag == YES) return (NO);
	else return (YES);
}
/*JG*/


int vexbackoff() {
             if ((cue->control) == VEXBACKOFF)
                 vexOffFlag |= VEXBGD;
                 return(0);
            } 
int backoffcheck() {
		if ((cue->control) == VEXBACKOFF) return(YES);
		else return(NO);
              }



void shuffle() 
{
	int i,j;
	int used[MAXDIFFTASKS];
	int shuff_array_tbl[MAXDIFFTASKS];
	
	shufflecount=0;
	shuff_array_max = 0;
	if (array.array_max > ARRAYSIZE) array.array_max = ARRAYSIZE;
	if (array.array_max < 0) array.array_max = 0;

	for (i=0;i<(array.array_max);++i) {
		if ((array.tbl[i].fp.background)<1) array.tbl[i].fp.background = 1;
		for (j=0;j<(array.tbl[i].fp.background);++j) {
			shuff_array_tbl[shuff_array_max] = array.tbl[i].index;
			shuff_array_max++;
		}
	}
	
	/* for debugging **********  
	for (i=0;i<shuff_array_max;++i) dprintf ("shuff_array_tbl[%d] = %d\n",i,shuff_array_tbl[i]);
	*************************/

	for (i=0;i<(shuff_array_max);++i) used[i]=0;
    	j=(int)((double)shuff_array_max*rand()/(RAND_MAX+1.0));
    	for(i=0;i<(shuff_array_max);++i){
		while (used[j]==1)
		{
		j=(int)((double)shuff_array_max*rand()/(RAND_MAX+1.0));
	    	}
		tablepointer[i]=shuff_array_tbl[j];	
		used[j]=1;
	 	}
}

void readshuffle()
{
	int temp_shuff_count = 0;
	int i,j;
/*
 *assigns elements of table  to global variables using the shuffled
 *pointer table tablepointer[]
 *if shufflecount has not reached the array size
 *else it reshuffles
 */
	if (++shufflecount >= shuff_array_max)  shuffle();
		 /*shuffle at the top*/
	/*redo shuffle if array_max has been made smaller*/

	for (i=0;i<(array.array_max);++i) {
		if ((array.tbl[i].fp.background)<1) array.tbl[i].fp.background = 1;
		for (j=0;j<(array.tbl[i].fp.background);++j) temp_shuff_count++; 
	}

	if ((temp_shuff_count) != (shuff_array_max)) shuffle();
	array.array_index = tablepointer[shufflecount];
		
}
/*state specific actions.
 *convention is state name and Stuff
 *must return 0 or code
 */

/* int klugepointer; -- now defined up above */
int kluge_array_max;
int kluge_array_index;
int kluge_array_number;
int kluge_grassflag;
int kluge_rf_flag;
int kluge_rf2_flag;
int kluge_cueflag;
int kluge_cue2flag;
int kluge_jmp1cueflag;
int kluge_jmp2cueflag;
int kluge_jmp1cue2flag;
int kluge_jmp2cue2flag;
int kluge_jmp2sacflag;
int kluge_jmp1Flag;
/*int kluge_jRandFlag;*/
int kluge_jmp2Flag;
int kluge_backon1flag;
int kluge_backon2flag;
int kluge_descriptor[DESCRIPTORSIZE];

void
sendVex(int vex_number)
{
	if (vex_number > VEXMAX) 
		rxerr("vexbuffer too large\n");
	else
	   	to_vex((unsigned short) vex_number);
	return;
}	

int
allOffStuff() 
/*this is actually the initializer as well as turning everything off*/
{

	int i;
        short int distance = 750;
	short int width = 755;

	vexObjectFlag = 0;
	vexIndex = 0;
	vexbuf[vexIndex++] = SET_REX_SCALE;
	vexbuf[vexIndex++] = hibyte(distance);
	vexbuf[vexIndex++] = lobyte(distance);
	vexbuf[vexIndex++] = hibyte(width);
	vexbuf[vexIndex++] = lobyte(width);
	
/* reset object stack for makeObjects*/
	for (i = 0; i < OBJECTNUMBER; i++) {
		vexObjectFlag += 1;
		objectStack[i] = vexObjectFlag;
	}
	vexbuf[vexIndex++] = ALL_OFF;
	sendVex(vexIndex);
	
}

int
clearScreen()
{
	vexbuf[vexIndex++] = ALL_OFF;
	sendVex(vexIndex);
	vexOffFlag &= (NOVEXOLDBG);
}
void
makeVexObject(int objectNumber) 
{
	unsigned char * count;
	switch (object[objectNumber].mode) {
/* set the pattern file*/	
	case PATTERN:
	   vexbuf[vexIndex++] = DRAW_USER_PATTERN;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	
	   vexbuf[vexIndex++] = hibyte((short)object[objectNumber].pattern);
	   vexbuf[vexIndex++] = lobyte((short)object[objectNumber].pattern);
	/*set the pattern check size*/
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].checksize;
	   vexbuf[vexIndex++] = 1; /*force sign to 1*/
/*
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].sign;
*/
	   vexbuf[vexIndex++] = SET_STIM_COLORS;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgr;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgg;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgb;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgr;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgg;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgb;
	   break;	
	case TIFF:
	   vexbuf[vexIndex++] = DRAW_TIFF_IMAGE;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	   vexbuf[vexIndex++] = hibyte(object[objectNumber].pattern);
	   vexbuf[vexIndex++] = lobyte(object[objectNumber].pattern);
	   break;
	case ANNULUS:
	   vexbuf[vexIndex++] = DRAW_ANNULUS;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	   vexbuf[vexIndex++] = (char)object[objectNumber].var1;
	   vexbuf[vexIndex++] = (char)object[objectNumber].var2;
	   vexbuf[vexIndex++] = 1; /*annulus has positive contrast*/
	   vexbuf[vexIndex++] = SET_STIM_COLORS;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgr;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgg;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgb;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgr;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgg;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgb;
	   break;
	case VEX_BAR:
	   vexbuf[vexIndex++] = DRAW_BAR;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	   vexbuf[vexIndex++] = (char)object[objectNumber].var1;
	   vexbuf[vexIndex++] = (char)object[objectNumber].var2;
	   vexbuf[vexIndex++] = (char)object[objectNumber].var3;
	   vexbuf[vexIndex++] = 1; /*bar has positive contrast*/
	   vexbuf[vexIndex++] = SET_STIM_COLORS;
	   vexbuf[vexIndex++] = 1;
	   vexbuf[vexIndex++] = (unsigned char)objectNumber;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgr;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgg;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].fgb;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgr;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgg;
	   vexbuf[vexIndex++] = (unsigned char)object[objectNumber].bgb;
	   break;
	} /*switch mode*/   
	vexbuf[vexIndex++] = STIM_LOCATION;
	count = &vexbuf[vexIndex++];
	*count = 0;
	locateObject(count, objectNumber, object[objectNumber].x, object[objectNumber].y);
}

/*here follow various vex functions and actions*/
int vexClearStuff() {
   if(wait_for_rfoff!=YES || oneframemode==0) vexIndex = 0;
/*   else dprintf("%d\n",sureshrfoff);*/
	return(0);
}

int vexLocateStuff()
/*this is necessary because it takes time to locate objects*/
/*and it should be done before turning them on*/
/*think of it like moving a mirror*/
{
	int objectNumber;
	unsigned char * count;

	vexbuf[vexIndex++] = STIM_LOCATION;
	count = &vexbuf[vexIndex++];
	*count = 0;
	while (vexLocateFlag >= 1 ) {
		objectNumber = locateStack[--vexLocateFlag];
		locateObject(count, objectNumber, object[objectNumber].x, object[objectNumber].y);
	}
	sendVex(vexIndex); /*now tell vex about it*/
	return(0);
}

int objDoneStuff()
{
	vexOnFlag |= VEXBGD; /*now that objects are made, turn on bg*/
	return(0);
}

int makeObjStuff()
{
	int objectNumber;
/*the object stack array contains the indices of the objects 
 *that have to be made.
 */
	while (vexObjectFlag > 0) {
		objectNumber = objectStack[--vexObjectFlag];
		makeVexObject(objectNumber);
	}
	sendVex(vexIndex); /*for the objects*/
	return (0);
}

void
switchObject(unsigned char *count, int objectNumber, unsigned char onOrOff)
{
	*count += 1;
	vexbuf[vexIndex++] = (unsigned char)objectNumber;
	vexbuf[vexIndex++] = onOrOff;
}

void 
floatload(int value) {
/*puts int value into vexbuf as four bytes of float*/
	int i;
	char foo[4];
	char *flbuf = &foo[0];
	float foofloat;
	foofloat = (float)value;
	flbuf = float2byte(foofloat);
	for (i = 0; i < 4; i++)
		vexbuf[vexIndex++] = flbuf[i];
}

int 
locateObject(unsigned char *count, int objectNumber, int objectx, int objecty)
{
/*assumes STIM_LOCATION has been sent to vexbuf, and count points to
 *the number of objects in the locate command (the location after 
 *STIM_LOCATE
 */
	*count += 1; /*bump count of objects to be switched*/
	vexbuf[vexIndex++] = (unsigned char)objectNumber; /*object number*/
	floatload(objectx);  /*object x and y*/
	floatload(objecty);
}

int 
vexLocateCheck()
{
	if (vexLocateFlag > 0) return(YES);
	else return(NO);
}

int 
vexObjCheck()
{
	if (vexObjectFlag > 0) return (YES);
	else return(NO);
}	
int vexAllOffCheck()
{
	if (vexAllOffFlag == YES) {
		vexAllOffFlag = 0;
		return(YES);
	}
	else return (NO);
}
	
	int bugprint(){
	dprintf("%s\n","rf waiting");
	return(0);
	}

/*
int debugprintB(){
   
     dprintf("%s\n","Entered vexfork");
   dprintf("photocancelflag = %d\n",photoCancelFlag);
   return(0);
}

int debugprintC(){
   
     dprintf("%s\n","Entered vexstart");
   return(0);
}

int debugprint(){
 
   dprintf("%s\n","Entered vexwait");
   return(0);
   
}*/
   
int 
minvexFlagCheck() 
{
   int j,i;
   unsigned char *count;
   short joyx, joyy;
   unsigned char joyobject[JOYNUMBER];
   int joynumber = 0;
   int tempcomp;

/*just a safety check to ensure entering rffotcheck*/
   
  if ( !(vexOffFlag & VEXFP) && wait_for_rfoff==YES && oneframemode==1) return(NO);

/*Making Sure that if switchonflag or switchoffflag are on, then we enter main loop*/

   if ((switchOnFlag > 0) && (vexOnFlag == 0)) 
	vexOnFlag = 1;
   if ((switchOffFlag > 0) && (vexOffFlag == 0))
	vexOffFlag = 1;

   /************MAIN LOOP BEGINS HERE ****************/
   
   if(myVexFlag==1 && buttOffFlag==0 && buttOnFlag==0) dprintf("%s\n","Yikies");
   
   if ((vexOnFlag != 0) || (vexOffFlag != 0) || myVexFlag==1  ) {  /*on or off have
						  *precendent over joy
						  */
	vexIndex = 0;   /*initializing vexindex*/

/*Special RF JOYSTICK Case: have to update RF location*/
      
	if ((vexOnFlag & VEXRF) && (rf->control == VEXJOY)) {
		object[rf->object[0]].x = joyh >> 2;	
		object[rf->object[0]].y = joyv >> 2;	
		vexbuf[vexIndex++] = STIM_LOCATION;
		vexbuf[vexIndex++] = 1;
		vexbuf[vexIndex++] = rf->object[0];
		floatload(joyh >> 2);
		floatload(joyy >> 2);
	}

     /*first locate background stimuli that will be turned on*/	

      if (vexOnFlag != 0) {
	    
	    if ((vexOnFlag & VEXBGD) != 0) { /*locate background*/
	        vexbuf[vexIndex++] = STIM_LOCATION;
	        count = &vexbuf[vexIndex++];
	        *count = 0; /*this will be the number of things to locate */
		for (j = 0; j < backgroundNumber; j++) {
			locateObject(count, background[j].object[0],
			background[j].bgobj[0].x, background[j].bgobj[0].y);
	       }
	    }
	} /*if vexOnFlag != 0*/

      /*Now get ready to turn stimuli on or off*/

        vexbuf[vexIndex++] = SWITCH_STIM;
	count = &vexbuf[vexIndex++];
        *count = 0;

      /*my own vexflag codebit*/

      if(myVexFlag==1)
     {   
	
   	   if (buttOffFlag==1) 
	     {
		switchObject(count,ButtObject,OBJ_OFF);
		buttCancelFlag=0;
		buttOffFlag=0;
		buttOnFlag=0; /*for safety*/
		wasButtOff=1;

		
	     }
     }
      

/*Turn off first, then on, so proper stimuli will stay on*/

	if (vexOffFlag != 0) {
	   
	   /*backgrounds*/

	   if (vexOffFlag & VEXBGD){ 
		vexOffFlag &= (NOVEXBGD);
		for (j = 0; j < backgroundNumber; j++) 
			switchObject(count,background[j].object[0], OBJ_OFF);
	   }

	   if (vexOffFlag & VEXOLDBG){ 
		vexOffFlag &= (NOVEXOLDBG);
		for (j = 0; j < backgroundNumber; j++) {
			switchObject(count,background[j].object[0], OBJ_OFF);
			switchObject(count,background[j].object[0]+1, OBJ_OFF);
		}
	   }

	   /*FP*/

	   if (vexOffFlag & VEXFP) {

	       askfpoff=0;
		vexOffFlag &= (NOVEXFP);
		vexCancelFlag &= (NOVEXFP); /*so last things doesn't
					    *try to turn it off
					    */
		switchObject(count,fp->object[0],OBJ_OFF);
	   }
	   
	   /*cue*/
	   
	   if(vexclean==0){
	   
	   if (vexOffFlag & VEXCUBE) /*ditto cue*/{
		vexOffFlag &= (NOVEXCUBE);
		vexCancelFlag &= (NOVEXCUBE); /*so last things doesn't
					    *try to turn it off
					    */
		switch (cue->control) {
		case VEXBACKGROUND:
		case VEXBACKOFF:
			cue->object[0] = background[cue->background].object[0]+1;
			break;
		case THRESHOLD:
		case MCSTHRESH:
		default:
	  	    for (i = 0; i < cue->objectNumber; i++)
			switchObject(count,cue->object[i],OBJ_OFF);
 	   	} /*switch cue->control*/
	  }/* if vexOfffFlag & VEXCUBE*/
	   if (vexOffFlag & VEXCUBE2) /*ditto cue*/{
		vexOffFlag &= (NOVEXCUBE2);
		vexCancelFlag &= (NOVEXCUBE2); /*so last things doesn't
					    *try to turn it off
					    */
		if((cue2->control == VEXBACKGROUND) || (cue2->control == VEXBACKOFF))
			cue2->object[0] = background[cue2->background].object[0]+1;
		else for (i = 0; i < cue2->objectNumber; i++)
			switchObject(count,cue2->object[i],OBJ_OFF);

	   }
	   }
	      
	      
	   if (vexOffFlag & VEXCURRENT) /*ditto fp*/{
		vexOffFlag &= (NOVEXCURRENT);
		if (current->control == VEXJOY) 
			vexJoyFlag &= NOVEXCURRENT;
		vexCancelFlag &= (NOVEXCURRENT);
		switchObject(count,current->object[0],OBJ_OFF);
	   }
	   if (vexOffFlag & VEXCURRENTDIM) /*ditto fp*/{
		vexOffFlag &= (NOVEXCURRENTDIM);
		if (current->control == VEXJOY) 
			vexJoyFlag &= NOVEXCURRENTDIM;
		vexCancelFlag &= (NOVEXCURRENTDIM);
		switchObject(count,current->object[1],OBJ_OFF);
	   }
	   if (vexOffFlag & VEXRF) /*ditto rf*/{
		vexOffFlag &= (NOVEXRF);
		vexCancelFlag &= (NOVEXRF);
		if((rf->control == VEXBACKGROUND) || (rf->control == VEXBACKOFF))
			rf->object[0] = background[rf->background].object[0]+1;
		else for(i = 0; i < rf->objectNumber; i++) {
			switchObject(count,rf->object[i],OBJ_OFF);
		/*	vexCode[vexCodeCount++] = PATOFFCD + rf->obj[i].pattern; --- not necessary */
		/*load objectoff code into code waiting buffer*/ 
		}
	   }
	    if (vexOffFlag & VEXRF2) /*ditto rf2*/{
	    	vexOffFlag &= (NOVEXRF2);
		vexCancelFlag &= (NOVEXRF2);
		for (i = 0; i < rf2->objectNumber; i++)
			switchObject(count,rf2->object[i],OBJ_OFF);
	    }

	   
	   if(vexclean==0||reflexive_sipercentage>0){
	    
	    if (vexOffFlag & VEXJMP1) /*ditto jmp1*/{

		vexOffFlag &= (NOVEXJMP1);
		vexCancelFlag &= (NOVEXJMP1);

		if (jRandFlag>0)
		  switchObject(count,jmp1->object[0],OBJ_OFF);
		  else
	
	for (i = 0; i < jmp1->objectNumber; i++) {
			switchObject(count,jmp1->object[i],OBJ_OFF);

		}
	   }
	   }
	   
	   if(vexclean==0){
	   

	   if (vexOffFlag & VEXJMP2) /*ditto jmp2*/{
		vexOffFlag &= (NOVEXJMP2);
		vexCancelFlag &= (NOVEXJMP2);
		for (i = 0; i < jmp2->objectNumber; i++)
			switchObject(count,jmp2->object[i],OBJ_OFF);
	   }
	   }
	   
	   while (switchOffFlag >0) {
		switchObject(count,switchOffStack[--switchOffFlag],OBJ_OFF);
	   }
	}/*if vexOfflag != 0 */

      /*Now Switch on the Guys that have to be Switched On*/
      /*Note we are putting new vex commands in vexbuf, and
       *changing the pointer to the object counter
       */

      /*MY OWN ON_CODEBIT*/
      
      if(myVexFlag==1)
	{

	   if (buttOnFlag==1)
	     {
		switchObject(count,ButtObject,OBJ_ON);
		buttCancelFlag=1;
		buttOnFlag=0;
		wasButtOn=1;


	     } else if(wasButtOff!=1) dprintf("%s\n","What is going on here ???");
	   
	} else if (turnonrequested==1) 
	
	     {
		dprintf("%s\n","Yikes, some turnonproblem");
		turnonrequested=0;
	     }
      

      /* BACK TO REGULAR VEXONFLAG */
      
	if (vexOnFlag != 0) {  /*main vexonflag loop begins here */
 
	   /*background stuff*/
	   
	   while (switchOnFlag >0) {
		switchObject(count,switchOnStack[--switchOnFlag],OBJ_ON);
	   }
	   
	   if (vexOnFlag & VEXBGD) /*turn on background*/{
		vexOnFlag &= (NOVEXBGD);
		   for (j = 0; j < backgroundNumber; j++) {
			switchObject(count,background[j].object[0], OBJ_ON);
		}
	   }
	   
	   /*fp*/

	   if (vexOnFlag & VEXFP)
	     {
		vexOnFlag &= (NOVEXFP); 
		vexCancelFlag |= (VEXFP);
					 
		if (fp->control == VEXJOY)
			vexJoyFlag |= VEXFP;
		switchObject(count,fp->object[0],OBJ_ON);
	     }
	   
	    /*current*/
	   
	   if (vexOnFlag & VEXCURRENT) /*ditto fp*/{
		if (current->control == VEXJOY)
			vexJoyFlag |= VEXCURRENT;
		vexOnFlag &= (NOVEXCURRENT); /*clear flag*/
		vexCancelFlag |= (VEXCURRENT); /*so last things can
					   *turn it off
					   */
		switchObject(count,current->object[0],OBJ_ON);
	   }
	   
	   /*currentdim*/

	   if (vexOnFlag & VEXCURRENTDIM) /*dim current fp*/{
		vexOnFlag &= (NOVEXCURRENTDIM); /*clear flag*/
		if (current->control == VEXJOY)
			vexJoyFlag |= VEXCURRENTDIM;
		switchObject(count,current->object[1],OBJ_ON);
		vexCancelFlag |= (VEXCURRENTDIM); /*so last things can
					   *turn it off
					   */
	   }
	   
	   /*cue*/
	   
	   if(vexclean==0){
	   if (vexOnFlag & VEXCUBE) /*ditto cue*/{
		vexOnFlag &= (NOVEXCUBE); /*clear flag*/
		vexCancelFlag |= (VEXCUBE); /*so last things can
					   *turn it off
					   */
		switch (cue->control) {
		case MCSTHRESH:
		case THRESHOLD:	
			if (disp_threshFlag !=0) {
			dprintf("\nIndex: %d\tT/hold level: %d\t\tVary1:  %s %d\n",
	array.array_index,cue->falsereward,vary1,cue->thresh[cue->falsereward].tv1);
			dprintf("\t\t\t\t\tVary2:  %s %d\n",
	vary2,cue->thresh[cue->falsereward].tv2);
			} /* show Threshold data on screen is disp_threshFlag is on */

			vexCode[vexCodeCount++] = PATNUMCD + cue->objectNumber;
			for (i = 0; i < cue->objectNumber; i++) {
				switchObject(count,cue->object[i],OBJ_ON);
				vexCode[vexCodeCount++] = THRESHOLDCD + cue->falsereward;
				vexCode[vexCodeCount++] = PATONCD + object[cue->object[i]].pattern;
				vexCode[vexCodeCount++] = PATXCD + object[cue->object[i]].x;
				vexCode[vexCodeCount++] = PATYCD + object[cue->object[i]].y;
		 		vexCode[vexCodeCount++] = PATRCD + object[cue->object[i]].fgr;
		 		vexCode[vexCodeCount++] = PATGCD + object[cue->object[i]].fgg;
		 		vexCode[vexCodeCount++] = PATBCD + object[cue->object[i]].fgb;
			};/* for i */
			break;
		case VEXBACKGROUND:
		case VEXBACKOFF:
			cue->object[0] = background[cue->background].object[0]+1;
			break;
		default: 
			vexCode[vexCodeCount++] = PATNUMCD + cue->objectNumber;
			for (i = 0; i < cue->objectNumber; i++) {
				switchObject(count,cue->object[i],OBJ_ON);
				vexCode[vexCodeCount++] = THRESHOLDCD + 0; /* No threshold */
				vexCode[vexCodeCount++] = PATONCD + object[cue->object[i]].pattern;
				vexCode[vexCodeCount++] = PATXCD + object[cue->object[i]].x;
				vexCode[vexCodeCount++] = PATYCD + object[cue->object[i]].y;
		 		vexCode[vexCodeCount++] = PATRCD + object[cue->object[i]].fgr;
		 		vexCode[vexCodeCount++] = PATGCD + object[cue->object[i]].fgg;
		 		vexCode[vexCodeCount++] = PATBCD + object[cue->object[i]].fgb;
			};/* for i */

				break;
	   	}/*swith cue->contorl*/
	}/*if flag & VEXCUBE */ 
	   if (vexOnFlag & VEXCUBE2) /*ditto cue*/{
		vexOnFlag &= (NOVEXCUBE2); /*clear flag*/
		vexCancelFlag |= (VEXCUBE2); /*so last things can
					   *turn it off
					   */
		if((cue2->control == VEXBACKGROUND) || (cue2->control == VEXBACKOFF))
			cue2->object[0] = background[cue2->background].object[0]+1;
		else for (i = 0; i < cue2->objectNumber; i++)
			switchObject(count,cue2->object[i],OBJ_ON);

	   }
	   }
	   if (vexOnFlag & VEXRF) /*ditto rf*/{
		vexOnFlag &= (NOVEXRF); /*clear flag*/
		vexCancelFlag |= (VEXRF); /*so last things can
					   *turn it off
					   */
		switch (rf->control) {
			case VEXBACKGROUND:
			case VEXBACKOFF:
				rf->object[0] = background[rf->background].object[0]+1;
				break;
			default:	
				vexCode[vexCodeCount++] = PATNUMCD + rf->objectNumber;
		 		for (i = 0; i < rf->objectNumber; i++) {
			   switchObject(count,rf->object[i],OBJ_ON);

				   vexCode[vexCodeCount++] = PATONCD + rf->obj[i].pattern; 
				   vexCode[vexCodeCount++] = PATXCD + rf->obj[i].x; 
				   vexCode[vexCodeCount++] = PATYCD + rf->obj[i].y; 
				   vexCode[vexCodeCount++] = PATRCD + rf->obj[i].fgr; 
				   vexCode[vexCodeCount++] = PATGCD + rf->obj[i].fgg; 
				   vexCode[vexCodeCount++] = PATBCD + rf->obj[i].fgb; 
				   vexCode[vexCodeCount++] = PATCHECKCD + rf->obj[i].checksize;
				vexCode[vexCodeCount++] = PATMODCD + object[(rf->object[i])].mode; 				
				vexCode[vexCodeCount++] = PATVAR1CD + object[(rf->object[i])].var1; 
				vexCode[vexCodeCount++] = PATVAR2CD + object[(rf->object[i])].var2; 
				vexCode[vexCodeCount++] = PATVAR3CD + object[(rf->object[i])].var3; 
			}/*else for i */

				   prfonflag=YES;
		}
	   }

	   if (vexOnFlag & VEXRF2) /*ditto rf2*/{
	   	vexOnFlag &= (NOVEXRF2); /*clear flag*/
		vexCancelFlag |= (VEXRF2); /*so last things can
		                          * turn it off*/
		if((rf2->control == VEXBACKGROUND) || (rf2->control == VEXBACKOFF))
			rf2->object[0] = background[rf2->background].object[0]+1;
		else {
			vexCode[vexCodeCount++] = PATNUMCD + rf2->objectNumber;
			for (i = 0; i < rf2->objectNumber; i++) {
				switchObject(count,rf2->object[i],OBJ_ON);
				vexCode[vexCodeCount++] = PATONCD + object[(rf2->object[i])].pattern; 
			   	vexCode[vexCodeCount++] = PATXCD + rf2->obj[i].x; 
				vexCode[vexCodeCount++] = PATYCD + rf2->obj[i].y; 
				vexCode[vexCodeCount++] = PATRCD + object[(rf2->object[i])].fgr; 
				vexCode[vexCodeCount++] = PATGCD + object[(rf2->object[i])].fgg; 
				vexCode[vexCodeCount++] = PATBCD + object[(rf2->object[i])].fgb; 
				vexCode[vexCodeCount++] = PATCHECKCD + object[(rf2->object[i])].checksize; 
				vexCode[vexCodeCount++] = PATMODCD + object[(rf2->object[i])].mode; 				
				vexCode[vexCodeCount++] = PATVAR1CD + object[(rf2->object[i])].var1; 
				vexCode[vexCodeCount++] = PATVAR2CD + object[(rf2->object[i])].var2; 
				vexCode[vexCodeCount++] = PATVAR3CD + object[(rf2->object[i])].var3; 

			}
		} /* end else */
	   } /* end if */

	   
	   if(vexclean==0||reflexive_sipercentage>0)
	     {
	   if (vexOnFlag & VEXJMP1) /*ditto jmp1*/{
		vexOnFlag &= (NOVEXJMP1); /*clear flag*/
		vexCancelFlag |= (VEXJMP1); /*so last things can
					   *turn it off
					   */
		vexCode[vexCodeCount++] = PATNUMCD + jmp1->objectNumber;
	
	
		if (jRandFlag>0)  /*Just object[0] to be switched on if rand*/
		   	tempcomp=1;
			else tempcomp=jmp1->objectNumber;
			
		for (i = 0; i < tempcomp; i++) {
			switchObject(count,jmp1->object[i],OBJ_ON);
		   	vexCode[vexCodeCount++] = PATONCD + jmp1->obj[i].pattern; 
		   	vexCode[vexCodeCount++] = PATXCD + jmp1->obj[i].x; 
			vexCode[vexCodeCount++] = PATYCD + jmp1->obj[i].y; 
			vexCode[vexCodeCount++] = PATRCD + jmp1->obj[i].fgr; 
			vexCode[vexCodeCount++] = PATGCD + jmp1->obj[i].fgg; 
			vexCode[vexCodeCount++] = PATBCD + jmp1->obj[i].fgb; 
			vexCode[vexCodeCount++] = PATCHECKCD + object[(jmp1->object[i])].checksize; 			
				vexCode[vexCodeCount++] = PATMODCD + object[(jmp1->object[i])].mode; 				
				vexCode[vexCodeCount++] = PATVAR1CD + object[(jmp1->object[i])].var1; 
				vexCode[vexCodeCount++] = PATVAR2CD + object[(jmp1->object[i])].var2; 
				vexCode[vexCodeCount++] = PATVAR3CD + object[(jmp1->object[i])].var3; 
		}

	  }}  /*end if*/

	   if(vexclean==0){ 
	   
	   if (vexOnFlag & VEXJMP2) /*ditto jmp2*/{
		vexOnFlag &= (NOVEXJMP2); /*clear flag*/
		vexCancelFlag |= (VEXJMP2); /*so last things can
					   *turn it off
					   */
		vexCode[vexCodeCount++] = PATNUMCD + jmp2->objectNumber;
		for (i = 0; i < jmp2->objectNumber; i++) {
			switchObject(count,jmp2->object[i],OBJ_ON);
		   	vexCode[vexCodeCount++] = PATONCD + jmp2->obj[i].pattern; 
		   	vexCode[vexCodeCount++] = PATXCD + jmp2->obj[i].x; 
			vexCode[vexCodeCount++] = PATYCD + jmp2->obj[i].y; 
			vexCode[vexCodeCount++] = PATRCD + jmp2->obj[i].fgr; 
			vexCode[vexCodeCount++] = PATGCD + jmp2->obj[i].fgg; 
			vexCode[vexCodeCount++] = PATBCD + jmp2->obj[i].fgb; 
			vexCode[vexCodeCount++] = PATCHECKCD + object[(jmp2->object[i])].checksize; 			
		}
	   }
	     }

	}/*if vexOnFlag*/ 
      
if(wasButtOn==1) 
     {
	wasButtOn=0; 

	myVexFlag=0;

     }
   
     if(wasButtOff==1)
       {
	wasButtOff=0;

	  myVexFlag=0;

       }

	return(YES); 

   }/*if either On or Off Flag*/

/*now tend to background luminance*/

    if (BGLumFlag == YES) {
	BGLumFlag = NO;
	vexIndex = 0;
        vexbuf[vexIndex++] = SET_BACK_LUM;
	vexbuf[vexIndex++] = (char)bkgd_lum; /* red */
	vexbuf[vexIndex++] = (char)bkgd_lum; /* green */
	vexbuf[vexIndex++] = (char)bkgd_lum; /* blue */
	/* sendVex(vexIndex); */
	return(YES);
    }/*if BGLumFlag*/
   

/*now tend to joy or ramp luminance*/
    if (vexJoyFlag != 0)  {
	vexIndex = 0;
    	joyx = (short int)joyh >> 2;
    	joyy = (short int)joyv >> 2;
    	if (vexJoyFlag & VEXRF) {
		joyobject[joynumber++] = (char)rf->object[0];
    	}
    	if (vexJoyFlag & VEXCURRENT) {
		joyobject[joynumber++] = (char)current->object[0];
	}
    	if (vexJoyFlag & VEXCURRENTDIM) {
		joyobject[joynumber++] = (char)current->object[1];
    	}
	if (vexJoyFlag & VEXRF2) {
		joyobject[joynumber++] = (char)rf2->object[0];
	}
	if (vexJoyFlag & VEXFP) {
		joyobject[joynumber++] = (char)fp->object[0];
	}
	if (vexJoyFlag & VEXJMP1) {
		joyobject[joynumber++] = (char)jmp1->object[0];
	}
	if (vexJoyFlag & VEXJMP2) {
		joyobject[joynumber++] = (char)jmp2->object[0];
	}
	vexIndex = 0;
    	vexbuf[vexIndex++] = STIM_LOCATION; /*special ramp driving command*/
    	vexbuf[vexIndex++] = joynumber; /*joyobject objects, 1-6*/
	for (i = 0; i < joynumber; i++) {
		vexbuf[vexIndex++] = joyobject[i];
		floatload(joyx);
		floatload(joyy);
	}
	/* sendVex(vexIndex); */
	return(YES);
	}/*if vexJoyFlag */

    return(NO);

}/*minvexFlagCheck*/

int
vexCodeStuff() {
	long codeTime;
	int i;
	
  	codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
	for (i = 0; i < vexCodeCount; i++) {
	    /*  dprintf("%d ", vexCode[i]); */
		vexEvent[i].e_code = vexCode[i]; /*load ecode*/
		vexEvent[i].e_key = codeTime;    /*load time*/
		ldevent (&vexEvent[i]); /*drop code*/
	}
	vexCodeCount = 0; /*clearing code count for next time*/
	/* rxerr("drop code\n"); */

	return(0);
}


int waitingForRf(){
   
if(wait_for_rfoff==1 && oneframemode==1) return(YES);
   else return(NO);
   
}

int
vexPhotoStuff() {

        long codeTime;
	int i;
	int j;
	long code = PBADCD;
	static howlong = 0;

	howlong = howlong + 1; /* count number of times before code dropped */
	j = code; /* to use if howlong goes too long */
   
   
    if(aminButt==1)
     {
		codeTime = i_b->i_time; 
		for (i = 0; i < vexCodeCount; i++) {
			vexEvent[i].e_code = vexCode[i]; 
			vexEvent[i].e_key = codeTime;    
			ldevent (&vexEvent[i]); /*drop code*/
		}
		vexCodeCount = 0; 
		howlong = 0;  /* reset counter */
	
	return(YES);
     }


	if (drinput & PHOTOIN) {

	   if(prfonflag==YES&&oneframemode==1)  wait_for_rfoff=YES; /*declares that rfon issue command has executed, i think*/

	   /*drop vex codes and reset codecount and howlong*/
	   
		codeTime = i_b->i_time; 
		for (i = 0; i < vexCodeCount; i++) {
			vexEvent[i].e_code = vexCode[i]; 
			vexEvent[i].e_key = codeTime;    
			ldevent (&vexEvent[i]); /*drop code*/
		}
		vexCodeCount = 0; 


		howlong = 0;  /* reset counter */

     if(rfreallyappeared==YES&&oneframemode==1) 
	     {
		sureshrfoff=NO; 
		wait_for_rfoff=NO;
		vexCancelFlag &= (NOVEXRF);  
		rfreallyappeared=NO;
	     }

	   if(go_time==0 && fpgoneoff==1) go_time=codeTime;

		if(prfonflag==YES&&oneframemode==1)
		  { 	        
		     vexCode[vexCodeCount++] = RFOFFCD; 
		     prfonflag=NO; rfreallyappeared=YES;
		  }

	      return(YES); /*photoprobe has been received*/

	} /* endif (drinput... */


          if (howlong > 50) {

		vexCode[vexCodeCount++] = j;

	     codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
		for (i = 0; i < vexCodeCount; i++) {
		    /*  dprintf("%d ", vexCode[i]); */
			vexEvent[i].e_code = vexCode[i]; /*load ecode*/
			vexEvent[i].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[i]); /*drop code*/
		}
		vexCodeCount = 0; /*clearing code count for next time*/

	     /* in case this photobad was after rfon command was issued */
	     
	     if(prfonflag==YES&&oneframemode==1)
	     { 	        
		vexCode[vexCodeCount++] = RFOFFCD; /*jan10-05, so this is the bug, 
						    * doing before dropping. fixed*/
		prfonflag=NO; rfreallyappeared=YES;
	     }
	   
	if(photowarn==1) dprintf("%s\n","************PhotoBAD******************");

		howlong = 0;  /* reset counter */

		if(sureshrfoff==YES&&oneframemode==1) 
	           {
		      sureshrfoff=NO; wait_for_rfoff=NO;
		       vexCancelFlag &= (NOVEXRF); rfreallyappeared=NO;
		   }

	     if(go_time==0 && fpgoneoff==1) go_time=-10;

	     return(YES);	       

       } /* if photodiode has not lit up in 50ms, force code drop */

   return(NO); /*default: still waiting for 50 ms or probe input*/
}


/*int photoClear1() {

	dio_on(photooutDevice);
	return (0);
}


int photoClear2() {

	dio_off(photooutDevice);
	return (0);
}
*/

int sendVexNow() {

        sendVex(vexIndex);
	if(prfonflag==YES&&sureshrfoff==NO) rfHasAppeared=YES;

	return (0);
}

int sendVexNowB() {

        sendVex(vexIndex);
	if(prfonflag==YES&&sureshrfoff==NO) rfHasAppeared=YES;

	return (0);
}

int startStuff()
{
	int i;
	unsigned int stime = 0;
	long ltime;

	for (i = 0; i < ARRAYSIZE; i++) array.tbl[i].index = i;
		

	ltime = time(NULL);
	stime = (unsigned) ltime*2;
	srand(stime);    /* Seed rand() by current time */

	shuffle(); /*shuffle the array pointer table*/
	return(0);
}

int backon1FlagCheck()
{
	if (local_backon1flag > 0) return(YES);
	else return(NO);
}

int backon2FlagCheck()
{
	if (local_backon2flag > 0) return(YES);
	else return(NO);
}

int backon1Check() 
{
	int choice = NO;
	if (rfonflag == YES) return(NO);	
	if (((backon1flag & B_GOODSAC) != 0) 
		&& ((goodsacFlag & SACCADE1) != 0)) choice = YES; 
	else if (((backon1flag & B_WINDOW) != 0) 
		&& ((eyeflag & WD1_XY) ==  0)) choice = YES;
	else if (((eyeflag & WD1_XY) == 0)
		&& ((backon1flag & B_DOUBLEJUMP) !=0)) choice = YES;
	if (choice == YES) {
		if ((backon1flag & B_DOUBLEJUMP) != 0) {
			jmp1WinNowFlag = NO;
			jmp1NowFlag = NO;
			jmp2NowFlag = YES;
			sac1Flag = NO;
			sac2Flag = YES;
		}
		local_backon2flag = backon2flag;
		return(YES);
	}
	else return(NO);
}

int backon2Check() 
{
	int choice = NO;
	if (((backon2flag & B_GOODSAC) != 0) 
		&& ((goodsacFlag & SACCADE2) != 0)) choice = YES; 
	else if (((backon2flag & B_WINDOW) != 0) 
		&& ((eyeflag & WD2_XY) ==  0)) choice = YES;
	if (choice == YES) {
		if ((backon2flag & B_DOUBLEJUMP) != 0) {
			jmp1WinNowFlag = NO;
			jmp1NowFlag = NO;
			jmp2NowFlag = YES;
		}
		local_backon1flag = 0;
		return(YES);
	}
	else return(NO);
}

int backon1WaitStuff() {
	local_backon1flag = NO;
	return(0);
}

int backon2WaitStuff() {
	local_backon2flag = NO;
	return(0);
}




int backon1OnStuff() {
	int j; 
	long code = BACKON1CD;
		
	j = code;

	if ((backon1flag & (B_GOODSAC | B_WINDOW)) == NO) return(NO);
	
	if(vexclean==0){
        if (jmp1->interface == BLUEBOX) {
 		if (current->device != 0) dio_on(current->device);	/* turn on LED */
	/* if there is a ramp, then move the LED
	 * 	ra_start with a 0 gives the mirrors a 40ms settling pause
	 *	change to 1 to remove settling pause
	 */
	   if ((jmp1->control == MIR1_RAMP) || (jmp1->control == MIR2_RAMP))
		ra_start(0,0,current->device); 
           j = code;
	} /*if interface == BLUEBOX*/
	else {
		vexCode[vexCodeCount++] = j; /*code buffer, loaded when 
					        *VEX says stimulus is on
						*/
		j = 0;

		if (nogoflag == YES) vexOnFlag |= VEXFP;
		else {
			switch (jmp1->control) {
			case VEXSTATIC:
			case NO:
				vexOnFlag |= VEXRF;
				break;
			case VEXARRAY:
/*	case VEXSTATIC:   I have moved this up so I can get it with Joy- JB */
			case VEXBACKGROUND:
			case VEXCUE:
			case VEXCUE2:
			case VEXBACKOFF:
				vexOnFlag |= VEXJMP1;
				vexCancelFlag |= VEXJMP1;
				break;
			case VEXJOY:
				vexCancelFlag |= VEXJMP1JOY;
				vexOnFlag |= VEXJMP1JOY;
				break;
			}; /*switch*/
		} /*else nogoflag */
	} /*else*/}else j=0;

	return(j);
}

int backon2OnStuff() {
	int j; 
	long code = BACKON2CD;
		
	j = code;

	if ((backon2flag & (B_GOODSAC | B_WINDOW)) == NO) return(NO);
	if(vexclean==0){
        if (jmp2->interface == BLUEBOX) {
 		if (current->device != 0) dio_on(current->device);	/* turn on LED */
	/* if there is a ramp, then move the LED
	 * 	ra_start with a 0 gives the mirrors a 40ms settling pause
	 *	change to 1 to remove settling pause
	 */
	   if ((jmp2->control == MIR1_RAMP) || (jmp2->control == MIR2_RAMP))
		ra_start(0,0,current->device); 
           j = code;
	} /*if interface == BLUEBOX*/
	else {
		vexCode[vexCodeCount++] = j; /*code buffer, loaded when 
					        *VEX says stimulus is on
						*/
		j = 0;

		if (nogoflag == YES) vexOnFlag |= VEXFP;
		else {
			switch (jmp2->control) {
			case VEXSTATIC:
			case NO:
				vexOnFlag |= VEXRF;
				break;
			case VEXARRAY:
/*	case VEXSTATIC:   I have moved this up so I can get it with Joy- JB */
			case VEXBACKGROUND:
			case VEXCUE:
			case VEXCUE2:
			case VEXBACKOFF:
				vexOnFlag |= VEXJMP2;
				vexCancelFlag |= VEXJMP2;
				break;
			case VEXJOY:
				vexCancelFlag |= VEXJMP2JOY;
				vexOnFlag |= VEXJMP2JOY;
				break;
			}; /*switch*/
		} /*else nogoflag */
	} /*else*/} else j=0;

	return(j);
}
	

int cheatCheck() {
	int x;
	int y;

	/*check to see if the monkey made a cheating saccade*/	
	if (--local_jmpCheckDelay > 0) return(NO);
	x = abs(eyeh/4 - current->x);
	y = abs(eyev/4 - current->y);
	if ( (x + y) < noCheat) {
		abortFlag = YES;
		return(YES);
	}
	return(NO);
}


int cueOnStuff() {
	int j;
	long code = CUEONCD;
	OBJECT *obj;

	j = code;
	local_cueflag = NO;
	cueOnFlag = YES;

if(vexclean==0){
if (cue->interface == TV) {
	   if((cue->control == VEXBACKGROUND) || (cue->control == VEXBACKOFF))
		cue->object[0] = background[cue->background].object[0]+1;
	   obj = &object[cue->object[0]];


	   vexCode[vexCodeCount++] = (short int)j;
           j = 0;
	   switch (cue->control) {


		case VEXBACKOFF:  /*JG*/
                case VEXSTATIC:
		case VEXARRAY:
		case VEXBACKGROUND:
			vexCode[vexCodeCount++] = (short int)j;
			obj->x = cue->x;
			obj->y = cue->y;
		case MCSTHRESH:
		case THRESHOLD:
			vexOnFlag |= VEXCUBE;
			vexCancelFlag |= VEXCUBE;
			break;
		case VEXJOY:
			vexOnFlag |= VEXCUEJOY;
			break;
	   }
	}/*if cue->interface == TV*/
	else if (cue->interface == BLUEBOX) {
	    switch (cue->control) {
		case MIR2_RAMP: 
			da_cntrl_2(2, DA_RAMP_X, 0, 3, DA_RAMP_Y, 0);
	 		ra_start(0, 0, cue->device);
			break;
		case MIR1_RAMP:
			da_cntrl_2(0, DA_RAMP_X, 0, 1, DA_RAMP_Y, 0);
		 	ra_start(0, 0, cue->device);
			break;
	    };
	if (cue->device != 0) dio_on(cue->device);
	} /*if cue->interface == BLUEBOX*/}
	return(j);
}

int cue2OnStuff() {
	int j;
	long code = CUE2ONCD;
	OBJECT *obj;

	j = code;
	local_cue2flag = NO;
	if(vexclean==0){
	if (cue2->interface == TV) {
	   if((cue2->control == VEXBACKGROUND) || (cue2->control == VEXBACKOFF))
		cue2->object[0] = background[cue2->background].object[0]+1;
	   obj = &object[cue2->object[0]];

	   vexCode[vexCodeCount++] = (short int)j;
           j = 0;
	   switch (cue2->control) {
		case VEXBACKOFF:  /*JG*/
                case VEXSTATIC:
		case VEXARRAY:
		case VEXBACKGROUND:
			vexCode[vexCodeCount++] = (short int)j;
			obj->x = cue2->x;
			obj->y = cue2->y;
			vexOnFlag |= VEXCUBE2;
			vexCancelFlag |= VEXCUBE2;
			break;
		case VEXJOY:
			vexOnFlag |= VEXCUE2JOY;
			break;
	   }
	}/*if cue2->interface == TV*/
	else if (cue2->interface == BLUEBOX) {
	    switch (cue2->control) {
		case MIR2_RAMP: 
			da_cntrl_2(2, DA_RAMP_X, 0, 3, DA_RAMP_Y, 0);
	 		ra_start(0, 0, cue2->device);
			break;
		case MIR1_RAMP:
			da_cntrl_2(0, DA_RAMP_X, 0, 1, DA_RAMP_Y, 0);
		 	ra_start(0, 0, cue2->device);
			break;
	    };
	if (cue2->device != 0) dio_on(cue2->device);
	} /*if cue2->interface == BLUEBOX*/}
	return(j);
}


void 
switchbg() {

	int i;
	

	for (i =0; i < backgroundNumber; i++) {
  	   if (compareobject (&background[i].bgobj[0],&background[i].bgobj[1]) 
		== NO) {
		if (rfswitchflag == ON1){
		    switchOnStack[switchOnFlag++] = background[i].object[1];
		    switchOffStack[switchOffFlag++] = background[i].object[0];
		}
		else if (rfswitchflag == ON0){
		    switchOnStack[switchOnFlag++] = background[i].object[0];
		    switchOffStack[switchOffFlag++] = background[i].object[1];
		}
	   }
	}
	/*now toggle switchflag*/
	if (rfswitchflag == ON0)
		rfswitchflag = ON1;
	else 
		rfswitchflag = ON0;
}

void 
makeObjDelta(int *objlist, int xdelta, int ydelta, int objectNumber) {
	int i;
	for (i = 1; i <objectNumber; i++) {
		object[objlist[i]].x = object[objlist[i]].x + xdelta;
		object[objlist[i]].y = object[objlist[i]].y + ydelta;
	}
}

int rfonStuff() {
	int j;
	long code = RFONCD;
/*
	int xdelta;
	int ydelta;
*/
	OBJECT *obj;

	j = code;
	local_rfflag = NO; new_fponflag=0;
	rfonflag = YES;
	rfwason=YES;

   rfdelayFlag=NO;
   rfnextFlag=NO;
   
		if(manyrfFlag==1&&rfrandmap==1) rflocind++;
   seenflashes++;
   if(seenflashes<rfmap_numflashes) seenflashflag=YES; else seenflashflag=NO;

   if(mmnmenuon==1){
		if(numrfobjects>0){
/*		if(skipthis==1) rf->objectNumber=numrfobjects-1;
		else */rf->objectNumber=numrfobjects;
		}
   }
		
	if (rf->interface == TV) {
	   if((rf->control == VEXBACKGROUND) || (rf->control == VEXBACKOFF))
		rf->object[0] = background[rf->background].object[0]+1;
	   obj = &object[rf->object[0]];
	   vexCode[vexCodeCount++] = (short int)j;
           j = 0;
	   vexJoyFlag &= NOVEXRF;
	   switch (rf->control) {
		case VEXBGRF:
			switchbg();
			vexCode[vexCodeCount++] = (short int)j;
			break;
		case VEXSTATIC:
		case VEXARRAY:
		case VEXBACKGROUND:
		case VEXBACKOFF:
			vexCode[vexCodeCount++] = (short int)j;
			vexOnFlag |=VEXRF;
			break;
		case VEXJOY:
			vexOnFlag |= VEXRF; 
			vexCode[vexCodeCount++] = (short int)j;
			rf->x = joyh >> 2;
			rf->y = joyv >> 2;
			vexJoyFlag |= VEXRF;
			break;
	   }
	}/*if rf->control == TV*/
	else if (rf->interface == BLUEBOX) {
	    switch (rf->control) {
		case ZAP:
			rfgrassflag = YES; /*turn on stimulator*/
			break;
		case MIR2_RAMP: 
			da_cntrl_2(2, DA_RAMP_X, 0, 3, DA_RAMP_Y, 0);
	 		ra_start(0, 0, rf->device);
			break;
		case MIR1_RAMP:
			da_cntrl_2(0, DA_RAMP_X, 0, 1, DA_RAMP_Y, 0);
		 	ra_start(0, 0, rf->device);
			break;
				    };
		if (rf->device != 0) dio_on(rf->device);
	} /*if rf->interface == BLUEBOX*/
	return(j);

}

int rfnextwaitstuff(){

double aar;

if(jitterprob>0&&manyrfFlag==1){
	   aar=((double)rand()/(double)(RAND_MAX+1));  
	   if(aar<=((double)jitterprob)/100){
	   srfnext.preset=rfnextval-jittertim;
	   	   } else srfnext.preset=  rfnextval;
		   	   if(srfnext.preset<50) srfnext.preset=50;

}
   return(0);
}

   
int CopyMyString(char* str1, char* str2, int numchar){

int i;
   
   for(i=0;i<numchar;i++){
    
      if(str1[i]!='\0')
	str2[i]=str1[i];
      else str2[i]='\0';
      
   }
   
   return(0);

}

int ShowArr(char* str1, int* arr1, int numlists){
 
   int i;
   
   dprintf("Setting %s to \t",str1);
/*   dprintf("This many values %d\n",numlists);*/
   
   for(i=0;i<numlists;i++){
      if(arr1[i]>-1000)
	{
	   dprintf("%d\t",arr1[i]);
   
	}
   }
   
   dprintf("%s\n","");
}


   int ParseMyString(char* str1, int* arr1, int numints){

      int intcounter=0;
      char delims[] = " ,/.=";
      char* p;
      int i;
      
      for(i=0;i<numints;i++){
	 arr1[i]=-1000; /* -1000 acts as the null integer */
      }

      p=strtok(str1,delims);
      while(p!=NULL) {
       
	 if(strcmpi(p,"FPx")&&strcmpi(p,"FPy")&&strcmpi(p,"Jumpx")
	    &&strcmpi(p,"Jumpy")&&strcmpi(p,"RF2x")&&strcmpi(p,"RF2y")
	    &&strcmpi(p,"RFx")&&strcmpi(p,"RFy")) {
	 
      arr1[intcounter++]=atoi(p); 
/*      dprintf("Setting to%d\t",atoi(p));*/

	 }
	 
/*	 else dprintf("Setting problem %s\n",p);*/
	 
      p=strtok(NULL,delims);
   }
      return(intcounter);

   }

   
int StopOnJump(){

  if(StopMapOnJump==1 & gap1nowFlag==1) return(YES);

  return(NO);
}

int rfnextStuff(){
int i;

   manyRFstuff();
   FillRF();
      MMNStuff();
   twospotRepStuff();

   if(rfPropertiesChanged==0){
for(i=0;i<rf->objectNumber;i++){
locateStack[vexLocateFlag++] = rf->object[i];
}
   } else {
      for(i=0;i<rf->objectNumber;i++){
objectStack[vexObjectFlag++] = rf->object[i];
   }
   }
   rfnextFlag=YES;
   
return(0);

}

int struct_compare(const void *a, const void *b) 
{
   
struct rff *da=(struct rff*)a;
struct rff *db=(struct rff*) b;
   
   return(da->ind>db->ind)-(da->ind<db->ind);
   
}

int rfshuf(){

int ii;
int xct; int yct;

if(shufflenowflag==1){
dprintf("%s\n","*********shuffling, like you said***********");
shufflenowflag=0;}

for(ii=0;ii<128;ii++) {rffar[ii].rfx=-300; rffar[ii].rfy=-300;
rffar[ii].ind=(double)((rand())/(RAND_MAX+1.0));}

xct=0; yct=0;
rfnumlocs=0;
ii=0;

/*dprintf("rflocind \t%d\n",rflocind);*/


while(rffar[ii].rfy<=rfymax){

while(rffar[ii].rfx<=rfxmax){

rffar[ii].rfx=rfxmin+rfxinc*xct; xct++;
rffar[ii].rfy=rfymin+rfyinc*yct;
rfnumlocs++;
if (rffar[ii].rfx>=rfxmax) {ii++;break;}
else ii++;

}

yct++;xct=0;
if (ii==0) break;
if (rffar[ii-1].rfy>=rfymax) break;


}


qsort(rffar,rfnumlocs,sizeof(struct rff),struct_compare);
   
dprintf("\t\tshuffling done, %d\trf locations\n",rfnumlocs);
rflocind=0;
   

}

int rf2onStuff() {
	int j;
	long code = RF2ONCD;
	OBJECT *obj;

	j = code;
	local_rf2flag = NO;
	if (rf2->interface == TV) {
	   if((rf2->control == VEXBACKGROUND) || (rf2->control == VEXBACKOFF))
		rf2->object[0] = background[rf2->background].object[0]+1;
	   obj = &object[rf2->object[0]];
	   vexCode[vexCodeCount++] = (short int)j;
           j = 0;
	   vexJoyFlag &= NOVEXRF2;
	   switch (rf2->control) {
		case VEXBGRF:
			switchbg();
			break;
		case VEXSTATIC:
		case VEXARRAY:
		case VEXBACKGROUND:
		case VEXBACKOFF:
			vexCode[vexCodeCount++] = (short int)j;
			obj->x = rf2->x;
			obj->y = rf2->y;
			vexOnFlag |=VEXRF2;
			break;
		case VEXJOY:
			vexCode[vexCodeCount++] = (short int)j;
			vexOnFlag |= VEXRF2; 
			obj->x = joyh >> 2;
			obj->y = joyv >> 2;
			vexJoyFlag |= VEXRF2;
			break;
	   }
	}/*if rf2->control == TV*/
	else if (rf2->interface == BLUEBOX) {
	    switch (rf2->control) {
		case ZAP:
			rf2grassflag = YES; /*turn on stimulator*/
			break;
		case MIR2_RAMP: 
			da_cntrl_2(2, DA_RAMP_X, 0, 3, DA_RAMP_Y, 0);
	 		ra_start(0, 0, rf2->device);
			break;
		case MIR1_RAMP:
			da_cntrl_2(0, DA_RAMP_X, 0, 1, DA_RAMP_Y, 0);
		 	ra_start(0, 0, rf2->device);
			break;
				    };
	    if (rf2->device != 0) dio_on(rf2->device);
						} /*if rf2->interface== BLUEBOX*/
	return(j);
}

int rfoffStuff() {
	int j;
	long code = RFOFFCD;

	j = code;
	rfonflag = NO;
		
	if (rf->interface == TV) {
		vexOffFlag |= VEXRF;
	        vexCode[vexCodeCount++] = j; /*code buffer, loaded when
					      *vertical refresh happens*/
	        /* rxerr("rfoff: vexOffFlag %d\n", vexOffFlag); */
	        j = 0; /*so when we return we do not drop a code*/
		
	}
	if (rf->interface == BLUEBOX)  
	    if (rf->device != 0) dio_off(rf->device);
	    rfHasAppeared=NO;
	return(j);
}

int 
suresh_turnsoff_rf()
{
   int j,i;
   unsigned char *count;
	long code = RFOFFCD;
	
	vexIndex = 0;

/*	j = code;*/
	rfonflag = NO;
	
/*else build a vexbuf that will turn on the necessary stimuli*/
/*first locate background stimuli that will be turned on*/	

	vexbuf[vexIndex++] = SWITCH_STIM;
	count = &vexbuf[vexIndex++];
        *count = 0;
	
	for(i=0;i<rf->objectNumber;i++){
		switchObject(count,rf->object[i],OBJ_OFF);	
	}

/*
				switchObject(count,rf->object[1],OBJ_OFF);*/
			   	to_vex((unsigned short) vexIndex);

/*		dprintf("%s\n","turning off rf");*/

rfHasAppeared=NO; sureshrfoff=YES;
   /*prfonflag=NO;*/
/*   j=CDELCD+13;*/ j=0;
	return(j);
    
}



int rf2offStuff() {
	int j;
	long code = RF2OFFCD;

	j = code;
		
	if (rf2->interface == TV) {
		vexOffFlag |= VEXRF2;
	        vexCode[vexCodeCount++] = j; /*code buffer, loaded when
 	                                  *vertical refresh happens*/ 
		/* rxerr("rf2off: vexOffFlag %d\n", vexOffFlag); */
	        j = 0; /*so when we return we do not drop a code*/
		
	}
	if (rf2->interface == BLUEBOX)  
	    if (rf2->device != 0) dio_off(rf2->device);
	return(j);
}

int cueOffStuff() {
	int j;
	long code = CUEOFFCD;

	j = code;
	if(vexclean==0){
	if (cue->interface == TV) {
		vexOnFlag &= NOVEXCUBE;
		vexOffFlag |= VEXCUBE;
	        vexCode[vexCodeCount++] = j; /*code buffer, loaded when
 	                                  *vertical refresh happens*/ 
	        j = 0; /*so when we return we do not drop a code*/
		
	}
	if (cue->interface == BLUEBOX)  
		
	    if (cue->device != 0) dio_off(cue->device);}

	/* This is for trials in which the monkey must release the
		bar after the cue comes on */
	if ((cuebarflag)&&(cueBarRelease == NO)&&(cue->falsereward < minnoflash))
			cuebarXFlag = YES;

	return(j);
}

int cue2OffStuff() {
	int j;
	long code = CUE2OFFCD;

	j = code;
	
	if(vexclean==0){
	if (cue2->interface == TV) {
		vexOnFlag &= NOVEXCUBE2;
		vexOffFlag |= VEXCUBE2;
	        vexCode[vexCodeCount++] = j; /*code buffer, loaded when
 	                                  *vertical refresh happens*/ 
	        j = 0; /*so when we return we do not drop a code*/
		
	}
	if (cue2->interface == BLUEBOX)  
	    if (cue2->device != 0) dio_off(cue2->device);}
	return(j);
}

int cueDelayStuff()
{
	local_cueflag = NO;
	return(0);
}

int cue2DelayStuff()
{
	local_cue2flag = NO;
	return(0);
}
	
	
int rfdelayStuff()
{
	local_rfflag = NO; new_fponflag=0;
   rfdelayFlag=YES;
   rfnextFlag=NO;
	return(0);

   
}

int rf2delayStuff()
{
	local_rf2flag = NO;
	return(0);
}
	
void
fixCurrentDim(FUNCTION *fpx) { 
if(vexclean==0|fpgoneoff!=YES){
	current->object[1] = fpx->object_dim;
	objectStack[vexObjectFlag++] = current->object[1];}

/* OLD STUFF
**	current->object[1] = fpx->object[0] + 1;
**	current->obj[1] = fpx->obj[0];
**	current->obj[1].fgr -= fpx->object_dim;
**	if (current->obj[1].fgr < 0)
**		current->obj[1].fgr = 0;
**	current->obj[1].fgb -= fpx->object_dim;
**	if (current->obj[1].fgb < 0)
**		current->obj[1].fgb = 0;
**	current->obj[1].fgg -= fpx->object_dim;
**	if (current->obj[1].fgg < 0)
**		current->obj[1].fgg = 0;
**	object[current->object[1]] = current->obj[1];
**	objectStack[vexObjectFlag++] = current->object[1];
*/	
}

int intertrialStuff(){

trialOn=0;
return(0);
}

int interStuff()
{
	char arrayIndexName[33];
	char *foobuf = NP;
	static int base  = 10;
	int percor = 0;
	double aar; /*these are for my fprandom --suresh*/
	int currentobj;
	int j,i;
        int tempx, tempy, aarand;
        double radrat;
   long templat;
   int sillyind; int shufflenow;
	double ang;   int maxrfobj;
   

   turnonrequested=0;
   aminButt=0;
   rfPropertiesChanged=0;
  
  if(whichreward==1) sreward_on.preset=rwdtime; else sreward_on.preset=orwdtime;
   
   if(waschonkinflash==1){bkgd_lum=old_bglum;
      		BGLumFlag = YES;
waschonkinflash=0;	
dio_off(beepDevice);
   }else  old_bglum = bkgd_lum;
   
   
/*   for(i=0;i<numlistfpxs;i++){
      if (listfpx[i]!=-1000)
	dprintf("%d ",listfpx[i]);
      else dprintf("%s\n","");
   }
   dprintf("%s\n","");*/
   

   monkeyhasacquired=NO;
   startacquire=NO;
   
   buttOnFlag=0; buttOffFlag=0; buttCancelFlag=0; myVexFlag=0;
   
   rfwason=0;
   trialOn=1;
   skipthis=0;
   seenflashes=0;
   rfdelayFlag=0;
   rfnextFlag=NO;

     
	if (((errorCorrectFlag == YES)|(repeatFlag == YES)) && (goodFlag == NO)) {
		goodFlag = YES; mygoodFlag=NO;
	}/*don't change array index if error correction on or if repeatFlag on*/
	else {
		goodFlag = YES; mygoodFlag=YES;
		switch (sequenceflag) {
		case S_SHUFFLE:
			readshuffle();
			break;
		case S_SEQUENCE:
			if (++array.array_index >= array.array_max) 
			   array.array_index = 0;
			break;
		};
	}

/*if(et_autoshuf==1){

       shufflenow=0;
       if(et_counter>=1600) et_counter=0;
   dprintf("%d\t",et_counter);
   dprintf("%d\n",et_marker);
   
	for (i=0;i<(array.array_max);++i) {
		array.tbl[i].fp.background=1;
	}

if(et_counter==0){dprintf("%s\n","reshuffling");
sillyind=2;et_marker=1; shufflenow=1;
}
   if(et_counter==400) {dprintf("%s\n","reshuffling");
      sillyind=6; et_marker=2; shufflenow=1;
   }
   
      if(et_counter==800) {dprintf("%s\n","reshuffling");
      sillyind=4; et_marker=3; shufflenow=1;
   }
   
      if(et_counter==1200) {dprintf("%s\n","reshuffling");
      sillyind=0; et_marker=4;shufflenow=1;
   }
   
   array.tbl[sillyind].fp.background=12;
      array.tbl[sillyind+1].fp.background=12;

   if(shufflenow==1) shuffle();

}
   
   else et_counter=0;*/

repeatFlag = NO;
rfind=0;


isab=0; isfb=0;

askfpoff=0;
fpgoneoff=NO;
	rfHasAppeared=NO;
sureshrfoff=NO; rfreallyappeared=NO;
   prfonflag=NO;
   wait_for_rfoff=NO;
   nowincheckflag=NO;
   
   go_time=0; fin_time=0;

	cueOnFlag = NO;
	cueBarRelease = NO;
	jRandEndFlag=NO;
	jRandINDEX=0;
	jRandOver=0;
	new_fponflag=0;
	new_trialFlag=0;
	local_newrfflag=newrfflag;
	local_window_delay=0; /* need to prevent fp bug*/
	local_jmp2RwdFlag = array.tbl[arrayIndex].jmp2RwdFlag;	
		
	if (resetit != 0) {
		resetit = 0;
		count_first_twenty = 0;
		for (i=0;i<20;++i) last[i]=0;
		}
	for (i=0;i<20;++i) percor = percor + last[i];
	if (count_first_twenty == 0) percor = 0;
		else percor = (int) ((percor*100)/(count_first_twenty));
	if (percorFlag != 0) dprintf ("%d percent\n",percor);


	/* put array.array_index on status line */
	arrayIndex = array.array_index; /*now use local copy of array index*/
	foobuf = itoa(array.array_index,arrayIndexName,base);
	if (printArrayFlag == YES) dprintf("%s ", arrayIndexName);

/*first function pointers for this trial*/
	fp = &array.tbl[arrayIndex].fp; /*initialize fixation .device pointers*/
	rf = &array.tbl[arrayIndex].rf;
	rf2 = &array.tbl[arrayIndex].rf2;
	jmp1 = &array.tbl[arrayIndex].jmp1;
	jmp2 = &array.tbl[arrayIndex].jmp2;
	jRandFlag= (*jmp1).RandFlag; /*initializing the 3 flags from the
		   		      jmp1menu*/
	NumJmp1s=(*jmp1).NumRandJumps;
	MaxJmp1Size=(*jmp1).RandJumpSize;

	cue = &array.tbl[arrayIndex].cue;	
	cue2 = &array.tbl[arrayIndex].cue2;
	gap = &array.tbl[arrayIndex].gap;
	rmp = &array.tbl[arrayIndex].rmp;

/*This little codebit does the fp randomization*/
	fpRandFlag= array.tbl[arrayIndex].fprandflag;
	fpRandSize= array.tbl[arrayIndex].fprandsize;
	if(fpRandFlag!=0) {
	
/*	   if (fpRandSize%2==0) fpRandSize ++ ;
	   
	   aar=((double)rand()/(double)(RAND_MAX+1));  
	   fp->x=(int)(aar*(fpRandSize))-(fpRandSize-1)/2;
	   aar=((double)rand()/(double)(RAND_MAX+1));  
	   fp->y=(int)(aar*(fpRandSize))-(fpRandSize-1)/2;*/
	   
	   /* new fprand version for ziggy*/
	   aar=2*PI*((double)rand()/(double)(RAND_MAX+1));  
	   fp->x=(int)(fpRandSize*cos(aar));
	   fp->y=(int)(fpRandSize*sin(aar));
	   
	   object[fp->object_dim].x=fp->x; /*here i am making dim location
same as that of fp*/
	   object[fp->object_dim].y=fp->y;
	
	}
/* end of fp randomization*/

/*if(rfrandflag==1){
radrat=100/(double)(fpRandSize);
   tempx=(int)(radrat*fp->x);
   tempy=(int)(radrat*fp->y);


   	   aarand=(int)(2*((double)rand()/(double)(RAND_MAX+1)));
if(aarand==2){tempx=0; tempy=0;
} else if(aarand==1) {tempx=-1*tempx; tempy=-1*tempy;
}

   rf->x=tempx; rf->y=tempy;
   object[rf->object[0]].x=tempx;
   object[rf->object[0]].y=tempy; 
   rf->obj[0].x=tempx;
   rf->obj[0].y=tempy;
   
}*//*mmove aarand back to 3 if center needed*/

	fp->obj[0] = object[fp->object[0]];
	if (fp->control == VEXJOY) {
		fp->obj[0].x = joyh >> 2;
		fp->obj[0].y = joyv >> 2;
	}
	else {
		fp->obj[0].x = fp->x;
		fp->obj[0].y = fp->y;
	}
	current = fp; 
	
	
	if(rf2->obj[0].x<0) lefttrial=1; else lefttrial=0;
   



   
/* now flags*/
	rfflag = array.tbl[arrayIndex].flag & RFFLAG;
	nogoflag = (array.tbl[arrayIndex].flag & NOGOFLAG) >> SHIFT_NOGOFLAG;
	rfshuffleflag = (array.tbl[arrayIndex].flag & RFSHUFFLEFLAG) >> SHIFT_RFSHUFFLEFLAG;
	fixjmpcueflag = (array.tbl[arrayIndex].flag & FIXJMPCUEFLAG) >> SHIFT_FIXJMPCUEFLAG;
	barflag = (array.tbl[arrayIndex].flag & BARFLAG) >> SHIFT_BARFLAG;
	baroffflag = (array.tbl[arrayIndex].flag & BAROFFFLAG) >> SHIFT_BAROFFFLAG;
	cuebarflag = (array.tbl[arrayIndex].flag & CUEBARFLAG) >> SHIFT_CUEBARFLAG;
	rf2flag = (array.tbl[arrayIndex].flag & RF2FLAG) >> SHIFT_RF2FLAG;
	jmp1Flag = (array.tbl[arrayIndex].flag & JMP1FLAG) >> SHIFT_JMP1FLAG;
/*	jRandFlag=(array.tbl[arrayIndex].jmp1randflag);*/
	jmp2Flag = (array.tbl[arrayIndex].flag & JMP2FLAG) >> SHIFT_JMP2FLAG;
	grassflag = (array.tbl[arrayIndex].flag & GRASSFLAG) >> SHIFT_GRASSFLAG;
	jmp2Sacflag = (array.tbl[arrayIndex].flag & JMP2SAC) >> SHIFT_JMP2SAC;
	backon1flag = (array.tbl[arrayIndex].flag & BACKON1) >> SHIFT_BACKON1;
	backon2flag = (array.tbl[arrayIndex].flag & BACKON2) >> SHIFT_BACKON2;
	jmp1cueflag = (array.tbl[arrayIndex].flag & JMP1CUEFLAG) >> SHIFT_JMP1CUEFLAG;
	jmp2cueflag = (array.tbl[arrayIndex].flag & JMP2CUEFLAG) >> SHIFT_JMP2CUEFLAG;
	jmp1cue2flag = (array.tbl[arrayIndex].flag & JMP1CUE2FLAG) >> SHIFT_JMP1CUE2FLAG;
	jmp2cue2flag = (array.tbl[arrayIndex].flag & JMP2CUE2FLAG) >> SHIFT_JMP2CUE2FLAG;
/*next one will have to be >> 16 */

	switch (cue->thresh[cue->falsereward].tp1) {
		case 1:
			strcpy(vary1, "x position");
			break;
		case 2:
			strcpy(vary1, "y position");
			break;
		case 3:
			strcpy(vary1, "luminance");
			break;
		case 4:
			strcpy(vary1, "pattern");
			break;
		case 5:
			strcpy(vary1, "checksize");
			break;
		default:
			strcpy(vary1, "");
			break;
	} /* tp1 switch */

	switch (cue->thresh[cue->falsereward].tp2) {
		case 1:
			strcpy(vary2, "x position");
			break;
		case 2:
			strcpy(vary2, "y position");
			break;
		case 3:
			strcpy(vary2, "luminance");
			break;
		case 4:
			strcpy(vary2, "pattern");
			break;
		case 5:
			strcpy(vary2, "checksize");
			break;
		default:
			strcpy(vary2, "");
			break;
	} /* tp2 switch */

/* set up times and delays from array if necessary*/


	
        sfpon.preset = fp->time;
	sgap1.preset = gap->time;
	sgap2.preset = gap->delay;
	sb1Gap.preset = gap->windowx;
	sb2Gap.preset = gap->windowy;
	senable.preset = fp->delay;
	scueOn.preset = cue->time;
	scue2On.preset = cue2->time;
	srfdelay.preset = rf->delay;

snewrfdelay.preset=rf->delay;
        snewrftimer.preset=rf->time;
/*now do special dim stuff*/
	if (barflag != NO)
		fixCurrentDim (fp);
	srf2delay.preset = rf2->delay;

if(latcorrect==1){   
if (lefttrial==1) {

   templat=0;
   for(i=0;i<10;i++){templat=templat+leftlatarray[i];
   }
} else if (lefttrial==0) {
 templat=0;
      for(i=0;i<10;i++){templat=templat+rightlatarray[i];
   }
}

  srfdelay.preset=sjmp1delay.preset+(int)(templat/10)-75;
  if(srfdelay.preset<(sjmp1delay.preset+50))
srfdelay.preset=sjmp1delay.preset+50;

   dprintf("latency measure is %d\n",(int)(templat/10)-75);
   
}
   

/*sfpon.preset=srfdelay.preset; *//*for hofsub only*/
/*	dprintf("\t\tRFdelay is %d\t",srfdelay.preset);
	dprintf("FPtime is %d\n",sfpon.preset);*/



/* I sometimes only want 2 possible jmp1.delay times, so I have used
 *	jmp1.falsereward to be the extra time placed on randomly. JB */

	i = (int)(10*rand()/(RAND_MAX+1.0));
	
	/* Suresh: am messing here with jmp1addrand. Trying to get 10
different times*/

/*	if (i<5) sjmp1delay.preset = jmp1->delay + jmp1->falsereward;
	else sjmp1delay.preset = jmp1->delay; */

	sjmp1delay.preset = jmp1->delay + ((int)(i))*((jmp1->falsereward/10));
/*	else sjmp1delay.preset = jmp1->delay;*/
	
	local_cuedel=sjmp1delay.preset; 
	
/* if jmp1cue is on, ZAP time will be cue-on-time+rf_delay+(sgrassdelay.preset)*/
	if (jmp1cueflag != 0)
	    {
		scueDelay.preset = sjmp1delay.preset + cue->delay;
		if (rf->control == ZAP)
			srfdelay.preset = sjmp1delay.preset + cue->delay + rf->delay;

	    }

	else if (jmp2cueflag != 0)
	    scueDelay.preset = sjmp1delay.preset + jmp2->delay + cue->delay;

	if (fixjmpcueflag != 0) scueDelay.preset = 0;

	if (jmp1cue2flag != 0)
	    {
		scue2Delay.preset = sjmp1delay.preset + cue2->delay;
		if (rf2->control == ZAP)
			srf2delay.preset = sjmp1delay.preset + cue2->delay + rf2->delay;

	    }

	else if (jmp2cue2flag != 0)
	    scue2Delay.preset = sjmp1delay.preset + jmp2->delay + cue2->delay;    

	srfon.preset = rf->time;
        srf2on.preset = rf2->time;
	sjmp1on.preset = jmp1->time;

	sjmp2on.preset = jmp2->time;
	sgap2.preset = jmp2->delay;
   
/*   dprintf("\trfx\t\t%d\t",rf->obj[0].x);
   dprintf("\trfx\t\t%d\n",rf->obj[0].y);*/

      /*Calling the MMN function to set things up*/
   
   if(manyrfFlag==1) srfnext.preset=rfnextval;
   manyRFstuff();
   FillRF();
   MMNStuff();
      mgsStuff();   /*call here so that jmp1delay etc an be set*/
      remapStuff();
   ttaskStuff();
   epStuff(); /*calling for eye position menu. last, so it dominates*/
   linemotionStuff();
   
   twospotOnceStuff();
   twospotRepStuff();
   infowarnMe();

	/*this is for the watson trianing kluge. making sure rf is located right here*/
        /* not suitable for any other purpose. is esesntially an early
version of what happens in <fponstuff properly*/

	if (rfflag != NO && local_newrfflag==1) {


	   	      	   if(rf->control==VEXARRAY){

			   for (i = 0; i < rf->objectNumber; i ++) {
				currentobj = rf->object[i];	
				object[currentobj] = rf->obj[i];
	  		    } /*for i*/

			rf->x = object[rf->object[0]].x;
			rf->y = object[rf->object[0]].y;
			if(rfflag && (rf->objectNumber > 0))
				for (i = 0; i < rf->objectNumber; i++) {
				objectStack[vexObjectFlag++] = 
						rf->object[i]; 
				} /*for i*/}
				
/*				dprintf("current rf_x is\t%d\n",rf->x);*/

	}
   
	return(0);
}

int 
trialwaitStuff() {
	int j;
	long code = MSTARTCD;
	 
	j = code; /*makes code of MSTARTCD | array*100*/
	
	/*now set up mirrors,
	 *window control functions,
	 *and local copies of the current FUNCTION arrays
	 */
	
	/*set up mirror control according to fp.control flag*/
	da_cntrl(4,&mirrorOff); /*put all mirrors on standby*/
	ra_stop(0); /*stop ramp*/
	if ((fp->windowx !=0 ) && (fp->windowy != 0)) 
		wd_siz(0, (long)fp->windowx,(long)fp->windowy);
	wd_src_pos(0, WD_DIRPOS,0,WD_DIRPOS,0);
/*now locate all stimuli for trial (VEX is slow)*/
	vexLocateFlag = 0;
	switch (fp->control) {
		case NOMIRROR:
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case MIR1_ARRAY:
			da_set_2(0, (long)fp->x, 1, (long)fp->y);
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case MIR1_STATIC:
			fp->x = joyh>>2;
			fp->y = joyv>>2;
			da_set_2(0,fp->x,1,fp->y);
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			wd_src_pos(0, WD_JOY_X, 0, WD_JOY_Y, 0);
			break;
		case MIR2_ARRAY:
			da_set_2(2, fp->x, 3, fp->y);
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case MIR2_STATIC:
			fp->x = joyh>>2;
			fp->y = joyv>>2;
			da_set_2(2, fp->x, 3, fp->y);
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case MIR2_JOY:
			wd_src_pos(0, WD_JOY_X, 0, WD_JOY_Y, 0);
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y,0);
			break;
		case JOYNARRAY_MIR1:
			fp->x += (joyh >>2);
			fp->y += (joyv >>2);
			da_set_2(0, fp->x, 1, fp->y);
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case JOYNARRAY_MIR2:
			fp->x += (joyh >>2);
			fp->y += (joyv >>2);
			da_set_2(2, fp->x, 3, fp->y);
			wd_pos(0, (long)fp->x, (long)fp->y);
			break;
		case VEXSTATIC:
			fp->x = joyh >>2;
			fp->y = joyv >>2;
		case VEXARRAY:
			object[fp->object[0]].x = fp->x;	
			object[fp->object[0]].y = fp->y;	
			wd_pos(0, (long)fp->x, (long)fp->y);
			wd_pos(1, (long)fp->x, (long)fp->y);
			wd_pos(2, (long)fp->x, (long)fp->y);
			wd_pos(3, (long)fp->x, (long)fp->y);
		 /*effect object location change*/
			locateStack[vexLocateFlag++] = fp->object[0];
			break;
		    
		case VEXJOY:
			wd_src_pos(0, WD_JOY_X, 0, WD_JOY_Y, 0);
			break;
		case VEXBACKGROUND:
		case VEXBACKOFF:
			object[fp->object[0]].x = fp->x;	
			object[fp->object[0]].y = fp->y;	
			wd_pos(0, (long)fp->x, (long)fp->y);
			wd_pos(1, (long)fp->x, (long)fp->y);
			wd_pos(2, (long)fp->x, (long)fp->y);
			wd_pos(3, (long)fp->x, (long)fp->y);
		 /*effect object location change*/
			locateStack[vexLocateFlag++] = fp->object[0];
			break;

	}
	/*now set up devices*/
	current = fp; /*initialize fixation device pointers*/
/*	if (beepFlag)  dio_on(beepDevice); 
**		This is OLD beepFlag Stuff. NEW beepFlag is Fix break
*/
	if (!barflag) {  
		if (current->interface == BLUEBOX) {
		 /*turn on FP if not a bar trial*/
			dio_on(current->device);
		}
		else if (current->interface == TV) {
			vexOnFlag |=VEXCURRENT;
			vexCancelFlag |= VEXCURRENT;
		}
		
		new_fponflag=1;
		new_trialFlag=1;
	}/*if !barflag*/
	return(j);
}


int getarraynum()
{
	int arraycode;

	photoCancelFlag = NO; /* placing it here gives time for lastThings
			       * to shut off objects */
	arraycode = arrayIndex + ARRNUMCD;

	return(arraycode);
}

int barfpon() {

	if (current->interface == TV) {
       	    if (barflag) {
		switch (fp->control) {
		case VEXJOY:
			vexJoyFlag = VEXFP;
		case VEXSTATIC:
		case VEXARRAY:
		case VEXBACKGROUND:
		case VEXBACKOFF:
			vexOnFlag |= VEXCURRENT;
			break;
	    	};/*switch*/
	    }/*if barflag*/
       	}/*if current->interface*/
	else if (current->interface == BLUEBOX) {	
		if (barflag)  dio_on(current->device);
	}
	if(barflag) 		{new_fponflag=1; new_trialFlag=1;}
	return(0);
}

int fponStuff() {
	int currentobj;
	int j,i;
	long code = FPONCD;
	float randfalse;
	float xfalsereward;
	int localrand;
	/* stuff for rf_shuffle */
	int jj,maxrfobj;
	int used[FUNCOBJECT];
	int originalx[FUNCOBJECT];
	int originaly[FUNCOBJECT];
	double aar;

	long codeTime; /*for my cue delay code -suresh*/

	/* set falsereward flag */
	/*assume rand seeding in the shuffle routine is enough*/

	localrand = rand();
	randfalse = (float)localrand;
	randfalse /= RAND_MAX;
	xfalsereward = (float)fp->falsereward;
	xfalsereward /= 100;
	if (randfalse < xfalsereward)
	falseflag = YES;
	else falseflag = NO;
	
	islast=0;

	     	       	 /*Am dropping my local cue delay code here -Suresh 12/04*/
			codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
/*			vexEvent[0].e_code = CDELCD+local_cuedel; */
			vexEvent[0].e_code = CDELCD+et_marker; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
   
   /*actually recalls of codeTime not required at all.. so commenting those out*/
   
/*   			codeTime = i_b->i_time;*/ /*pick up current clock time for event code*/ 
/*			vexEvent[0].e_code = CDELCD+local_cuedel; */
			vexEvent[0].e_code = CDELCD+bkgd_lum; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/


/*			codeTime = i_b->i_time;*/ /*pick up current clock time for event code*/ 
			vexEvent[0].e_code = CDELCD+fp->x; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
			
/*			codeTime = i_b->i_time; *//*pick up current clock time for event code*/ 
			vexEvent[0].e_code = CDELCD+fp->y; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/

			vexEvent[0].e_code = CDELCD+fp->obj[0].checksize; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/

			vexEvent[0].e_code = CDELCD+fp->obj[0].fgr; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/

			vexEvent[0].e_code = CDELCD+fp->obj[0].fgg; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/

			vexEvent[0].e_code = CDELCD+fp->obj[0].fgb; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/

			/* the stuff here for linemotionmenu and
			   tdistractormenu is superfluous since these
			   variables are now being dropped along with
			   rf, rf2, jmp1 and jmp2*/   


/*commented out block:************************************************/

			if(0){   if(linemotionMenu==1){

   			vexEvent[0].e_code = CDELCD+rf->obj[0].var1; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
   
   			vexEvent[0].e_code = CDELCD+rf->obj[0].var2; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
   
   			vexEvent[0].e_code = CDELCD+rf->obj[0].var3; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
			
   }

if(tdistractorMenu==1){

   			vexEvent[0].e_code = CDELCD+rf->obj[0].var1; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
   
   			vexEvent[0].e_code = CDELCD+rf->obj[0].var2; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
   
   			vexEvent[0].e_code = CDELCD+rf->obj[0].var3; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
			
 }} /**********************commented out above; even if emacs doesn't show it*/


	/*now get back to main stuff*/
	j = code;

/*	if (beepFlag)	dio_on(beepDevice);
**		This is OLD beepFlag stuff. NEW beepFlag is fix break.
*/
	trialFlag = YES;
	local_jmp1Flag = jmp1Flag;
	local_rfflag = rfflag;
	local_rf2flag = rf2flag;
/*	local_window_delay = window_delay;*/ /*moving this to gap1stuff*/
	localflashFlag = flashFlag;
	localflashFlag2= barflashFlag;
	localBeepFlag = beepFlag;
	if ((jmp1Flag != 0) && (jmp1cueflag != 0)) local_cueflag = jmp1cueflag;
	else if (jmp2Flag != 0) local_cueflag = jmp2cueflag;
	if ((jmp1Flag != 0) && (jmp1cue2flag != 0)) local_cue2flag = jmp1cue2flag;
	else if (jmp2Flag != 0) local_cue2flag = jmp2cue2flag;

   
   
   /*now have to locate jmp,cue, rf stimuli - vex takes a long time, so
 * do it here
 */
   
   
	/*set TV according to control flag*/
        /* mirror is set at gap1*/
      if (jmp1Flag != NO) {
/*
	    jmp1->x = object[jmp1->object[0]].x;
	    jmp1->y = object[jmp1->object[0]].y;
*/
	if (nogoflag == YES) {
		jmp1->x = jmp1->obj[0].x = fp->x;
		jmp1->y = jmp1->obj[0].y = fp->y;
	}

	    switch (jmp1->control) {
		case VEXBACKGROUND:
		case VEXCUE:
		case VEXBACKOFF:
			object[jmp1->object[0]].x
			 = background[cue->background].bgobj[0].x;
			object[jmp1->object[0]].y
			 = background[cue->background].bgobj[0].y;
			locateStack[vexLocateFlag++] = jmp1->object[0];
			break;
		case VEXCUE2:
			object[jmp1->object[0]].x
			 = background[cue2->background].bgobj[0].x;
			object[jmp1->object[0]].y
			 = background[cue2->background].bgobj[0].y;
			locateStack[vexLocateFlag++] = jmp1->object[0];
			break;
		case VEXSTATIC:
/***** old JB062601	jmp1->x = joyh>>2;
			jmp1->y = joyv>>2;
****/
			jmp1->obj[0].x = joyh>>2;
			jmp1->obj[0].y = joyv>>2;

			jmp1->x = jmp1->obj[0].x;
				jmp1->y = jmp1->obj[0].y;
	case VEXARRAY:
/***** old JB062601	object[jmp1->object[0]].x = jmp1->obj[0].x = jmp1->x;
			object[jmp1->object[0]].y = jmp1->obj[0].y = jmp1->y;
****/
			object[jmp1->object[0]].x = jmp1->obj[0].x;
			object[jmp1->object[0]].y = jmp1->obj[0].y;
/**
dprintf("jmp1->object[0] is %d, object[%d].x,y are %d,%d, jmp1->x,y are %d,%d\n",
	jmp1->object[0], jmp1->object[0],
	object[jmp1->object[0]].x,object[jmp1->object[0]].y,
	jmp1->x, jmp1->y);
**/

				locateStack[vexLocateFlag++] = jmp1->object[0];
		case VEXJOY:
			break;
	     } /*switch*/
	}/*IF jmp1flag*/
	if (jmp2Flag != NO) {
	    switch (jmp2->control) {
		case VEXSTATIC:
			jmp2->x = joyh>>2;
			jmp2->y = joyv>>2;
		case VEXARRAY:
			object[jmp2->object[0]].x = jmp2->obj[0].x = jmp2->x;
			object[jmp2->object[0]].y = jmp2->obj[0].y = jmp2->y;
			locateStack[vexLocateFlag++] = jmp2->object[0];
		case VEXJOY:
			break;
		case VEXBACKOFF:
		case VEXBACKGROUND:
		case VEXCUE:
			object[jmp2->object[0]].x
			 = background[cue->background].bgobj[0].x;
			object[jmp2->object[0]].y
			 = background[cue->background].bgobj[0].y;
			locateStack[vexLocateFlag++] = jmp2->object[0];
		case VEXCUE2:
			object[jmp2->object[0]].x
			 = background[cue2->background].bgobj[0].x;
			object[jmp2->object[0]].y
			 = background[cue2->background].bgobj[0].y;
			locateStack[vexLocateFlag++] = jmp2->object[0];
			break;
	     } /*switch*/
	}/*IF jmp2Flag*/

   ShowbuttStuff();

   if (rfflag != NO) {
	switch (rf->control) {

		case VEXSTATIC:
			rf->x = joyh >> 2;
			rf->y = joyv >> 2;
		case VEXBACKOFF:
		case VEXBACKGROUND:
			rf->object[0] = background[rf->background].object[0]+1;
			object[rf->object[0]].x = rf->x;
			object[rf->object[0]].y = rf->y;
			object[rf->object[0]].pattern = rf->obj[0].pattern;
			if(rfflag)
			   for(i = 0; i < rf->objectNumber; i++)
				objectStack[vexObjectFlag++] = 
					rf->object[i]; 
				/*effect object change*/
			break;

		case VEXARRAY:
/*if there is only one member the background array, the x,y
 *value in the menu determines
 *the object value
 */
			if (rfshuffleflag == 0) {	
			    for (i = 0; i < rf->objectNumber; i ++) {
				currentobj = rf->object[i];	
				object[currentobj] = rf->obj[i];
/*if the rf array is more than one, shuffle it, and
 * make rf and jmp1 x and y values the object values
 * also subtract the hint values from the used objects
 */
						
	  		    } /*for i*/
			} /* rfshuffleflag == 0 */
			else {
				maxrfobj = rf->objectNumber;
				for (i = 0; i < maxrfobj; i++) {
					originalx[i] = rf->obj[i].x;
					originaly[i] = rf->obj[i].y;
				} /* for i*/

				for (i = 0; i < maxrfobj; i++) used[i]=0;
    	
				jj=(int)((double)maxrfobj*rand()/(RAND_MAX+1.0));
    				for (i = 0; i < maxrfobj; i++) {
					while (used[jj]==1)
					{
						jj=(int)((double)maxrfobj*rand()/(RAND_MAX+1.0));
				    	}
					rf->obj[i].x = originalx[jj];	
					rf->obj[i].y = originaly[jj];
					used[jj]=1;
			 	} /* for i */ 

				for (i = 0; i < maxrfobj; i++) {
					currentobj = rf->object[i];	
					object[currentobj] = rf->obj[i];
				} /*for i*/

			} /* rfshuffleflag == 0 else */

/*set local rf->x and y and jmp1 values */
			rf->x = object[rf->object[0]].x;

			rf->y = object[rf->object[0]].y;
			if(rfflag && (rf->objectNumber > 0))
				for (i = 0; i < rf->objectNumber; i++) {
				objectStack[vexObjectFlag++] = 
						rf->object[i]; 
				} /*for i*/
			break;
		case VEXJOY:
		case NOMIRROR:
			break;
		case MIR1_ARRAY:
			da_set_2(0, rf->x, 1, rf->y);
			break;
		case MIR1_STATIC:
			rf->x = joyh>>2;
			rf->y = joyv>>2;
			da_set_2(0, rf->x, 1, rf->y);
			break;
		case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			break;
		case MIR2_ARRAY:
			da_set_2(2, rf->x, 3, rf->y);
			break;
		case MIR2_STATIC:
			rf->x = joyh>>2;
			rf->y = joyv>>2;
			da_set_2(2, rf->x, 3, rf->y);
			break;
		case MIR2_JOY:
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y, 0);
			break;
		case JOYNARRAY_MIR1:
			rf->x += (joyh >>2);
			rf->y += (joyv >>2);
			da_set_2(0, rf->x, 1, rf->y);
			break;
		case JOYNARRAY_MIR2:
			rf->x += (joyh >>2);
			rf->y += (joyv >>2);
			da_set_2(2, rf->x, 3, rf->y);
			break;
 		case MIR2_RAMP:  
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			rf->x, rf->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
		case MIR1_RAMP:
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			rf->x, rf->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
	}	
	}/*IF rfflag*/
        if (rf2flag) {
	switch (rf2->control) {
		case VEXSTATIC:
			rf2->x = joyh >> 2;
			rf2->y = joyv >> 2;
		case VEXBACKGROUND:
		case VEXBACKOFF:
			rf2->object[0] = background[rf2->background].object[0]+1;
			object[rf2->object[0]].x = rf2->x;
			object[rf2->object[0]].y = rf2->y;
			if(rf2flag)
				locateStack[vexLocateFlag++] = rf2->object[0];
		case VEXARRAY:
			object[rf2->object[0]].x = rf2->x;
			object[rf2->object[0]].y = rf2->y;
			if(rf2flag)
/*				locateStack[vexLocateFlag++] = rf2->object[0];*/
/* 3/20/06: annegret -> changing to objectstack so that checksize changes to rf2 show up*/	     
	     			 objectStack[vexObjectFlag++] = rf2->object[0];
		case VEXJOY:
		case NOMIRROR:
			break;
		case MIR1_ARRAY:
			da_set_2(0, rf2->x, 1, rf2->y);
			break;
		case MIR1_STATIC:
			rf2->x = joyh>>2;
			rf2->y = joyv>>2;
			da_set_2(0, rf2->x, 1, rf2->y);
			break;
		case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			break;
		case MIR2_ARRAY:
			da_set_2(2, rf2->x, 3, rf2->y);
			break;
		case MIR2_STATIC:
			rf2->x = joyh>>2;
			rf2->y = joyv>>2;
			da_set_2(2, rf2->x, 3, rf2->y);
			break;
		case MIR2_JOY:
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y, 0);
			break;
		case JOYNARRAY_MIR1:
			rf2->x += (joyh >>2);
			rf2->y += (joyv >>2);
			da_set_2(0, rf2->x, 1, rf2->y);
			break;
		case JOYNARRAY_MIR2:
			rf2->x += (joyh >>2);
			rf2->y += (joyv >>2);
			da_set_2(2, rf2->x, 3, rf2->y);
			break;
 		case MIR2_RAMP:  
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			rf2->x, rf2->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
		case MIR1_RAMP:
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			rf2->x, rf2->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
	}	
	}/*IF rf2flag*/
        if ((jmp1cueflag != NO) || (jmp2cueflag != NO) || (fixjmpcueflag != NO)) {
	switch (cue->control) {
		case MCSTHRESH:
		case THRESHOLD:
			for (i = 0; i < cue->objectNumber; i++) {
				if ((cue->obj[i].thlink) != 0) {
					switch (cue->thresh[cue->falsereward].tp1) {
					case 1:
						cue->obj[i].x = cue->thresh[cue->falsereward].tv1;
						break;
					case 2:
						cue->obj[i].y = cue->thresh[cue->falsereward].tv1;
						break;
					case 3:
						cue->obj[i].fgr = cue->thresh[cue->falsereward].tv1;
						cue->obj[i].fgg = cue->thresh[cue->falsereward].tv1;
						cue->obj[i].fgb = cue->thresh[cue->falsereward].tv1;
						break;
					case 4:
						cue->obj[i].pattern = cue->thresh[cue->falsereward].tv1;
						break;
					case 5:
						cue->obj[i].checksize = cue->thresh[cue->falsereward].tv1;
						break;
					}; /*switch tp1*/
					
					switch (cue->thresh[cue->falsereward].tp2) {
					case 1:
						cue->obj[i].x = cue->thresh[cue->falsereward].tv2;
						break;
					case 2:
						cue->obj[i].y = cue->thresh[cue->falsereward].tv2;
						break;
					case 3:
						cue->obj[i].fgr = cue->thresh[cue->falsereward].tv2;
						cue->obj[i].fgg = cue->thresh[cue->falsereward].tv2;
						cue->obj[i].fgb = cue->thresh[cue->falsereward].tv2;
						break;
					case 4:
						cue->obj[i].pattern = cue->thresh[cue->falsereward].tv2;
						break;
					case 5:
						cue->obj[i].checksize = cue->thresh[cue->falsereward].tv2;
						break;
					}; /*switch tp1*/
	
				} /* If thlink != 0 */
				object[cue->object[i]] = cue->obj[i];
				objectStack[vexObjectFlag++] = cue->object[i];	
			} /*for i ..cue-Objectnumber*/
			break;
		case VEXBACKGROUND:
		case VEXBACKOFF:
			cue->object[0] = background[cue->background].object[0]+1;
			object[cue->object[0]].x = cue->x;
			object[cue->object[0]].y = cue->y;
			locateStack[vexLocateFlag++] = cue->object[0];
			break;
		case VEXSTATIC:
			cue->obj[0].x = cue->x = joyh >> 2;
			cue->obj[0].y = cue->y = joyv >> 2;
		case VEXARRAY:
			object[cue->object[0]] = cue->obj[0];
			objectStack[vexObjectFlag++] = cue->object[0];
		case VEXJOY:
		case NOMIRROR:
			break;
		case MIR1_ARRAY:
			da_set_2(0, cue->x, 1, cue->y);
			break;
		case MIR1_STATIC:
			cue->x = joyh>>2;
			cue->y = joyv>>2;
			da_set_2(0, cue->x, 1, cue->y);
			break;
		case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			break;
		case MIR2_ARRAY:
			da_set_2(2, cue->x, 3, cue->y);
			break;
		case MIR2_STATIC:
			cue->x = joyh>>2;
			cue->y = joyv>>2;
			da_set_2(2, cue->x, 3, cue->y);
			break;
		case MIR2_JOY:
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y, 0);
			break;
		case JOYNARRAY_MIR1:
			cue->x += (joyh >>2);
			cue->y += (joyv >>2);
			da_set_2(0, cue->x, 1, cue->y);
			break;
		case JOYNARRAY_MIR2:
			cue->x += (joyh >>2);
			cue->y += (joyv >>2);
			da_set_2(2, cue->x, 3, cue->y);
			break;
 		case MIR2_RAMP:  
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			cue->x, cue->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
		case MIR1_RAMP:
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			cue->x, cue->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
	} /* switch */	
	}/*IF cueflag*/
        if ((jmp1cue2flag != NO) || (jmp2cue2flag != NO)) {
	switch (cue2->control) {
		case VEXBACKGROUND:
		case VEXBACKOFF:
			cue2->object[0] = background[cue2->background].object[0]+1;
			object[cue2->object[0]].x = cue2->x;
			object[cue2->object[0]].y = cue2->y;
			if(kluge_cue2flag)
				locateStack[vexLocateFlag++] = cue2->object[0];
			break;
		case VEXSTATIC:
			cue2->x = joyh >> 2;
			cue2->y = joyv >> 2;
		case VEXARRAY:
			object[cue2->object[0]].x = cue2->x;
			object[cue2->object[0]].y = cue2->y;
			if(kluge_cue2flag)
				locateStack[vexLocateFlag++] = cue2->object[0];
		case VEXJOY:
		case NOMIRROR:
			break;
		case MIR1_ARRAY:
			da_set_2(0, cue2->x, 1, cue2->y);
			break;
		case MIR1_STATIC:
			cue2->x = joyh>>2;
			cue2->y = joyv>>2;
			da_set_2(0, cue2->x, 1, cue2->y);
			break;
		case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			break;
		case MIR2_ARRAY:
			da_set_2(2, cue2->x, 3, cue2->y);
			break;
		case MIR2_STATIC:
			cue2->x = joyh>>2;
			cue2->y = joyv>>2;
			da_set_2(2, cue2->x, 3, cue2->y);
			break;
		case MIR2_JOY:
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y, 0);
			break;
		case JOYNARRAY_MIR1:
			cue2->x += (joyh >>2);
			cue2->y += (joyv >>2);
			da_set_2(0, cue2->x, 1, cue2->y);
			break;
		case JOYNARRAY_MIR2:
			cue2->x += (joyh >>2);
			cue2->y += (joyv >>2);
			da_set_2(2, cue2->x, 3, cue2->y);
			break;
 		case MIR2_RAMP:  
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			cue2->x, cue2->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
		case MIR1_RAMP:
			ra_new(0,rmp->x, rmp->y, rmp->delay,
			cue2->x, cue2->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			ra_tostart(0);
			break;
	}	

	}/*IF cue2flag*/
	
/*	dprintf("%d\n",array.array_index);
	dprintf("%d\n",rf->obj[0].pattern);
	dprintf("%d\n",baroffflag);*/
	
	
	return(j);
}


int dimStuff() {
	int j;
	long code = DIMCD;
 
	if (barflag == 0) return(0);
	j = code;
	return(j);
}

int setlocal_cueflag()
{
    local_cueflag = YES;
    return(0);
}

int jmp1delayStuff()
{

double r;
int z,j;  

    	   if (jRandFlag==2) {
	   r=((double)rand()/(double)(RAND_MAX+1));  
	   curNumJmp1s=(int)(r*(NumJmp1s+1));  /*M is in range 0 to NumJmp1s*/
	   }
	   if(jRandFlag==1) curNumJmp1s=NumJmp1s;
	   if (jRandFlag==0) curNumJmp1s=1;
	   
	   if (jRandFlag!=0) {
	   if (MaxJmp1Size%2==0) MaxJmp1Size ++ ;

/*	   dprintf("NumJmp1s is %d\n",NumJmp1s);
	   dprintf("curNumJmp1s is %d\n",curNumJmp1s);
	   dprintf("JRandFlag is %d\n",jRandFlag);
	   dprintf("MaxJmp1Size is %d\n",MaxJmp1Size);
	   */
	   
if(epmenuflag!=1){
	   for(j=0;j<curNumJmp1s;j++) /*temporrary for testing*/
	   {
	   r=((double)rand()/(double)(RAND_MAX+1));  
	   randXArr[j]=(int)(r*(MaxJmp1Size))-(MaxJmp1Size-1)/2;
	   r=((double)rand()/(double)(RAND_MAX+1));  
	   randYArr[j]=(int)(r*(MaxJmp1Size))-(MaxJmp1Size-1)/2;
	   }
	      
	      
}
	   }

	local_jmp1Flag = NO;
	return(0);


}

int gap1Stuff() {
/*sets up stimulus for jmp1, having turned off current fp*/
	int j;
	long code =  GAP1CD; /*NB This will be set in turnitoffstuff */
	
	if ((jRandFlag!=0) && (curNumJmp1s==0)) jRandOver=1;
	if (jRandFlag==0) jRandOver=0;
	
/*	if(beepFlag) dio_off(beepDevice);
**		This is OLD beepFlag stuff. NEW beepFlag is fix break.
*/
	j = code;
	/*now set desired saccade*/
	if ((fp-> control == VEXJOY || 
	   fp->control == MIR1_JOY) || (fp->control == MIR2_JOY)) {
		hormov1 = jmp1->x - (joyh >> 2);
		vermov1 = jmp1->y - (joyv >> 2);
	}
	else {
		hormov1 = jmp1->x - fp->x;
		vermov1 = jmp1->y - fp->y;
	} /*if jmp1->control is not a vex control*/

if(vexclean==0){
        switch (jmp1->control) {
	    case NOMIRROR:
			break;
	    case MIR1_ARRAY:
			da_set_2(0, jmp1->x, 1, jmp1->y);
			break;
	    case MIR1_STATIC:
			jmp1->x = joyh>>2;
			jmp1->y = joyv>>2;
			da_set_2(0, jmp1->x, 1, jmp1->y);
			break;
	    case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			break;
	    case MIR2_ARRAY:
			da_set_2(2, jmp1->x, 3, jmp1->y);
			break;
	    case MIR2_STATIC:
			jmp1->x = joyh>>2;
			jmp1->y = joyv>>2;
			da_set_2(2, jmp1->x, 3, jmp1->y);
			break;
	    case MIR2_JOY:
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y, 0);
			break;
	    case JOYNARRAY_MIR1:
			jmp1->x += (joyh >>2);
			jmp1->y += (joyv >>2);
			da_set_2(0, jmp1->x, 1, jmp1->y);
			break;
	    case JOYNARRAY_MIR2:
			jmp1->x += (joyh >>2);
			jmp1->y += (joyv >>2);
			da_set_2(2, jmp1->x, 3, jmp1->y);
			break;
	    case MIR2_RAMP:  
			ra_new(0,rmp->x, rmp->y, rmp->delay,
				jmp1->x, jmp1->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			da_cntrl_2(2, DA_RAMP_X, 0, 3, DA_RAMP_Y, 0);
			break;
	    case MIR1_RAMP:
			ra_new(0,rmp->x, rmp->y, rmp->delay,
				jmp1->x, jmp1->y, 0, rmp->control);
			da_cntrl_2(0, DA_RAMP_X, 0, 1, DA_RAMP_Y, 0);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			break;
        }} /*switch*/


/*  Turn off FP in turnitoff loop. Default set zero msec
 *	if (fp->interface == TV) {
 *		vexOffFlag |= VEXCURRENT;
 *	        vexCode[vexCodeCount++] = j; *code buffer, loaded when
 * 	                                  *vertical refresh happens*
 *	        j = 0; *so when we return we do not drop a code*
 *	}
 *	if (fp->interface == BLUEBOX) 
 *	    dio_off(fp->device);
 */

	fpoffFlag = YES; fpgoneoff=YES;
	local_window_delay = window_delay;
	return(0);
}

turnitoffStuff() {
	int j;
	long code =  GAP1CD;
	
	j = code;

/*now turn off fixation device*/
#ifdef VEX

	if (fp->interface == TV) {
		vexOffFlag |= VEXFP;
/*		dprintf("%s\n","ask fp off");*/ askfpoff=1;
	        vexCode[vexCodeCount++] = j; /*code buffer, loaded when
 	                                  *vertical refresh happens*/ 
	        j = 0; /*so when we return we do not drop a code*/
	}
	if (fp->interface == BLUEBOX) 
#endif
	    dio_off(fp->device);
	fpoffFlag = NO;
	gap1nowFlag = YES; /*Hey world, the FP is now off */
	return(j);
}


int jmp1onStuff() {
	int j = 0;
	long code = JMP1CD;
	   
	if (jRandFlag>0)  {
	
	   if(jRandINDEX==0) {current=jmp1;
	   jRandEndFlag=NO;
	   
	   object[jmp1->object_dim].x=randXArr[curNumJmp1s-1];
	   object[jmp1->object_dim].y=randYArr[curNumJmp1s-1];
	   fixCurrentDim(jmp1); 
/*	   locateStack[vexLocateFlag++]=jmp1->object_dim; */
	   	   
	   } 
	   
	   jmp1->obj[0].x = randXArr[jRandINDEX];
	   jmp1->obj[0].y = randYArr[jRandINDEX];
	   jmp1->x = jmp1->obj[0].x;
	   jmp1->y = jmp1->obj[0].y;
	   object[jmp1->object[0]].x=randXArr[jRandINDEX];
	   object[jmp1->object[0]].y=randYArr[jRandINDEX];
	   locateStack[vexLocateFlag++]=jmp1->object[0];
	   
/*	   dprintf("jrand index is%d\n",jRandINDEX); */
	   if (jRandINDEX == (curNumJmp1s-1) || curNumJmp1s==0) jRandEndFlag=YES;
	   /* NumJmp1s==0 is superfluous probably, because : see gap1stuff -s.*/
	   
	   } /* completes the loop for if jrand flag is set. */

	   else 
	   
	   {current=jmp1; fixCurrentDim(jmp1);} 

/*	   dprintf("Jmp1x, Jmp1y:  %d\t%d\n",jmp1->obj[0].x,jmp1->obj[0].y); */


        local_backon1flag = backon1flag;
   startacquire=YES;
	if (vexJoyFlag == VEXFP) vexJoyFlag = 0;

	if (grassflag == YES) local_grassflag = YES;
	jmp1NowFlag = YES; /*signal the world that the jump interval is on*/
	r_jmp1NowFlag = YES; /* setting the random version of jmp1NowFlag as well*/
	sac1Flag = YES;   /*signal that we are waiting for the jmp1 saccade*/
	local_jmp2Sacflag = jmp2Sacflag; 

if(vexclean==0|reflexive_sipercentage>0){

if ((jmp1->control == MIR1_RAMP) || (jmp1->control == MIR2_RAMP))
		local_window_delay = ramp_window_delay;
  	else
		local_window_delay = window_delay;
	if ((local_backon1flag & (B_DOUBLEJUMP | B_GOODSAC | B_WINDOW)) == NO) {
	   if (jmp1->interface == BLUEBOX) {
		j = code;
		if (current->device != 0) dio_on(current->device);	/* turn on LED */
	/* if there is a ramp, then move the LED
	 * 	ra_start with a 0 gives the mirrors a 40ms settling pause
	 *	change to 1 to remove settling pause
	 */
	   if ((jmp1->control == MIR1_RAMP) || (jmp1->control == MIR2_RAMP))
		ra_start(0,0,current->device); 
  	   } /*if interface == BLUEBOX*/
	   else {

		switch (jmp1->control) {
		case NOMIRROR:
			docode=NO;
			break; /*remove code if there is no stim */	 
		case VEXARRAY:
		case VEXSTATIC:
		case VEXBACKGROUND:
		case VEXCUE:
		case VEXCUE2:
		case VEXBACKOFF:
			vexOnFlag |= VEXJMP1;
			vexCancelFlag |= VEXJMP1;
			break;
		case VEXJOY:
			vexOnFlag |= VEXJMP1JOY;
			break;
		}

		if (docode==YES) {
			j = code;
			vexCode[vexCodeCount++] = j; /*code buffer, loaded when 
						    VEX says stimulus is on */
			j = 0;
		} /* if docode */    
		else docode = YES;

	    } /*else*/
	}}
	   current=jmp1; fixCurrentDim(jmp1);
	   return(j); /*j zero if VEX*/

	   }
 
int jmp1offStuff() {
	int j;
	long code = JMP1OFFCD;	

	sacCheckFlag = NO;
	if(jRandFlag>0) {
	jmp1WinNowFlag = NO;
	jmp1timer=50;
	r_jmp1NowFlag=NO;
	r_jmp1WinShiftFlag=YES; 
	jRandINDEX=jRandINDEX+1;

	if (YES && jRandEndFlag) jRandOver=1;

	}

/*this action just turns off jump1light*/
	j = code;

if(vexclean==0|reflexive_sipercentage>0){
if (jmp1->interface == BLUEBOX) {
		if (current->device != 0) dio_off(current->device);
		if (current->device_dim != 0) dio_off(current->device_dim);
	}
	else { /*device is TV*/

		switch (jmp1->control) {
		case NOMIRROR:
			docode=NO;
			break; /*Remove code if there is no stim */	 
		case VEXARRAY:
		case VEXSTATIC:
		case VEXBACKGROUND:
		case VEXCUE:
		case VEXCUE2:
		case VEXBACKOFF:
		     if((jRandFlag>0 && jRandOver!=1) || jRandFlag==0) {
			vexOffFlag |= VEXJMP1;
			break;	   }
		case VEXJOY:
		     if((jRandFlag>0 && jRandOver!=1) || jRandFlag==0) {
		     vexOffFlag |= VEXJMP1JOY;
			break; }
		}

		if (docode==YES) {
			vexCode[vexCodeCount++] = j; /*code buffer, loaded when 
						    VEX says stimulus is on */
			j = 0;
		} /* if docode */
		else docode = YES;

	}
} else j=0;


return(j); /*either 0 or JMP1OFFCD*/

}

int jmp1WinCheck()
{
	if (jmp1NowFlag == YES) return(NO);
	if (jmp2Flag == NO) return(NO);
	if (jmp1NowFlag == NO) {
		if (eyewinCheck(jmp1->windowx,jmp1->windowy,
			jmp1->x,jmp1->y) == NO) return(NO);
	}	
/*	dprintf("%s\n","returning yes");*/
	return (YES);
}

int jmp1WinStuff()
{

r_jmp1WinShiftFlag=NO;

/*set window sizes if appropriate*/
/*default is to set window from array, but jmp1->windows must be set*/
	if ((jmp1->windowx !=0 ) && (jmp1->windowy != 0)){ 
	        wd_siz(0, (long)jmp1->windowx, (long)jmp1->windowy);
	        wd_siz(1, (long)jmp1->windowx, (long)jmp1->windowy);
         }
/*
	if ((jmp2->windowx !=0 ) && (jmp2->windowy != 0)){ 
	        wd_siz(2, (long)jmp2->windowx, (long)jmp2->windowy);
         }
*/
/*now set window delay*/

	if (jmp1->control != MIR1_RAMP)
		local_window_delay = window_delay;
	else
		local_window_delay = ramp_window_delay;

/*now set window location for jmp targets according to control flag*/
	switch (jmp1->control) {
		case NOMIRROR:
		case MIR1_ARRAY:
		case MIR1_STATIC:
		case MIR2_ARRAY:
		case JOYNARRAY_MIR1:
		case MIR2_STATIC:
		case JOYNARRAY_MIR2:
		case VEXARRAY:
		case VEXSTATIC: /*I have changed jmp1->x,y to jmp1->obj[0].x,y... JB062601*/
			wd_src_pos(0, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(0, (long)jmp1->obj[0].x, (long)jmp1->obj[0].y);
			wd_src_pos(1, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(1, (long)jmp1->obj[0].x, (long)jmp1->obj[0].y);
			wd_src_pos(2, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(2, (long)jmp1->x, (long)jmp1->y);
			wd_pos(3, (long)jmp1->x, (long)jmp1->y);
			break;
		case VEXJOY:
		case MIR1_JOY:
		case MIR2_JOY:
			wd_src_pos(0, WD_JOY_X, 0, WD_JOY_Y, 0);
			break;
		case MIR1_RAMP: 
		case MIR2_RAMP: 
			wd_src_pos(0, WD_RAMP_X, 0, WD_RAMP_Y, 0);
			break;
		case VEXCUE:
		case VEXBACKGROUND:
		case VEXBACKOFF:
			wd_src_pos(0, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(0, (long)background[cue->background].bgobj[0].x, 
				  (long)background[cue->background].bgobj[0].y );
			wd_src_pos(1, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(1, (long)background[cue->background].bgobj[0].x, 
				  (long)background[cue->background].bgobj[0].y );
			wd_src_pos(2, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(2, (long)background[cue->background].bgobj[0].x, 
				  (long)background[cue->background].bgobj[0].y );
			wd_pos(3, (long)background[cue->background].bgobj[0].x, 
				  (long)background[cue->background].bgobj[0].y );
		case VEXCUE2:
			wd_src_pos(0, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(0, (long)background[cue2->background].bgobj[0].x, 
				  (long)background[cue2->background].bgobj[0].y );
			wd_src_pos(1, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(1, (long)background[cue2->background].bgobj[0].x, 
				  (long)background[cue2->background].bgobj[0].y );
			wd_src_pos(2, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(2, (long)background[cue2->background].bgobj[0].x, 
				  (long)background[cue2->background].bgobj[0].y );
			wd_pos(3, (long)background[cue2->background].bgobj[0].x, 
				  (long)background[cue2->background].bgobj[0].y );
			break;
	}

	/* For jmp2Sacflag, we need to know when the window has moved before
	checking to see if monk has entered window. So I am using this flag */
	jmp1WinNowFlag = YES;
	jmp1timer=50;
	
	return(0);
}


int jmp2WinStuff()
{

/*set window size if appropriate*/
	if ((jmp2->windowx !=0 ) && (jmp2->windowy != 0)){ 
	        wd_siz(0, (long)jmp2->windowx, (long)jmp2->windowy);
	        wd_siz(2, (long)jmp2->windowx, (long)jmp2->windowy);
         }

	/*now set windows for jmp target according to control flag*/

	switch (jmp2->control) {
		case NOMIRROR:
		case MIR1_ARRAY:
		case MIR1_STATIC:
		case MIR2_ARRAY:
		case JOYNARRAY_MIR1:
		case MIR2_STATIC:
		case JOYNARRAY_MIR2:
		case VEXARRAY:
		case VEXSTATIC:
			wd_src_pos(0, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(0, (long)jmp2->x, (long)jmp2->y);
			wd_src_pos(2, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(2, (long)jmp2->x, (long)jmp2->y);
			wd_pos(3, (long)jmp2->x, (long)jmp2->y);
			break;
		case MIR1_JOY:
		case MIR2_JOY:
		case VEXJOY:
			wd_src_pos(0, WD_JOY_X, 0, WD_JOY_Y, 0);
			break;
		case MIR1_RAMP: 
		case MIR2_RAMP: 
			wd_src_pos(0, WD_RAMP_X, 0, WD_RAMP_Y, 0);
			break;
		case VEXCUE:
		case VEXBACKGROUND:
		case VEXBACKOFF:
			wd_src_pos(2, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(2, (long)background[cue->background].bgobj[0].x,
				  (long)background[cue->background].bgobj[0].y );
			wd_pos(3, (long)background[cue->background].bgobj[0].x,
				  (long)background[cue->background].bgobj[0].y );
		case VEXCUE2:
			wd_src_pos(2, WD_DIRPOS, 0, WD_DIRPOS, 0);
			wd_pos(2, (long)background[cue2->background].bgobj[0].x,
				  (long)background[cue2->background].bgobj[0].y );
			wd_pos(3, (long)background[cue2->background].bgobj[0].x,
				  (long)background[cue2->background].bgobj[0].y );
			break;
	}

	jmp2WinNowFlag = YES;

	return(0);
}


int gap2Stuff() {
	int j;
	long code =  GAP2CD;
	j = code;
	/*now set desired saccade*/
	hormov2 = jmp2->x - jmp1->x;
	vermov2 = jmp2->y - jmp1->y;
	/*now turn off old stimulus*/
	
/*	dprintf("%s\n","doing gap2");*/
	
	if(vexclean==0){
	if (jmp1->interface == BLUEBOX) {
/*	   if(beepFlag) dio_off(beepDevice);
**		This is OLD beepFlag stuff. NEW beepFlag is fix break.
/*
	   if (current->device != 0) {
		dio_off(current->device);
            }
	    else (dio_off(jmp1->device));
	}
	else if (jmp1->interface == TV) {
	   vexOffFlag |= VEXJMP1; /*turn off vexOffFlag*/
	   vexCode[vexCodeCount++] = (short int)j;/*register code for future drop*/
	   j = 0; /*don't drop code at end of function */
	}
/* now set mirror (VEX was set a fponStuff)*/
	
	    switch (jmp2->control) {
		case NOMIRROR:
			break;
		case MIR1_ARRAY:
			da_set_2(0, jmp2->x, 1, jmp2->y);
			break;
		case MIR1_STATIC:
			jmp2->x = joyh>>2;
			jmp2->y = joyv>>2;
			da_set_2(0, jmp2->x, 1, jmp2->y);
			break;
		case MIR1_JOY:
			da_cntrl_2(0, DA_JOY_X, 0, 1, DA_JOY_Y, 0);
			break;
		case MIR2_ARRAY:
			da_set_2(2, jmp2->x, 3, jmp2->y);
			break;
		case MIR2_STATIC:
			jmp2->x = joyh>>2;
			jmp2->y = joyv>>2;
			da_set_2(2, jmp2->x, 3, jmp2->y);
			break;
		case MIR2_JOY:
			da_cntrl_2(2, DA_JOY_X, 0, 3, DA_JOY_Y, 0);
			break;
		case JOYNARRAY_MIR1:
			jmp2->x += (joyh >>2);
			jmp2->y += (joyv >>2);
			da_set_2(0, jmp2->x, 1, jmp2->y);
			break;
		case JOYNARRAY_MIR2:
			jmp2->x += (joyh >>2);
			jmp2->y += (joyv >>2);
			da_set_2(2, jmp2->x, 3, jmp2->y);
			break;
		case MIR2_RAMP:  
			ra_new(0,rmp->x, rmp->y, rmp->delay,
				jmp2->x, jmp2->y, 0, rmp->control);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			da_cntrl_2(2, DA_RAMP_X, 0, 3, DA_RAMP_Y, 0);
			break;
		case MIR1_RAMP:
			ra_new(0,rmp->x, rmp->y, rmp->delay,
				jmp2->x, jmp2->y, 0, rmp->control);
			da_cntrl_2(0, DA_RAMP_X, 0, 1, DA_RAMP_Y, 0);
			/* reflects len,angle,vel,xoff,yoff,ecode,type */
			break;
	     } /*switch*/} else j=0;
	   return(j); /*no code now if TV*/
}

int jmp2onStuff() {
	int j;
	long code = JMP2CD;
	
/*	dprintf("%s\n","doing jmp2on");*/

	/*now set window delay*/

	if (jmp2->control != MIR1_RAMP)
		local_window_delay = window_delay;
	else
		local_window_delay = ramp_window_delay;

	local_jmpCheckDelay = jmpCheckDelay;
	j = code;
	current = jmp2;
	fixCurrentDim(jmp2);
	if ((backon2flag & B_DOUBLEJUMP) == 0) {
		jmp1NowFlag = NO;
		jmp2NowFlag = YES;
		sac1Flag = NO;
		sac2Flag = YES;
		local_backon2flag = backon2flag;

if(vexclean==0){
if (jmp2->interface == BLUEBOX) {

	/* turn on the grassflag at the beginning of saccade
	 * so extra stimuli can't occur
	 * Note that should not do such stimulation with tV
	 */ 
			if (grassflag2 == YES) local_grassflag = YES;
			if (current->device != 0) dio_on(current->device);
			return(j);
		}
		if (jmp2->interface == TV) {
	
			switch (jmp2->control) {
			case NOMIRROR:
				docode=NO;
				break; /*don't enter a code if there is no stim */	 
			case VEXARRAY:
			case VEXSTATIC:
			case VEXBACKGROUND:
			case VEXCUE:
			case VEXCUE2:
			case VEXBACKOFF:
				vexOnFlag |= VEXJMP2;
				break;
			case VEXJOY:
				vexOnFlag |= VEXJMP2JOY;
				break;
			}

			if (docode==YES) {
				vexCode[vexCodeCount++] = j; /*code buffer, loaded when 
							    VEX says stimulus is on */
				j = 0;
			} /* if docode */}
		else docode = YES;
		
}	} /*else do this at backon1On*/
	return(0);
}
 
int jmp2offStuff() {
	int j;
	long code = JMP2OFFCD;	
/*this action just turns off jump2light*/
	j = code;
	if(vexclean==0){
	if (jmp2->interface == BLUEBOX) {
		if (current->device != 0) dio_off(current->device);
		if (current->device_dim != 0) dio_off(current->device_dim);
	}
	else 
	{ /*device is TV*/
		switch (jmp2->control) {
		case NOMIRROR:
			docode=NO;
			break; /*don't enter a code if there is no stim */	 
		case VEXARRAY:
		case VEXSTATIC:
		case VEXBACKGROUND:
		case VEXCUE:
		case VEXCUE2:
		case VEXBACKOFF:
			vexOffFlag |= VEXJMP2;
			break;
		case VEXJOY:
			vexOffFlag |= VEXJMP2JOY;
			break;
		}
		if (docode==YES) {
			vexCode[vexCodeCount++] = j; /*code buffer, loaded when 
						    VEX says stimulus is on */
			j = 0;
		} /* if docode */
		else docode = YES;
	}}

	jmp2WinNowFlag = NO;

	return(j); /*either 0 or JMP2OFFCD*/

}

int grassonStuff() {
	local_grassflag = NO;
	rfgrassflag = NO;
	if (pulsenum == 0) {
		pulseFlag = NO;
	}
	else {
		dio_off(ampSwitch);
		pulseFlag = YES;
		localPulsenum = pulsenum;
	}
	return(0);
}

int grassZapStuff() {
	long code = GRASSONCD;
	int j;

	if (pulseFlag == YES) dio_on(grassDevice);
	localPulsenum -= 1;
	if (localPulsenum == 0) pulseFlag = NO;
	j = code;
	return(j);
}

int grassUnzapStuff() {
	long code = GRASSOFFCD;
	int j;

	dio_off(grassDevice);
	j = code;
	return(j);
}

int grassoffStuff() {
	dio_on(ampSwitch);
	if (grassFreebieFlag == YES) rewardflag = YES;
	return(0);
}

int rewardStuff() {
	int j;
	long code;

       if(showbuttOn==1) displaybutt();
   
	if (((humbutflag)&&(baroffflag != NO))&&(hyes==NO))
	    {
		code = ERRORCD;
		last[cfl] = 0;
		++cfl;
		if (count_first_twenty < 20) ++count_first_twenty;
		if (cfl >= 20) cfl = 0;
		goodFlag = NO;
		score(NO);
		}
	else if ((cuebarflag)&&(cueBarRelease == NO)&&(cue->falsereward >= minnoflash)) {

 	/* The following code acts as if the monk got the trial wrong. It does so 
	 *  for trials in which the bar was to be released during the trial, but 
	 *  it wasn't AND the threshold level was >= minnoflash (ie. we didn't want
	 *  the monkey to know he got it wrong). So we set the flag to NO so that the
	 *  performance stats and threshold levels can be set accordingly.  
	 */
	
		code = BARERR2CD;
		last[cfl] = 0;
		++cfl;
		if (count_first_twenty < 20) ++count_first_twenty;
		if (cfl >= 20) cfl = 0;
		goodFlag = NO;
		score(NO);
		rewardflag = YES; /* we give the reward anyway */	
	}
	else
	{
		code = RWCD;
		last[cfl] = 1;
		++cfl;
		if (count_first_twenty < 20) ++count_first_twenty;
		if (cfl >= 20) cfl = 0;

/*if (lefttrial==1&&go_time>0&&fin_time>0) {leftlatarray[leftind]=fin_time-go_time; 
		   dprintf("left latency %ld\n",leftlatarray[leftind]);
		   leftind++; if(leftind>9) leftind=0;
		}
		else if(lefttrial==0&&go_time>0&&fin_time>0) {rightlatarray[rightind]=fin_time-go_time; 
		   		   dprintf("right latency %ld\n",rightlatarray[rightind]);
		   rightind++; if(rightind>9) rightind=0;
		}*/
	   
	   
		score(YES);
		rewardflag = YES;	

		}

	hyes = NO;
	j = code;
	return(j);
} 

int reward1Stuff() 
{
	rewardflag = NO;
	if(whichreward==1) whichreward=0; else whichreward=1;
	cuebarrwd_flag = NO;
	dio_on(rewardDevice);
	return(0);
}


int FillRF(){
int i;
int maxrfobj;
   int localpattern;
   double aar;
   double aar1;
int randi;   
   
/*      int rfori;
   int rforinc;
   int rforinum;
   int rfstartpattern;
   int rfendpattern; */
   
 		if(rffillFlag==1){

		   localpattern=frfpattern;
		   
if(rfnums!=0) rf->objectNumber=rfnums;
   if (ttask_menuon==1) rf->objectNumber=ttask_stimnum;

	maxrfobj = rf->objectNumber;
				for (i = 0; i < maxrfobj; i++) {

if (frfopatternprob>0)	{			   
          aar=((double)rand()/(double)(RAND_MAX+1));  
   if(aar<=((double)frfopatternprob)/100) {
          aar1=((double)rand()/(double)(RAND_MAX+1));  
      if(aar1<=0.5) localpattern=frfopattern1; else localpattern=frfopattern2;
   
   } else localpattern=frfpattern;
   
   
} else localpattern=frfpattern;
				   
if (localpattern!=0) rf->obj[i].pattern=localpattern;
				   
if(localpattern==0) /* if pattern is zero, assume bar, and set length, width and orientation*/
	    {				   
	       rf->obj[i].mode=2;
	       

	       randi = (int)(rforinum*rand()/(RAND_MAX+1.0));      				   
	       rf->obj[i].var1=rfori+randi*rforinc;
	       randi = (int)(rfwidthnum*rand()/(RAND_MAX+1.0));      				   
	       rf->obj[i].var2=rfwidth+randi*rfwidthinc;
	       randi = (int)(rflengthnum*rand()/(RAND_MAX+1.0));      				   
	       rf->obj[i].var3=rflength+randi*rflengthinc;
					
	    }
				   
randi = (int)(rfchksizenum*rand()/(RAND_MAX+1.0));      				   
rf->obj[i].checksize=rfchksize+randi*rfchksizeinc;
object[rf->object[i]].checksize=rf->obj[i].checksize;
	
randi = (int)(rflumnum*rand()/(RAND_MAX+1.0));      				   				   
				   
rf->obj[i].fgr=rffgr+randi*rrfluminc;
rf->obj[i].fgg=rffgg+randi*grfluminc;
rf->obj[i].fgb=rffgb+randi*brfluminc;
				   
object[rf->object[i]].fgr=rf->obj[i].fgr;
object[rf->object[i]].fgb=rf->obj[i].fgb;
object[rf->object[i]].fgg=rf->obj[i].fgg;				   

object[rf->object[i]].pattern=localpattern;
				   
object[rf->object[i]].var1=rf->obj[i].var1;
object[rf->object[i]].var2=rf->obj[i].var2;				   
object[rf->object[i]].var3=rf->obj[i].var3;				   
				   
				} /* for i*/	
	       if(rforinum>1||rfwidthnum>1||rflengthnum>1||frfopatternprob>0||rfchksizenum>1||rflumnum>1) rfPropertiesChanged=1;
		
		}
   
   return(0);
}


int manyRFstuff(){

   		if(manyrfFlag==1){

		   srfdelay.preset=rfmap_rfdelay;
		   srfon.preset=rfmap_rftime;
		   sfpon.preset=rfmap_trialtime;
		   
		   
		   if(rfrandmap==1){

		      if ((rflocind>=rfnumlocs)||(shufflenowflag==1)) {
rfshuf();
}
	rf->x=rffar[rflocind].rfx; rf->y=rffar[rflocind].rfy;		      
		   } else{
		      rf->x=rfxarr[rfind];
	rf->y=rfyarr[rfind];
rfind++;
if(rfind>7) rfind=0;		      
		   }

	rf->obj[0].x=rf->x; rf->obj[0].y=rf->y;
	object[rf->object[0]].x=rf->x;
	object[rf->object[0]].y=rf->y;

		}
   return(0);
};


int ShowbuttStuff()
{
   
   int curbutt;
   int i;
   
/*this basically loads the butt image. display is taken care of in displaybutt*/
   
         if(showbuttOn==1) {

	    /*now finding pattern to display*/
	    
          i = (int)((Buttimagenum)*rand()/(RAND_MAX+1.0));	    
	 curbutt=Buttimagestart+i*Buttimageinc;
	    
	 object[ButtObject].x=0;
	 object[ButtObject].y=0;
	 object[ButtObject].mode=1;
	 object[ButtObject].pattern=curbutt;
	 objectStack[vexObjectFlag++]=ButtObject;

	 stiffdisplay.preset=Buttimagedur;
	   
      }

return(0);   
}

     
int ttaskStuff(){

   int i,j,current_odist,odist_range,
       tempbak,temptarget,indix,
       current_red, current_blue, current_green, current_pop, current_pat, 
       local_ttask_onet;
   int ax,bx,ay,by;
   
   double aar, aar1, justanotherrand, ang, startang, ecc;
   
   
   if (ttask_menuon==1){
      
/****************************************TIME*****************************************************/

         /*setting basic properties*/
      
      oneframemode=ttask_ofmode;
      vexclean=ttask_vexclean;
      rf->objectNumber=ttask_stimnum;

         /*duration variation*/
      
          i = (int)((ttask_tdurnum)*rand()/(RAND_MAX+1.0));
          srfon.preset=ttask_tdur+i*ttask_tdurinc;
	 
      /* catch (i.e. target absent) duration: so that monkey does not have to keep holding for 3 seconds or something*/

      if(ttask_tcatchprob>0){

         aar=((double)rand()/(double)(RAND_MAX+1));  

	 if(aar<((double)ttask_tcatchprob)/100) {

	    srfon.preset=ttask_tcatchdur;
	 
      }
      }
      
      /* if link rf to fp is on, then rf comes on 25 ms after fp goes off, and is within dim time*/
      
      if(linkrftofp==1) {

	  i = (int)((ttask_fpnum)*rand()/(RAND_MAX+1.0));
	 sfpon.preset=ttask_fpon+i*ttask_fpinc;
	 srfdelay.preset=sfpon.preset+25;
      }
      
      
             if(srfon.preset>=10&&oneframemode==1)
	{
	   dprintf("%s\n","Houston: changed oneframe mode cos duration is too long");
	   oneframemode=0; 
	}
      
      
/************************************************ENDOFTIME**************************************/
      
/*********************************** PATTERNS ETC ************************************************/      

      
      /* now set the target pattern etc */
      
      if(mygoodFlag==YES){     /*only switch if good trial: when error correct is operating*/

	 aar=((double)rand()/(double)(RAND_MAX+1));
      if(aar<=((double)ttask_tprob)/100)  /* UPRIGHT T */
	{current_pat=ttask_tpat; baroffflag=2;
	   current_red=ttask_tred; current_green=ttask_tgreen;
	   current_blue=ttask_tblue;
/*	   rf2flag=0;*/ /*for debugging only*/
	}
	 
      else  /* Inverted T */

	{current_pat=ttask_itpat; baroffflag=1;
	   current_red=ttask_itred; 
	   current_green=ttask_itgreen;
	   current_blue=ttask_itblue;
	   /*rf2flag=1;*/ /*for debugging only*/

	}
	
	 /*TARGET ABSENT TRIALS*/
	 
	 if(ttask_catchprob>0){
	       aar=((double)rand()/(double)(RAND_MAX+1));
      if(aar<=((double)ttask_catchprob)/100){  /*catch trial*/
	      current_pat=ttask_dpat;
	 baroffflag=3;
	 sdimon.preset=ttask_catchdimtime;
      }
	 } else sdimon.preset=ttask_dimtime;

	 /* SAVING PATTERN INFORMATION FOR ERROR CORRECT SITUTION*/
	 
	 t_oldpat=current_pat;
	 t_oldred=current_red;
	 t_oldgreen=current_green;
	 t_oldblue=current_blue;
	 t_oldflag=baroffflag;
	 
      } else 
	{
	   
	   /*ERROR CORRECT IN OPERATION: USING PREVIOUS TRIAL INFORMATION*/

	 current_pat=t_oldpat;
	 baroffflag=t_oldflag;
	 current_red=t_oldred;
	 current_green=t_oldgreen;
	 current_blue=t_oldblue;
	   
	}   /*END OF IF_ELSE LOOP STARTTING AT MYGOODFLAG==YES*/

/*************************************END OF PATTERNS*********************************************/
      
/******************* L O C A T I O N S **********************************************************/      
      
      /* setting rfx and rfy*/
      
      rf->x=ttask_x;
      rf->y=ttask_y;


       /* now calculate and set target location
       * target will always be object 0*/

      if(rf->objectNumber>1){  /* no point doing this unless >1 target*/

	 /*  T A R G E T      L O C A T I O N */
	 
	 i = (int)(ttask_targlocnum*rand()/(RAND_MAX+1.0));      
      temptarget=ttask_targlocstart+i*ttask_targlocinc;

	if(temptarget<rf->objectNumber) 
	  {
	startang=atan2(rf->y,rf->x);
      	ecc=sqrt( (double)rf->x*(double)rf->x + (double)rf->y*(double)rf->y );
        ang= startang+ temptarget * (2*PI)/(double)(rf->objectNumber);
	      rf->x=ecc*cos(ang);
	      rf->y=ecc*sin(ang); /* rf->x and rf->y have now been reset*/
	  }


	   /*SETTING OTHER LOCATIONS AROUND A CIRCLE*/
	   
	 for(indix=1;indix<rf->objectNumber;indix++) /*target (indix=0) filled separately*/
	   {
	      startang=atan2(rf->y,rf->x);
	      ecc=sqrt( (double)rf->x*(double)rf->x + (double)rf->y*(double)rf->y );
	      ang= startang+ indix* (2*PI)/(double)(rf->objectNumber);
	      rf->obj[indix].x=ecc*cos(ang);
	      rf->obj[indix].y=ecc*sin(ang);
	      rf->obj[indix].pattern=ttask_dpat;
	   }
      

	 /* IF T2X is in operation, setting second object to T2X,T2Y etc */
	   
	   
	 if(ttask_T2x<350)  
	   { 
	      	       
	      aar=((double)rand()/(double)(RAND_MAX+1));
	      
	      if(aar<=((double)ttask_prob)/100){ /*using ttask_prob*/
      ax=rf->x; ay=rf->y; bx=ttask_T2x; by=ttask_T2y;	
	      } else{
		       bx=rf->x; by=rf->y; ax=ttask_T2x; ay=ttask_T2y;	
	      }
	      
	      rf->obj[0].x=ax; rf->obj[0].y=ay;
	      rf->x=ax;	      rf->y=ay;
	      rf->obj[1].x=bx; rf->obj[1].y=by;

	   }
      
      
      }/*ending if(rf->objectNumber>1)/
      
      
      /*************************** END OF LOCATIONS ********************************************/
      
      /*ONE T OR NOT*/
      
      if(ttask_onetprob>0)
	{
	   justanotherrand=((double)rand()/(double)(RAND_MAX+1));  
	   if(justanotherrand<= ((double)ttask_onetprob)/100)
	     local_ttask_onet=1; 
	   else	
	     local_ttask_onet=0;
	} else local_ttask_onet=0;
      
      /* setting no. stimuli */
      
      if(local_ttask_onet==1) rf->objectNumber=1; 
            
      /* fill up the target pattern; remaining are filled according to rffill */

      rf->obj[0].x=rf->x; rf->obj[0].y=rf->y;
      rf->obj[0].pattern=current_pat;
      rf->obj[0].fgr=current_red;
      rf->obj[0].fgg=current_green;
      rf->obj[0].fgb=current_blue;

      /* setting odist patterns */
	 
      if(odist_prob>0)
	{  
	   odist_range=ttask_maxdpat-ttask_mindpat;
	   aar=((double)rand()/(double)(RAND_MAX+1));  
	   if(aar<=((double)odist_prob)/100) /*PICKING WHERE TO PLACE NOVEL DISTRACTOR*/
	                                     /*AND DECIDING WHICH NOVEL DISTRACTOR TO USE*/
	     {	
		i = (int)((odist_range+1)*rand()/(RAND_MAX+1.0));
		j = (int)(ttask_odistnum*rand()/(RAND_MAX+1.0));
		current_odist=ttask_odistart+j*ttask_odistnum;
		if(current_odist>(rf->objectNumber-1)) current_odist=1;
		rf->obj[current_odist].pattern=ttask_mindpat+i;
	     }
	}

      /* SET UP the POPOUT PROPERTIES */
      
	 /* now assign popout location */
      
      if(ttask_targpop==1) current_pop=0; /*target popout*/
	 else if (ttask_targpop==0) current_pop=-1;    /* no popout */
	 else if (ttask_targpop==2)                    /* distractor popout */
	                                               
	   {
	      if(local_ttask_onet!=1){ /* if one T, then cannot have a distractor popout condition */
      	i = (int)(ttask_poplocnum*rand()/(RAND_MAX+1.0)); /*popout location chosen at random*/
        current_pop=ttask_poplocstart+i*ttask_poplocinc;
	   } else current_pop=-1;
	      
	   }
      else current_pop=-1; /*no popout is the default if you set weird ttask_targpop*/
	 
      /* now set popout properties, and also if show all pop, use all target locations*/
      
        if(current_pop!=-1 & current_pop<rf->objectNumber) {
	    
	    if(ttask_showallpops!=1){ /*ONLY ONE POPOUT*/
	 	 rf->obj[current_pop].fgr=ttask_pred;
	 	 rf->obj[current_pop].fgg=ttask_pgreen;
	 	 rf->obj[current_pop].fgb=ttask_pblue;
	 }
       else {

	 for(i=0;i<ttask_poplocnum;i++){  /*MORE THAN ONE POPOUT*/
	    current_pop=ttask_poplocstart+i*ttask_poplocinc;
	    if(current_pop<rf->objectNumber){
	       	 rf->obj[current_pop].fgr=ttask_pred;
	 	 rf->obj[current_pop].fgg=ttask_pgreen;
	 	 rf->obj[current_pop].fgb=ttask_pblue;
	    }
	 }
	 
      } /* ending the else for showall pops*/
	 }/*ending the if(current_pop!=-1*/

      /*equating all the object properties*/
      
     for(indix=0;indix<rf->objectNumber;indix++){
	
	object[rf->object[indix]].fgr=rf->obj[indix].fgr;
	object[rf->object[indix]].fgg=rf->obj[indix].fgg;
     	object[rf->object[indix]].fgb=rf->obj[indix].fgb;
	object[rf->object[indix]].pattern=rf->obj[indix].pattern;
	object[rf->object[indix]].x=rf->obj[indix].x;
	object[rf->object[indix]].y=rf->obj[indix].y;
     }
      
   } /*if ttask_menuon==1*/

   tdistractorStuff(); /*calling tdistractor stuff; outside of ttaskmenu, probably unintended (!)*/
   return(0);
}

int remapStuff() {

   double aar;
   int i;
   int j;
   
   int newfpx=0; int newfpy=0; int newjumpx=0; int newjumpy=0;
   int newojumpx=0; int newojumpy=0; int newrfx=0; int newrfy=0;
   
   
   if (remap_menuon==1){
      
      
      /*handle FPx first*/

   newfpx=remap_fpx;
      
   if(remap_fpxnum<0){
      if(numlistfpxs>0){
	 i=(int)((double)(numlistfpxs)*(rand()/(RAND_MAX+1.0)));
	 newfpx=listfpx[i];
      } else dprintf("%s\n","No Can Do. FPx list not long enough");
   } 
      else if(remap_fpxnum>1){
      	i = (int)(remap_fpxnum*rand()/(RAND_MAX+1.0));
      newfpx=remap_fpx+i*remap_fpxinc;
      }
      
   /*handle FPy next*/
  
      newfpy=remap_fpy;

      if(remap_fpynum<0){
	 
         if(remap_fpxnum<0 && numlistfpxs>0 && numlistfpys>=numlistfpxs)
	   newfpy=listfpy[i]; /*linking to fpx*/
	 else if(numlistfpys>0){
	   i=(int)((double)(numlistfpys)*(rand()/(RAND_MAX+1.0)));
	   newfpy=listfpy[i];
	 }
	 else dprintf("%s\n","No Can Do. FPy list not long enough");
      } 
      else if (remap_fpynum>1) {
      	i = (int)(remap_fpynum*rand()/(RAND_MAX+1.0));
      newfpy=remap_fpx+i*remap_fpxinc;
      }

      /*setting fpx and fpy*/
      
   fp->obj[0].x=newfpx; object[fp->object[0]].x=newfpx; fp->x=newfpx;
   fp->obj[0].y=newfpy; object[fp->object[0]].y=newfpy; fp->y=newfpy;
   
      /*handling jumpx*/
      
   newjumpx=remap_jumpx;
      
   if(remap_jumpxnum<0){
      if(numlistjumpxs>0){
	 i=(int)((double)(numlistjumpxs)*(rand()/(RAND_MAX+1.0)));
	 newjumpx=listjumpx[i];
      } else dprintf("%s\n","No Can Do. jumpx list not long enough");
   } 
      else if(remap_jumpxnum>1){
      	i = (int)(remap_jumpxnum*rand()/(RAND_MAX+1.0));
      newjumpx=remap_jumpx+i*remap_jumpxinc;
      }
      
   /*handle jumpy next*/
  
      newjumpy=remap_jumpy;

      if(remap_jumpynum<0){
	 
         if(remap_jumpxnum<0 && numlistjumpxs>0 &&
numlistjumpys>=numlistjumpxs)
	   newjumpy=listjumpy[i]; /*linking to jumpx*/
	 else if(numlistjumpys>0){
	   i=(int)((double)(numlistjumpys)*(rand()/(RAND_MAX+1.0)));
	   newjumpy=listjumpy[i];
	 }
	 else dprintf("%s\n","No Can Do. jumpy list not long enough");
      } 
      else if (remap_jumpynum>1) {
      	i = (int)(remap_jumpynum*rand()/(RAND_MAX+1.0));
      newjumpy=remap_jumpx+i*remap_jumpxinc;
      }
      
      /* handling ojumps: no list here yet, so just use old*/      
      
   newojumpx=remap_ojumpx;
   newojumpy=remap_ojumpy;

               if(remap_ojumpxnum>1){
      	i = (int)(remap_ojumpxnum*rand()/(RAND_MAX+1.0));
      newojumpx=remap_ojumpx+i*remap_ojumpxinc;
   }
      if(remap_ojumpynum>1){
            	i = (int)(remap_ojumpynum*rand()/(RAND_MAX+1.0));
      newojumpy=remap_ojumpy+i*remap_ojumpyinc;
      }
      

      /* now setting rf2s to jump or ojump position*/
      
   aar=((double)rand()/(double)(RAND_MAX+1));  
   if(aar<=((double)remap_ojumprob)/100){
      rf2->x=newojumpx;
      rf2->y=newojumpy;
   } else {
      rf2->x=newjumpx;
      rf2->y=newjumpy;
   }

   rf2->obj[0].x=rf2->x; object[rf2->object[0]].x=rf2->x;
   rf2->obj[0].y=rf2->y; object[rf2->object[0]].y=rf2->y;
   jmp1->obj[0].x=rf2->x; object[jmp1->object[0]].x=rf2->x; jmp1->x=rf2->x;
   jmp1->obj[0].y=rf2->y; object[jmp1->object[0]].y=rf2->y; jmp1->y=rf2->y;
      


 /*rf2 duration randomization*/

   if(remap_rf2durinc>0){
   	i = (int)(remap_rf2durnum*rand()/(RAND_MAX+1.0));
   srf2on.preset=remap_rf2duration+remap_rf2durinc*i;
} else   srf2on.preset=remap_rf2duration;


/*finally doing rf*/
      
   newrfx=remap_rfx;
      
   if(remap_rfxnum<0){
      if(numlistrfxs>0){
	 i=(int)((double)(numlistrfxs)*(rand()/(RAND_MAX+1.0)));
	 newrfx=listrfx[i];

      } else dprintf("%s\n","No Can Do. rfx list not long enough");
   } 
      else if(remap_rfxnum>1){
      	i = (int)(remap_rfxnum*rand()/(RAND_MAX+1.0));
      newrfx=remap_rfx+i*remap_rfxinc;
      }
      
   /*handle rfy next*/
  
      newrfy=remap_rfy;

      if(remap_rfynum<0){
	 
         if(remap_rfxnum<0 && numlistrfxs>0 && numlistrfys>=numlistrfxs)
{	   newrfy=listrfy[i]; /*linking to rfx*/
/*	   	 dprintf("rfy= %d\n",newrfy);*/
		 }
	 else if(numlistrfys>0){
	   i=(int)((double)(numlistrfys)*(rand()/(RAND_MAX+1.0)));
	   newrfy=listrfy[i];

	 }
	 else dprintf("%s\n","No Can Do. rfy list not long enough");
      } 
      else if (remap_rfynum>1) {
      	i = (int)(remap_rfynum*rand()/(RAND_MAX+1.0));
      newrfy=remap_rfy+i*remap_rfyinc;
      }
      
   /*setting rf values*/
      
      rf->x=newrfx; rf->y=newrfy;
      rf->obj[0].x=rf->x; rf->obj[0].y=rf->y;
      object[rf->object[0]].x=rf->x; 
      object[rf->object[0]].y=rf->y;
/*	 dprintf("rfx= %d\n",newrfx);
	 dprintf("rfy= %d\n",newrfy);*/
		 
      /* rf or blank trial ?*/
      
   aar=((double)rand()/(double)(RAND_MAX+1));  
   if(aar<=(((double)remap_blankprob)/100)){
    rfflag=0;  
   }else rfflag=1;
      
      /*reflexive or NOT: hack assumes that turning on jmp on top of rf2 wont be visible*/

      if(reflexive_sipercentage>0){
         aar=((double)rand()/(double)(RAND_MAX+1));  
   if(aar<=(((double)reflexive_sipercentage)/100)){
    rf2flag=0;  
   }else rf2flag=1;
      }


/*if(srfon.preset>20) {oneframemode=0; vexclean=0;} *//*arbitrary resetting hack
here*/

      /* jump delay randomization*/
      
	i = (int)(remap_jumpdelay_num*rand()/(RAND_MAX+1.0));
sjmp1delay.preset=remap_jumpdelay+i*remap_jumpdelay_inc;

/*   sjmp1delay.preset=remap_jumpdelay;*/
   sfpon.preset=remap_trialtime+i*remap_jumpdelay_inc; /*changing trial time
   						       if jump delayed*/

	j = (int)(rftimenum*rand()/(RAND_MAX+1.0));
srfdelay.preset=rftimeinit+j*rftimeinc+i*remap_jumpdelay_inc;		       /*changing rfon time
						       if jump delayed*/

      srfon.preset=rfduration; /*wow on 5th may 2006, fixing this !!!*/
      oneframemode=remap_ofmode;
      vexclean=remap_vexclean;
      
      sjmp1on.preset=remap_jumptime;
      window_delay=remap_windowdelay; /*state menu will change too*/
      
      
      
      if(infowarn==1) {
	 dprintf("Jump Delay  %d\t",sjmp1delay.preset);
	 dprintf("RF Delay  %d\t",srfdelay.preset);
	 dprintf("Jump Time  %d\t",sjmp1on.preset);
	 dprintf("Trial Time  %d\n",sfpon.preset);
	 if (photowarn!=1) dprintf("%s\n","Photowarn is off");

      }
   }
   return(0);
}

int twospotOnceStuff(){

   if(twospotmenuflag==1){
   
      rf2->x=twospot_rf2x;
      rf2->y=twospot_rf2y;
      object[rf2->object[0]].x=rf2->x;
      object[rf2->object[0]].y=rf2->y;
      rf2->obj[0].x=rf2->x;
      rf2->obj[0].y=rf2->y;
    
      srf2on.preset=twospot_rf2on;


      rf2->obj[0].pattern=twospot_rf2pat;
      rf2->obj[0].checksize=twospot_rf2check;
      rf2->obj[0].fgr=twospot_rf2fgr;
      rf2->obj[0].fgg=twospot_rf2fgg;
      rf2->obj[0].fgb=twospot_rf2fgb;      

      object[rf2->object[0]].pattern=rf2->obj[0].pattern;
      object[rf2->object[0]].checksize=rf2->obj[0].checksize;
      object[rf2->object[0]].fgr=rf2->obj[0].fgr;
      object[rf2->object[0]].fgg=rf2->obj[0].fgg;
      object[rf2->object[0]].fgb=rf2->obj[0].fgb;
      
   }
  return(0);
   
};

int twospotRepStuff(){
   
   double aar;
   int i;
   
   if(twospotmenuflag==1){

           	i = (int)(twospot_rf2num*rand()/(RAND_MAX+1.0));
   srf2delay.preset=srfdelay.preset+(twospot_rf2lat+twospot_rf2inc*i);
      if(srf2delay.preset<=0) {srf2delay.preset=100;
	 dprintf("%s\n","hello ????");
      }
		 
      
       aar=((double)rand()/(double)(RAND_MAX+1));  
      
      if(rf->obj[0].checksize!=0) twospot_rfbakcheck=rf->obj[0].checksize;
      
      if(aar<= ( (double)twospot_rfblankprob)/100.0 ) {
	 
	 rf->obj[0].checksize=0;
	 object[rf->object[0]].checksize=0;
	 
      } else{
   rf->obj[0].checksize=twospot_rfbakcheck;
   object[rf->object[0]].checksize=twospot_rfbakcheck;
      }
	
      
   }
  return(0); 
};


 int mgsStuff() {
   double ang,aar;
int i; int i1;
    int current_ecc;
    int current_fpx; int current_fpy;
      	
   if(mgsmenuflag==1) {
      
      if(mgsrand==1 && mygoodFlag==YES){

        	i = (int)(mgsnum*rand()/(RAND_MAX+1.0));
	ang=((double)(mgstart+i*mgsinc)/360)*2*PI;
	 
	      	i = (int)(mgseccnum*rand()/(RAND_MAX+1.0));
	 	current_ecc=mgsecc+mgseccinc*i;
	 
	rf->x=current_ecc*cos(ang);
	rf->y=current_ecc*sin(ang);
	oldrfx=rf->x;
	oldrfy=rf->y;


      } else if(mgsrand==0) {
	 rf->x=mgsrfx;
	 rf->y=mgsrfy;

      } else if(mygoodFlag==NO) {
      if(oldrfx==0&&oldrfy==0){oldrfx=mgsrfx; oldrfy=mgsrfy;}
      rf->x=oldrfx;
      rf->y=oldrfy;

      
      }
      
      
	object[rf->object[0]].x=rf->x;
	object[rf->object[0]].y=rf->y;
	rf->obj[0].x=rf->x;
	rf->obj[0].y=rf->y;
	

	jmp1->x=rf->x;
	jmp1->y=rf->y;
	jmp1->obj[0].x=rf->x;
	jmp1->obj[0].y=rf->y;
      
/*dprintf("%d\n",arrayIndex);
      dprintf("%d\n",rf->x);*/
	      
	      sjmp1delay.preset=mgsj1delay;
      sjmp1on.preset=mgsj1time;
      sfpon.preset=mgsj1delay+mgsj1time-50;
      srfdelay.preset=mgsrfdelay;
      
      	      	i = (int)(mgsrftimenum*rand()/(RAND_MAX+1.0));
      srfon.preset=mgsrftime+i*mgsrftimeinc;
      
      if(mgspercentage<100){
	   aar=((double)rand()/(double)(RAND_MAX+1));  
	   if(aar>((double)mgspercentage)/100)
	      srfon.preset=8000; /*hack 8000 is assume to be a BIG number, longer than any fpontime*/
      }

      rfflag=1;
      jmp1Flag=1;
   
      if (mgsfpxnum>1||mgsfpynum>1)
	{
	   	      	i = (int)(mgsfpxnum*rand()/(RAND_MAX+1.0));
	 	current_fpx=mgsfpx+mgsfpxinc*i;
	   	   	      	i1 = (int)(mgsfpynum*rand()/(RAND_MAX+1.0));
	 	current_fpy=mgsfpy+mgsfpyinc*i1;
	   
	   fp->obj[0].x=current_fpx;
	   fp->obj[0].y=current_fpy;
	   fp->x=fp->obj[0].x;
	   fp->y=fp->obj[0].y;
	   object[fp->object[0]].x=fp->x;
	   object[fp->object[0]].y=fp->y;
	   
	   if(fprelflag==1){
	 
	 rf->x=rf->x+i*mgsfpxinc;
	 rf->y=rf->y+i*mgsfpyinc;
	   rf->obj[0].x=rf->x; 
	   object[rf->object[0]].x=rf->x;
	   	   rf->obj[0].y=rf->y; 
	   object[rf->object[0]].y=rf->y;
	   
	   }
	  
	}
      
   }
    
		   return(0);		
 }



   int infowarnMe(){
      
      if(infowarn==1){

   if(oneframemode==1 && (srfon.preset>10||vexclean!=1)){
	   dprintf("%s\n","Oneframemode with long RF/novexclean !!");
	      oneframemode=0; vexclean=0;
   }

/*      	 dprintf("RFx %d\t",rf->x);
	 dprintf("RFy %d\t",rf->y);
	 dprintf("RFFlag %d\t",rfflag);
	 	 dprintf("J1x %d\t",rf->x);
	 dprintf("J1y %d\n",rf->y);*/

      }
      return(0);
   }
   
int tdistractorStuff(){

  int i; int ii; int iii; int iv;
   double aar; 
   double rf2posrand;
   int rf2_hasbeen_set;
   int local_rf2;
   int tempvar; int tempvar2; 
   
   
   if (tdistractorMenu==1){

      /*setting RF2 duration*/
      
      srf2on.preset=tdistractorRF2on;

      /*randomizes RF2dur */
            if(tdistractorRF2onnum>1)

	{
	   i = (int)(tdistractorRF2onnum*rand()/(RAND_MAX+1.0));      
	   srf2on.preset=tdistractorRF2on+tdistractorRF2oninc*i;
	}
      
     
     
 /*if you want to fix either the time of the distractor, or the t */
     /*  fix rf2 wrt rf */
      if(fixrf2_wrt_rf==0){

	  srf2delay.preset=tdistractorRF2lat;
	  rf2_hasbeen_set=0;
	 
      /*randomizes RF2delay */
      if(tdistractorRF2latnum>1)
	{
      ii = (int)(tdistractorRF2latnum*rand()/(RAND_MAX+1.0));      
      tempvar= srf2delay.preset + ii*tdistractorRF2latinc; /*RF2lat can be negative*/
      if(tempvar>0) srf2delay.preset=tempvar;
      else {srf2delay.preset=100;
      }
	}

       srfdelay.preset=tdistractorRFdelay;
      /*randomizes RFdelay*/
      if(tdistractorRFlatnum>1){
      iii = (int)(tdistractorRFlatnum*rand()/(RAND_MAX+1.0));      
      tempvar2= srfdelay.preset + srf2delay.preset + iii*tdistractorRFlatinc; 
      if(tempvar2>0) srfdelay.preset=tempvar2;
      else {srfdelay.preset=400;
	 
      }
      }
      }
    /* if you want to set RF2 time based on fixed RFon time */  
      if(fixrf2_wrt_rf==1){

	   srfdelay.preset=tdistractorRFdelay;
      /*randomizes RF2delay */


	 if(tdistractorRF2latnum>1&tdistractorRF2lat<0)
	{   
      iv = (int)(tdistractorRF2latnum*rand()/(RAND_MAX+1.0));      
      tempvar=iv*tdistractorRF2latinc; /*RF2lat can be negative*/
      srf2delay.preset=tdistractorRFdelay+tempvar+tdistractorRF2lat;

	}
      if(tdistractorRF2latnum==1&tdistractorRF2lat<0){
       srf2delay.preset=(tdistractorRFdelay+tdistractorRF2lat);
	}

     
      }

      
      
/*This uses the menu for RF2 locations based on T location */     
if(tdistractorRF2num>0){     
	 /*If only one position, then setting RF2position*/
	 if(tdistractorRF2num==1&tdistractorpredict==0){
	 rf2->x=tdistractorx;
	 rf2->y=tdistractory;
	    rf2_hasbeen_set=1;
         }

	 if(tdistractorpredict==1&tdistractorRF2num==1){
	    rf2->x=rf->x;
	    rf2->y=rf->y;
	       rf2_hasbeen_set=1;
	 }

	 /*If more than one  position, then setting RF2 position and inverse position*/ 
	 if(tdistractorRF2num>1&tdistractorpredict==0)
	   {
	   if(tdistractorRF2posprob>0)
	     {
	   rf2posrand=((double)rand()/(double)(RAND_MAX+1));
	   if(rf2posrand<= ((double)tdistractorRF2posprob)/100)
	    { local_rf2=1;}
	   else
	   {local_rf2=0;}
	   

	   if(local_rf2==1){
	     rf2->x=tdistractorx;
	     rf2->y=tdistractory;
	   }
	   if(local_rf2==0){
	     rf2->x=-1*tdistractorx;
	     rf2->y=-1*tdistractory;
	   } rf2_hasbeen_set=1;
	 }


}
}
      

      /*
  
      if(remap_jumpynum<0){
	 
         if(remap_jumpxnum<0 && numlistjumpxs>0 &&
numlistjumpys>=numlistjumpxs)
	   newjumpy=listjumpy[i]; 
	 else if(numlistjumpys>0){
	   i=(int)((double)(numlistjumpys)*(rand()/(RAND_MAX+1.0)));
	   newjumpy=listjumpy[i];
	 }
	 else dprintf("%s\n","No Can Do. jumpy list not long enough");
      } 

      */

      
      /*This uses the menu for variable or many RF2 locations using function menu */
if(tdistractorRF2num<0){      
 
      if(numlistrf2xs>0){
	 i=(int)((double)(numlistrf2xs)*(rand()/(RAND_MAX+1.0)));
	 tdistractorx=listrf2x[i];

      }
   else { dprintf("%s\n","No Can Do. rf2x list not long enough");}
    
	 
         if(numlistrf2xs>0 && numlistrf2ys>=numlistrf2xs)
{	   
/*	   i=(int)((double)(numlistrf2ys)*(rand()/(RAND_MAX+1.0)));*/
	   tdistractory=listrf2y[i];

	 }
	 else {
	    	   i=(int)((double)(numlistrf2ys)*(rand()/(RAND_MAX+1.0)));
	   tdistractory=listrf2y[i];
	    
	    dprintf("%s\n","redrawing rand for rf2y; not long enough list"); } 
    
      
   /*setting rf2 values*/
      
      rf2->x=tdistractorx; rf2->y=tdistractory;
      rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
      object[rf2->object[0]].x=rf2->x; 
      object[rf2->object[0]].y=rf2->y;
}


/*sets prob that RF2 will appear at all and resets flags*/      
      
      if(tdistractorRF2prob>0){
	 
	   aar=((double)rand()/(double)(RAND_MAX+1));  	
	 
	 if(aar<= ( (double)(tdistractorRF2prob)/100))
	 
	   rf2flag=1;
	 
	else rf2flag=0;

      } else rf2flag=0;
   
      /*finally setting all the rf2 properties*/
/*      if (rf2_hasbeen_set==1){*/
      rf2->obj[0].pattern=tdistractorRF2pat;
      rf2->obj[0].checksize=tdistractorRF2check;
      rf2->obj[0].fgr=tdistractorRF2fgr;
      rf2->obj[0].fgg=tdistractorRF2fgg;
      rf2->obj[0].fgb=tdistractorRF2fgb;      
	 rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
	 

      object[rf2->object[0]].pattern=rf2->obj[0].pattern;
      object[rf2->object[0]].checksize=rf2->obj[0].checksize;
      object[rf2->object[0]].fgr=rf2->obj[0].fgr;
      object[rf2->object[0]].fgg=rf2->obj[0].fgg;
      object[rf2->object[0]].fgb=rf2->obj[0].fgb;
	 object[rf2->object[0]].x=rf2->x;
	 object[rf2->object[0]].y=rf2->y;
/*      }*/
   }
   
  if(tdist_dimlink==1){ 
     
  sfpon.preset=srfdelay.preset-50;
  }
   return(0);
	
}
      
      
int linemotionStuff(){

   int i; int i1;
   int tempvar;
   int currentDegs;
   int xdiff; int ydiff;
   int xlen; int ylen;
   double aar; double aar1;
   int current_linemotionRFlen;
   int current_linemotionRFang;
   int rf2_hasbeen_set;
   
   int current_RF2x; int current_RF2y;
   
   if (linemotionMenu==1){

      /*setting some basic values*/
      
      srfon.preset=linemotionRFon;
      
      if(linemotionRFonnum>1)

	{
	         i = (int)(linemotionRFonnum*rand()/(RAND_MAX+1.0));      
	   srfon.preset=linemotionRFon+linemotionRFoninc*i;
	}
      
      srf2on.preset=linemotionRF2on;
      
            if(linemotionRF2onnum>1)

	{
	         i = (int)(linemotionRF2onnum*rand()/(RAND_MAX+1.0));      
	   srf2on.preset=linemotionRF2on+linemotionRF2oninc*i;
	}
      
      srfdelay.preset=linemotionRFdelay;
      rf2_hasbeen_set=0;
      

      /*setting ISI*/
      
      i = (int)(linemotionRF2latnum*rand()/(RAND_MAX+1.0));      
      tempvar= srfdelay.preset + linemotionRF2lat + i*linemotionRF2latinc; /*linemotionRF2lat can be negative*/
      if(tempvar>0) srf2delay.preset=tempvar; else {srf2delay.preset=100; dprintf("%s\n","hello ???");
      }
      
      /*setting RF orientation*/
      
      if(linemotionRFoangprob>0){
      	   aar=((double)rand()/(double)(RAND_MAX+1));  	
	 if(aar<= ( (double)(linemotionRFoangprob)/100))
	current_linemotionRFang=linemotionRFoang;
      else current_linemotionRFang=linemotionRFang;
      } else current_linemotionRFang=linemotionRFang;
      
      /*setting RF length and placing rf2, to be redone if displace degs is set*/
      if (linemotionRFlennum>1){
	       i = (int)(linemotionRFlennum*rand()/(RAND_MAX+1.0));      
      current_linemotionRFlen=linemotionRFlen+i*linemotionRFleninc;

	 rf2->x=linemotionRF2x; rf2->y=linemotionRF2y;
/*	 rf2->obj[0].x=linemotionRF2x; rf2->obj[0].y=linemotionRF2y;
	 object[rf2->object[0]].x=linemotionRF2x; 
	 object[rf2->object[0]].y=linemotionRF2y;*/
      } else current_linemotionRFlen=linemotionRFlen;
      

      
      if(current_linemotionRFang>=0) {      /*use rfang rather than endx and endy*/
	 xlen=(int)( (double)current_linemotionRFlen*cos( ((double)current_linemotionRFang/360) * 2*PI) / 2);
	   ylen=(int)( (double)current_linemotionRFlen*sin( ((double)current_linemotionRFang/360) * 2*PI) / 2);
	 
	 /*If "ReceptiveX" or "ReceptiveY" >350, then midpoint values are used --> KLUUUUUUUUUUUUUUUUUUUGE*/
	 
	 if(linemotionRFx<350 && linemotionRFy<350){
	 rf->x=linemotionRFx+xlen;
      	 rf->y=linemotionRFy+ylen;
	 } else{
	  rf->x=linemotionRFmidx;
	    rf->y=linemotionRFmidy;
	 }
	 
	 rf->obj[0].x=rf->x; rf->obj[0].y=rf->y;
	 object[rf->object[0]].x=rf->x; object[rf->object[0]].y=rf->y;
	 rf->obj[0].var1=current_linemotionRFang; object[rf->object[0]].var1=current_linemotionRFang;
	 rf->obj[0].var2=linemotionRFwidth; object[rf->object[0]].var2=linemotionRFwidth;
	 rf->obj[0].var3=current_linemotionRFlen; object[rf->object[0]].var3=current_linemotionRFlen;
	 
	 /*If only one length, then setting RF2*/
	 if(linemotionRFlennum<=1){
	 rf2->x=rf->x+xlen;
	 rf2->y=rf->y+ylen;
/*	 rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
	 object[rf2->object[0]].x=rf2->x;
	 object[rf2->object[0]].y=rf2->y;*/
	 }
      } /*else{  

	 rf->x=(linemotionRFendx+linemotionRFx)/2;
	 rf->y=(linemotionRFendy+linemotionRFy)/2;
	 
	 rf->obj[0].x=rf->x; rf->obj[0].y=rf->y;
	 object[rf->object[0]].x=rf->x; object[rf->object[0]].y=rf->y;
	 
	 xdiff=linemotionRFendx-linemotionRFx;
	 ydiff=linemotionRFendy-linemotionRFy;
	 
	 tempvar=atan2((double)(ydiff) , (double)(xdiff) );
	 rf->obj[0].var1=(int)(tempvar); object[rf->object[0]].var1=rf->obj[0].var1;
	 
	 rf->obj[0].var2=linemotionRFwidth; object[rf->object[0]].var1=linemotionRFwidth;
	 
         rf->obj[0].var3=sqrt( xdiff*xdiff + ydiff*ydiff );
	 object[rf->object[0]].var1=rf->obj[0].var3;
	 if(linemotionRFlennum<=1){
	 rf2->x=linemotionRFendx;
	 rf2->y=linemotionRFendy;
	 rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
	 object[rf2->object[0]].x=rf2->x;
	 object[rf2->object[0]].y=rf2->y;
	 }
	 dprintf("%s\n","StartX EndX Not yet fully vetted !!");

      }*/ /*if negative, then use endx and endy instead of angle, length and width*/
      
      
      if(linemotionDisplace==1) {  /*displacing rf2 a bit from the line in one direction*/
	 
	       i = (int)(linemotionDisplaceDegsNum*rand()/(RAND_MAX+1.0));      
	 currentDegs=linemotionDisplaceDegs+linemotionDisplaceDegsInc*i;

	 if(current_linemotionRFang>=0){
	    
/*	 rf2->x=rf2->x+(int)((double)(linemotionDisplaceDegs)*cos(((double)current_linemotionRFang/360)*(2*PI))); 
	 rf2->y=rf2->y+(int)((double)(linemotionDisplaceDegs)*sin(((double)current_linemotionRFang/360)*(2*PI)));*/ /*this may work */
	    
	 rf2->x=rf2->x+(int)((double)(currentDegs)*cos(((double)current_linemotionRFang/360)*(2*PI))); /*this may work */
	 rf2->y=rf2->y+(int)((double)(currentDegs)*sin(((double)current_linemotionRFang/360)*(2*PI))); /*this may work */
	 
	 }
	 else
	   {

	 rf2->x=rf2->x+(int)((double)(currentDegs)*cos(tempvar));
	 rf2->y=rf2->y+(int)((double)(currentDegs)*sin(tempvar));
	      
/*	      	 rf2->x=rf2->x+(int)((double)(linemotionDisplaceDegs)*cos(tempvar)); 
	 rf2->y=rf2->y+(int)((double)(linemotionDisplaceDegs)*sin(tempvar));*/
	      
	   }
	 
      }
      
      
/*finally need to set up rf2 flash probability; and set flags appropriately*/
/*also need to set up rf2 object properties*/      
      
      if(linemotionRF2prob>0){
	 
	   aar=((double)rand()/(double)(RAND_MAX+1));  	
	 
	 if(aar<= ( (double)(linemotionRF2prob)/100))
	 
	   rf2flag=1;
	 
	else rf2flag=0;

      } else rf2flag=0;

      /*Now doing the symmetric one-sided probability*/
      
      /*I think this works 12/20*/
      
      if(linemotionDinprob>0){

	 aar1= ((double)rand()/(double)(RAND_MAX+1));  	
	 	 if(aar1<= ( (double)(linemotionDinprob)/100)){

		    rf2->x=rf->x - (rf2->x-rf->x);
		    rf2->y=rf->y - (rf2->y-rf->y);

		 }
	 
      }

      
      /*If using RF2 random values*/
      
         if (linemotionRF2xnum>0||linemotionRF2ynum>0){

	 	       i = (int)(linemotionRF2xnum*rand()/(RAND_MAX+1.0));      
	 rf2->x=linemotionRF2x+i*linemotionRF2xinc;
	 	 	       i = (int)(linemotionRF2ynum*rand()/(RAND_MAX+1.0));
	 rf2->y=linemotionRF2y+i*linemotionRF2yinc;
	 rf2_hasbeen_set=1;
	    
/*	 	 rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
	 object[rf2->object[0]].x=rf2->x; 
	 object[rf2->object[0]].y=rf2->y;*/

/*	 dprintf("%d\n",rf2->x);
	 dprintf("%d\n",rf2->y);*/
	 }
   
      /*finally setting all the rf2 properties*/
      
         rf2->obj[0].pattern=linemotionRF2pat;
      rf2->obj[0].checksize=linemotionRF2check;
      rf2->obj[0].fgr=linemotionRF2fgr;
      rf2->obj[0].fgg=linemotionRF2fgg;
      rf2->obj[0].fgb=linemotionRF2fgb;      
	 rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
	 

      object[rf2->object[0]].pattern=rf2->obj[0].pattern;
      object[rf2->object[0]].checksize=rf2->obj[0].checksize;
      object[rf2->object[0]].fgr=rf2->obj[0].fgr;
      object[rf2->object[0]].fgg=rf2->obj[0].fgg;
      object[rf2->object[0]].fgb=rf2->obj[0].fgb;
	 object[rf2->object[0]].x=rf2->x;
	 object[rf2->object[0]].y=rf2->y;
      
      if(linemotionRF1prob>0){

	 aar=((double)rand()/(double)(RAND_MAX+1));  	
	 if(aar<= ( (double)(linemotionRF1prob)/100)) rfflag=0; 
	   
      }  else rfflag=1;  /* watch out because this means that if line motion menu is on, rfflag will atuomatically go to 1 when prob==0*/
      

   }
   return(0);
}

int epStuff(){
   
   int i; int j;
   int whichj1;

   
   if (epmenuflag==1){
      
if(ep_fprand==1){

      fp->x = ep_fpxbegin+ep_fpxinc*(int)(ep_fpxnum*rand()/(RAND_MAX+1.0));
    	fp->y = ep_fpybegin+ep_fpyinc*(int)(ep_fpynum*rand()/(RAND_MAX+1.0));      
      
      fp->obj[0].x=fp->x; fp->obj[0].y=fp->y;
      object[fp->object[0]].x=fp->x; object[fp->object[0]].y=fp->y;
}
      if(ep_j1rand!=1){
      
      whichj1=(int)(j1num*rand()/(RAND_MAX+1.0));
        rf2->x=j1xarr[ whichj1];
	rf2->y=j1yarr[ whichj1];
      
      rf2->obj[0].x=rf2->x; rf2->obj[0].y=rf2->y;
      object[fp->object[0]].x=rf2->x; object[fp->object[0]].y=rf2->y;
      
      jmp1->x=rf2->x;jmp1->y=rf2->y;
      jmp1->obj[0].x=jmp1->x; jmp1->obj[0].y=jmp1->y;
      object[jmp1->object[0]].x=jmp1->x; object[jmp1->object[0]].y=jmp1->y;
      

      srf2delay.preset=ep_rf2del;
      sjmp1delay.preset=ep_fixdur;
      srf2on.preset=ep_jtargdur;
      } else {
      
if(ep_usestatic!=1){      
	 for(i=0;i<ep_j1num;i++){
      while(i>=0){	    
      randXArr[i] = ep_j1xbegin+ep_j1xinc*(int)(ep_j1xnum*rand()/(RAND_MAX+1.0));
      randYArr[i] = ep_j1ybegin+ep_j1yinc*(int)(ep_j1ynum*rand()/(RAND_MAX+1.0));      
      if(i==0) break;
else	 if (randXArr[i]!=randXArr[i-1] || randYArr[i]!=randYArr[i=1]) break;
      }
/*	    dprintf("%s\n","Randomized JMPS");*/

/*      jmp1->obj[0].x=jmp1->x; jmp1->obj[0].y=jmp1->y;
      object[jmp1->object[0]].x=jmp1->x; object[jmp1->object[0]].y=jmp1->y;*/
	 }} else

{

for(i=0;i<j1num;i++){
while(i>=0){
   whichj1=(int)(j1num*rand()/(RAND_MAX+1.0));
randXArr[i]=j1xarr[whichj1];
randYArr[i]=j1yarr[whichj1];
if(i==0) break;
else	 if (randXArr[i]!=randXArr[i-1] || randYArr[i]!=randYArr[i=1]) break;   
}
}
}
}
      
      
      }

 return(0);  
}

int MMNStuff()
{
double aar;
int curskipobj;
   int i;
   int xx; int yy;

/*int rfxx[24]; 
int rfyy[24];
int rfnx[24];
int rfny[24];*/
   /*24 is arbitrary. */

   if (mmnmenuon==1){
      
/*   for(i=0;i<24;i++){
      rfxx[i]=0;
      rfyy[i]=0;
      rfnx[i]=0;
      rfny[i]=0;
   }*/


if(skippattern==1&&rfrandmap==0&&manyrfFlag==1){

rf->obj[0].x=rfxarr[0]; rf->obj[0].y=rfyarr[0];
rf->obj[1].x=rfxarr[1]; rf->obj[1].y=rfyarr[1];
rf->obj[2].x=rfxarr[2]; rf->obj[2].y=rfyarr[2];
rf->obj[3].x=rfxarr[3]; rf->obj[3].y=rfyarr[3];

object[rf->object[0]].x=rfxarr[0]; object[rf->object[0]].y=rfyarr[0];
object[rf->object[1]].x=rfxarr[1]; object[rf->object[1]].y=rfyarr[1];
object[rf->object[2]].x=rfxarr[2]; object[rf->object[2]].y=rfyarr[2];
object[rf->object[3]].x=rfxarr[3]; object[rf->object[3]].y=rfyarr[3];

rf->x=rf->obj[0].x; rf->y=rf->obj[0].y;

}




/* setting up the active mmn here*/
   
   if(mmnactiveflag==1){
	   aar=((double)rand()/(double)(RAND_MAX+1));  	
	   if(aar<=(((double)devprob)/100)) {
rf->obj[1].pattern=devpattern;
	      rf->obj[1].checksize=devcheck;
rf->obj[1].fgr=devred;
rf->obj[1].fgg=devgreen;
rf->obj[1].fgb=devblue;
	      
	      object[rf->object[1]].pattern=devpattern;
            	      object[rf->object[1]].checksize=devcheck;
	      	      object[rf->object[1]].fgr=devred;
	      	      object[rf->object[1]].fgg=devgreen;
	      	      object[rf->object[1]].fgb=devblue;

	objectStack[vexObjectFlag++] = rf->object[1];
	   
	   }
   } else /*notice how active flag dominates; ad-hoc choice*/
   
      if(mmnpassiveflag==1){
	 
	   aar=((double)rand()/(double)(RAND_MAX+1));  	
	   if(aar<=(((double)devprob)/100)) {
rf->obj[0].pattern=devpattern;
	      rf->obj[0].checksize=devcheck;
rf->obj[0].fgr=devred;
rf->obj[0].fgg=devgreen;
rf->obj[0].fgb=devblue;
	      
	      object[rf->object[0]].pattern=devpattern;
            	      object[rf->object[0]].checksize=devcheck;
	      	      object[rf->object[0]].fgr=devred;
	      	      object[rf->object[0]].fgg=devgreen;
	      	      object[rf->object[0]].fgb=devblue;

	   } else {
	      
	      rf->obj[0].pattern=basepattern;
	      rf->obj[0].checksize=basecheck;
rf->obj[0].fgr=basered;
rf->obj[0].fgg=basegreen;
rf->obj[0].fgb=baseblue;
	      
	      object[rf->object[0]].pattern=basepattern;
            	      object[rf->object[0]].checksize=basecheck;
	      	      object[rf->object[0]].fgr=basered;
	      	      object[rf->object[0]].fgg=basegreen;
	      	      object[rf->object[0]].fgb=baseblue;
	      
	   }
	 	objectStack[vexObjectFlag++] = rf->object[0];
      }
   
   
 

/*if(skippattern==1){*/

 if(skippattern==1 && ((skipthisnumflag==1 && (seenflashes+1)==skipthisnum) || skipthisnumflag==0) ){
     
/*   for(i=0;i<numrfobjects;i++){
	rfxx[i]=rf->obj[i].x;
	rfyy[i]=rf->obj[i].y;}*/

   aar=((double)rand()/(double)(RAND_MAX+1));  
	   if(aar<=((double)skipprop)/100){
	   if(skipobj>=numrfobjects){
	   i = (int)(numrfobjects*rand()/(RAND_MAX+1.0));
	   curskipobj=i;

	   } else{

	   curskipobj=skipobj;
	   if(otherskipprop>0){
	   	   aar=((double)rand()/(double)(RAND_MAX+1));  
	   if(aar<=((double)otherskipprop)/100){
	   curskipobj=otherskipobj;
	   }}
}
dprintf("\t\tskipping object %d\n",curskipobj);

rf->obj[curskipobj].checksize=0;
object[rf->object[curskipobj]].checksize=0;
	      
/*	      yy=0;
	for(xx=0;xx<numrfobjects;xx++){
	if(xx!=curskipobj){
	rfnx[yy]=rfxx[xx];
	rfny[yy]=rfyy[xx];
	yy++;
	}
	}
	     
for(i=0;i<(numrfobjects-1);i++){
   rf->obj[i].x=rfnx[i];
   rf->obj[i].y=rfny[i];
   object[rf->object[i]].x=rfnx[i];
   object[rf->object[i]].y=rfny[i];
}*/
skipthis=1;

	   } else skipthis=0;
   
   for(i=0;i<numrfobjects;i++)
     	      	 	objectStack[vexObjectFlag++] = rf->object[i];
   
} else skipthis=0;

   }

   
 return(0);  
}

int rewardOffStuff()
{
	dio_off(rewardDevice);
	return(0);
}

int nostart()
{
	int j;
	long code = ABTLCD;

	goodFlag = NO;
	if (repeatFlagOn != 0) repeatFlag = YES;
	abttrl++;
	j = code;
	return(j);
}

int dimerrorStuff()
{
	if (localflashFlag) cuebarXFlag = YES;
	return(0);	
}

int barerrorStuff()
{
	int j;
	long code = BARERRCD;

	if (localflashFlag2) cuebarXFlag = YES;
	j = code;
	return(j);	
}

int fbStuff()
{
	int j;
	long code = FBRKCD;
	goodFlag = NO;
	if (repeatFlagOn != 0) repeatFlag = YES;
	fbrk++;
	trialFlag = NO; new_trialFlag=0;
	if (beepFlag) dio_on(beepDevice);
	/* NB. The fix break tone goes for "fixbreak" time because
		it is turned off in lastThings */

	j = code;
	isfb=1;
	return(j);
}
	
int abstuff()
{isab=1;}


int errorStuff()
{
	int j;
	int test;
	long code = ERRORCD;
	long codeTime;
	
	last[cfl] = 0;
	++cfl;
	if (count_first_twenty < 20) ++count_first_twenty;
	if (cfl >= 20) cfl = 0;

if(barcodedrop==1){
   	test = drinput & BOTHBARS;
	if ((test & LEFTBAR) == 0)   {
			codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
			vexEvent[0].e_code = CDELCD+1; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/	   
	}
   
   	if ((test & RIGHTBAR) == 0)   {
	   			codeTime = i_b->i_time; /*pick up current clock time for event code*/ 
			vexEvent[0].e_code = CDELCD+2; /*load ecode*/
			vexEvent[0].e_key = codeTime;    /*load time*/
			ldevent (&vexEvent[0]); /*drop code*/
	}
     
}
        if(localflashFlag) cuebarXFlag=YES; /*jan 2006 suresh entry*/
   
        trialFlag = NO; new_trialFlag=0;
	goodFlag = NO;
	score(NO);
	j = code;
	return(j);
}

int flashwaitStuff(){

if(chonkinflash==0) chonkinflashon=0; else {chonkinflashon=1;
waschonkinflash=1;}

return(0);
}

int chonkinflashCheck(){

if(chonkinflash==1&trialOn==0)
{
   
   if(beepontime<=chonkinflashontime){
      scflashOn.preset=beepontime;
      scbeepOff.preset=chonkinflashontime-beepontime;
   }
   else {
      
    scflashOn.preset=chonkinflashontime;
      scbeepOff.preset=5; /*arbitrary time to turn off beep device*/
   }

   scflashOff.preset=chonkinflashofftime;
   
   return(1);}
else return(0);
}

int turnoffbutt(){

  myVexFlag=1;
  buttOffFlag=1;

  return(0);
}

int displaybutt(){

	vexOnFlag = 0; /*cancel any turnons*/
			vexOffFlag |= VEXRF;
	vexOffFlag |= vexCancelFlag;
	vexCancelFlag = vexOnFlag = NO; /* turn off all VEX objects except 
					 * background*/
	if ((cue->control) == VEXBACKOFF) vexOnFlag = VEXBGD; /*JG*/

/*  vexOffFlag |= VEXCURRENT;*/

  myVexFlag=1;
  buttOnFlag=1;
	  aminButt=1;
  turnonrequested=1;
  return(0);
}

int flashOnStuff()
{
	if (localflashFlag || localflashFlag2 || chonkinflash)
	{
		old_bglum = bkgd_lum;
		bkgd_lum = bkgd_lumX;
		BGLumFlag = YES;
		if(beepFlag) dio_on(beepDevice);
/*	   dprintf("doing flash on  %d\n",bkgd_lum);*/
	}
	return(0);
}

int cflashOnStuff()
{
	if (localflashFlag || localflashFlag2 || chonkinflash)
	{

		bkgd_lum = bkgd_lumX;
		BGLumFlag = YES;
		      dio_on(beepDevice);
	   if(chonkinflash==1){ waschonkinflash=1;
   chonkinflashon=YES;
	   }else chonkinflashon=NO;
	}

	return(0);
}


int flashOffStuff()
{
	if (localflashFlag || localflashFlag2 || chonkinflash)
	{
		bkgd_lum = old_bglum;
		BGLumFlag = YES;
		cuebarXFlag = NO; /* reset flag */
		dio_off(beepDevice);
/*	   	   dprintf("doing flash off  %d\n",bkgd_lum);*/
	}

	return(0);
}

int cbeepOffStuff()
{
   
if(chonkinflash) dio_off(beepDevice);   
   return(0);
   
}

int cflashOffStuff()
{
	if (localflashFlag || localflashFlag2 || chonkinflash)
	{
		bkgd_lum = 0;
		BGLumFlag = YES;
		cuebarXFlag = NO; /* reset flag */
		dio_off(beepDevice);
	}

	return(0);
}

int testOnStuff()
{
	dio_on(testDevice);
	return(0);
}

int testOffStuff()
{
	dio_off(testDevice);
	return(0);
}

int lastThings() 
{
	int j,i;
	long code = DISABLECD;


   rfdelayFlag=0;
   rfnextFlag=NO;

  
	jRandINDEX=0;
   
	jRandEndFlag=NO;
	jRandOver=0;
	sureshrfoff=NO;
	islast=1;
   prfonflag=NO;
   if(wait_for_rfoff==YES)  vexCancelFlag |= (VEXRF);
   wait_for_rfoff=NO;
   fpgoneoff=NO;
   seenflashes=0;
   
/*   if(isfb!=1 & isab!=1) et_counter++;*/
   
   if(latcorrect==1){
   if (lefttrial==1&&go_time>0&&fin_time>0) {leftlatarray[leftind]=fin_time-go_time; 
		   dprintf("left latency %d\n",leftlatarray[leftind]);
		   leftind++; if(leftind>9) leftind=0;
		}
		else if(lefttrial==0&&go_time>0&&fin_time>0) {rightlatarray[rightind]=fin_time-go_time; 
		   		   dprintf("right latency %d\n",rightlatarray[rightind]);
		   rightind++; if(rightind>9) rightind=0;
		}
		
/*		dprintf("%d\n",go_time);
		dprintf("%d\n",fin_time);*/
		
		}
   
   go_time=0; fin_time=0;

/*
dprintf("drinput: %o; BOTHBARS: %o; drinput&BOTHBARS %o\n", drinput, BOTHBARS,
	(drinput & BOTHBARS)); 
*/

	debugcount = 0;
	if (rf->device !=0) dio_off(rf->device);
	if (rf->device_dim !=0) dio_off(rf->device_dim);
        if (rf2->device !=0) dio_off(rf2->device);
	if (rf2->device_dim !=0) dio_off(rf2->device_dim);
	if (fp->device !=0) dio_off(fp->device);

	if (fp->device_dim !=0) dio_off(fp->device_dim);
	if (jmp1->device !=0) dio_off(jmp1->device);
	if (jmp1->device_dim !=0) dio_off(jmp1->device_dim);
	if (jmp2->device !=0) dio_off(jmp2->device);
	if (jmp2->device_dim !=0) dio_off(jmp2->device_dim);
	if (jmp2->device_dim !=0) dio_off(jmp2->device_dim);
	if(grassDevice != 0) dio_off(grassDevice); /*make sure grass is off*/
	if (beepFlag&&cuebarXFlag!=1) dio_off(beepDevice); /* turn off fix break tone */

	/* The following code changes all staircases. If monkey gets enough 
	 *  trials in a row correcy then the cue increases by one. If the monk
	 *  gets enough in a row incorrect then the cue decreases by one.
	 *  normal psychophysics uses 3 correct and 1 incorrect.
	 *
	 * If MCSTHRESH is on then randomly pick a new level first and then
	 *  assign it to all the relevent arrays.
	 */

	if ((cue->control == MCSTHRESH ) && (repeatFlag != YES)) cue->falsereward = (int) (cue->counter*rand()/(RAND_MAX+1));

	for (i=0;i<(array.array_max);++i) {
		if (((array.tbl[i].cue.control == THRESHOLD ) && (repeatFlag != YES)) && (array.tbl[i].cue.object_dim == cue->object_dim)) { 
			if (goodFlag == NO)
			   if (++localbad[i] >= array.tbl[0].cue.windowy) {
				if (--array.tbl[i].cue.falsereward < 0)
					array.tbl[i].cue.falsereward = 0;
				localbad[i] = 0;
				localgood[i] = 0;
			   }
			if (goodFlag == YES) 
			   if (++localgood[i] >= array.tbl[0].cue.windowx) {
				localgood[i] = 0;
				localbad[i] = 0;
				if (++array.tbl[i].cue.falsereward >= array.tbl[i].cue.counter)
					array.tbl[i].cue.falsereward= array.tbl[i].cue.counter-1;
			   }
		}/*if array.tbl[i].cue.control == THRESHOLD*/

		if ((array.tbl[i].cue.control == MCSTHRESH) && (cue->control == MCSTHRESH) && (repeatFlag != YES) && (array.tbl[i].cue.object_dim == cue->object_dim)) { 
			array.tbl[i].cue.falsereward = cue->falsereward;
			/*  dprintf("\nThe new thresh level is: %d\n ",array.tbl[i].cue.falsereward); */
		}/*if array.tbl[i].cue.control == MCSTHRESH*/
	} /* for i=0 to array_max */

	/* update # trial and % correct */
	if (tyes + tno > 1)
 		tot_num_trials = tyes + tno;
	else tot_num_trials = 1;
	percent_cor = (int) (100 * tyes / tot_num_trials);

	jmp1WinNowFlag = NO;
	jmp1timer=50;
	jmp2WinNowFlag = NO;
	local_jmp2RwdFlag = NO;
	givejmp2Rwd = NO;
	sacCheckFlag = NO;
   nowincheckflag=NO;
	photoCancelFlag = YES;
	fpoffFlag = NO;
	trialFlag = NO; new_trialFlag=0;
	vexJoyFlag = NO;
	jmp1NowFlag = NO;
	r_jmp1NowFlag=YES;
	r_jmp1WinShiftFlag=NO;
	gap1nowFlag = NO;
	jmp2NowFlag = NO;
	sac1Flag = sac2Flag = NO;
	local_grassflag = NO;
	local_jmp1Flag = NO;
	local_jmp2Sacflag = NO;
	local_rfflag = NO; new_fponflag=0;
	local_rf2flag = NO;
	local_backon1flag = NO;
	local_backon2flag = NO;
	local_cueflag = NO;
	local_cue2flag = NO;
	localBeepFlag = NO;
	abortFlag = NO;
	goodsacFlag = NO;
	rfonflag = NO;
	if(buttCancelFlag==1){myVexFlag=1; buttOffFlag=1;}
	if(aminButt!=1){
	vexOnFlag = 0; /*cancel any turnons*/
			vexOffFlag |= VEXRF;
	vexOffFlag |= vexCancelFlag;
	vexCancelFlag = vexOnFlag = NO; /* turn off all VEX objects except 
					 * background*/
	if ((cue->control) == VEXBACKOFF) vexOnFlag = VEXBGD; /*JG*/

	} else 	aminButt=0;
	
        j = code;
	  trialOn=0;
	return(j);
}

int sacStartStuff()
{
	long code;
	int j;

	if (sac1Flag == YES) {
		code = SACON1CD;
	}
	else if (sac2Flag == YES) {
		code = SACON2CD;
	}
	else code = SACONCD;
	j = code;
	return(j);
}
	
int sacWaitStuff()
{
	sac1Flag = sac2Flag = 0;
	return(0);
}

int sacEndStuff()
{
	long code;
	int j;

	if (printSacFlag == YES)
		dprintf("saccade duration = %d\n", duration);
	if (sac1Flag == YES) {
		if (printSacFlag == YES) 
	   	  dprintf( "jmp 1: real: %d %d desired:%d %d \n",
			h_sacsize/4, v_sacsize/4,hormov1, vermov1);
		sac1Flag = NO;
		if ((abs(hormov1 - h_sacsize/4) < fudge1h) && 
		   (abs(vermov1 - v_sacsize/4) < fudge1v)) {
			code = SACOFF1CD;
			goodsacFlag |= SACCADE1;
		}
	}
	else if (sac2Flag == YES) {
		if (printSacFlag == YES) 
	   	  dprintf( "jmp 2 real: %d %d desired:%d %d \n",
			h_sacsize/4, v_sacsize/4,hormov2, vermov2);
		sac2Flag = NO;
		if ((abs(hormov2 - h_sacsize/4) < fudge2h) && 
		   (abs(vermov2 - v_sacsize/4) < fudge2v)){
			code = SACOFF2CD;
			goodsacFlag |= SACCADE2;
		}
	}
	else code = SACOFFCD;
	j = code;
	return(j);
}

void
rinitf(void)
{

	/*sockets for ethernet communication*/

	/*******************************/
	/* USE WITH REX 7.5 or EARLIER */
	/*******************************/
/* 
**	char *port = GLVEX_PORT_STR;
**	char *host = "vex1";
**	char *subnet = 0;
**	int i;
**
**	pcsSetPeerAddr(host, port);
**	pcsAllocPassiveSocket(subnet, port);
**
**	for (cfl = 0;cfl <20;++cfl) last[cfl] = 0;
*/
	/*****************************/
	/* USE WITH REX 7.6 or LATER */
	/*****************************/

	char *vexport = GLVEX_PORT_STR;
	char *vexhost = "vex3";
   	char *mexport = MEX_PORT_STR;
	char *mexhost = "mex3";

	char *subnet = 0;
	int i;

	pcsSetVexPeerAddr(vexhost, vexport);
	pcsAllocPassiveVexSocket(subnet, vexport);
	pcsSetMexPeerAddr(mexhost, mexport);
	pcsAllocPassiveMexSocket(subnet, mexport);

	for (cfl = 0;cfl <20;++cfl) last[cfl] = 0;

	
    /*
     * Initializations.
     */
    da_cursor(DA0,DA1, CU_DA_ONE);	    /* da cursors */
    da_cursor(DA2,DA3, CU_DA_TWO);
    
    pre_post(500,100);
    wd_cntrl(0,WD_ON); /*turn windows on*/
    wd_cntrl(1,WD_ON);
    wd_cntrl(2,WD_ON);
    wd_cntrl(3, WD_ON);
    
    wd_disp(D_W_ALLCUR );	    /* all cursors  */

    wd_src_pos(0, WD_DIRPOS,0,WD_DIRPOS,0);
    wd_src_check(0, WD_SIGNAL, 0, WD_SIGNAL, 1); /*eyeh is signal 0, 
						  *eyev is signal 1
						  */
    wd_siz(0, 100, 100);
    wd_pos(0, 0, 0);

    wd_src_pos(1, WD_DIRPOS,0,WD_DIRPOS,0);
    wd_src_check(1, WD_SIGNAL, 0, WD_SIGNAL, 1); /*eyeh is signal 0, 
						  *eyev is signal 1
						  */
    wd_siz(1, 100, 100);
    wd_pos(1, 0, 0);

    wd_src_pos(2, WD_DIRPOS,0,WD_DIRPOS,0);
    wd_src_check(2, WD_SIGNAL, 0, WD_SIGNAL, 1); /*eyeh is signal 0, 
						  *eyev is signal 1
						  */
    wd_siz(2, 100, 100);
    wd_pos(2, 0, 0);

    wd_src_pos(3, WD_DIRPOS,0,WD_DIRPOS,0);
    wd_siz(3, 10, 10);
    wd_pos(3, 0, 0);

    pre_post(10,10); /*make very short window pre and post times*/

	for (i=0;i<(array.array_max);++i) {
		localbad[i] = 0;
		localgood[i] = 0;
	}  /* This clears staircase levels */

}

%% /*start of state set section*/
id 200
restart rinitf
main_set {
status ON
begin
first:
	to start 
start:
	do startStuff()
	to intertrial

intertrial:
	   time 5
	   do intertrialStuff()
	   to fintertrial
	   
fintertrial:
	time 1000
        to trueIntertrial on -YES & chonkinflashon
	to limboloc
 
limboloc:
	 time 1000
	 to fintertrial

trueIntertrial:
	do interStuff()
	time 20
	rl 0
	to enable

enable:
	time 500	
	to pstopcheck

pstopcheck:
	to openWind on -PSTOP & softswitch

openWind:
	rl + 20
	awind(OPEN_W);
	to enable2

enable2:
 	do getarraynum()
	to trialwait 
	
trialwait:
	do trialwaitStuff()
	time 20
	rl 20
	to bartrialck

bartrialck:
	time 2000
	to trial_chec on NO % fork_check
	to eyetrialck on +YES % start_check
	to ch_error

eyetrialck:
	do barfpon()
	time 2000
	to fpwait on +YES % window_check
	to ch_error

trial_chec:
	time 2000
	to fpwait on +YES % start_check
	to ch_error 

fpwait:
	time 500
	to fixbreak on +NO % window_check 
	to fpon

fpon:
	do fponStuff()
	time 3000
	rl 40
	to barerror on +NO % bar_check
	to winerror on +NO % window_check
	to aberror on +NO % abortCheck
	to fprwd on +YES % fixcuetime
        to reward on +YES % hasheacquired /*kluge for dorf mgs*/
	to barerror on +YES & cuebarXFlag
	to dimfork on +YES & givejmp2Rwd
	to dimfork on +1=jRandOver
	to dimfork

fprwd:
	time 1300
	to error on +NO % window_check
	to dimfork

barerror:
	do barerrorStuff()
	to error

winerror:
	to error on +YES & jmp1NowFlag
	to error on +YES & jmp2NowFlag
	to fixbreak

fixbreak:
	time 150
	do fbStuff()	
	to last 

aberror:
	to error

dimfork:
	to reward on NO % fork_check2
	to wtdimon

wtdimon:
	time 80	
	do dimonStuff()
	rl +10
	to aberror on +NO % bar_check
	to winerror on +NO % window_check
	to dimon

dimon:
	to barhold on +YES & nogoflag
	to reward on +YES % dimbar_check 
	to error on +NO % abortCheck
	to winerror on +NO % window_check
	to dimerrorcheck
	
dimerrorcheck:

        to dimerror on +NO%dimerrorcheckfn
	to reward

barhold:
	time 1000
	to error on +NO % bar_check
	to reward

reward:
	do rewardStuff()  /*butt turned on in reward stuff*/
	rl +10
	to tiffdisplay on +YES & showbuttOn
	to last

tiffdisplay:  /*holding time for butt*/
	time 500
        to last
	to tiffturnoff

tiffturnoff:	   /*time to turn butt off*/

        time 20
	do turnoffbutt()
	to last

ch_error:
	do nostart()
	to last 

dimerror:
	do dimerrorStuff()
	to error
error:
	do errorStuff()
	to erlast

/*erlast:
       time 1000
       to trueerlast on -YES & chonkinflash
       to trueerlast
       
trueerlast:*/
erlast:
       time 5
       do lastThings()
       to ercloseWin

ercloseWin:
	awind(CLOSE_W)
	to timeout

timeout:
	time 3000
	to intertrial

/*last: 
      time 1000
      to truelast on -YES & chonkinflash
      to truelast

truelast:*/
last:
	time 5
        do lastThings()
	to closeWin
	
closeWin:
	awind(CLOSE_W)
	to intertrial
}
/*the vex_set begins by setting up the vex object list
 *and the background,
 *and then 
 *waiting either for a background change or a stimulus change
 *when vexOnFlag is set
 *the vexWhere sends out the where command, two subsequent states do
 *vex and pcm ready stuff, and then the vexOn state turns it on.
 *It then waits
 *for reply, after which it goes to the vexCode routine
 *sends out the codes, and goes back to vexStart, which send out the
 *pcm_ack and goes to vexWait when the line is ready
 *note that all vex requests are funnelled through here
 *monk does not use the vex FP facility
 */
vex_set {
status ON
begin
vexInit:
	to allOff 

allOff:
	do allOffStuff()
	to vexStart on 0 % tst_rx_new
clrscr:
	do clearScreen()
	to vexStart on 0 % tst_rx_new

makeObj:
	do makeObjStuff()
	to objDone on 0 % tst_rx_new
objDone:
	do objDoneStuff()
	to vexStart 
vexLocate:
	do vexLocateStuff()
	to vexFoo
vexFoo: 
	to vexStart on 0 % tst_rx_new
vexStart:
/*   do debugprintC()*/
	to vexClear 
vexClear:
	do vexClearStuff()
	to vexWait

vexWait:
/*        do debugprint()*/
     	to vexForRf on +YES % waitingForRf
	to clrscr on +VEXOLDBG & vexOffFlag
	to makeObj on +YES % vexObjCheck
	to vexLocate on +YES % vexLocateCheck
	to vexfork on +YES % minvexFlagCheck
	to allOff on +YES %vexAllOffCheck

vexfork:
/*        do debugprintB()*/
	to vexDo on +YES = photoCancelFlag
	to vexPhotDo on +YES = photocellFlag
	to vexDo
	
vexForRf:
	 time 5
	 to vexRfFotCheck
	 
vexRfFotCheck:

	 to vexStart on +YES % vexPhotoStuff

vexPhotDo:	
	do sendVexNow()
	to vexStart on +YES % vexPhotoStuff

vexDo:
	do sendVexNowB()
	to vexCode on 0 % tst_rx_new

vexCode:
	do vexCodeStuff()
	to vexStart
}


reward_set {
status ON

begin
reward_wai:
	to reward_on on +YES & rewardflag
	to cuebar_rwd on +YES & cuebarrwd_flag	

cuebar_rwd:
	do reward1Stuff()
	time 110
	to reward_off

reward_on:
	do reward1Stuff()
	time 110
	to reward_off

reward_off:
	do rewardOffStuff()
	to reward_pau

reward_pau:
	time 500
	to reward_wai
}


/* currently disenabled for debugging purposes
raster_set {
status ON
	
begin
only_raste:
	code RASONCD
	time 500
	to next_raste

next_raste:
	code RASONCD
	time 500
	to only_raste
}
*/


/* next two chains involve jump control
 *jmpSet deals with lights
 *jmpWindowSet with windows
 */
 
/************************
 jmp1NowFlag is set in jmp1onstuff, and turned off in jmp2onstuff, NOT in
jmp1offstuff. this is probably because.. the eyewindow jumps to jmp2, only
when jmp2 goes on, not when jmp1 goes off. but if we are running my rand
stimulus, you want the eyewindow to go to wait position the moment jmp1off
stuff happens. 

In the new format: R_jmp1NowFlag goes on along with jmp1NowFlag, but is
turned off in jmp1offstuff, IF the jRandFlag is set; otherwise, it stays
set, and so the chain is blind to its variations.

-suresh 

Other notes: it seems to me that jmp1wincheck is simply doing a basic check
to make sure that the eye is within the jmp1 window.. not sure what this
accomplishes over and above the fp chain chekcing. plus it looks like if the
eye wanders and comes back in, jmp1win will then move to jmp2win. 

*****************************************/

jmpWindowSet {
status ON
begin

jRandWinWait:

	  to jWinWait on +YES & r_jmp1NowFlag

jWinWait:
	to jmp1Win on +YES & jmp1NowFlag
	
jmp1Win:
	do jmp1WinStuff()  /*here I must shift r_jmpWinShiftFlag to be NO*/
	to jRandWinWait on +YES & r_jmp1WinShiftFlag
	to jRandWinWait on -YES & trialFlag
	to jmp2Win on +YES % jmp1WinCheck

jmp2Win:
	do jmp2WinStuff()
	to jWinWait on -YES & trialFlag
}


backon_set {
status ON

begin
bStart: to bSleep

bSleep:
	to b1Wait on +YES % backon1FlagCheck
	to b2Wait on +YES % backon2FlagCheck

b1Wait:
	do backon1WaitStuff()
	to b1Gap on +YES % backon1Check
	to bSleep on -YES & trialFlag



b1Gap: 
	time 1
	to bSleep on -YES & trialFlag
	to b1On

b1On:
	do backon1OnStuff()
	to bSleep

b2Wait:
	do backon2WaitStuff();
	to b2Gap on +YES % backon2Check
	to bSleep on -YES & trialFlag

	
b2Gap: 
	time 1
	to bSleep on -YES & trialFlag
	to b2On

b2On:
	do backon2OnStuff()
	to bSleep
	
	
}

fpdelay_set {
status ON
begin

offwait: to keepiton on +YES & fpoffFlag

keepiton: 
	time 1
	to turnitoff


turnitoff: 
	do turnitoffStuff()
	to offwait
}

jmp_set {
status ON

begin
jmpwait:
	to jmp1delay on +YES & local_jmp1Flag


jmp1delay:
	do jmp1delayStuff() /* This is where I am going to do all the rand
	   		       	    calcs - Suresh 3/03*/
	time 700 rand 250
	to jmpwait on -YES & trialFlag
	to jmpwait on +1=jRandOver
	to jmp1fork

jmp1fork:
	to gap1 on -YES & fixjmpcueflag /*This flag allows a fixed interval
	   	   	  	      between cue on and gap on.. the jmp1fix -S.*/
	to jmp1fix

jmp1fix:
	do setlocal_cueflag()
	time 150
	to jmpwait on -YES & trialFlag
	to jmpwait on +1=jRandOver
	to gap1

gap1:
	do gap1Stuff()   
	time 30
	rl -10
	to jmpwait on -YES & trialFlag
	to jmpwait on +1=jRandOver
	to jmp1on

jmp1on:
 	do jmp1onStuff() /*My loop will work between here and the next state -S.*/
	time 4000  /* set this time carefully, to something like 500 ms or
	     	   so -S */
	rl + 40
	to jmpwait on -YES & trialFlag
	to jmp1off on +YES & sacCheckFlag  /* I dont know how this interacts with
	   	      	     		   my jRand stuff... Suresh. Keep
					    sacflags UNSET */
	to jmp1off


jmp1off:   
	    do jmp1offStuff()  /*Verify that it doesnt do anything disastrous 
	       		       	 and if so, leave untouched-S.*/
	    to jmpwait on -YES & trialFlag
	    to jmp1test
	    
jmp1test:

            to jmp1leave on +0=jRandFlag
	    to jmp1leave on +YES & jRandEndFlag
            to jmp1on	    
jmp1leave:
	to gap2 on +YES  & jmp2Flag 
	to jmpwait on -YES & trialFlag

gap2:
	do gap2Stuff()
	time 30
	rl -10
	to jmpwait on -YES & trialFlag
	to jmp2on 

jmp2on:
 	do jmp2onStuff()
	time 4000
	rl + 40
	to jmpwait on -YES & trialFlag
	to jmp2off

jmp2off:
	do jmp2offStuff()
	to jmpwait on -YES & trialFlag

}


hum_set {
status ON

begin
respwait:
         to waitResp on +YES % hum_resp_check

waitResp:
         time 500
         to humcorrect on +YES % check_answer
	 to respwait on -YES & trialFlag

humcorrect:
	 do humrightstuff()
	 to respwait on -YES & trialFlag
}


/*chain to run cue stimulus*/
cue_set {
status ON

begin
cueWait:
	to cueDelay on +YES & local_cueflag
/*JG*/
cueDelay:
	do cueDelayStuff()
	time 1 
	to cueWait on -YES & trialFlag
	to cueDelay1 on +YES % backoffcheck 
        to cueOn

cueDelay1:
        do vexbackoff()
        time 1
        to cueWait on -YES & trialFlag
        to cueOn
 
cueOn:
 	do cueOnStuff()
	rl + 40
	time 400
	to cueWait on -YES & trialFlag
	to cueOff on +YES & cueBarRelease
	to cueOff

cueOff:
	do cueOffStuff()
	rl - 40
	to cueWait
}

cue2_set {
status ON

begin
cue2Wait:
	to cue2Delay on +YES & local_cue2flag
/*JG*/
cue2Delay:
	do cue2DelayStuff()
	time 1 
	to cue2Wait on -YES & trialFlag
	to cue2Delay1 on +YES % backoffcheck 
        to cue2On

cue2Delay1:
        do vexbackoff()
        time 1
        to cue2Wait on -YES & trialFlag
        to cue2On
 
cue2On:
 	do cue2OnStuff()
	rl + 40
	time 400
	to cue2Wait on -YES & trialFlag
	to cue2Off

cue2Off:
	do cue2OffStuff()
	rl - 40
	to cue2Wait
}

/*chain to run rf*/
rf_set {
status ON

begin
rfstart:
	to rfwait on +0=local_newrfflag
rfwait:
	to rftdelay on +YES & local_rfflag
     
rfdecide:
        to rfnextwait on +YES & seenflashflag;
     	   to rfstart on -YES & trialFlag

rfnextwait:
	   time 200
	   do rfnextwaitstuff()
	   to rflimbo on +YES %StopOnJump
	   to rfstart on -YES & trialFlag
	   to rfnext
rflimbo:
	   to rfstart on -YES & trialFlag

rfnext:
       time 1000
       do rfnextStuff()
       to rfstart on -YES & trialFlag
       to rfdelay
     
rftdelay:

     to rfstart on -YES & trialFlag
     to rfdelay

rfdelay:
	do rfdelayStuff()
	time 700 rand 250
	to rfstart on -YES & trialFlag 
	to rfpreon

rfpreon: 
	 do rfonStuff()
	 time 50
	 rl+40
	 to rfstart on -YES & trialFlag
         to rfon on +1 = rfHasAppeared
/*	 to rfon on +2= rfHasAppeared*/
	 to rfon

rfon:
        time 10
        to rfstart on -YES & trialFlag
	to rffork
	
rffork:

        to surrfoff on +1=oneframemode
	to rfoff
	
surrfoff:
	do suresh_turnsoff_rf()
	rl - 40
	to rfstart on -YES & trialFlag
	to rfdecide on +YES & manyrfFlag
	to rfstart

rfoff:
	do rfoffStuff()
	rl - 40
	to rfstart on -YES & trialFlag
	to rfdecide on +YES & manyrfFlag
	to rfstart
	
}


/* chain to turn on rf before trial*/
newrf_set{
status ON

begin
newrfstart: 
	    to newrfwait on +1=local_newrfflag
newrfwait:
	  to newrfdelay on +1=new_fponflag
newrfdelay:
	   do rfdelayStuff()
	   time 200
	   to newrfstart on -YES & new_trialFlag
	   to newrfon
newrfon:
	   do rfonStuff()
	   rl +40
	   to newrfstart on -YES & new_trialFlag
	   to newrftimer on +YES & local_rfflag
newrftimer:
	   time 400
	   to newrfstart on -YES & new_trialFlag
	   to newrfoff
newrfoff:
	    do rfoffStuff()
	    rl -40
	    to newrfstart on -YES & new_trialFlag
	    to newrfstart
}



/*chain to run rf2*/
rf2_set {
status ON

begin
rf2wait:
	to rf2delay on +YES & local_rf2flag

rf2decide:
        to rf2flip on +YES & rfnextFlag
         to rf2wait on -YES & trialFlag
   
rf2flip:   
        to rf2delay on +YES & rfdelayFlag
        to rf2wait on -YES & trialFlag

rf2delay:
	do rf2delayStuff()
	time 700 rand 250
	to rf2wait on -YES & trialFlag
	to rf2on

rf2on:
 	do rf2onStuff()
	rl + 40
	time 400
	to rf2wait on -YES & trialFlag
	to rf2off

rf2off:
	do rf2offStuff()
	rl - 40
     to rf2decide on +1=twospotmenuflag
	to rf2wait on -YES & trialFlag
	to rf2wait
}


/*chain to run grass stimulator
 *starts stimulator on either saccade beginning or switch
 *sends out the number of pulses specified by pulsenum
 *set pulsenum = 1 if want to trigger a single TRAIN of pulses, with
 *frequency specified by stimulator settings;
 *set pulsenum > 1 if want to trigger pulses individually; frequency
 *is 1/sgrassUnzap.preset
 */
/*
grass_set {
status ON

begin
grasswait:
	to saccheck on +YES & local_grassflag
	to grassdelay on +STIMSWITCH & drinput
	to grassdelay on +YES & rfgrassflag
	
saccheck:
	to grassdelay on +SF_ONSET & sacflags
	to grasswait on -YES & local_jmp1Flag
	to grasswait on -YES & trialFlag

grassdelay:
	do grassonStuff()
	rl + 40
	time 0
	to grasswait on -YES & trialFlag
	to grassZap
	
grassZap:
	do grassZapStuff()
	rl + 40
	to grassUnzap

grassUnzap:
	do grassUnzapStuff()
	rl - 40
	time 100
	to grasswait on -YES & trialFlag
	to grassoff on -YES & pulseFlag
	to grassZap

grassoff:
	do grassoffStuff()
	rl -40
	to grasswait on -YES & trialFlag
	to grassdelay1
	
grassdelay1:
	time 500
	to grasswait on -YES & trialFlag
	to grasswait
}
*/
saccade_set {
status ON
/*dropping codes concerning saccades*/
/*each saccade drops a SACONCD at start and a SACOFFCD at end*/
/*if during appropriate times, also SACON1CD and SACOFF1CD or SAC2 etc*/
begin
sacBegin:
	to sacWait
sacWait:
	do sacWaitStuff()
	to sacStart on +SF_ONSET & sacflags

sacStart:
	do sacStartStuff()
	to sacEndWait

sacEndWait:
	to sacEnd on +SF_GOOD & sacflags
	to sacWait on -SF_ONSET & sacflags

sacEnd:
	do sacEndStuff()
	to sacWait
}

test_set {
status ON
/*turns test device on and off*/
/*test device chosen by device submenu, default is LED1 */
begin
testWait:
	to testOn on +YES & testFlag

testOn:
	do testOnStuff()
	time 500 
	rl +100
        to testOff 

testOff:
	do testOffStuff()
	rl -100
	time 500
	to testWait on -YES & testFlag
	to testOn
}

flash_set {
status ON
begin
flashBegin:
	to flashWait

flashWait:

	do flashwaitStuff()
	to flashOn on +YES & cuebarXFlag
	to cflashOn on +YES % chonkinflashCheck
	
flashOn:
	do flashOnStuff()
	time 500
	to flashOff
	
cflashOn:

	do cflashOnStuff()
	time 500
	to cbeepOff     

cbeepOff:

       time 100
       do cbeepOffStuff()
       to cflashOff

flashOff:
	do flashOffStuff()
	time 500
	to flashWait
	
cflashOff:
	do cflashOffStuff()
	time 500
	to flashWait	
}
