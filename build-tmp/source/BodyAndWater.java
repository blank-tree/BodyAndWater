import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import KinectPV2.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BodyAndWater extends PApplet {

/**
 * BodyAndWater - MainClass
 * Spatial Interaction Project 2017 - ZHdK IAD15
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 
 

// SETTINGS
final static boolean DEBUGGING = true;


// Basic Variables
KinectPV2 kinect;
Silhouette silhouette;
Noise noise;

// States
int currentState;
// StateBlood stateBlood;
StateBones stateBones;
// StateDigestion stateDigestion;
// StateMuscles stateMuscles;
// StateWater stateWater;

// Debugging
Debug debug;

public void setup() {
	
	background(0);

	initKinect();
	silhouette = new Silhouette(kinect);
	noise = new Noise();

	// States
	currentState = 0;
	// stateBlood = new StateBlood();
	stateBones = new StateBones();
	// stateDigestion = new StateDigestion();
	// stateMuscles = new StateMuscles();
	// stateWater = new StateWater();

	// Debugging
	debug = new Debug();
}

public void draw() {

	background(0);

	kinect.getDepthMaskImage();
	scale(2.54717f); // scale from 424 to 1080
	translate(200, 0, 0);

	ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();
	int[] rawDepthData = kinect.getRawDepthData();

	stateBones.draw(skeletonArray, rawDepthData);

	// Debugging
	if (DEBUGGING) {
		
	}

}

public void initKinect() {
	kinect = new KinectPV2(this);

	// Settings
	kinect.enableBodyTrackImg(true);
	kinect.enableDepthMaskImg(true);
	kinect.enableSkeletonDepthMap(true);
	kinect.enableSkeleton3DMap(true);

	kinect.init();
}

public void drawKinectImage() {
	// PImage videoImage = kinect.getVideoImage();
	// image(videoImage, 0, 0);
}

public int decideState() {




	return 0;
}

/**
* Debug Class
* Only for development to display information about the current state and switch states and debug modes with the keyboard
* @author: HALT Design - Simon Fischer and Fernando Obieta
*/

public class Debug {

	private boolean displayText;
	private boolean displaySkeletons;

	public Debug() {
		displayText = false;
		displaySkeletons = false;
	}

	public void draw(Silhouette silhouette) {
		checkKeys();
		// skeletons(silhouette);
		// textInformation(silhouette);
	}

	private void textInformation(Silhouette silhouette) {
		if (displayText) {
			noStroke();
			fill(255);
			rect(10, 10, 150, 50);
			stroke(255);
			fill(0);
			textSize(12);
			text("Framerate: " + frameRate, 15, 30);
			String areSkeletonsDisplayed = displaySkeletons ? "on" : "off";
			text("Skeletons: " + areSkeletonsDisplayed, 15, 50);
		}
	}

	// private void skeletons(Silhouette silhouette) {
	// 	if (displaySkeletons) {
	// 		silhouette.drawSkeletons();
	// 	}
	// }

	private void checkKeys() {
		if (keyPressed == true) {
			if (key == 'i' || key == 'I') {
				displayText = !displayText;
			}
			if (key == 's' || key == 'S') {
				displaySkeletons = !displaySkeletons;
			}
		}
	}
}
/**
 * Noise Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class Noise {

	Noise() {
		
	}
}
/**
* Silhouette Class
*
* Mostly based on the SkeletonMaskDepth example by Thomas Lengeling
* https://github.com/ThomasLengeling/KinectPV2/blob/master/KinectPV2/examples/SkeletonMaskDepth/SkeletonMaskDepth.pde
* @author: HALT Design - Simon Fischer and Fernando Obieta
*/

public class Silhouette {

	private KinectPV2 kinect;
	private ArrayList<KSkeleton> skeletonArray;

	public Silhouette(KinectPV2 kinect) {
		this.kinect = kinect;
	}

	


}
/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBase {

 	float fadeState;

	StateBase() {
		fadeState = 0;
	}

	public void draw(KinectPV2 kinect) {
		
	}

	public void setFadeState(float fadeState) {
		this.fadeState = fadeState;
	}
}
// /**
//  * StateBlood Class
//  * @author: HALT Design - Simon Fischer and Fernando Obieta
//  */

//  public class StateBlood extends StateBase {

//  	// Shapes
//  	private PShape
//  	_head,
//  	_shoulder_l, _shoulder_r,
//  	_upperarm_l, _upperarm_r,
//  	_forearm_l, _forearm_r,
//  	_body, _heart,
//  	_hip,
//  	_thigh_l, _thigh_r,
//  	_shin_l, _shin_r;

//  	private int distance;
//  	private int[] rawDepthData;

//  	StateBlood() {
//  		// Shapes
//  		String path = "bodyTypes/blood/";
//  		_head = loadShape(path + "head.svg");
//  		_shoulder_l = loadShape(path + "shoulder_l.svg");
//  		_shoulder_r = loadShape(path + "shoulder_r.svg");
// 	 	_upperarm_l = loadShape(path + "upperarm_l.svg");
// 	 	_upperarm_r = loadShape(path + "upperarm_r.svg");
// 	 	_forearm_l = loadShape(path + "forearm_l.svg");
// 	 	_forearm_r = loadShape(path + "forearm_r.svg");
// 	 	_body = loadShape(path + "body.svg");
// 	 	_heart = loadShape(path + "heart.svg");
// 	 	_hip = loadShape(path + "hip.svg");
// 	 	_thigh_l = loadShape(path + "thigh_l.svg");
// 	 	_thigh_r = loadShape(path + "thigh_r.svg");
// 	 	_shin_l = loadShape(path + "shin_l.svg");
// 	 	_shin_r = loadShape(path + "shin_r.svg");

//  		distance = 0;
//  	}

//  	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
// 		this.rawDepthData = rawDepthData;

// 		  //individual joints
// 		  for (int i = 0; i < skeletonArray.size(); i++) {
// 		  	KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
// 		    //if the skeleton is being tracked compute the skeleton joints
// 		    if (skeleton.isTracked()) {
// 		    	KJoint[] joints = skeleton.getJoints();

// 		    	color col  = skeleton.getIndexColor();
// 		    	fill(col);
// 		    	stroke(col);

// 		    	drawBody(joints);
// 		  	}
// 		}
// 	}

// 	private void drawBody(KJoint[] joints) {
// 	  // Draw the SVGs:     joint 1                             joint 2                             grahic        rot fix   scale fix   pos fix
// 	  // shin
// 	  drawVeinSvg(joints,   KinectPV2.JointType_KneeLeft,       KinectPV2.JointType_AnkleLeft,      _shin_l,      PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_KneeRight,      KinectPV2.JointType_AnkleRight,     _shin_r,      PI,       1,          new PVector(0,0));
// 	  // thigh
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineBase,      KinectPV2.JointType_KneeLeft,       _thigh_l,     PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineBase,      KinectPV2.JointType_KneeRight,      _thigh_r,     PI,       1,          new PVector(0,0));
// 	  // shoulder
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderLeft,   _shoulder_l,  PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderRight,  _shoulder_r,  PI,       1,          new PVector(0,0));
// 	  // upper arm
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ShoulderLeft,   KinectPV2.JointType_ElbowLeft,      _upperarm_l,  PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ShoulderRight,  KinectPV2.JointType_ElbowRight,     _upperarm_r,  PI,       1,          new PVector(0,0));
// 	  // fore arm
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ElbowLeft,      KinectPV2.JointType_WristLeft,      _forearm_l,   PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ElbowRight,     KinectPV2.JointType_WristRight,     _forearm_r,   PI,       1,          new PVector(0,0));
// 	  //head
// 	  drawVeinSvg(joints,	KinectPV2.JointType_Head,           KinectPV2.JointType_Neck,           _head,       PI,       1,          new PVector(0,0));
// 	  //heart
// 	  drawHeartSvg(joints,	KinectPV2.JointType_SpineMid,  		KinectPV2.JointType_SpineShoulder,	_heart,       PI,       1,          new PVector(0,0));
// 	  //body
// 	  drawVeinSvg(joints,	KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_SpineBase,		_body,       PI,       1,          new PVector(0,0));
// 	}

