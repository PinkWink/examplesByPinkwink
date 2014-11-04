void drawGraphPanel(){
  stroke(ColorOfListBoxForeground);
  strokeWeight(1.5);
  fill(color(255,255,255));
  rect(graphPanelXPos, graphPanelYPos, graphPanelXSize, graphPanelYSize); 
  
  fill(ColorOfBackground);
  rect(selectPanelXPos, selectPanelYPos, selectPanelXSize, selectPanelYSize);
  
  pauseBt.drawButton();
  stopBt.drawButton();
  rollAngBt.drawButton();
  pitchAngBt.drawButton();
  rollAngVelBt.drawButton();
  pitchAngVelBt.drawButton();

  strokeWeight(1);
  for (int i=(graphPanelYPos+panelGridYDivision); 
              i<(graphPanelYPos+graphPanelYSize); i=i+panelGridYDivision) {
    for (int j=(graphPanelXPos+buttonXDiv);
              j<(graphPanelXPos+graphPanelXSize); j=j+buttonXDiv) {
      line(j+panelGridHalfLength, i, j-panelGridHalfLength, i);
      line(j,i+panelGridHalfLength, j, i-panelGridHalfLength);   
    }
  }
    
  int tmpX = graphPanelXPos+graphPanelXSize/10;
  for (int i=0; i<9; i++) {
    line(tmpX-panelGridHalfLength+i*graphPanelXSize/10, graphPanelYCenterPos, 
          tmpX+panelGridHalfLength+i*graphPanelXSize/10, graphPanelYCenterPos);
  }  
}

void drawText() {
  textFont(bigfontText);
  fill(100);  
  text("NT-ARSv1 Monitor",10,35);
  textFont(fontText);
  text("This Processing code is monitoring program for NT-ARSv1",280,51);
  text("NT-ARSv1 Monitoring Ver. 0.80 by PinkWink in NTRexLAB.",280,63);
  //text("by PinkWink in http://pinkwink.kr/",420,75);
  text("x division = 1 second",
    graphPanelXPos+graphPanelXSize/2-50,graphPanelYPos+graphPanelYSize+15);
  for (int i=0; i<7; i++){
    text(graphYLabel[i], graphPanelXPos-20, graphPanelYPos+panelGridYDivision*i+5);
  }
  text("RollAngle", buttonXStartPos+11, buttonYPos+5);
  text("PitchAngle", buttonXStartPos+buttonXDiv+11, buttonYPos+5);
  text("RollAngVel", buttonXStartPos+buttonXDiv*2+11, buttonYPos+5);
  text("PitchAngVel", buttonXStartPos+buttonXDiv*3+11, buttonYPos+5);  
  text("Pause", graphPanelXPos+13, graphPanelYPos-20);
  text("STOP", graphPanelXPos+93, graphPanelYPos-20);    
}
