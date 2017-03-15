/**
 * BodyAndWater - MainClass
 * Spatial Interaction Project 2017 - ZHdK IAD15
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

import org.openkinect.processing.*;

// Basic Variables
Kinect2 kinect;
Silhouette silhouette;
Noise noise;

// States
int currentState;
StateBlood stateBlood;
StateBones stateBones;
StateDigestion stateDigestion;
StateMuscles stateMuscles;
StateWater stateWater;

void setup() {
	size(1920, 1080, P3D);
	background(0);

	initKinect();
	silhouette = new Silhouette();
	noise = new Noise();

	// States
	currentState = 0;
	stateBlood = new StateBlood(silhouette);
	stateBones = new StateBones(silhouette);
	stateDigestion = new StateDigestion(silhouette);
	stateMuscles = new StateMuscles(silhouette);
	stateWater = new StateWater(silhouette);
}

void draw() {
	
}

void initKinect() {
	kinect = new Kinect2(this);
	kinect.initDevice();
	kinect.initVideo();
	kinect.initDevice();
}

void drawKinectImage() {
	PImage videoImage = kinect.getVideoImage();
	image(videoImage, 0, 0);
}