/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: qrsolve.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "qrsolve.h"
#include "xgeqp3.h"

/* Function Declarations */
static void LSQFromQR(const double A[2800], const double tau[7], const int jpvt
                      [7], double B[400], double Y[7]);
static int rankFromQR(const double A[2800]);

/* Function Definitions */

/*
 * Arguments    : const double A[2800]
 *                const double tau[7]
 *                const int jpvt[7]
 *                double B[400]
 *                double Y[7]
 * Return Type  : void
 */
static void LSQFromQR(const double A[2800], const double tau[7], const int jpvt
                      [7], double B[400], double Y[7])
{
  int j;
  int i;
  double wj;
  for (j = 0; j < 7; j++) {
    Y[j] = 0.0;
    if (tau[j] != 0.0) {
      wj = B[j];
      for (i = j + 1; i + 1 < 401; i++) {
        wj += A[i + 400 * j] * B[i];
      }

      wj *= tau[j];
      if (wj != 0.0) {
        B[j] -= wj;
        for (i = j + 1; i + 1 < 401; i++) {
          B[i] -= A[i + 400 * j] * wj;
        }
      }
    }
  }

  for (i = 0; i < 7; i++) {
    Y[jpvt[i] - 1] = B[i];
  }

  for (j = 6; j >= 0; j += -1) {
    Y[jpvt[j] - 1] /= A[j + 400 * j];
    for (i = 0; i + 1 <= j; i++) {
      Y[jpvt[i] - 1] -= Y[jpvt[j] - 1] * A[i + 400 * j];
    }
  }
}

/*
 * Arguments    : const double A[2800]
 * Return Type  : int
 */
static int rankFromQR(const double A[2800])
{
  int r;
  double tol;
  r = 0;
  tol = 400.0 * fabs(A[0]) * 2.2204460492503131E-16;
  while ((r < 7) && (fabs(A[r + 400 * r]) >= tol)) {
    r++;
  }

  return r;
}

/*
 * Arguments    : const double A[2800]
 *                const double B[400]
 *                double Y[7]
 *                int *rankR
 *                double R[49]
 * Return Type  : void
 */
void qrsolve(const double A[2800], const double B[400], double Y[7], int *rankR,
             double R[49])
{
  double b_A[2800];
  double tau[7];
  int jpvt[7];
  double b_B[400];
  int j;
  int i;
  memcpy(&b_A[0], &A[0], 2800U * sizeof(double));
  xgeqp3(b_A, tau, jpvt);
  *rankR = rankFromQR(b_A);
  memcpy(&b_B[0], &B[0], 400U * sizeof(double));
  LSQFromQR(b_A, tau, jpvt, b_B, Y);
  for (j = 0; j < 7; j++) {
    for (i = 0; i + 1 <= j + 1; i++) {
      R[i + 7 * j] = b_A[i + 400 * j];
    }

    for (i = j + 1; i + 1 < 8; i++) {
      R[i + 7 * j] = 0.0;
    }
  }
}

/*
 * File trailer for qrsolve.c
 *
 * [EOF]
 */