// 	private void drawHeartSvg(KJoint[] _joints, int _jointType1, int _jointType2, int _jointType3, int _jointType4, PShape _theShape, float _rot_fix, float _pos_fix) {
// 		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
// 		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
// 		PVector joint3 = new PVector(_joints[_jointType3].getX(), _joints[_jointType3].getY());
// 		PVector joint4 = new PVector(_joints[_jointType4].getX(), _joints[_jointType4].getY());

// 		PVector matu = new PVector(joint3.x - joint4.x, joint3.y - joint4.y);
// 		float rot = -atan2(matu.x, matu.y) + _rot_fix - PI/2;

// 		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
// 		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/24;

// 		//draw the svg
// 		pushMatrix();
// 		shapeMode(CENTER);
// 		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
// 		rotate(rot);
// 		translate(0, _pos_fix);
// 		scale(min(_scale, 2));
// 		shape(_theShape, 0, 0);
// 		scale(1);
// 		shapeMode(CORNER);
// 		popMatrix();

// 	}

// 	private void drawVeinSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix, PVector _pos_fix) {
// 		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
// 		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

// 		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
// 		float rot = -atan2(matu.x, matu.y) + _rot_fix;

// 		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
// 		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
// 		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

// 		pushMatrix();
// 		shapeMode(CENTER);
// 		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
// 		rotate(rot);
// 		translate(_pos_fix.x, _pos_fix.y);
// 		scale(min(_scaleX,2), min(_scaleY, 2));
// 		scale(_scale_fix);
// 		shape(_theShape, 0, 0);
// 		scale(1);
// 		shapeMode(CORNER);
// 		popMatrix();

