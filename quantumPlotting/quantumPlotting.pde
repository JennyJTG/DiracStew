PVector centerShift, scaled, scaledMouseCoords, onScreen;
FloatList x[];
FloatList y[];
float time, timeInterval = 0.00007;
PVector cam;
int autoPlay = 0;
int n = 1, m = 2, functions = 69, steps = 1500;
boolean hide = false;
int mode = 0;

String[] inputValues;
float probabilityWeightSum;
int eigenIndex;
float[][] eigenNummer;

void setup() {
  size(1500, 800);
  frameRate(120);
  textSize(40);
  eigenSetUp();
  x = new FloatList[functions];
  y = new FloatList[functions];
  centerShift = new PVector(200, height/2);
  onScreen = new PVector(0,1);
  scaled = new PVector(1200, 180);
}

void draw() {
  background(0);
  fill(255);
  text(frameRate, 10, 40);
  text("t: "+time, width-240, 40);
  strokeWeight(1);
  displayGridAxis();
  scaledMouseCoords = mouseCoords();
  text(scaledMouseCoords.x+", "+scaledMouseCoords.y, mouseX, mouseY);
  strokeWeight(3);
  switch(mode) {
  case 0:
    text("n: "+n+"\nm: "+m, width-240, 80);
    if (!hide) {
      calcFunction(0, steps);
      renderFunction(0, 255, 0, 0, 255);
      calcFunction(1, steps);
      renderFunction(1, 0, 0, 255, 128);
    }
    calcFunction(2, steps);
    renderFunction(2, 0, 180, 180, 255);
    break;
  case 1:
    if (!hide) {
      calcFunction(3, steps);
      renderFunction(3, 255, 0, 0, 255);
      calcFunction(4, steps);
      renderFunction(4, 0, 0, 255, 128);
    }
    calcFunction(5, steps);
    renderFunction(5, 180, 180, 180, 255);
    break;
  }
  //<keyboard bullshit>
  //show/hide functions
  if (keyTap(92)) hide = !hide;
  //n stuff
  if (keys[78]&&keyTap(38)) nUpdate(true);
  if (n>0&&keys[78]&&keyTap(40)) nUpdate(false);
  //m stuff
  if (keys[77]&&keyTap(38)) mUpdate(true);
  if (m>0&&keys[77]&&keyTap(40)) mUpdate(false);
  
  if (keys[16]&&keys[37]) shiftCam(-10,0);
  if (keys[16]&&keys[38]) shiftCam(0,-10);
  if (keys[16]&&keys[39]) shiftCam(10,0);
  if (keys[16]&&keys[40]) shiftCam(0,10);
  //time control
  if (keyTap(47)) autoPlay = 0;
  if (keyTap(46)) autoPlay = 1;
  if (keyTap(44)) autoPlay = -1;
  //time control
  if (keyTap(49)) mode = 0;
  if (keyTap(50)) mode = 1;
  //if(keyTap(51)) mode = 2;
  if (keyTap(69)) eigenSetUp();
  //<\keyboard bullshit>
  time+=autoPlay*timeInterval;
}

void shiftCam(float x, float y){
  centerShift.set(centerShift.x-x,centerShift.y-y);
  onScreen.set(max(0,unScalerX(0)),min(1,unScalerX(width)));
}

void eigenSetUp() {
  inputValues = loadStrings("inputValues.txt");
  eigenIndex = inputValues.length;
  probabilityWeightSum = 0;
  eigenNummer = new float[eigenIndex][3];
  for (int i = 0; i<eigenIndex; i++) {
    String str[] = split(inputValues[i], ',');
    eigenNummer[i][0] = float(str[0]);
    eigenNummer[i][1] = float(str[1]);
    probabilityWeightSum+=float(str[1]);
  }
  probabilityWeightSum=sqrt(probabilityWeightSum);
  for (int i = 0; i<eigenIndex; i++) {
    eigenNummer[i][2] = sqrt(eigenNummer[i][1])/probabilityWeightSum;
  }
}

void nUpdate(boolean isIncreasing) {
  n = isIncreasing?n+1:n-1;
}

void mUpdate(boolean isIncreasing) {
  m = isIncreasing?m+1:m-1;
}

boolean keyTap(int index) {
  if (keys[index]&&!keysPressing[index]) keysPressing[index] = true;
  else if (!keys[index]&&keysPressing[index]) {
    keysPressing[index] = false;
    return true;
  }
  return false;
}

void calcFunction(int functionIndex, float steps) {
  x[functionIndex] = new FloatList();
  y[functionIndex] = new FloatList();
  float traverseX = onScreen.x;
  float incrementX = (onScreen.y-onScreen.x)/steps;
  steps++;
  for (int i = 0; i<steps; i++) {
    y[functionIndex].append(scalerY(referenceFunctions(functionIndex, traverseX)));
    x[functionIndex].append(scalerX(traverseX));
    traverseX+=incrementX;
  }
}

float scalerX(float inputX){
  return scaled.x*inputX+centerShift.x;
}

float unScalerX(float inputX){
  return (inputX-centerShift.x)/scaled.x;
}

float scalerY(float inputY){
  return -scaled.y*inputY+centerShift.y;
}

float unScalerY(float inputY){
  return -(inputY-centerShift.y)/scaled.y;
}

void renderFunction(int index, int r, int g, int b, int a) {
  float pastX = x[index].get(0), pastY = y[index].get(0);
  float currentX, currentY;
  stroke(0, 255, 0);
  line(x[index].get(0), 0, x[index].get(0), height);
  fill(r, g, b, a);
  for (int i = 0; i<y[index].size(); i++) {
    currentX = x[index].get(i);
    currentY = y[index].get(i);
    noStroke();
    stroke(r, g, b, a);
    line(currentX, currentY, pastX, pastY);
    pastX = currentX;
    pastY = currentY;
  }
  stroke(0, 255, 0);
  line(x[index].get(x[index].size()-1), 0, x[index].get(x[index].size()-1), height);
}

PVector mouseCoords() {
  return(new PVector(unScalerX(mouseX), unScalerY(mouseY)));
}

void displayGridAxis() {
  stroke(255);
  line(0, centerShift.y, width, centerShift.y);
  line(centerShift.x, 0, centerShift.x, height);
}

PVector cMult(PVector p, PVector q) {
  return new PVector(p.x*q.x-p.y*q.y, p.x*q.y+p.y*q.x);
}

PVector cConj(PVector p) {
  return new PVector(p.x, -p.y);
}

PVector cExp(PVector p) {
  return new PVector(cos(p.y), sin(p.y)).mult(exp(p.x));
}

boolean[] keys = new boolean[256], keysPressing = new boolean[256];
//when a key is pressed set the key to true
void keyPressed() {
  println(key, keyCode);
  keys[keyCode] = true;
}
//when keys are released set the keycode to false
void keyReleased() {
  keys[keyCode] = false;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(!keys[16]){
    timeInterval *= 1+e*0.2;
  }else{
    float scaleChange = 1+e*0.1;
    scaled.set(scaled.x*scaleChange,scaled.y*scaleChange);
    onScreen.set(max(0,unScalerX(0)),min(1,unScalerX(width)));
    println(max(0,unScalerX(0)),min(1,unScalerX(width)));
  }
}