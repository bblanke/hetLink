/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: xnrm2.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

#ifndef XNRM2_H
#define XNRM2_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "analyzeECG_types.h"

/* Function Declarations */
extern double b_xnrm2(int n, const double x[2800], int ix0);
extern double c_xnrm2(int n, const double x[2800], int ix0);
extern double xnrm2(const double x[2800], int ix0);

#endif

/*
 * File trailer for xnrm2.h
 *
 * [EOF]
 */
