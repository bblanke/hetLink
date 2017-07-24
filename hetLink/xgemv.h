/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: xgemv.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

#ifndef XGEMV_H
#define XGEMV_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "analyzeECG_types.h"

/* Function Declarations */
extern void xgemv(int m, int n, const double A[2800], int ia0, const double x
                  [2800], int ix0, double y[7]);

#endif

/*
 * File trailer for xgemv.h
 *
 * [EOF]
 */
