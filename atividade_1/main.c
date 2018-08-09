#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <errno.h>
#include <fenv.h>

double media();
double desvio();


double media(int* V ,int tamanho) {
    
    int soma = 0;

    for(int i = 0; i < tamanho; i++) {
        soma += V[i];
    }

    return soma/tamanho;
}

double desvio(int* V, int tamanho) {

    int somatorio = 0;
    double auxMedia = media(V, tamanho);

    for (int i = 0; i < tamanho; i++) {
        somatorio += pow((V[i] - auxMedia) ,2);
    }

    return  sqrt(somatorio/tamanho);

}
int main(int argc, char* argv[]) {

    int* V = calloc(0, sizeof(int));

    if(argc == 1){
        
    }
    else {
        int size = atoi(argv[1]);
        V = realloc(V, size*sizeof(int));
        srand(time(0));

        printf("V = { ");
        for (int i = 0; i < size; i++){
            V[i] = rand() % 100;
            printf("%d ", V[i]);
        }
        printf("}\n ");

        printf("MEDIA = %f\n", media(V, size));
        printf("DESVIO PADRÃO = %f\n", desvio(V, size));
    }
    free(V);

    return 0;
}


