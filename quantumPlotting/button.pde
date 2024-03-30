boolean AABB(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) return true;
  return false;
}

boolean AABB(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) return true;
  return false;
}



class button {
  int x, y, w, h;
  int r = 255, g = 0, b = 0, a = 255;
  int rHover = 255, gHover = 50, bHover = 50;
  PImage texture;
  String text = "";
  int strX, strY;
  boolean hover, clicked;


  button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    strX = x;
    strY = y+h;
  }

  /**
   *displays the button
   *
   */

  void displayImg() {
    display();
    image(texture, x, y);
  }

  void display() {
    fill(r, g, b, a);
    if (hover) fill(rHover, gHover, bHover, a);
    rect(x, y, w, h);
    fill(0);
    textSize(40);
    text(text, strX, strY);
  }

  void enable() {
    hover = AABB(x, y, w, h);
  }

  void disable() {
    hover = false;
    clicked = false;
  }

  boolean click() {
    if (hover&&mousePressed&&!clicked) {
      clicked = true;
    } else if (hover&&!mousePressed&&clicked) {
      clicked = false;
      return true;
    }
    return false;
  }
  
  boolean click(int i) {
    if (hover&&mousePressed&&mouseButton == i&&!clicked) {
      clicked = true;
    } else if (hover&&!mousePressed&&!(mouseButton == i)&&clicked) {
      clicked = false;
      return true;
    }
    return false;
  }

  void setPosition(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void setSize(int w, int h) {
    this.w = w;
    this.h = h;
  }

  void setText(String text) {
    this.text = text;
  }

  void setText(String text, int strX, int strY) {
    this.text = text;
    this.strX = strX;
    this.strY = strY;
  }

  void setColour(int l) {
    this.r = l;
    this.g = l;
    this.b = l;
    if (l>128) setHoverColour(l-50);
    else setHoverColour(l+50);
  }

  void setColour(int l, int a) {
    this.r = l;
    this.g = l;
    this.b = l;
    this.a = a;
    if (l>128) setHoverColour(l-50);
    else setHoverColour(l+50);
  }

  void setColour(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
    if (r+g+b>384) setHoverColour(r-50, g-50, b-50);
    else setHoverColour(r+50, g+50, b+50);
  }

  void setColour(int r, int g, int b, int a) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
    if (r+g+b>384) setHoverColour(r-50, g-50, b-50);
    else setHoverColour(r+50, g+50, b+50);
  }

  void setHoverColour(int l) {
    this.rHover = l;
    this.gHover = l;
    this.bHover = l;
  }

  void setHoverColour(int rHover, int gHover, int bHover) {
    this.rHover = rHover;
    this.gHover = gHover;
    this.bHover = bHover;
  }

  void setTexture(PImage texture) {
    this.texture = texture;
  }
}
