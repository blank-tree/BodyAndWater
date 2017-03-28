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

// Calibration
final static float DISTANCE_STEP = 500;

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

float globalScale;

long CURRENT_TIME;

// Debugging
Debug debug;

void setup() {
	size(1920, 1080, P3D);
	background(0);

	globalScale = 1;

	initKinect();
	silhouette = new Silhouette(kinect);
	noise = new Noise();

	// States
	currentState = 0;
	String speechPath = "speech/";
	stateBlood = new StateBlood(new SoundFile(this, speechPath + "blood.mp3"));
	stateBones = new StateBones(new SoundFile(this, speechPath + "bones.mp3"));
	stateDigestion = new StateDigestion(new SoundFile(this, speechPath + "digestion.mp3"));
	stateMuscles = new StateMuscles(new SoundFile(this, speechPath + "muscles.mp3"));
	stateWater = new StateWater(new SoundFile(this, speechPath + "water.mp3"));

	CURRENT_TIME = 0;

	// Debugging
	debug = new Debug();
}

void draw() {

	CURRENT_TIME = millis();

	background(0);

	kinect.getDepthMaskImage();
	translate(310, 0);
	scale(2.54717); // scale from 424 to 1080
	// scale(globalScale);
	// translate(map(globalScale, 0.6, 2, 0, -300), map(globalScale, 0.6, 2, 0, -200));

	ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
	int[] rawDepthData = kinect.getRawDepthData();

	stateHandler(skeletonArray, rawDepthData);

	stateBlood.draw(skeletonArray, rawDepthData);
	stateBones.draw(skeletonArray, rawDepthData);
	stateDigestion.draw(skeletonArray, rawDepthData);
	stateMuscles.draw(skeletonArray, rawDepthData);
	stateWater.draw(skeletonArray, rawDepthData);

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

			if (distance < DISTANCE_STEP * 6 + 1000 && distance > DISTANCE_STEP * 5 + 1000) {
				deactiveAllStates();
				stateWater.stateActive = true;
				println("State Water");
			} else if (distance < DISTANCE_STEP + 1000 * 5 && distance > DISTANCE_STEP * 4 + 1000) {
				deactiveAllStates();
				stateMuscles.stateActive = true;
				println("State Muscles");
			} else if (distance < DISTANCE_STEP + 1000 * 4 && distance > DISTANCE_STEP * 3 + 1000) {
				deactiveAllStates();
				stateBones.stateActive = true;
				println("State Digestion");
			} else if (distance < DISTANCE_STEP + 1000 * 3 && distance > DISTANCE_STEP * 2 + 1000) {
				deactiveAllStates();
				stateBlood.stateActive = true;
				println("State Blood");
			} else if (distance < DISTANCE_STEP + 1000 * 2 && distance > DISTANCE_STEP + 1000) {
				deactiveAllStates();
				stateDigestion.stateActive = true;
				println("State Bones");
			} else {
				deactiveAllStates();
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
}

