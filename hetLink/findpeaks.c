/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: findpeaks.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "findpeaks.h"
#include "sort1.h"
#include "eml_setop.h"
#include "diff.h"
#include "sign.h"

/* Function Declarations */
static void c_findPeaksSeparatedByMoreThanM(const double y[400], const double
  iPk_data[], const int iPk_size[1], double idx_data[], int idx_size[1]);
static void findLocalMaxima(const double yTemp[400], double iPk_data[], int
  iPk_size[1], double iInflect_data[], int iInflect_size[1]);
static void getAllPeaks(const double y[400], double iPk_data[], int iPk_size[1],
  double iInf_data[], int iInf_size[1], double iInflect_data[], int
  iInflect_size[1]);
static void keepAtMostNpPeaks(double idx_data[], int idx_size[1]);
static void removePeaksBelowMinPeakHeight(const double Y[400], double iPk_data[],
  int iPk_size[1]);
static void removePeaksBelowThreshold(const double Y[400], double iPk_data[],
  int iPk_size[1]);

/* Function Definitions */

/*
 * Arguments    : const double y[400]
 *                const double iPk_data[]
 *                const int iPk_size[1]
 *                double idx_data[]
 *                int idx_size[1]
 * Return Type  : void
 */
static void c_findPeaksSeparatedByMoreThanM(const double y[400], const double
  iPk_data[], const int iPk_size[1], double idx_data[], int idx_size[1])
{
  int loop_ub;
  int i4;
  int locs_temp_size[1];
  short locs_data[800];
  double locs_temp_data[800];
  int iidx_data[800];
  int iidx_size[1];
  int sortIdx_size_idx_0;
  int sortIdx_data[800];
  int i;
  boolean_T idelete_data[800];
  int trueCount;
  boolean_T tmp_data[800];
  if (iPk_size[0] == 0) {
    idx_size[0] = 0;
  } else {
    loop_ub = iPk_size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      locs_data[i4] = (short)(1 + (short)((int)iPk_data[i4] - 1));
    }

    locs_temp_size[0] = iPk_size[0];
    loop_ub = iPk_size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      locs_temp_data[i4] = y[(int)iPk_data[i4] - 1];
    }

    sort(locs_temp_data, locs_temp_size, iidx_data, iidx_size);
    sortIdx_size_idx_0 = iidx_size[0];
    loop_ub = iidx_size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      sortIdx_data[i4] = iidx_data[i4];
    }

    loop_ub = iidx_size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      locs_temp_data[i4] = locs_data[sortIdx_data[i4] - 1];
    }

    loop_ub = (short)iidx_size[0];
    for (i4 = 0; i4 < loop_ub; i4++) {
      idelete_data[i4] = false;
    }

    for (i = 0; i < sortIdx_size_idx_0; i++) {
      if (!idelete_data[i]) {
        for (i4 = 0; i4 < sortIdx_size_idx_0; i4++) {
          tmp_data[i4] = (((int)locs_temp_data[i4] >= locs_data[sortIdx_data[i]
                           - 1] - 60) && ((int)locs_temp_data[i4] <=
            locs_data[sortIdx_data[i] - 1] + 60));
        }

        loop_ub = (short)sortIdx_size_idx_0;
        for (i4 = 0; i4 < loop_ub; i4++) {
          idelete_data[i4] = (idelete_data[i4] || tmp_data[i4]);
        }

        idelete_data[i] = false;
      }
    }

    loop_ub = (short)iidx_size[0] - 1;
    trueCount = 0;
    for (i = 0; i <= loop_ub; i++) {
      if (!idelete_data[i]) {
        trueCount++;
      }
    }

    sortIdx_size_idx_0 = 0;
    for (i = 0; i <= loop_ub; i++) {
      if (!idelete_data[i]) {
        iidx_data[sortIdx_size_idx_0] = i + 1;
        sortIdx_size_idx_0++;
      }
    }

    idx_size[0] = trueCount;
    for (i4 = 0; i4 < trueCount; i4++) {
      idx_data[i4] = sortIdx_data[iidx_data[i4] - 1];
    }

    c_sort(idx_data, idx_size);
  }
}

/*
 * Arguments    : const double yTemp[400]
 *                double iPk_data[]
 *                int iPk_size[1]
 *                double iInflect_data[]
 *                int iInflect_size[1]
 * Return Type  : void
 */
