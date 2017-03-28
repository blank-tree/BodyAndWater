/**
 * BodyAndWater - MainClass
 * Spatial Interaction Project 2017 - ZHdK IAD15
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 import gab.opencv.*;
 import KinectPV2.*;
 import processing.sound.*;

// SETTINGS
final static boolean DEBUGGING = true;


// Basic Variables
KinectPV2 kinect;
Silhouette silhouette;
Noise noise;

// States
int currentState;
StateBlood stateBlood;
// StateBones stateBones;
// StateDigestion stateDigestion;
// StateMuscles stateMuscles;
// StateWater stateWater;

long CURRENT_TIME;

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
	String speechPath = "speech/";
	stateBlood = new StateBlood(new SoundFile(this, speechPath + "blood.mp3"));
	// stateBones = new StateBones(new SoundFile(this, speechPath + "bones.mp3"));
	// stateDigestion = new StateDigestion(new SoundFile(this, speechPath + "digestion.mp3"));
	// stateMuscles = new StateMuscles(new SoundFile(this, speechPath + "muscles.mp3"));
	// stateWater = new StateWater(new SoundFile(this, speechPath + "water.mp3"));

	CURRENT_TIME = 0;

	// Debugging
	debug = new Debug();
}

void draw() {

	CURRENT_TIME = millis();

	background(0);

	kinect.getDepthMaskImage();
	scale(2.54717); // scale from 424 to 1080
	translate(200, 0, 0);

	ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
	int[] rawDepthData = kinect.getRawDepthData();

	// stateBones.draw(skeletonArray, rawDepthData);
	// stateDigestion.draw(skeletonArray, rawDepthData);
	stateBlood.draw(skeletonArray, rawDepthData);

	// Debugging
	if (DEBUGGING) {
		
	}

}

void initKinect() {
	kinect = new KinectPV2(this);

	// Settings
	kinect.enableBodyTrackImg(true);
	kinect.enableDepthMaskImg(true);
	kinect.enableSkeletonDepthMap(true);
	kinect.enableSkeleton3DMap(true);

	kinect.init();
}

void drawKinectImage() {
	// PImage videoImage = kinect.getVideoImage();
	// image(videoImage, 0, 0);
}

int decideState() {




	return 0;
}

