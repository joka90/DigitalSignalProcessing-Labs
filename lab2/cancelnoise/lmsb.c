/*
 *========================================================================
 *
 *detect1
 *
 *MEX-file implementing:
 *detect1 - detects changes using a one-filter approach
 *
 *Jonas Elbornsson July 1998
 *========================================================================
 */

#define S_FUNCTION_NAME lmsb    /*defines the name of the S-function*/
#define S_FUNCTION_LEVEL 2     /*defines the level of the S-function*/

#include "simstruc.h"
#ifdef MATLAB_MEX_FILE
#include "mex.h"
#endif

#define NNN                ssGetSFcnParam(S,0)    /*model structure*/
#define MU                 ssGetSFcnParam(S,1)    /*noise variance*/
#define TS                 ssGetSFcnParam(S,2)    /*sample time*/

/*
 *====================================================================
 *mdlInitializeSizes - initialize the sizes array
 *
 *The sizes array is used by SIMULINK to determine the S-function
 *block's characteristics (number of inputs, outputs, states, etc.)
 *
 *====================================================================
 */

static void mdlInitializeSizes(SimStruct *S)
{
  real_T model0 = mxGetPr(NNN)[0];           /*pointer to NNN*/
  real_T model1 = mxGetPr(NNN)[1];
  real_T model2 = mxGetPr(NNN)[2];
  int_T   nstates;                        /*number of states*/
  real_T model[3];
  /*determine the type of the specified model*/
  model[0]=model0;
  model[1]=model1;
  model[2]=model2;
  nstates = model[0]+model[1];

  ssSetNumContStates(             S,0);           /*Number of continuous states*/
  ssSetNumDiscStates(S,     nstates);           /*Number of discrete states*/

  if (!ssSetNumInputPorts(        S,2)) return;   /*Number of inputports*/
  ssSetInputPortWidth(           S,0,1);         /*Width of inputport 0*/
  ssSetInputPortWidth(           S,1,1);         /*Width of inputport 1*/
  ssSetInputPortDirectFeedThrough(S,0,1);         /*Direct feedthrough flag*/
  ssSetInputPortDirectFeedThrough(S,1,1);

  if (!ssSetNumOutputPorts(       S,2)) return;   /*Number of outputports*/
  ssSetOutputPortWidth(           S,0,1);         /*Width of outputport 0*/
  ssSetOutputPortWidth(     S,1,nstates);         /*Width of outputport 1*/


  ssSetNumSampleTimes(            S,1);           /*Number of sample times*/

  ssSetNumSFcnParams(             S,3);           /*Number of input arguments*/
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
    {
        /* Return if number of expected != number of actual parameters */
        return;
    }
    ssSetNumRWork( S,3+model[2]+nstates);

  ssSetNumIWork(                  S,4);           /*Number of integer workvector elements*/
  ssSetNumPWork(                  S,0);           /*Number of pointer workvector elements*/

}


static void mdlInitializeSampleTimes(SimStruct *S)
{
  ssSetSampleTime(S,0,mxGetPr(TS)[0]);
  ssSetOffsetTime(S,0,0);
}

#define MDL_INITIALIZE_CONDITIONS   /* Change to #undef to remove function */
#if defined(MDL_INITIALIZE_CONDITIONS)
static void mdlInitializeConditions(SimStruct *S)
{
  real_T  model0 = mxGetPr(NNN)[0];          /*pointer to NNN*/
  real_T model1 = mxGetPr(NNN)[1];
  real_T model2 = mxGetPr(NNN)[2];
  int_T   tstart,nstates;
  int_T   *iwork = ssGetIWork(S);
  real_T model[3];

  model[0]=model0;
  model[1]=model1;
  model[2]=model2;
  /*determine the type of the specified model*/
  nstates = model[0]+model[1];


    if (model[0]+1 > model[1]+model[2])
      tstart = model[0]+1;
    else
      tstart = model[1]+model[2];

  iwork[0] = nstates;                              /*number of states*/
  iwork[1] = 0;                                    /*time*/
  iwork[2] = tstart;                               /*startingtime*/

}
#endif

static void mdlOutputs(SimStruct *S,int_T tid)
{
  real_T nnn0 = mxGetPr(NNN)[0];
  real_T nnn1 = mxGetPr(NNN)[1];
  real_T nnn2 = mxGetPr(NNN)[2];
  real_T *rwork = ssGetRWork(S);
  int_T *iwork = ssGetIWork(S);
  int_T nstates = iwork[0];
  int_T *n = iwork+1;
  real_T eps,temp;
  real_T *phi,*threc;
  int_T i,j;
  int_T tstart = iwork[2];
  real_T *th = ssGetRealDiscStates(S);
  real_T mu = mxGetPr(MU)[0];
  InputRealPtrsType u=ssGetInputPortRealSignalPtrs(S,0);
  InputRealPtrsType y=ssGetInputPortRealSignalPtrs(S,1);
  real_T nnn[3];
  
  nnn[0]=nnn0;
  nnn[1]=nnn1;
  nnn[2]=nnn2;

  n[0]++;
  threc = ssGetOutputPortRealSignal(S,1);

  for (i=nnn[0]+nnn[2]; i>nnn[2];i--)
	 rwork[i] = rwork[i-1];
  i = nnn[2];
  rwork[i] = -*y[0];
  for (i=nnn[0]+nnn[1]+nnn[2]; i>nnn[0]+nnn[2]+1; i--)
	 rwork[i] = rwork[i-1];
  i=nnn[0]+nnn[2]+1;
  j=nnn[2]-1;
  rwork[i] = rwork[j];
  for (i=nnn[2]-1; i>0; i--)
	 rwork[i] = rwork[i-1];
  rwork[0] = *u[0];
  i = nnn[2];
  phi = rwork+i + 1;


  if (n[0]>tstart)
	{
     /*update epsilon*/
     temp=0;
     for (i=0;i<nstates;i++)
  	    temp=temp+phi[i]*th[i];
     eps = *y[0] - temp;

     /*calculate step-length*/
     temp=0;
     for (i=0;i<nstates;i++)
       temp = temp+phi[i]*phi[i];

     /*calculate th*/
     for (i=0; i<nstates; i++)
       th[i] = th[i] + phi[i]*mu*eps/(mu/1000+temp);

	  for (i=0; i<nstates; i++)
	    threc[i] = th[i];
	}

  ssGetOutputPortRealSignal(S,0)[0]=eps;
}


static void mdlTerminate(SimStruct *S)
{
  return;
}

#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
