import processing.serial.*;

float maxX=3;
float maxY=maxX*(height/(float)width);
float radius=1;
boolean clicked;
float[] x;
float[] y;
float[] a;
float[] range;
int i=0, maxPoints=7, maxRange=5000;

void setup(){
  size(800,800);
  noStroke();
  fill(0,0,0);
  frameRate(30);
  
  clicked=false;
  x=new float[maxPoints];
  y=new float[maxPoints];
  a=new float[maxPoints];
  range=genRange(0, width, (float)width/maxRange);
  
  for(int i=0;i<maxPoints;++i) a[i]=0;
  //Print(a);
  //Print(range);
  //println("maxX: "+maxX+", maxY: "+maxY);
}

void draw(){
  background(225,225,225);
  for(int i=0;i<x.length;++i) drawPoint(x[i]*(float)width/maxX, y[i]*(float)height/maxY, 5);
  if(isClicked()){
    a=solveMat(x,y,i);
    //Print(a);
  }
  drawFunc(a,range);
}

boolean isClicked(){
  if(mousePressed==false && clicked){
    clicked=false;
    return true;
  }
  return false;
}

void mouseClicked(){
  if(i>=maxPoints) for(;i!=0;) x[--i]=y[i]=0;
  x[i]=mouseX/(float)width*maxX;
  y[i++]=mouseY/(float)height*maxY;
  //println("\n"+x[i-1]+", "+y[i-1]);
  clicked=true;
}

float[] solveMat(float[] x, float[] y, int count){
  float[] a=new float[x.length];
  float[][] mat=createMat(x,y,count);
  
  //println("\nMatrix:");
  //printMat(mat);
  
  for(int i=0;i<count;++i){
    divMat(mat[i][i], mat, i);
    for(int j=i+1;j<count;++j){
      divMat(mat[j][i], mat, j);
      sbtrMat(j, i, mat);
      mat[j][i]=0;
    }
  }
  
  //println("\nInt Matrix:");
  //printMat(mat);
  
  for(int i=count-1;i>=0;--i){
    for(int j=i-1;j>=0;--j){
      mulMat(mat[j][i]/mat[i][i], mat, i);
      sbtrMat(j, i, mat);
      mat[j][i]=0;
    }
    divMat(mat[i][i], mat, i);
  }
  
  //println("\nResult Matrix:");
  //printMat(mat);
  
  for(int i=0;i<count;++i) a[i]=mat[count-1-i][count];
  
  return a;
}

float[][] createMat(float[] x, float[] y, int count){
  float[][] mat=new float[count][count+1];
  int maxP=count-1;
  
  for(int i=0;i<count;++i){
    for(int j=0;j<count;++j) mat[i][j]=pow(x[i],maxP-j);
    mat[i][count]=y[i];
  }
  
  return mat;
}

void mulMat(float val, float[][] mat, int row){
  for(int col=0;col<mat[0].length;++col) mat[row][col]*=val;
}

void addMat(int r, int r2, float[][] mat){
  for(int col=0;col<mat[0].length;++col) mat[r][col]+=mat[r2][col];
}

void divMat(float val, float[][] mat, int row){
  if(val!=0) mulMat(1.0/val, mat, row);
}

void sbtrMat(int r, int r2, float[][] mat){
  for(int col=0;col<mat[0].length;++col) mat[r][col]-=mat[r2][col];
}

void drawFunc(float[] a, float[] x){
  int count=x.length;
  float[] y=new float[count];
  
  for(int i=0;i<count;++i){
    y[i]=calc(x[i]/(float)width*maxX, a);
    drawPoint(x[i],y[i]*(float)height/maxY,radius);
  }
}

float[] genRange(float beg, float end, float step){
  int count=(int)((end-beg)/step);
  float[] range=new float[count+1];
  
  for(int i=0;i<=count;++i) range[i]=beg+i*step;
  
  return range;
}

void drawPoint(float x, float y, float r){
  if(x<=width && y<=height &&
     x>=0 && y>=0) ellipse(x,y,r,r);
}

float calc(float x, float[] a){
  float res=0;
  
  for(int i=0;i<a.length;++i){
    if(a[i]!=0) res+=a[i]*pow(x,i);
  }
  
  return res;
}

void printMat(float[][] mat){
  for(int i=0;i<mat.length;++i){
    Print(mat[i]);
    println();
  }
}

void Print(float[] data){
  for(int i=0;i<data.length;++i) print(data[i]+"\t\t");
}
