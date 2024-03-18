float referenceFunctions(int index, float x) {
  switch(index) {
  case 0:
    return cos(sq(n)*sq(PI)*time/2)*sin(n*PI*x)+cos(sq(m)*sq(PI)*time/2)*sin(m*PI*x);
  case 1:
    return -(sin(sq(n)*sq(PI)*time/2)*sin(n*PI*x)+sin(sq(m)*sq(PI)*time/2)*sin(m*PI*x));
  case 2:
    float waveSum = sq(referenceFunctions(0, x))+sq(referenceFunctions(1, x));
    return n==m?waveSum/2:waveSum;
  case 3:
    float sumRe = 0;
    for (int i = 0; i<eigenIndex; i++) {
      sumRe+=eigenNummer[i][2]*cos(sq(eigenNummer[i][0])*sq(PI)*time/2)*sin(eigenNummer[i][0]*PI*x);
    }
    return sumRe;
  case 4:
    float sumIm = 0;
    for (int i = 0; i<eigenIndex; i++) {
      sumIm-=eigenNummer[i][2]*sin(sq(eigenNummer[i][0])*sq(PI)*time/2)*sin(eigenNummer[i][0]*PI*x);
    }
    return sumIm;
  case 5:
    return sq(referenceFunctions(3, x))+sq(referenceFunctions(4, x));
  case 6:
    float sumReals = 0;
    for (int i = 0; i<eigenIndex; i++) {
      sumReals += eigenNummer[i][2]*Hermite(int(eigenNummer[i][0]), x)*cos((eigenNummer[i][0]+0.5)*time)/sqrt(pow(2, eigenNummer[i][0])*factorial(int(eigenNummer[i][0])));
    }
    return exp(-sq(x)/2)/pow(PI,0.25)*sumReals;
  case 7:
    float sumImaginary = 0;
    for (int i = 0; i<eigenIndex; i++) {
      sumImaginary -= eigenNummer[i][2]*Hermite(int(eigenNummer[i][0]), x)*sin((eigenNummer[i][0]+0.5)*time)/sqrt(pow(2, eigenNummer[i][0])*factorial(int(eigenNummer[i][0])));
    }
    return exp(-sq(x)/2)/pow(PI,0.25)*sumImaginary;
  case 8:
    return sq(referenceFunctions(6, x))+sq(referenceFunctions(7, x));
  case 9:
    return sq(x)/2;
  case 30:
    return complexFunctions(x).x;
  default:
    return -1;
  }
}

int factorial(int i) {
  if(i <= 1) return 1;
  return i*factorial(i-1);
}

float Hermite(int degree, float x) {
  if(degree==0){
      return 1;
  }else if(degree==1){
      return 2*x;
  }else{
      return 2*x*Hermite(degree-1,x)-2*(degree-1)*Hermite(degree-2,x);
  }
}

PVector complexFunctions(float x) {
  PVector complexAnswer = new PVector(0, 0);
  for (int i = 0; i<eigenIndex; i++) {
    for (int j = 0; j<eigenIndex; j++) {
      PVector imaginaryPart = new PVector(0, sq(PI)*(sq(eigenNummer[i][0])-sq(eigenNummer[j][0]))*time/2);
      complexAnswer.add(cExp(imaginaryPart).mult(eigenNummer[i][2]*eigenNummer[j][2]*sin(eigenNummer[i][0]*PI*x)*sin(eigenNummer[j][0]*PI*x)));
    }
  }
  return complexAnswer;
}
