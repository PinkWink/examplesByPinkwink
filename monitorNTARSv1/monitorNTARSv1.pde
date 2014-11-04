/* ****************************************************************************
This program is monitoring program of NT-ARSv1 made by NTRexLAB.
The commercial web-page of NT-ARSv1 is http://ntrexgo.com
In NT-ARSv1, commands are as follows:
  <CAO> : to get data at once
  <CAH> : to get data continuously at 10ms intervals
  <CAE> : to stop recieving data.
And incomming data is organized as follows:
  <Roll angle, Pitch angle, Roll angular velocity, Pitch angular velocit>.
The NT-ARSv1's output data are multiplying 1000 times after expressed radians.   

                                                by PinkWink in NTRexLAB
**************************************************************************** */

import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial arsPort;

DropdownList l;
ArsButtons pauseBt, stopBt, rollAngBt, pitchAngBt, rollAngVelBt, pitchAngVelBt;

int graphPanelXPos = 110;
int graphPanelYPos = 100;
int graphPanelXSize = 500;
int graphPanelYSize = 240;
int graphPanelYCenterPos = graphPanelYPos+graphPanelYSize/2; 
int panelGridHalfLength = 15;
int panelGridYDivision = graphPanelYSize/6;
int selectPanelXPos = graphPanelXPos;
int selectPanelYPos = graphPanelYPos+graphPanelYSize+40;
int selectPanelXSize = graphPanelXSize;
int selectPanelYSize = panelGridYDivision;
int buttonXStartPos = graphPanelXPos+60;
int buttonYPos = selectPanelYPos+selectPanelYSize/2;
int buttonXDiv = selectPanelXSize/5;

float resizingYSize = float(graphPanelYSize)/180;
float resizingAngVelYSize = float(graphPanelYSize)/1000;

float[] rollAng = new float[graphPanelXSize];
float[] pitchAng = new float[graphPanelXSize];
float[] rollAngVel = new float[graphPanelXSize];
float[] pitchAngVel = new float[graphPanelXSize];

String availablePort[];
String connectPort;

String[] graphYLabel = {"90", "60", "30", " 0", "-30", "-60", "-90"};

boolean arsConnection = false;

PFont fontText, bigfontText;

color ColorOfBackground = color(245,245,245);
color ColorOfListBoxBackground = color(190,190,190);
color ColorOfListBoxActive = color(150,150,150);
color ColorOfListBoxForeground = color(150,150,150);
color ColorOfListBoxSetColor = color(100,100,100);
color ColorOfRollAngLine = color(255,0,0);
color ColorOfPitchAngLine = color(0,255,0);
color ColorOfRollAngVelLine = color(255,100,0);
color ColorOfPitchAngVelLine = color(100,255,0);

void setup() {
  size(650, 450);
  
  fontText = loadFont("CenturyGothic-12.vlw");
  bigfontText = loadFont("CenturyGothic-32.vlw");
  
  pauseBt = new ArsButtons(graphPanelXPos, graphPanelYPos-30, false, "rec");
  stopBt = new ArsButtons(graphPanelXPos+80, graphPanelYPos-30, false, "rec");
  rollAngBt = new ArsButtons(buttonXStartPos, buttonYPos, true, "ell");
  pitchAngBt = new ArsButtons(buttonXStartPos+buttonXDiv, buttonYPos, true, "ell");
  rollAngVelBt = new ArsButtons(buttonXStartPos+buttonXDiv*2, buttonYPos, false, "ell");
  pitchAngVelBt = new ArsButtons(buttonXStartPos+buttonXDiv*3, buttonYPos, false, "ell");
  
  cp5 = new ControlP5(this);
  l = cp5.addDropdownList("AvailablePorts");
    
  comPortList(l);
}

void draw() {
  background(ColorOfBackground);
  drawGraphPanel();
  drawText();
  drawGraph();
}

void mousePressed(){
  if(mouseButton==LEFT){
    if(rollAngBt.isButtonClicked(mouseX, mouseY, 10)) {
      rollAngBt.buttonClick(); }
    if(pitchAngBt.isButtonClicked(mouseX, mouseY, 10)) {
      pitchAngBt.buttonClick(); }
    if(rollAngVelBt.isButtonClicked(mouseX, mouseY, 10)) {
      rollAngVelBt.buttonClick(); }
    if(pitchAngVelBt.isButtonClicked(mouseX, mouseY, 10)) {
      pitchAngVelBt.buttonClick(); }
    if(pauseBt.isButtonClicked(mouseX, mouseY, 10)) {
      pauseBt.buttonClick(); }
    if(stopBt.isButtonClicked(mouseX, mouseY, 10)) {
      if(stopBt.buttonClicked) {
        stopBt.buttonClick();
        arsPort.write("<CAH>");
        delay(20);
      }else {
        stopBt.buttonClick(); 
        arsPort.write("<CAE>");
        delay(20);
      }
    }
  }
}

