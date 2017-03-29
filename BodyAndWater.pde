/**
 * BodyAndWater - MainClass
 * Spatial Interaction Project 2017 - ZHdK IAD15
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 import gab.opencv.*;
 import KinectPV2.*;
 import ddf.minim.*;

// SETTINGS
final static boolean DEBUGGING = true;

// Calibration
final static float DISTANCE_STEP = 350;
final static float MIN_DISTANCE = 2400;

// Basic Variables
KinectPV2 kinect;
Silhouette silhouette;
Noise noise;
Minim MINIM;

// States
int currentState;
StateBlood stateBlood;
StateBones stateBones;
StateDigestion stateDigestion;
StateMuscles stateMuscles;
StateWater stateWater;

float globalScale;

long CURRENT_TIME;

void setup() {
	// size(1920, 1080, P3D);
	fullScreen(P3D, 1);
	background(0);

	globalScale = 1;

	initKinect();
	silhouette = new Silhouette(new OpenCV(this, 512, 424));
	noise = new Noise();

	MINIM = new Minim(this);

	// States
	currentState = 0;
	String speechPath = "speech/";
	stateBlood = new StateBlood(speechPath + "blood.mp3");
	stateBones = new StateBones(speechPath + "bones.mp3");
	stateDigestion = new StateDigestion(speechPath + "digestion.mp3");
	stateMuscles = new StateMuscles(speechPath + "muscles.mp3");
	stateWater = new StateWater(speechPath + "water.mp3");

	CURRENT_TIME = 0;
}

void draw() {

	CURRENT_TIME = millis();

	background(0);

	// Debugging
	if (DEBUGGING) {
		noStroke();
		fill(255);
		rect(10, 10, 150, 50);
		stroke(255);
		fill(0);
		textSize(12);
		text("Framerate: " + frameRate, 15, 30);
	}

	kinect.getBodyTrackImage();

	// translate(310, 0);
	scale(2.54717); // scale from 424 to 1080
	// translate(310, 0);

	scale(globalScale);
	float exp = map(globalScale, 0.6, 2, 2.7, 1);
	translate(-pow( 4, exp), 0);

	ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
	int[] rawDepthData = kinect.getRawDepthData();

	stateHandler(skeletonArray, rawDepthData);

	silhouette.draw(kinect);
	stateBlood.draw(skeletonArray, rawDepthData);
	stateBones.draw(skeletonArray, rawDepthData);
	stateDigestion.draw(skeletonArray, rawDepthData);
	stateMuscles.draw(skeletonArray, rawDepthData);
	stateWater.draw(skeletonArray, rawDepthData);

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

void stateHandler(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
	if (skeletonArray.size() > 0) {
		KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
		if (skeleton.isTracked()) {
			KJoint[] joints = skeleton.getJoints();

			int distance = rawDepthData[
				min(
					max(int(joints[KinectPV2.JointType_SpineMid].getY()) * 512 + int(joints[KinectPV2.JointType_SpineMid].getX()), 
					0), 
				rawDepthData.length-1)];
				println(distance);

			if (distance < DISTANCE_STEP * 5 + MIN_DISTANCE && distance > DISTANCE_STEP * 4 + MIN_DISTANCE) {
				deactiveAllStates();
				stateWater.stateActive = true;
				println("State Water");
			} else if (distance < DISTANCE_STEP * 4 + MIN_DISTANCE && distance > DISTANCE_STEP * 3 + MIN_DISTANCE) {
				deactiveAllStates();
				stateMuscles.stateActive = true;
				silhouette.active = true;
				println("State Muscles");
			} else if (distance < DISTANCE_STEP * 3 + MIN_DISTANCE && distance > DISTANCE_STEP * 2 + MIN_DISTANCE) {
				deactiveAllStates();
				stateDigestion.stateActive = true;
				silhouette.active = true;
				println("State Digestion");
			} else if (distance < DISTANCE_STEP * 2 + MIN_DISTANCE && distance > DISTANCE_STEP + MIN_DISTANCE) {
				deactiveAllStates();
				stateBlood.stateActive = true;
				silhouette.active = true;
				println("State Blood");
			} else if (distance < DISTANCE_STEP + MIN_DISTANCE && distance > MIN_DISTANCE) {
				deactiveAllStates();
				stateBones.stateActive = true;
				silhouette.active = true;
				println("State Bones");
			} else {
				deactiveAllStates();
				silhouette.active = true;
			}

		globalScale = map(distance, 1500, 4000, 0.6, 2);

		} else {
			deactiveAllStates();
		}
	} else {
		deactiveAllStates();
	}

}

void deactiveAllStates() {
	stateBlood.stateActive = false; 
	stateBones.stateActive = false;
	stateDigestion.stateActive = false; 
	stateMuscles.stateActive = false; 
	stateWater.stateActive = false;
	silhouette.active = false;
}

