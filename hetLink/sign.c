/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: sign.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "sign.h"

/* Function Definitions */

/*
 * Arguments    : double x_data[]
 *                int x_size[1]
 * Return Type  : void
 */
void b_sign(double x_data[], int x_size[1])
{
  int nx;
  int k;
  nx = x_size[0];
  for (k = 0; k + 1 <= nx; k++) {
    if (x_data[k] < 0.0) {
      x_data[k] = -1.0;
    } else if (x_data[k] > 0.0) {
      x_data[k] = 1.0;
    } else {
      if (x_data[k] == 0.0) {
        x_data[k] = 0.0;
      }
    }
  }
}

/*
 * File trailer for sign.c
 *
 * [EOF]
 */
