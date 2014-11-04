class ArsButtons {
  int posX, posY;
  String type;
  boolean buttonClicked;    
  color ColorOfClickedButton = color(150,150,150);    
  
  ArsButtons(int tmpX, int tmpY, boolean initValue, String tmpType) {
    buttonClicked = initValue;
    posX = tmpX;
    posY = tmpY;
    type = tmpType;
    
    drawButton();
  }
  
  boolean isButtonClicked(int X, int Y, int buttonArea) {
    boolean buttonClickedResult = false;
    
    if (type=="rec") {
      if(X<(posX+buttonArea) && X>posX && Y<(posY+buttonArea) && Y>posY) {
        buttonClickedResult = true; }
    } else if (type=="ell") {      
      if(X<(posX+buttonArea/2) && X>(posX-buttonArea/2) 
          && Y<(posY+buttonArea/2) && Y>(posY-buttonArea/2)) {
            buttonClickedResult = true; }
    }
    return buttonClickedResult;
  }
  
  void buttonClick() {
    if (buttonClicked) {
      buttonClicked = false;
    } else {
      buttonClicked = true;
    }
  }  
  
  void drawButton() {
    fill(ColorOfBackground);
    if (type=="rec") {
      rect(posX, posY, 10, 10);
      if (buttonClicked) { fill(ColorOfClickedButton); } 
      else { fill(ColorOfBackground); } 
      rect(posX+2, posY+2, 6, 6);
    } else if (type=="ell") {      
      ellipse(posX, posY, 10, 10);
      if (buttonClicked) { fill(ColorOfClickedButton); } 
      else { fill(ColorOfBackground); }
      ellipse(posX, posY, 6, 6);
    } 
  }
}