/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: nonSingletonDim.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "nonSingletonDim.h"

/* Function Definitions */

/*
 * Arguments    : const int x_size[1]
 * Return Type  : int
 */
int nonSingletonDim(const int x_size[1])
{
  int dim;
  dim = 2;
  if (x_size[0] != 1) {
    dim = 1;
  }

  return dim;
}

/*
 * File trailer for nonSingletonDim.c
 *
 * [EOF]
 */