static void findLocalMaxima(const double yTemp[400], double iPk_data[], int
  iPk_size[1], double iInflect_data[], int iInflect_size[1])
{
  double b_yTemp[402];
  boolean_T yFinite[402];
  int i;
  boolean_T x[401];
  int idx;
  short ii_data[401];
  int ii;
  boolean_T exitg3;
  boolean_T guard3 = false;
  int loop_ub;
  short tmp_data[402];
  int i3;
  double yTemp_data[402];
  short iTemp_data[402];
  int yTemp_size[1];
  double b_tmp_data[798];
  int tmp_size[1];
  int s_size[1];
  double s_data[401];
  boolean_T x_data[400];
  int b_ii_data[400];
  int ii_size_idx_0;
  boolean_T exitg2;
  boolean_T guard2 = false;
  int c_ii_data[400];
  boolean_T exitg1;
  boolean_T guard1 = false;
  b_yTemp[0] = rtNaN;
  memcpy(&b_yTemp[1], &yTemp[0], 400U * sizeof(double));
  b_yTemp[401] = rtNaN;
  for (i = 0; i < 402; i++) {
    yFinite[i] = !rtIsNaN(b_yTemp[i]);
  }

  for (i = 0; i < 401; i++) {
    x[i] = ((b_yTemp[i] != b_yTemp[i + 1]) && (yFinite[i] || yFinite[i + 1]));
  }

  idx = 0;
  ii = 1;
  exitg3 = false;
  while ((!exitg3) && (ii < 402)) {
    guard3 = false;
    if (x[ii - 1]) {
      idx++;
      ii_data[idx - 1] = (short)ii;
      if (idx >= 401) {
        exitg3 = true;
      } else {
        guard3 = true;
      }
    } else {
      guard3 = true;
    }

    if (guard3) {
      ii++;
    }
  }

  if (1 > idx) {
    loop_ub = 0;
  } else {
    loop_ub = idx;
  }

  tmp_data[0] = 1;
  for (ii = 0; ii < loop_ub; ii++) {
    tmp_data[ii + 1] = (short)(ii_data[ii] + 1);
  }

  if (1 > idx) {
    i3 = 0;
  } else {
    i3 = idx;
  }

  i = 1 + i3;
  for (ii = 0; ii < i; ii++) {
    iTemp_data[ii] = tmp_data[ii];
  }

  yTemp_size[0] = 1 + loop_ub;
  loop_ub++;
  for (ii = 0; ii < loop_ub; ii++) {
    yTemp_data[ii] = b_yTemp[iTemp_data[ii] - 1];
  }

  diff(yTemp_data, yTemp_size, b_tmp_data, tmp_size);
  s_size[0] = tmp_size[0];
  loop_ub = tmp_size[0];
  for (ii = 0; ii < loop_ub; ii++) {
    s_data[ii] = b_tmp_data[ii];
  }

  b_sign(s_data, s_size);
  diff(s_data, s_size, b_tmp_data, tmp_size);
  loop_ub = tmp_size[0];
  for (ii = 0; ii < loop_ub; ii++) {
    x_data[ii] = (b_tmp_data[ii] < 0.0);
  }

  i = tmp_size[0];
  idx = 0;
  ii_size_idx_0 = tmp_size[0];
  ii = 1;
  exitg2 = false;
  while ((!exitg2) && (ii <= i)) {
    guard2 = false;
    if (x_data[ii - 1]) {
      idx++;
      b_ii_data[idx - 1] = ii;
      if (idx >= i) {
        exitg2 = true;
      } else {
        guard2 = true;
      }
    } else {
      guard2 = true;
    }

    if (guard2) {
      ii++;
    }
  }

  if (tmp_size[0] == 1) {
    if (idx == 0) {
      ii_size_idx_0 = 0;
    }
  } else if (1 > idx) {
    ii_size_idx_0 = 0;
  } else {
    ii_size_idx_0 = idx;
  }

  if (1 > s_size[0] - 1) {
    loop_ub = 0;
  } else {
    loop_ub = s_size[0] - 1;
  }

  ii = !(2 > s_size[0]);
  for (i = 0; i < loop_ub; i++) {
    x_data[i] = (s_data[i] != s_data[ii + i]);
  }

  idx = 0;
  ii = 1;
  exitg1 = false;
  while ((!exitg1) && (ii <= loop_ub)) {
    guard1 = false;
    if (x_data[ii - 1]) {
      idx++;
      c_ii_data[idx - 1] = ii;
      if (idx >= loop_ub) {
        exitg1 = true;
      } else {
        guard1 = true;
      }
    } else {
      guard1 = true;
    }

    if (guard1) {
      ii++;
    }
  }

  if (loop_ub == 1) {
    if (idx == 0) {
      loop_ub = 0;
    }
  } else if (1 > idx) {
    loop_ub = 0;
  } else {
    loop_ub = idx;
  }

  iInflect_size[0] = loop_ub;
  for (ii = 0; ii < loop_ub; ii++) {
    iInflect_data[ii] = (double)iTemp_data[c_ii_data[ii]] - 1.0;
  }

  iPk_size[0] = ii_size_idx_0;
  for (ii = 0; ii < ii_size_idx_0; ii++) {
    iPk_data[ii] = (double)iTemp_data[b_ii_data[ii]] - 1.0;
  }
}

