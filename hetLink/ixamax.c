/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: ixamax.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "ixamax.h"

/* Function Definitions */

/*
 * Arguments    : int n
 *                const double x[7]
 *                int ix0
 * Return Type  : int
 */
int ixamax(int n, const double x[7], int ix0)
{
  int idxmax;
  int ix;
  double smax;
  int k;
  double s;
  idxmax = 1;
  if (n > 1) {
    ix = ix0 - 1;
    smax = fabs(x[ix0 - 1]);
    for (k = 2; k <= n; k++) {
      ix++;
      s = fabs(x[ix]);
      if (s > smax) {
        idxmax = k;
        smax = s;
      }
    }
  }

  return idxmax;
}

/*
 * File trailer for ixamax.c
 *
 * [EOF]
 */
