import papaya.*;

float[][] y0 = {{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1}};

float theta = 30*3.14/180;
float a = 100;

void setup() {
	size(60,60);
	noLoop();
}

void draw() {
	float[][] T = Mat.multiply(RotZ(theta), TransX(a));

	float[][] yT = Mat.multiply(T, y0);

	println("Original Matrix == >");
	Mat.print(y0, 2);
	println("--------------------");
	println("transform Matrix == >");
	Mat.print(yT, 2);
}

float[][] RotZ(float theta) {
	return new float[][]{{cos(theta), -sin(theta), 0,0},{sin(theta), cos(theta), 0,0},{0,0,1,0},{0,0,0,1}};
}

float[][] TransX(float a) {
	return new float[][]{{1,0,0,a},{0,1,0,0},{0,0,1,0},{0,0,0,1}};
}