/**
 * BodyAndWater - MainClass
 * Spatial Interaction Project 2017 - ZHdK IAD15
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

import KinectPV2.*;

// SETTINGS
final static boolean DEBUGGING = true;


// Basic Variables
KinectPV2 kinect;
Silhouette silhouette;
Noise noise;

// States
int currentState;
StateBlood stateBlood;
StateBones stateBones;
StateDigestion stateDigestion;
StateMuscles stateMuscles;
StateWater stateWater;

// Debugging
Debug debug;

void setup() {
	size(1920, 1080, P3D);
	background(0);

	initKinect();
	silhouette = new Silhouette(kinect);
	noise = new Noise();

	// States
	currentState = 0;
	stateBlood = new StateBlood(silhouette);
	stateBones = new StateBones(silhouette);
	stateDigestion = new StateDigestion(silhouette);
	stateMuscles = new StateMuscles(silhouette);
	stateWater = new StateWater(silhouette);

	// Debugging
	debug = new Debug();
}

void draw() {

	background(0);

	silhouette.update();

	// Debugging
	if (DEBUGGING) {
		debug.draw(silhouette);
	}
}

void initKinect() {
	kinect = new KinectPV2(this);

	// Settings
	kinect.enableDepthMaskImg(true);
	kinect.enableSkeletonDepthMap(true);

	kinect.init();
}

void drawKinectImage() {
	// PImage videoImage = kinect.getVideoImage();
	// image(videoImage, 0, 0);
}

int decideState() {




	return 0;
}
