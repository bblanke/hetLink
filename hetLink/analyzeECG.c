/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: analyzeECG.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "mean.h"
#include "diff.h"
#include "findpeaks.h"
#include "polyval.h"
#include "polyfit.h"

/* Function Definitions */

/*
 * Setup
 * Arguments    : const double time[400]
 *                const double ecg[400]
 * Return Type  : double
 */
double analyzeECG(const double time[400], const double ecg[400])
{
  double b_ecg[400];
  int i;
  double p[7];
  double expl_temp[49];
  double b_expl_temp;
  double c_expl_temp;
  double mu[2];
  double dv0[400];
  double unusedU1_data[800];
  int unusedU1_size[1];
  double locsRwave_data[800];
  int locsRwave_size[1];
  int loop_ub;
  double b_locsRwave_data[799];
  int b_locsRwave_size[1];
  double diffRwave_data[798];
  int trueCount;
  int partialTrueCount;

  /*  Detrending */
  for (i = 0; i < 400; i++) {
    b_ecg[i] = 1.0 + (double)i;
  }

  polyfit(b_ecg, ecg, p, expl_temp, &b_expl_temp, &c_expl_temp, mu);

  /*  Fit Polynomial */
  /*  Get function */
  /*  Detrend */
  /*  Calculate important points */
  for (i = 0; i < 400; i++) {
    b_ecg[i] = 1.0 + (double)i;
  }

  polyval(p, b_ecg, mu, dv0);
  for (i = 0; i < 400; i++) {
    b_ecg[i] = ecg[i] - dv0[i];
  }

  findpeaks(b_ecg, unusedU1_data, unusedU1_size, locsRwave_data, locsRwave_size);
  if (1 > locsRwave_size[0] - 1) {
    loop_ub = 0;
  } else {
    loop_ub = locsRwave_size[0] - 1;
  }

  /*  Calculate BPM */
  b_locsRwave_size[0] = loop_ub;
  for (i = 0; i < loop_ub; i++) {
    b_locsRwave_data[i] = locsRwave_data[i];
  }

  diff(b_locsRwave_data, b_locsRwave_size, diffRwave_data, unusedU1_size);

  /*  Get the difference between each point */
  loop_ub = unusedU1_size[0] - 1;
  trueCount = 0;
  for (i = 0; i <= loop_ub; i++) {
    if (diffRwave_data[i] < 100.0) {
      trueCount++;
    }
  }

  partialTrueCount = 0;
  for (i = 0; i <= loop_ub; i++) {
    if (diffRwave_data[i] < 100.0) {
      diffRwave_data[partialTrueCount] = diffRwave_data[i];
      partialTrueCount++;
    }
  }

  unusedU1_size[0] = trueCount;

  /*  Filter out the outliers that were wonky */
  b_expl_temp = b_mean(diffRwave_data, unusedU1_size) * ((time[399] - time[0]) /
    400.0);
  return 1.0 / (b_expl_temp / 60.0);
}

/*
 * File trailer for analyzeECG.c
 *
 * [EOF]
 */
