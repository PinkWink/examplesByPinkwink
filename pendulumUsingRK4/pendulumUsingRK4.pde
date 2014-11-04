float h = 0.01, t = 0, x = 30*PI/180, v = 0;
float pen_fm = 0.05, pen_m = 0.1, pen_l = 100*0.01, pen_J = 0.02, pen_g = 9.8;

float gndCenterX = 150, gndCenterY =20, penLength = pen_l*100*2;

PFont font;

void setup() {
	size(300,300);  
	font=loadFont("CenturyGothic-12.vlw");	
}

void draw() {
	background(255);
	fill(255);
  	smooth();
  	stroke(50);
	strokeWeight(10);
	line(10,20,290,20);
	stroke(0);
	strokeWeight(3);
	ellipse(gndCenterX,gndCenterY,15,15);

	drawText();

	drawPendulum(x);

	float[] states = solveODEusingRK4(t, x, v);

	delay(10);

	x = states[0];
	v = states[1];
	t = t + h;
}

void drawPendulum(float theta) {
	float updatedX = gndCenterX + penLength*sin(theta);
	float updatedY = gndCenterY + penLength*cos(theta);

	fill(255);
	stroke(150);
	strokeWeight(2);
    line(gndCenterX, gndCenterY, updatedX, updatedY);
    stroke(0);
    ellipse(updatedX, updatedY, 20, 20);
}

float[] solveODEusingRK4(float t, float x, float v){
	float kx1 = v;
	float kv1 = calcODEFunc( t, x, v );
	 
	float kx2 = v + h*kv1/2;
	float kv2 = calcODEFunc( t + h/2, x + h*kx1/2, v + h*kv1/2 );
	 
	float kx3 = v + h*kv2/2;
	float kv3 = calcODEFunc( t + h/2, x + h*kx2/2, v + h*kv2/2 );
	 
	float kx4 = v + h*kv3;
	float kv4 = calcODEFunc( t + h, x + h*kx3, v + h*kv3 );
	 
	float dx = h*(kx1 + 2*kx2 + 2*kx3 + kx4)/6;
	float dv = h*(kv1 + 2*kv2 + 2*kv3 + kv4)/6;
    
    float[] result = {x+dx, v+dv};

    return result;
}

float calcODEFunc(float tVal, float xVal, float vVal) {
	return -pen_fm/(pen_m*pen_l*pen_l+pen_J)*vVal-pen_m*pen_g*pen_l/(pen_m*pen_l*pen_l+pen_J)*xVal;
}

void drawText() {
	fill(50);
	textFont(font);
  	text("by PinkWink",200,280);
}