//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include "cblas.h"
#endif

//
#include "types.h"

//Baseline - naive implementation
f64 reduc_base(f64 *restrict a, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i];

  return d;
}

//deroulage x8, prenant a vecteur, la taille du vecteur n, return la somme de tous les elements
f64 reduc_unroll(f64 *restrict a, u64 n)
{
  double d = 0.0;
  //d1,d2,d3,d4,d5,d6,d7,d8 = 0;
    for (u64 i = 0; i < n; i+=8){
        /***
        d1+= a[i];
        d2 += a[i+1];
        d3 += a[i+2];
        d4+= a[i+3];
        d5+= a[i+4];
        d6+= a[i+5];
        d7+= a[i+6];
        d8+= a[i+7];
        ***/
        d += a[i] + a[i+1] + a[i+2] + a[i+3] + a[i+4] + a[i+5] + a[i+6] + a[i+7];
    }
    //return d1+d2+d3+d4+d5+d6+d7+d8;

  return d;
}