/*
 * Arguments    : const double y[400]
 *                double iPk_data[]
 *                int iPk_size[1]
 *                double iInf_data[]
 *                int iInf_size[1]
 *                double iInflect_data[]
 *                int iInflect_size[1]
 * Return Type  : void
 */
static void getAllPeaks(const double y[400], double iPk_data[], int iPk_size[1],
  double iInf_data[], int iInf_size[1], double iInflect_data[], int
  iInflect_size[1])
{
  boolean_T x[400];
  int i;
  short ii_data[400];
  int ii;
  boolean_T exitg1;
  boolean_T guard1 = false;
  double yTemp[400];
  for (i = 0; i < 400; i++) {
    x[i] = (rtIsInf(y[i]) && (y[i] > 0.0));
  }

  i = 0;
  ii = 1;
  exitg1 = false;
  while ((!exitg1) && (ii < 401)) {
    guard1 = false;
    if (x[ii - 1]) {
      i++;
      ii_data[i - 1] = (short)ii;
      if (i >= 400) {
        exitg1 = true;
      } else {
        guard1 = true;
      }
    } else {
      guard1 = true;
    }

    if (guard1) {
      ii++;
    }
  }

  if (1 > i) {
    i = 0;
  }

  iInf_size[0] = i;
  for (ii = 0; ii < i; ii++) {
    iInf_data[ii] = ii_data[ii];
  }

  memcpy(&yTemp[0], &y[0], 400U * sizeof(double));
  for (ii = 0; ii < i; ii++) {
    ii_data[ii] = (short)iInf_data[ii];
  }

  for (ii = 0; ii < i; ii++) {
    yTemp[ii_data[ii] - 1] = rtNaN;
  }

  findLocalMaxima(yTemp, iPk_data, iPk_size, iInflect_data, iInflect_size);
}

/*
 * Arguments    : double idx_data[]
 *                int idx_size[1]
 * Return Type  : void
 */
static void keepAtMostNpPeaks(double idx_data[], int idx_size[1])
{
  double b_idx_data[800];
  int i12;
  if (idx_size[0] > 400) {
    memcpy(&b_idx_data[0], &idx_data[0], 400U * sizeof(double));
    idx_size[0] = 400;
    for (i12 = 0; i12 < 400; i12++) {
      idx_data[i12] = b_idx_data[i12];
    }
  }
}

/*
 * Arguments    : const double Y[400]
 *                double iPk_data[]
 *                int iPk_size[1]
 * Return Type  : void
 */
static void removePeaksBelowMinPeakHeight(const double Y[400], double iPk_data[],
  int iPk_size[1])
{
  int end;
  int trueCount;
  int i;
  int partialTrueCount;
  if (!(iPk_size[0] == 0)) {
    end = iPk_size[0] - 1;
    trueCount = 0;
    for (i = 0; i <= end; i++) {
      if (Y[(int)iPk_data[i] - 1] > 0.5) {
        trueCount++;
      }
    }

    partialTrueCount = 0;
    for (i = 0; i <= end; i++) {
      if (Y[(int)iPk_data[i] - 1] > 0.5) {
        iPk_data[partialTrueCount] = iPk_data[i];
        partialTrueCount++;
      }
    }

    iPk_size[0] = trueCount;
  }
}

