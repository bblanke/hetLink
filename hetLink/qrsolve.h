/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: qrsolve.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

#ifndef QRSOLVE_H
#define QRSOLVE_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "analyzeECG_types.h"

/* Function Declarations */
extern void qrsolve(const double A[2800], const double B[400], double Y[7], int *
                    rankR, double R[49]);

#endif

/*
 * File trailer for qrsolve.h
 *
 * [EOF]
 */
