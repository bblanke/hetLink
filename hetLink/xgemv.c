/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: xgemv.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "xgemv.h"

/* Function Definitions */

/*
 * Arguments    : int m
 *                int n
 *                const double A[2800]
 *                int ia0
 *                const double x[2800]
 *                int ix0
 *                double y[7]
 * Return Type  : void
 */
void xgemv(int m, int n, const double A[2800], int ia0, const double x[2800],
           int ix0, double y[7])
{
  int iy;
  int i6;
  int iac;
  int ix;
  double c;
  int i7;
  int ia;
  if (n != 0) {
    for (iy = 1; iy <= n; iy++) {
      y[iy - 1] = 0.0;
    }

    iy = 0;
    i6 = ia0 + 400 * (n - 1);
    for (iac = ia0; iac <= i6; iac += 400) {
      ix = ix0;
      c = 0.0;
      i7 = (iac + m) - 1;
      for (ia = iac; ia <= i7; ia++) {
        c += A[ia - 1] * x[ix - 1];
        ix++;
      }

      y[iy] += c;
      iy++;
    }
  }
}

/*
 * File trailer for xgemv.c
 *
 * [EOF]
 */