// 	}

// }
/**
 * StateBones Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBones extends StateBase {

 	// Shapes
 	private PShape
 	_skull,
 	_neck,
 	_upperspine,
 	_lowerspine,
 	_shoulder_l, _shoulder_r,
 	_upperarm_l, _upperarm_r,
 	_forearm_l, _forearm_r,
 	_hand_l, _hand_r,
 	_ribcage,
 	_hip,
 	_thigh_l, _thigh_r,
 	_knee_l, _knee_r,
 	_shin_l, _shin_r,
 	_foot_l, _foot_r;

 	private int distance;
 	private int[] rawDepthData;


 	StateBones() {
 		// Shapes
 		String path = "bodyTypes/skeleton/";
 		_skull = loadShape(path + "skull.svg");
 		_neck = loadShape(path + "neck.svg");
 		_lowerspine = loadShape(path + "lower_spine.svg");
 		_shoulder_l = loadShape(path + "shoulder_l.svg");
 		_shoulder_r = loadShape(path + "shoulder_r.svg");
 		_upperarm_l = loadShape(path + "upperarm_l.svg");
 		_upperarm_r = loadShape(path + "upperarm_r.svg");
 		_forearm_l = loadShape(path + "forearm_l.svg");
 		_forearm_r = loadShape(path + "forearm_r.svg");
 		_hand_l = loadShape(path + "hand_l.svg");
 		_hand_r = loadShape(path + "hand_r.svg");
 		_ribcage = loadShape(path + "ribcage.svg");
 		_hip = loadShape(path + "hip.svg");
 		_thigh_l = loadShape(path + "thigh_l.svg");
 		_thigh_r = loadShape(path + "thigh_r.svg");
 		_knee_l = loadShape(path + "knee_l.svg");
 		_knee_r = loadShape(path + "knee_r.svg");
 		_shin_l = loadShape(path + "shin_l.svg");
 		_shin_r = loadShape(path + "shin_r.svg");
 		_foot_l = loadShape(path + "foot_l.svg");
 		_foot_r = loadShape(path + "foot_r.svg");

 		distance = 0;
 	}

 	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
		this.rawDepthData = rawDepthData;

		  //individual joints
		  for (int i = 0; i < skeletonArray.size(); i++) {
		  	KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
		    //if the skeleton is being tracked compute the skeleton joints
		    if (skeleton.isTracked()) {
		    	KJoint[] joints = skeleton.getJoints();

		    	int col  = skeleton.getIndexColor();
		    	fill(col);
		    	stroke(col);

		    	drawBody(joints);
		      // drawHandState(joints[KinectPV2.JointType_HandRight]);
		      // drawHandState(joints[KinectPV2.JointType_HandLeft]);
		  }
		}
	}

	private void drawBody(KJoint[] joints) {
	  // Draw the SVGs:     joint 1                             joint 2                             grahic        rot fix   scale fix   pos fix
	  // thigh
	  drawBoneSvg(joints,   KinectPV2.JointType_HipLeft,        KinectPV2.JointType_KneeLeft,       _thigh_l,     PI,       1,          new PVector(0,0));
	  drawBoneSvg(joints,   KinectPV2.JointType_HipRight,       KinectPV2.JointType_KneeRight,      _thigh_r,     PI,       1,          new PVector(0,0));
	  // hip
	  drawHipSvg(joints, 	KinectPV2.JointType_SpineBase, 		KinectPV2.JointType_HipLeft, KinectPV2.JointType_HipRight, _hip, 0, 0);
	  // lower spine
	  drawBoneSvg(joints,   KinectPV2.JointType_SpineMid,       KinectPV2.JointType_SpineBase,      _lowerspine,  PI,       1,          new PVector(0,0));
	  // neck
	  drawJointSvg(joints,  KinectPV2.JointType_Neck,           KinectPV2.JointType_Head,           _neck,        PI,       1,          0);
	  // upper arm
	  drawBoneSvg(joints,   KinectPV2.JointType_ShoulderLeft,   KinectPV2.JointType_ElbowLeft,      _upperarm_l,  PI,       1,          new PVector(0,0));
	  drawBoneSvg(joints,   KinectPV2.JointType_ShoulderRight,  KinectPV2.JointType_ElbowRight,     _upperarm_r,  PI,       1,          new PVector(0,0));
	  // fore arm
	  drawBoneSvg(joints,   KinectPV2.JointType_ElbowLeft,      KinectPV2.JointType_WristLeft,      _forearm_l,   PI,       1,          new PVector(0,0));
	  drawBoneSvg(joints,   KinectPV2.JointType_ElbowRight,     KinectPV2.JointType_WristRight,     _forearm_r,   PI,       1,          new PVector(0,0));
	  // shins
	  drawBoneSvg(joints,   KinectPV2.JointType_KneeLeft,       KinectPV2.JointType_AnkleLeft,      _shin_l,      PI,       1,          new PVector(0,0));
	  drawBoneSvg(joints,   KinectPV2.JointType_KneeRight,      KinectPV2.JointType_AnkleRight,     _shin_r,      PI,       1,          new PVector(0,0));
	  // ribcage
	  drawRibSvg(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ShoulderRight, _ribcage, 0, 15);
	  // shoulder
	  drawBoneSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderLeft,   _shoulder_l,  PI,       1,          new PVector(0,0));
	  drawBoneSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderRight,  _shoulder_r,  PI,       1,          new PVector(0,0));
	  // hands
	  drawJointSvg(joints,  KinectPV2.JointType_HandLeft,       KinectPV2.JointType_HandTipLeft,    _hand_l,      PI,       1,          0);
	  drawJointSvg(joints,  KinectPV2.JointType_HandRight,      KinectPV2.JointType_HandTipRight,   _hand_r,      PI,       1,          0);
	  // feet
	  drawJointSvg(joints,  KinectPV2.JointType_FootLeft,       KinectPV2.JointType_AnkleLeft,      _foot_l,      0,       1,          	0);
	  drawJointSvg(joints,  KinectPV2.JointType_FootRight,      KinectPV2.JointType_AnkleRight,     _foot_r,      0,       1,          	0);
	  // knees
	  drawJointSvg(joints,  KinectPV2.JointType_KneeLeft,       KinectPV2.JointType_AnkleLeft,      _knee_l,      PI,       1,          0);
	  drawJointSvg(joints,  KinectPV2.JointType_KneeRight,      KinectPV2.JointType_AnkleRight,     _knee_r,      PI,       1,          0);
	  // head
	  drawJointSvg(joints,  KinectPV2.JointType_Head,           KinectPV2.JointType_Neck,           _skull,       PI,       1,          0);
	}

	private void drawRibSvg(KJoint[] _joints, int _jointType1, int _jointType2, int _jointType3, int _jointType4, PShape _theShape, float _rot_fix, float _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector joint3 = new PVector(_joints[_jointType3].getX(), _joints[_jointType3].getY());
		PVector joint4 = new PVector(_joints[_jointType4].getX(), _joints[_jointType4].getY());

		PVector matu = new PVector(joint3.x - joint4.x, joint3.y - joint4.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix - PI/2;

		distance = rawDepthData[min(max(PApplet.parseInt(joint1.y) * 512 + PApplet.parseInt(joint1.x), 0), rawDepthData.length-1)];
		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/24;

		//draw the svg
		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
		rotate(rot);
		translate(0, _pos_fix);
		scale(min(_scale, 2));
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawHipSvg(KJoint[] _joints, int _jointType1, int _jointType2, int _jointType3, PShape _theShape, float _rot_fix, float _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector joint3 = new PVector(_joints[_jointType3].getX(), _joints[_jointType3].getY());

		PVector matu = new PVector(joint2.x - joint3.x, joint2.y - joint3.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix - PI/2;

		distance = rawDepthData[min(max(PApplet.parseInt(joint1.y) * 512 + PApplet.parseInt(joint1.x), 0), rawDepthData.length-1)];
		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/24;

		//draw the svg
		pushMatrix();
		shapeMode(CENTER);
		translate(joint1.x, joint1.y);
		rotate(rot);
		translate(0, _pos_fix);
		scale(min(_scale, 2));
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawBoneSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix, PVector _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix;

		distance = rawDepthData[min(max(PApplet.parseInt(joint1.y) * 512 + PApplet.parseInt(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3f, 1.1f);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
		rotate(rot);
		translate(_pos_fix.x, _pos_fix.y);
		scale(min(_scaleX,2), min(_scaleY, 2));
		scale(_scale_fix);
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawJointSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix, float _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix;

		distance = rawDepthData[min(max(PApplet.parseInt(joint1.y) * 512 + PApplet.parseInt(joint1.x), 0), rawDepthData.length-1)];
		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/24;

		pushMatrix();
		shapeMode(CENTER);
		translate(joint1.x, joint1.y);
		rotate(rot);
		translate(0, _pos_fix);
		scale(min(_scale, 2));
		scale(_scale_fix);
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();
	}

}
// /**
//  * StateDigestion Class
//  * @author: HALT Design - Simon Fischer and Fernando Obieta
//  */

