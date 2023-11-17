//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include "cblas.h"
#endif

//
#include "types.h"

//Baseline - naive implementation - n=8的倍数
f64 dotprod_base(f64 *restrict a, f64 *restrict b, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i] * b[i];

  return d;
}


//deroulage x8, prenant a,b deux vecteurs, la taille des vecteurs n, return le produit scalaire
f64 dotprod_unroll(f64 *restrict a, f64 *restrict b, u64 n)
{
    double d = 0 ;
    double r0 = 0 ;
    double r1 = 0 ;
    double r2 = 0 ;
    double r3 = 0 ;
    double r4 = 0 ;
    double r5 = 0 ;
    double r6 = 0 ;
    double r7 = 0 ;
    for (u64 i = 0; i < n; i+=8){
        r0 += a[i] * b[i];
        r1 += a[i+1] * b[i+1];
        r2 += a[i+2] * b[i+2];
        r3 += a[i+3] * b[i+3];
        r4 += a[i+4] * b[i+4];
        r5 += a[i+5] * b[i+5];
        r6 += a[i+6] * b[i+6];
        r7 += a[i+7] * b[i+7];
    }
    d = r0+r1+r2+r3+r4+r5+r6+r7;
  return d;
}
