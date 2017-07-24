/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: mean.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "mean.h"

/* Function Definitions */

/*
 * Arguments    : const double x_data[]
 *                const int x_size[1]
 * Return Type  : double
 */
double b_mean(const double x_data[], const int x_size[1])
{
  double y;
  int k;
  if (x_size[0] == 0) {
    y = 0.0;
  } else {
    y = x_data[0];
    for (k = 2; k <= x_size[0]; k++) {
      y += x_data[k - 1];
    }
  }

  y /= (double)x_size[0];
  return y;
}

/*
 * Arguments    : const double x[400]
 * Return Type  : double
 */
double mean(const double x[400])
{
  double y;
  int k;
  y = x[0];
  for (k = 0; k < 399; k++) {
    y += x[k + 1];
  }

  y /= 400.0;
  return y;
}

/*
 * File trailer for mean.c
 *
 * [EOF]
 */