//  public class StateDigestion extends StateBase {

//  	// Shapes
//  	private PShape
//  	_gullet,
//  	_stomach,
//  	_colon_l, _color_r, _end,
//  	_bowel;

//  	private int distance;
//  	private int[] rawDepthData;

//  	StateDigestion() {
//  		// Shapes
//  		String path = "bodyTypes/blood/";
//  		_head = loadShape(path + "head.svg");
//  		_shoulder_l = loadShape(path + "shoulder_l.svg");
//  		_shoulder_r = loadShape(path + "shoulder_r.svg");
// 	 	_upperarm_l = loadShape(path + "upperarm_l.svg");
// 	 	_upperarm_r = loadShape(path + "upperarm_r.svg");
// 	 	_forearm_l = loadShape(path + "forearm_l.svg");
// 	 	_forearm_r = loadShape(path + "forearm_r.svg");
// 	 	_body = loadShape(path + "body.svg");
// 	 	_heart = loadShape(path + "heart.svg");
// 	 	_hip = loadShape(path + "hip.svg");
// 	 	_thigh_l = loadShape(path + "thigh_l.svg");
// 	 	_thigh_r = loadShape(path + "thigh_r.svg");
// 	 	_shin_l = loadShape(path + "shin_l.svg");
// 	 	_shin_r = loadShape(path + "shin_r.svg");

