/*
Universidad de Cundinamarca
Facultad de Ingeniería en Sistemas y Computación
Programación I

Autor: José Alejandro Estrada Castiblanco

Programa que realiza operaciones con matrices y vectores:
- Llenado de matrices
- Producto de matrices
- Producto matriz-vector
- Producto punto
- Transpuesta
- Inversa por método Gauss-Jordan
*/

int dimension = 3;

String salidaTexto = "";

// MATRICES
float[][] matrizPrincipal = new float[dimension][dimension];
float[][] matrizSecundaria = new float[dimension][dimension];

// VECTORES
float[] vectorA = new float[dimension];
float[] vectorB = new float[dimension];

void setup(){

  size(800,600);
  textSize(14);
  fill(0);

  salidaTexto += "==== OPERACIONES CON MATRICES Y VECTORES ====\n\n";

  inicializarDatos();
  ejecutarOperaciones();
}

void draw(){

  background(255);

  float desplazamiento = map(mouseY,0,height,0,-2000);

  text(salidaTexto,20,40 + desplazamiento);
}


// BLOQUE 1: INICIALIZACIÓN DE DATOS


void inicializarDatos(){

  llenarMatrizConteo(matrizPrincipal);
  llenarMatrizAleatoria(matrizSecundaria);

  llenarVectorAleatorio(vectorA);
  llenarVectorAleatorio(vectorB);

  salidaTexto += "Matriz A\n";
  salidaTexto += matrizATexto(matrizPrincipal);

  salidaTexto += "\nMatriz B\n";
  salidaTexto += matrizATexto(matrizSecundaria);

  salidaTexto += "\nVector 1\n";
  salidaTexto += vectorATexto(vectorA);

  salidaTexto += "\nVector 2\n";
  salidaTexto += vectorATexto(vectorB);
}


// BLOQUE 2: OPERACIONES MATEMÁTICAS


void ejecutarOperaciones(){

  salidaTexto += "\nProducto de matrices (A * B)\n";
  float[][] productoMatrices = multiplicarMatrices(matrizPrincipal,matrizSecundaria);
  salidaTexto += matrizATexto(productoMatrices);

  salidaTexto += "\nProducto matriz-vector (A * v1)\n";
  float[] resultadoVector = matrizVector(matrizPrincipal,vectorA);
  salidaTexto += vectorATexto(resultadoVector);

  salidaTexto += "\nProducto punto\n";
  float escalar = productoPunto(vectorA,vectorB);
  salidaTexto += nf(escalar,1,2) + "\n";

  salidaTexto += "\nTranspuesta de A\n";
  float[][] matrizTrans = transpuesta(matrizPrincipal);
  salidaTexto += matrizATexto(matrizTrans);

  salidaTexto += "\nInversa de A\n";
  float[][] matrizInv = inversa(matrizPrincipal);

  if(matrizInv != null)
    salidaTexto += matrizATexto(matrizInv);
  else
    salidaTexto += "La matriz no es invertible\n";
}


// BLOQUE 3: FUNCIONES DE LLENADO


void llenarMatrizConteo(float[][] matriz){

  int valor = 1;

  for(int fila=0; fila<dimension; fila++){
    for(int col=0; col<dimension; col++){

      matriz[fila][col] = valor;
      valor++;
    }
  }
}

void llenarMatrizAleatoria(float[][] matriz){

  for(int fila=0; fila<dimension; fila++){
    for(int col=0; col<dimension; col++){

      matriz[fila][col] = random(1,10);
    }
  }
}

void llenarVectorAleatorio(float[] vector){

  for(int i=0;i<dimension;i++){

    vector[i] = random(1,10);
  }
}


// BLOQUE 4: FUNCIONES DE IMPRESIÓN


String matrizATexto(float[][] matriz){

  String texto = "";

  for(int i=0;i<dimension;i++){

    for(int j=0;j<dimension;j++){

      texto += nf(matriz[i][j],1,2) + "   ";
    }

    texto += "\n";
  }

  return texto;
}

String vectorATexto(float[] vector){

  String texto = "";

  for(int i=0;i<vector.length;i++){

    texto += nf(vector[i],1,2) + "   ";
  }

  texto += "\n";

  return texto;
}


// BLOQUE 5: OPERACIONES CON MATRICES


float[][] multiplicarMatrices(float[][] A, float[][] B){

  float[][] resultado = new float[dimension][dimension];

  for(int fila=0; fila<dimension; fila++){

    for(int col=0; col<dimension; col++){

      float acumulador = 0;

      for(int k=0; k<dimension; k++){

        acumulador += A[fila][k] * B[k][col];
      }

      resultado[fila][col] = acumulador;
    }
  }

  return resultado;
}

float[] matrizVector(float[][] matriz, float[] vector){

  float[] resultado = new float[dimension];

  for(int fila=0; fila<dimension; fila++){

    float suma = 0;

    for(int col=0; col<dimension; col++){

      suma += matriz[fila][col] * vector[col];
    }

    resultado[fila] = suma;
  }

  return resultado;
}

float productoPunto(float[] a, float[] b){

  float suma = 0;

  for(int i=0;i<dimension;i++){

    suma += a[i] * b[i];
  }

  return suma;
}

float[][] transpuesta(float[][] matriz){

  float[][] t = new float[dimension][dimension];

  for(int i=0;i<dimension;i++){

    for(int j=0;j<dimension;j++){

      t[j][i] = matriz[i][j];
    }
  }

  return t;
}


// BLOQUE 6: MÉTODO GAUSS-JORDAN


float[][] inversa(float[][] matriz){

  float[][] extendida = new float[dimension][dimension*2];

  for(int i=0;i<dimension;i++){

    for(int j=0;j<dimension;j++){

      extendida[i][j] = matriz[i][j];
    }

    for(int j=dimension;j<dimension*2;j++){

      if(i == j-dimension)
        extendida[i][j] = 1;
      else
        extendida[i][j] = 0;
    }
  }

  for(int i=0;i<dimension;i++){

    float pivote = extendida[i][i];

    if(pivote == 0)
      return null;

    for(int j=0;j<dimension*2;j++){

      extendida[i][j] /= pivote;
    }

    for(int k=0;k<dimension;k++){

      if(k != i){

        float factor = extendida[k][i];

        for(int j=0;j<dimension*2;j++){

          extendida[k][j] -= factor * extendida[i][j];
        }
      }
    }
  }

  float[][] inversa = new float[dimension][dimension];

  for(int i=0;i<dimension;i++){

    for(int j=0;j<dimension;j++){

      inversa[i][j] = extendida[i][j+dimension];
    }
  }

  return inversa;
}
