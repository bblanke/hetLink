/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: std.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "std.h"

/* Function Definitions */

/*
 * Arguments    : const double varargin_1[400]
 * Return Type  : double
 */
double b_std(const double varargin_1[400])
{
  double y;
  int ix;
  double xbar;
  int k;
  double r;
  ix = 0;
  xbar = varargin_1[0];
  for (k = 0; k < 399; k++) {
    ix++;
    xbar += varargin_1[ix];
  }

  xbar /= 400.0;
  ix = 0;
  r = varargin_1[0] - xbar;
  y = r * r;
  for (k = 0; k < 399; k++) {
    ix++;
    r = varargin_1[ix] - xbar;
    y += r * r;
  }

  y /= 399.0;
  return sqrt(y);
}

/*
 * File trailer for std.c
 *
 * [EOF]
 */
