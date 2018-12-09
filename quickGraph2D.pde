PFont f;
boolean pressed=false;
float[] currentPoints = new float[100];
float[] points;
float[] coefs;
int n_terms;
int n_inputs=0;

float[][] matrix;
int n_row, n_col;

int x=3, y=3;

void setup() {
  size(420, 420);  // 640, 480
  background(255);
  f=createFont("Arial", 12, true);
}

void draw() {
  
  if(pressed) {
    getPoints(3, 1, 100);
    currentPoints[2*n_inputs]=x;
    currentPoints[2*n_inputs+1]=y;
    ++n_inputs;
    //printCurrentPoints(currentPoints, 2*n_inputs);
    
    fill(255,0,0);
    ellipse(x, y, 5, 5);
    pressed=false;
    fill(125, 125, 125);
    textFont(f, 12);
    text("("+x+", "+y+")", x, y);
    x+=5; y+=5;
    initMatrix(currentPoints, 2*n_inputs);
    printCoefs();
    update(100);
  }
}

void mousePressed() {
  pressed=true;
}

void update(int n) {
  for(int i=0;i<n;i+=2){
    ellipse(points[i], points[i+1], 3, 3);
  }
}

void getPoints(float x, float dx, int n) {
  points = new float[2*n];
  int index=0;
  for(int nb=0;nb<n;++nb, index+=2) {
    points[index]=x+nb*dx;
    points[index+1]=getY(points[index]);
    //println(points[index]+", "+points[index+1]);
  }
}

float getY(float x) {
  float y=0;
  for(int nterm=0;nterm<n_row;++nterm) {
    y+=(coefs[n_row-1-nterm]*pow(x,nterm));
  }
  
  return y;
}

void printCurrentPoints(float[] currentPoints, int n) {
  println("Printing current points : ");
  for(int i=0;i<n;i+=2) {
    println(currentPoints[i]+", "+currentPoints[i+1]);
  }
}

void printCoefs() {
  println("Printing current coefficients : ");
  for(int i=0;i<n_row;++i) {
    print(coefs[i]+" ");
  }
  print("\n");
}

// Equation

void initMatrix(float[] points, int n) {
  n_row=n/2;
  n_col=n/2+1;
  matrix = new float[n_row][n_col];
  coefs = new float[n_row];
  
  for(int i=0;i<n/2;++i) {
    for(int j=0;j<n/2;++j) {
      matrix[i][j]=pow(points[2*i],n/2-1-j);
    }
    matrix[i][n/2]=points[2*i+1];
  }
  //printMatrix();
  solveMatrix();
  //printMatrix();
  //println("===== EOC =====");
}

void solveMatrix() {
  for(int j=0;j<n_col-1;++j) {
    for(int i=j;i<n_row;++i) {
      divRow(i, matrix[i][j]);
    }
    multRow(j, -1);
    for(int i=j;i<n_row-1;++i) {
      addRow(i+1, j);
    }
    multRow(j, -1);
    //println("In the process..");
    //printMatrix();
  }
  //println("Last step print : ");
  //printMatrix();
  for(int i=0;i<n_row;++i) {
    for(int j=0;j<n_col-2-i;++j) {
      multRow(n_row-1-i, -1*matrix[n_row-2-i-j][n_row-1-i]/matrix[n_row-1-i][n_row-1-i]);
      addRow(n_row-2-i-j, n_row-1-i);
      //println("   (1)In the process..");
      //printMatrix();
    }
    //println("In the process..");
    //printMatrix();
    divRow(n_row-1-i, matrix[n_row-1-i][n_row-1-i]);
  }
  for(int i=0;i<n_row;++i) {
    coefs[i]=matrix[i][n_col-1];
  }
}

void addRow(int row1, int row2) {
  for(int i=0;i<n_col;++i) {
    matrix[row1][i]+=matrix[row2][i];
  }
}

void divRow(int row1, float coef) {
  for(int i=0;i<n_col;++i) {
    matrix[row1][i]/=coef;
  }
}

void multRow(int row1, float coef) {
  for(int i=0;i<n_col;++i) {
    matrix[row1][i]*=coef;
  }
}

void printMatrix() {
  println("Printing the current matrix : ");
  for(int i=0;i<n_row;++i) {
    for(int j=0;j<n_col;++j) {
      print(matrix[i][j]+" ");
    }
    print("\n");
  }
}