//  		distance = 0;
//  	}

//  	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
// 		this.rawDepthData = rawDepthData;

// 		  //individual joints
// 		  for (int i = 0; i < skeletonArray.size(); i++) {
// 		  	KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
// 		    //if the skeleton is being tracked compute the skeleton joints
// 		    if (skeleton.isTracked()) {
// 		    	KJoint[] joints = skeleton.getJoints();

// 		    	color col  = skeleton.getIndexColor();
// 		    	fill(col);
// 		    	stroke(col);

// 		    	drawBody(joints);
// 		  	}
// 		}
// 	}

// 	private void drawBody(KJoint[] joints) {
// 	  // Draw the SVGs:     joint 1                             joint 2                             grahic        rot fix   scale fix   pos fix
// 	  // shin
// 	  drawVeinSvg(joints,   KinectPV2.JointType_KneeLeft,       KinectPV2.JointType_AnkleLeft,      _shin_l,      PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_KneeRight,      KinectPV2.JointType_AnkleRight,     _shin_r,      PI,       1,          new PVector(0,0));
// 	  // thigh
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineBase,      KinectPV2.JointType_KneeLeft,       _thigh_l,     PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineBase,      KinectPV2.JointType_KneeRight,      _thigh_r,     PI,       1,          new PVector(0,0));
// 	  // shoulder
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderLeft,   _shoulder_l,  PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderRight,  _shoulder_r,  PI,       1,          new PVector(0,0));
// 	  // upper arm
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ShoulderLeft,   KinectPV2.JointType_ElbowLeft,      _upperarm_l,  PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ShoulderRight,  KinectPV2.JointType_ElbowRight,     _upperarm_r,  PI,       1,          new PVector(0,0));
// 	  // fore arm
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ElbowLeft,      KinectPV2.JointType_WristLeft,      _forearm_l,   PI,       1,          new PVector(0,0));
// 	  drawVeinSvg(joints,   KinectPV2.JointType_ElbowRight,     KinectPV2.JointType_WristRight,     _forearm_r,   PI,       1,          new PVector(0,0));
// 	  //head
// 	  drawVeinSvg(joints,	KinectPV2.JointType_Head,           KinectPV2.JointType_Neck,           _head,       PI,       1,          new PVector(0,0));
// 	  //heart
// 	  drawHeartSvg(joints,	KinectPV2.JointType_SpineMid,  		KinectPV2.JointType_SpineShoulder,	_heart,       PI,       1,          new PVector(0,0));
// 	  //body
// 	  drawVeinSvg(joints,	KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_SpineBase,		_body,       PI,       1,          new PVector(0,0));
// 	}

