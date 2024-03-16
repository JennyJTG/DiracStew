PVector centerShift, scale, scaledMouseCoords;
FloatList x[];
FloatList y[];
float time, timeInterval = 0.00007;
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
  scale = new PVector(1200, 180);
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
      calcFunction(0, 0, 1, steps);
      renderFunction(0, 255, 0, 0, 255);
      calcFunction(1, 0, 1, steps);
      renderFunction(1, 0, 0, 255, 128);
    }
    calcFunction(2, 0, 1, steps);
    renderFunction(2, 0, 180, 180, 255);
    break;
  case 1:
    if (!hide) {
      calcFunction(3, 0, 1, steps);
      renderFunction(3, 255, 0, 0, 255);
      calcFunction(4, 0, 1, steps);
      renderFunction(4, 0, 0, 255, 128);
    }
    calcFunction(5, 0, 1, steps);
    renderFunction(5, 180, 180, 180, 255);
    break;
  }
  //<keyboard bullshit>
  //show/hide functions
  if (keyTap(92)) hide = !hide;
  //n stuff
  if (keyTap(38)) nUpdate(true);
  if (keyTap(40)) nUpdate(false);
  //m stuff
  if (keyTap(39)) mUpdate(true);
  if (keyTap(37)) mUpdate(false);
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

void calcFunction(int functionIndex, float rangeBegin, float rangeEnd, float steps) {
  x[functionIndex] = new FloatList();
  y[functionIndex] = new FloatList();
  float traverseX = rangeBegin;
  float incrementX = (rangeEnd-rangeBegin)/steps;
  steps++;
  for (int i = 0; i<steps; i++) {
    y[functionIndex].append(-scale.y*(referenceFunctions(functionIndex, traverseX))+centerShift.y);
    x[functionIndex].append(scale.x*traverseX+centerShift.x);
    traverseX+=incrementX;
  }
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
  return(new PVector((mouseX-centerShift.x)/scale.x, -(mouseY-centerShift.y)/scale.y));
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
  timeInterval *= 1+e*0.2;
}
