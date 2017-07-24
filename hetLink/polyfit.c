/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: polyfit.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "polyfit.h"
#include "norm.h"
#include "qrsolve.h"
#include "vander.h"
#include "std.h"
#include "mean.h"

/* Function Definitions */

/*
 * Arguments    : const double x[400]
 *                const double y[400]
 *                double p[7]
 *                double S_R[49]
 *                double *S_df
 *                double *S_normr
 *                double mu[2]
 * Return Type  : void
 */
void polyfit(const double x[400], const double y[400], double p[7], double S_R
             [49], double *S_df, double *S_normr, double mu[2])
{
  double d0;
  double d1;
  double b_x[400];
  int i;
  double V[2800];
  double p1[7];
  int i0;
  d0 = mean(x);
  d1 = b_std(x);
  mu[0] = mean(x);
  mu[1] = b_std(x);
  for (i = 0; i < 400; i++) {
    b_x[i] = (x[i] - d0) / d1;
  }

  vander(b_x, V);
  qrsolve(V, y, p1, &i, S_R);
  *S_df = 393.0;
  for (i = 0; i < 400; i++) {
    d0 = 0.0;
    for (i0 = 0; i0 < 7; i0++) {
      d0 += V[i + 400 * i0] * p1[i0];
    }

    b_x[i] = y[i] - d0;
  }

  *S_normr = norm(b_x);
  for (i = 0; i < 7; i++) {
    p[i] = p1[i];
  }
}

/*
 * File trailer for polyfit.c
 *
 * [EOF]
 */
