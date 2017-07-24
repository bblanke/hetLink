/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: polyval.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "polyval.h"

/* Function Definitions */

/*
 * Arguments    : const double p[7]
 *                double x[400]
 *                const double mu[2]
 *                double y[400]
 * Return Type  : void
 */
void polyval(const double p[7], double x[400], const double mu[2], double y[400])
{
  int i1;
  int k;
  for (i1 = 0; i1 < 400; i1++) {
    y[i1] = p[0];
    x[i1] = (x[i1] - mu[0]) / mu[1];
  }

  for (k = 0; k < 6; k++) {
    for (i1 = 0; i1 < 400; i1++) {
      y[i1] = x[i1] * y[i1] + p[k + 1];
    }
  }
}

/*
 * File trailer for polyval.c
 *
 * [EOF]
 */
