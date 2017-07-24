/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: polyfit.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

#ifndef POLYFIT_H
#define POLYFIT_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "analyzeECG_types.h"

/* Function Declarations */
extern void polyfit(const double x[400], const double y[400], double p[7],
                    double S_R[49], double *S_df, double *S_normr, double mu[2]);

#endif

/*
 * File trailer for polyfit.h
 *
 * [EOF]
 */
