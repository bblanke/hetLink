/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: xzlarf.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "xzlarf.h"
#include "xgerc.h"
#include "xgemv.h"

/* Function Declarations */
static int ilazlc(int m, int n, const double A[2800], int ia0);

/* Function Definitions */

/*
 * Arguments    : int m
 *                int n
 *                const double A[2800]
 *                int ia0
 * Return Type  : int
 */
static int ilazlc(int m, int n, const double A[2800], int ia0)
{
  int j;
  boolean_T exitg2;
  int coltop;
  int ia;
  int exitg1;
  j = n;
  exitg2 = false;
  while ((!exitg2) && (j > 0)) {
    coltop = ia0 + (j - 1) * 400;
    ia = coltop;
    do {
      exitg1 = 0;
      if (ia <= (coltop + m) - 1) {
        if (A[ia - 1] != 0.0) {
          exitg1 = 1;
        } else {
          ia++;
        }
      } else {
        j--;
        exitg1 = 2;
      }
    } while (exitg1 == 0);

    if (exitg1 == 1) {
      exitg2 = true;
    }
  }

  return j;
}

/*
 * Arguments    : int m
 *                int n
 *                int iv0
 *                double tau
 *                double C[2800]
 *                int ic0
 *                double work[7]
 * Return Type  : void
 */
void xzlarf(int m, int n, int iv0, double tau, double C[2800], int ic0, double
            work[7])
{
  int lastv;
  int lastc;
  if (tau != 0.0) {
    lastv = m;
    lastc = iv0 + m;
    while ((lastv > 0) && (C[lastc - 2] == 0.0)) {
      lastv--;
      lastc--;
    }

    lastc = ilazlc(lastv, n, C, ic0);
  } else {
    lastv = 0;
    lastc = 0;
  }

  if (lastv > 0) {
    xgemv(lastv, lastc, C, ic0, C, iv0, work);
    xgerc(lastv, lastc, -tau, iv0, work, C, ic0);
  }
}

/*
 * File trailer for xzlarf.c
 *
 * [EOF]
 */