// 	private void drawHeartSvg(KJoint[] _joints, int _jointType1, int _jointType2, int _jointType3, int _jointType4, PShape _theShape, float _rot_fix, float _pos_fix) {
// 		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
// 		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
// 		PVector joint3 = new PVector(_joints[_jointType3].getX(), _joints[_jointType3].getY());
// 		PVector joint4 = new PVector(_joints[_jointType4].getX(), _joints[_jointType4].getY());

// 		PVector matu = new PVector(joint3.x - joint4.x, joint3.y - joint4.y);
// 		float rot = -atan2(matu.x, matu.y) + _rot_fix - PI/2;

// 		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
// 		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/24;

// 		//draw the svg
// 		pushMatrix();
// 		shapeMode(CENTER);
// 		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
// 		rotate(rot);
// 		translate(0, _pos_fix);
// 		scale(min(_scale, 2));
// 		shape(_theShape, 0, 0);
// 		scale(1);
// 		shapeMode(CORNER);
// 		popMatrix();

// 	}

// 	private void drawVeinSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix, PVector _pos_fix) {
// 		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
// 		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

// 		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
// 		float rot = -atan2(matu.x, matu.y) + _rot_fix;

// 		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
// 		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
// 		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

// 		pushMatrix();
// 		shapeMode(CENTER);
// 		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
// 		rotate(rot);
// 		translate(_pos_fix.x, _pos_fix.y);
// 		scale(min(_scaleX,2), min(_scaleY, 2));
// 		scale(_scale_fix);
// 		shape(_theShape, 0, 0);
// 		scale(1);
// 		shapeMode(CORNER);
// 		popMatrix();

// 	}

// }
/**
 * StateMuscles Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateMuscles extends StateBase {


	StateMuscles(Silhouette silhouette) {
		// super(silhouette);
	}

}
/**
 * StateWater Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateWater extends StateBase {


	StateWater(Silhouette silhouette) {
		// super(silhouette);
	}

}
  public void settings() { 	size(1920, 1080, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BodyAndWater" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
