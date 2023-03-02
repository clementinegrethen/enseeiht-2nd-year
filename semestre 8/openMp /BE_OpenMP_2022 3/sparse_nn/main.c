#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void sequential_nn(layer *layers, int n, int L);
void parallel_nn_loops(layer *layers, int n, int L);
void parallel_nn_tasks(layer *layers, int n, int L);

int main(int argc, char **argv){
  int   n, m, N, L, i;
  long  t_start, t_end;
  layer *layers_se, *layers_pl, *layers_pt;
  
  // Command line arguments
  if ( argc == 3 ) {
    n = atoi(argv[1]);    /* size of layers */
    L = atoi(argv[2]);    /* number of layers in the network */
  } else {
    printf("Usage:\n\n ./main n L\n\nsuch that n is the size of the layers and L is the number of layers.\n");
    return 1;
  }

  layers_se = (layer*) malloc(sizeof(layer)*L);
  layers_pl = (layer*) malloc(sizeof(layer)*L);
  layers_pt = (layer*) malloc(sizeof(layer)*L);

  init(layers_se, n, L);
  copy_nn(layers_se, layers_pl, n, L);
  copy_nn(layers_se, layers_pt, n, L);
  

  t_start = usecs();
  sequential_nn(layers_se, n, L);
  t_end = usecs();
  printf("Sequential     time    : %8.2f msec.\n",((double)t_end-t_start)/1000.0);


  t_start = usecs();
  parallel_nn_loops(layers_pl, n, L);
  t_end = usecs();
  printf("Parallel loops time    : %8.2f msec.    ",((double)t_end-t_start)/1000.0);

  check_result(layers_se, layers_pl, n, L);
  

  t_start = usecs();
  parallel_nn_tasks(layers_pt, n, L);
  t_end = usecs();
  printf("Parallel tasks time    : %8.2f msec.    ",((double)t_end-t_start)/1000.0);

  check_result(layers_se, layers_pt, n, L);

  return 0;
  
}


void sequential_nn(layer *layers, int n, int L){
  int i, j, k, l, s;
  
  for(l=0; l<L-1; l++){
    /* printf("layer %2d  m:%2d\n",l,layers[l].m); */
    for(s=0; s<layers[l].m; s++){
      i = layers[l].syn[s].i;
      j = layers[l].syn[s].j;
      /* printf("layer %2d  i:%2d  j:%2d\n",l,i,j); */
      layers[l+1].neu[j].nv += update(layers[l].neu[i].nv, layers[l].syn[s].sv);
    }
  }
}


void parallel_nn_loops(layer *layers, int n, int L){
  int i, j, k, l, s;
  
#pragma omp parallel private(l,i,j,s)
  {
    for(l=0; l<L-1; l++){
      /* printf("layer %2d  m:%2d\n",l,layers[l].m); */
#pragma omp for
      for(s=0; s<layers[l].m; s++){
        i = layers[l].syn[s].i;
        j = layers[l].syn[s].j;
        /* printf("layer %2d  i:%2d  j:%2d\n",l,i,j); */
#pragma omp atomic update
        layers[l+1].neu[j].nv += update(layers[l].neu[i].nv, layers[l].syn[s].sv);
      }
    }
  }
}



void parallel_nn_tasks(layer *layers, int n, int L){
  int i, j, k, l, s;
#pragma omp parallel
  {
#pragma omp single
    {
      for(l=0; l<L-1; l++){
        /* printf("layer %2d  m:%2d\n",l,layers[l].m); */
        for(s=0; s<layers[l].m; s++){
          i = layers[l].syn[s].i;
          j = layers[l].syn[s].j;
          /* printf("layer %2d  i:%2d  j:%2d\n",l,i,j); */
#pragma omp task firstprivate(i,j,l,s) depend(in:layers[l].neu[i]) depend(inout:layers[l+1].neu[j])
          {
            layers[l+1].neu[j].nv += update(layers[l].neu[i].nv, layers[l].syn[s].sv);
          }
        }
      }
    }
  }
}

