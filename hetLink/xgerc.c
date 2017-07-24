/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: xgerc.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "xgerc.h"

/* Function Definitions */

/*
 * Arguments    : int m
 *                int n
 *                double alpha1
 *                int ix0
 *                const double y[7]
 *                double A[2800]
 *                int ia0
 * Return Type  : void
 */
void xgerc(int m, int n, double alpha1, int ix0, const double y[7], double A
           [2800], int ia0)
{
  int jA;
  int jy;
  int j;
  double temp;
  int ix;
  int i8;
  int ijA;
  if (!(alpha1 == 0.0)) {
    jA = ia0 - 1;
    jy = 0;
    for (j = 1; j <= n; j++) {
      if (y[jy] != 0.0) {
        temp = y[jy] * alpha1;
        ix = ix0;
        i8 = m + jA;
        for (ijA = jA; ijA + 1 <= i8; ijA++) {
          A[ijA] += A[ix - 1] * temp;
          ix++;
        }
      }

      jy++;
      jA += 400;
    }
  }
}

/*
 * File trailer for xgerc.c
 *
 * [EOF]
 */
