/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: xgeqp3.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "xgeqp3.h"
#include "xnrm2.h"
#include "xzlarf.h"
#include "xzlarfg.h"
#include "xswap.h"
#include "ixamax.h"

/* Function Definitions */

/*
 * Arguments    : double A[2800]
 *                double tau[7]
 *                int jpvt[7]
 * Return Type  : void
 */
void xgeqp3(double A[2800], double tau[7], int jpvt[7])
{
  int k;
  double vn1[7];
  double vn2[7];
  double work[7];
  int pvt;
  int i;
  double temp1;
  int itemp;
  double temp2;
  k = 1;
  for (pvt = 0; pvt < 7; pvt++) {
    jpvt[pvt] = 1 + pvt;
    work[pvt] = 0.0;
    temp1 = xnrm2(A, k);
    vn2[pvt] = temp1;
    k += 400;
    vn1[pvt] = temp1;
  }

  for (i = 0; i < 7; i++) {
    k = i + i * 400;
    pvt = (i + ixamax(7 - i, vn1, i + 1)) - 1;
    if (pvt + 1 != i + 1) {
      xswap(A, 1 + 400 * pvt, 1 + 400 * i);
      itemp = jpvt[pvt];
      jpvt[pvt] = jpvt[i];
      jpvt[i] = itemp;
      vn1[pvt] = vn1[i];
      vn2[pvt] = vn2[i];
    }

    temp1 = A[k];
    tau[i] = xzlarfg(400 - i, &temp1, A, k + 2);
    A[k] = temp1;
    if (i + 1 < 7) {
      temp1 = A[k];
      A[k] = 1.0;
      xzlarf(400 - i, 6 - i, k + 1, tau[i], A, (i + (i + 1) * 400) + 1, work);
      A[k] = temp1;
    }

    for (pvt = i + 1; pvt + 1 < 8; pvt++) {
      if (vn1[pvt] != 0.0) {
        temp1 = fabs(A[i + 400 * pvt]) / vn1[pvt];
        temp1 = 1.0 - temp1 * temp1;
        if (temp1 < 0.0) {
          temp1 = 0.0;
        }

        temp2 = vn1[pvt] / vn2[pvt];
        temp2 = temp1 * (temp2 * temp2);
        if (temp2 <= 1.4901161193847656E-8) {
          vn1[pvt] = c_xnrm2(399 - i, A, (i + 400 * pvt) + 2);
          vn2[pvt] = vn1[pvt];
        } else {
          vn1[pvt] *= sqrt(temp1);
        }
      }
    }
  }
}

/*
 * File trailer for xgeqp3.c
 *
 * [EOF]
 */
