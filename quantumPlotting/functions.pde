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
    for(int i = 0; i<eigenIndex; i++){
      sumRe+=eigenNummer[i][2]*cos(sq(eigenNummer[i][0])*sq(PI)*time/2)*sin(eigenNummer[i][0]*PI*x);
    }
    return sumRe;
  case 4:
    float sumIm = 0;
    for(int i = 0; i<eigenIndex; i++){
      sumIm-=eigenNummer[i][2]*sin(sq(eigenNummer[i][0])*sq(PI)*time/2)*sin(eigenNummer[i][0]*PI*x);
    }
    return sumIm;
  case 5:
    return sq(referenceFunctions(3, x))+sq(referenceFunctions(4, x));
    //return complexFunctions(x).x;
  default:
    return -1;
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
