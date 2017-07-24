/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: sort1.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 24-Jul-2017 13:49:26
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "analyzeECG.h"
#include "sort1.h"
#include "sortIdx.h"
#include "nonSingletonDim.h"

/* Type Definitions */
#ifndef struct_emxArray_int32_T_800
#define struct_emxArray_int32_T_800

struct emxArray_int32_T_800
{
  int data[800];
  int size[1];
};

#endif                                 /*struct_emxArray_int32_T_800*/

#ifndef typedef_emxArray_int32_T_800
#define typedef_emxArray_int32_T_800

typedef struct emxArray_int32_T_800 emxArray_int32_T_800;

#endif                                 /*typedef_emxArray_int32_T_800*/

/* Function Declarations */
static void b_sort(double x_data[], int x_size[1], int dim, int idx_data[], int
                   idx_size[1]);

/* Function Definitions */

/*
 * Arguments    : double x_data[]
 *                int x_size[1]
 *                int dim
 *                int idx_data[]
 *                int idx_size[1]
 * Return Type  : void
 */
static void b_sort(double x_data[], int x_size[1], int dim, int idx_data[], int
                   idx_size[1])
{
  int i10;
  double vwork_data[800];
  int vwork_size[1];
  int vstride;
  int k;
  int j;
  int iidx_data[800];
  int iidx_size[1];
  if (dim <= 1) {
    i10 = x_size[0];
  } else {
    i10 = 1;
  }

  vwork_size[0] = (short)i10;
  idx_size[0] = (short)x_size[0];
  vstride = 1;
  k = 1;
  while (k <= dim - 1) {
    vstride *= x_size[0];
    k = 2;
  }

  for (j = 0; j + 1 <= vstride; j++) {
    for (k = 0; k + 1 <= i10; k++) {
      vwork_data[k] = x_data[j + k * vstride];
    }

    sortIdx(vwork_data, vwork_size, iidx_data, iidx_size);
    for (k = 0; k + 1 <= i10; k++) {
      x_data[j + k * vstride] = vwork_data[k];
      idx_data[j + k * vstride] = iidx_data[k];
    }
  }
}

/*
 * Arguments    : double x_data[]
 *                int x_size[1]
 * Return Type  : void
 */
void c_sort(double x_data[], int x_size[1])
{
  int dim;
  int i11;
  double vwork_data[800];
  int vwork_size[1];
  int vstride;
  int k;
  emxArray_int32_T_800 b_vwork_data;
  dim = nonSingletonDim(x_size);
  if (dim <= 1) {
    i11 = x_size[0];
  } else {
    i11 = 1;
  }

  vwork_size[0] = (short)i11;
  vstride = 1;
  k = 1;
  while (k <= dim - 1) {
    vstride *= x_size[0];
    k = 2;
  }

  for (dim = 0; dim + 1 <= vstride; dim++) {
    for (k = 0; k + 1 <= i11; k++) {
      vwork_data[k] = x_data[dim + k * vstride];
    }

    b_sortIdx(vwork_data, vwork_size, b_vwork_data.data, b_vwork_data.size);
    for (k = 0; k + 1 <= i11; k++) {
      x_data[dim + k * vstride] = vwork_data[k];
    }
  }
}

/*
 * Arguments    : double x_data[]
 *                int x_size[1]
 *                int idx_data[]
 *                int idx_size[1]
 * Return Type  : void
 */
void sort(double x_data[], int x_size[1], int idx_data[], int idx_size[1])
{
  int i9;
  i9 = nonSingletonDim(x_size);
  b_sort(x_data, x_size, i9, idx_data, idx_size);
}

/*
 * File trailer for sort1.c
 *
 * [EOF]
 */
