#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int media();
int desvio_padrao();

int main(int argc, char* argv[]) {

    int size = atoi(argv[1]);

    int *V = malloc(size*sizeof(int))
    srand(time(NULL));

    for (int i = 0; i < size; i++){
        V[i] = rand();
    }

    free(V);

    return 0;
}

double media(int tamanho, int *V) {
    
    int soma = 0;

    for(int i = 0; i < tamanho; i++) {
        soma += V[i];
    }

    return soma/tamanho;
}

int desvio_padrao(int tamanho, int *V) {

    int somatorio = 0;

    for (int i = 0; i < tamanho; i++) {
        somatorio += pow((V[i] - media(tamanho, V)) ,2);
    }

    return  sqrt(somatorio/tamanho);

}


