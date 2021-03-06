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
final static int STATE_CHANGE_DELAY = 1000; // 1sec

// Calibration
final static float DISTANCE_STEP = 300;
final static float MIN_DISTANCE = 2400;

float THE_CONSTANT = 2.58;

// Basic Variables
KinectPV2 kinect;
Silhouette silhouette;
Noise noise;
Minim MINIM;

// States
int currentState;
int lastState;
StateBlood stateBlood;
StateBones stateBones;
StateDigestion stateDigestion;
StateMuscles stateMuscles;
StateWater stateWater;

// State handler
long lastStateChange;

float globalScale;

long CURRENT_TIME;

void setup() {
	// size(1920, 1080, P3D);
	fullScreen(P3D, 1);
	background(0);

	globalScale = 1;

	lastStateChange = 0;

	initKinect();
	silhouette = new Silhouette(new OpenCV(this, 512, 424));
	noise = new Noise();

	MINIM = new Minim(this);

	// States
	currentState = 0;
	lastState = 0;
	String speechPath = "speech/";
	stateBlood = new StateBlood(speechPath + "blood.mp3");
	stateBones = new StateBones(speechPath + "bones.mp3");
	stateDigestion = new StateDigestion(speechPath + "digestion.mp3");
	stateMuscles = new StateMuscles(speechPath + "muscles.mp3");
	stateWater = new StateWater(speechPath + "water.mp3", new OpenCV(this, 512, 424));

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

	// scale(globalScale);

	ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
	int[] rawDepthData = kinect.getRawDepthData();

	stateHandler(skeletonArray, rawDepthData);
	translate(400, 656);

	pushMatrix();

	translate((512-512*(THE_CONSTANT+globalScale))/2, (424-424*(THE_CONSTANT+globalScale))/2);

	scale(THE_CONSTANT+globalScale); // scale from 424 to 1080


	silhouette.draw(kinect);
	stateBlood.draw(skeletonArray, rawDepthData);
	stateBones.draw(skeletonArray, rawDepthData);
	stateDigestion.draw(skeletonArray, rawDepthData);
	stateMuscles.draw(skeletonArray, rawDepthData);
	stateWater.draw(kinect);

	stroke(255, 0, 0);
	strokeWeight(2);
	noFill();
	// rect(0, 0, 512, 424);

	popMatrix();

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

			if (CURRENT_TIME > lastStateChange + STATE_CHANGE_DELAY) {

				if (distance > DISTANCE_STEP * 4 + MIN_DISTANCE) {
					deactiveAllStates();
					stateWater.stateActive = true;
					currentState = 5;
					println("State Water");
				} else if (distance < DISTANCE_STEP * 4 + MIN_DISTANCE && distance > DISTANCE_STEP * 3 + MIN_DISTANCE) {
					deactiveAllStates();
					stateMuscles.stateActive = true;
					silhouette.active = true;
					currentState = 4;
					println("State Muscles");
				} else if (distance < DISTANCE_STEP * 3 + MIN_DISTANCE && distance > DISTANCE_STEP * 2 + MIN_DISTANCE) {
					deactiveAllStates();
					stateDigestion.stateActive = true;
					silhouette.active = true;
					currentState = 3;
					println("State Digestion");
				} else if (distance < DISTANCE_STEP * 2 + MIN_DISTANCE && distance > DISTANCE_STEP + MIN_DISTANCE) {
					deactiveAllStates();
					stateBlood.stateActive = true;
					silhouette.active = true;
					currentState = 2;
					println("State Blood");
				} else if (distance < DISTANCE_STEP + MIN_DISTANCE && distance > MIN_DISTANCE) {
					deactiveAllStates();
					stateBones.stateActive = true;
					silhouette.active = true;
					currentState = 1;
					println("State Bones");
				} else {
					deactiveAllStates();
					silhouette.active = true;
					currentState = 0;
				}

				if (currentState != lastState) {
					lastStateChange = CURRENT_TIME;
				}

				lastState = currentState;

			}

		globalScale = map(distance, 2400, 3900, 0, 2);

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

