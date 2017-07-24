/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: findpeaks.h
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

#ifndef FINDPEAKS_H
#define FINDPEAKS_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "rtwtypes.h"
#include "analyzeECG_types.h"

/* Function Declarations */
extern void findpeaks(const double Yin[400], double Ypk_data[], int Ypk_size[1],
                      double Xpk_data[], int Xpk_size[1]);

#endif

/*
 * File trailer for findpeaks.h
 *
 * [EOF]
 */