/*
 * Arguments    : const double Y[400]
 *                double iPk_data[]
 *                int iPk_size[1]
 * Return Type  : void
 */
static void removePeaksBelowThreshold(const double Y[400], double iPk_data[],
  int iPk_size[1])
{
  short csz_idx_0;
  double base_data[400];
  int k;
  int trueCount;
  int i;
  int partialTrueCount;
  csz_idx_0 = (short)iPk_size[0];
  for (k = 0; k + 1 <= csz_idx_0; k++) {
    if ((Y[(int)(iPk_data[k] - 1.0) - 1] >= Y[(int)(iPk_data[k] + 1.0) - 1]) ||
        rtIsNaN(Y[(int)(iPk_data[k] + 1.0) - 1])) {
      base_data[k] = Y[(int)(iPk_data[k] - 1.0) - 1];
    } else {
      base_data[k] = Y[(int)(iPk_data[k] + 1.0) - 1];
    }
  }

  k = iPk_size[0] - 1;
  trueCount = 0;
  for (i = 0; i <= k; i++) {
    if (Y[(int)iPk_data[i] - 1] - base_data[i] >= 0.0) {
      trueCount++;
    }
  }

  partialTrueCount = 0;
  for (i = 0; i <= k; i++) {
    if (Y[(int)iPk_data[i] - 1] - base_data[i] >= 0.0) {
      iPk_data[partialTrueCount] = iPk_data[i];
      partialTrueCount++;
    }
  }

  iPk_size[0] = trueCount;
}

/*
 * Arguments    : const double Yin[400]
 *                double Ypk_data[]
 *                int Ypk_size[1]
 *                double Xpk_data[]
 *                int Xpk_size[1]
 * Return Type  : void
 */
void findpeaks(const double Yin[400], double Ypk_data[], int Ypk_size[1], double
               Xpk_data[], int Xpk_size[1])
{
  double iFinite_data[400];
  int iFinite_size[1];
  double iInf_data[400];
  int iInf_size[1];
  double iInflect_data[400];
  int iInflect_size[1];
  int iPk_size[1];
  int loop_ub;
  int i2;
  double iPk_data[800];
  double b_iPk_data[800];
  int ia_data[400];
  int ib_data[400];
  int ib_size[1];
  double idx_data[800];
  int idx_size[1];
  short tmp_data[800];
  getAllPeaks(Yin, iFinite_data, iFinite_size, iInf_data, iInf_size,
              iInflect_data, iInflect_size);
  removePeaksBelowMinPeakHeight(Yin, iFinite_data, iFinite_size);
  iPk_size[0] = iFinite_size[0];
  loop_ub = iFinite_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    iPk_data[i2] = iFinite_data[i2];
  }

  loop_ub = iPk_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    iFinite_data[i2] = iPk_data[i2];
  }

  removePeaksBelowThreshold(Yin, iFinite_data, iFinite_size);
  iPk_size[0] = iFinite_size[0];
  loop_ub = iFinite_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    iPk_data[i2] = iFinite_data[i2];
  }

  do_vectors(iPk_data, iPk_size, iInf_data, iInf_size, b_iPk_data, iFinite_size,
             ia_data, iInflect_size, ib_data, ib_size);
  c_findPeaksSeparatedByMoreThanM(Yin, b_iPk_data, iFinite_size, idx_data,
    idx_size);
  keepAtMostNpPeaks(idx_data, idx_size);
  loop_ub = idx_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    iPk_data[i2] = b_iPk_data[(int)idx_data[i2] - 1];
  }

  Ypk_size[0] = idx_size[0];
  loop_ub = idx_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    Ypk_data[i2] = Yin[(int)iPk_data[i2] - 1];
  }

  loop_ub = idx_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    tmp_data[i2] = (short)(1 + (short)((int)iPk_data[i2] - 1));
  }

  Xpk_size[0] = idx_size[0];
  loop_ub = idx_size[0];
  for (i2 = 0; i2 < loop_ub; i2++) {
    Xpk_data[i2] = tmp_data[i2];
  }
}

/*
 * File trailer for findpeaks.c
 *
 * [EOF]
 */
