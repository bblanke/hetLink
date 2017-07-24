/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: vander.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "vander.h"

/* Function Definitions */

/*
 * Arguments    : const double v[400]
 *                double A[2800]
 * Return Type  : void
 */
void vander(const double v[400], double A[2800])
{
  int k;
  int j;
  for (k = 0; k < 400; k++) {
    A[2400 + k] = 1.0;
    A[2000 + k] = v[k];
  }

  for (j = 0; j < 5; j++) {
    for (k = 0; k < 400; k++) {
      A[k + 400 * (4 - j)] = v[k] * A[k + 400 * (5 - j)];
    }
  }
}

/*
 * File trailer for vander.c
 *
 * [EOF]
 */