void drawGraph() {
  noFill();  
  if (rollAngBt.buttonClicked) {
    stroke(ColorOfRollAngLine);
    strokeWeight(2);
    beginShape();
      for (int xPos=0; xPos<rollAng.length; xPos++) {
        float tmp = saturatingValue(rollAng[xPos], 90);        
        vertex(xPos+graphPanelXPos, graphPanelYCenterPos - tmp*resizingYSize);
      }
    endShape();
  }
  if (pitchAngBt.buttonClicked) {
    stroke(ColorOfPitchAngLine);
    strokeWeight(2);
    beginShape();
      for (int xPos=0; xPos<pitchAng.length; xPos++) {
        float tmp = saturatingValue(pitchAng[xPos], 90); 
        vertex(xPos+graphPanelXPos, graphPanelYCenterPos - tmp*resizingYSize);
      }
    endShape();
  }
  if (rollAngVelBt.buttonClicked) {
    stroke(ColorOfRollAngVelLine);
    strokeWeight(1);
    beginShape();
      for (int xPos=0; xPos<rollAngVel.length; xPos++) {
        float tmp = saturatingValue(rollAngVel[xPos], 500);
        vertex(xPos+graphPanelXPos, graphPanelYCenterPos - tmp*resizingAngVelYSize);
      }
    endShape();
  }
  if (pitchAngVelBt.buttonClicked) {
    stroke(ColorOfPitchAngVelLine);
    strokeWeight(1);
    beginShape();
      for (int xPos=0; xPos<pitchAngVel.length; xPos++) {
        float tmp = saturatingValue(pitchAngVel[xPos], 500);
        vertex(xPos+graphPanelXPos, graphPanelYCenterPos - tmp*resizingAngVelYSize);
      }
    endShape();
  }
}

void serialEvent(Serial p) {
  String arsValues = "";
  
  arsValues = arsPort.readStringUntil(10);
  if (!pauseBt.buttonClicked && (arsValues != null)) {
      calAngles(arsValues);
  }  
}

float saturatingValue(float target, float limitValue) {
  float resizingResult;
  float tmp = abs(target);
  if (tmp>limitValue) {
    resizingResult = target/tmp*limitValue;
  } else {
    resizingResult = target;
  }        
  return resizingResult;
}

void calAngles(String s) {
  int lastPosInString = s.indexOf('>');
  s = s.substring(1, lastPosInString);
  
  int arsResultArray[] = int(split(s, ','));
  
  rollAng = subset(rollAng, 1);
  pitchAng = subset(pitchAng, 1);
  rollAngVel = subset(rollAngVel, 1);
  pitchAngVel = subset(pitchAngVel, 1);
  
  rollAng = append(rollAng, float(arsResultArray[0])*0.001*180/PI);
  pitchAng = append(pitchAng, float(arsResultArray[1])*0.001*180/PI);
  rollAngVel = append(rollAngVel, float(arsResultArray[2])*0.001*180/PI);
  pitchAngVel = append(pitchAngVel, float(arsResultArray[3])*0.001*180/PI);   
}

void controlEvent(ControlEvent theEvent) {
  
  if (theEvent.isGroup() && theEvent.name().equals("AvailablePorts")){
    int connectPortNo = (int)theEvent.group().getValue();
    connectPort = availablePort[connectPortNo];
  }
  if (!arsConnection) { 
    arsPort = new Serial(this, connectPort, 115200); 
    arsConnection = true;
  }
  
  delay(100);  
  arsPort.write("<CAH>");    
}

void comPortList(DropdownList ddl) {
  availablePort = arsPort.list();
  
  ddl.setPosition(10, 70);
  ddl.setSize(80, 60);
  ddl.setItemHeight(15);
  ddl.setBarHeight(15);
  ddl.setColorBackground(ColorOfListBoxBackground);
  ddl.setColorActive(ColorOfListBoxActive);
  ddl.setColorForeground(ColorOfListBoxForeground);
  ddl.setValue(0);
  ddl.captionLabel().toUpperCase(true);
  ddl.captionLabel().set("AvailablePorts");
  ddl.captionLabel().setColor(ColorOfListBoxSetColor);  
  ddl.captionLabel().style().marginTop = 3;
  ddl.valueLabel().style().marginTop = 3; 
  
  for (int i=0; i<availablePort.length; i++) {
    l.addItem(availablePort[i], i);
  }
}
