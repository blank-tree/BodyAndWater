import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
StateBlood stateBlood;
StateBones stateBones;
StateDigestion stateDigestion;
StateMuscles stateMuscles;
StateWater stateWater;

// Debugging
Debug debug;

public void setup() {
	
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

public void draw() {

	silhouette.update();

	// Debugging
	if (DEBUGGING) {
		debug.draw(silhouette);
	}
}

public void initKinect() {
	kinect = new KinectPV2(this);

	// Settings
	// kinect.enableDepthMaskImg(true);
	// kinect.enableSkeletonDepthMap(true);

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
		textInformation(silhouette);
		skeletons(silhouette);
	}

	private void textInformation(Silhouette silhouette) {
		if (displayText) {
			noStroke();
			fill(255);
			rect(10, 10, 150, 50);
			stroke(255);
			fill(0);
			textSize(12);
			text("Framerate: " + frameRate, 15, 15);
			String areSkeletonsDisplayed = displaySkeletons ? "on" : "off";
			text("Skeletons: " + areSkeletonsDisplayed, 15, 30);
		}
	}

	private void skeletons(Silhouette silhouette) {
		if (displaySkeletons) {
			silhouette.drawSkeletons();
		}
	}

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

	public void update() {
		skeletonArray = kinect.getSkeletonDepthMap();
	}

	public void drawSkeletons() {
		// individual joints
		for (int i = 0; i < skeletonArray.size(); i++) {
			KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
			//if the skeleton is being tracked compute the skleton joints
			if (skeleton.isTracked()) {
				KJoint[] joints = skeleton.getJoints();

				int col  = skeleton.getIndexColor();
				fill(col);
				stroke(col);

				drawBody(joints);
				drawHandState(joints[KinectPV2.JointType_HandRight]);
				drawHandState(joints[KinectPV2.JointType_HandLeft]);
			}
		}
	}

	//draw the body
	private void drawBody(KJoint[] joints) {
		drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
		drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
		drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
		drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
		drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
		drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
		drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
		drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

		// Right Arm
		drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
		drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
		drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
		drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
		drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

		// Left Arm
		drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
		drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
		drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
		drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
		drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

		// Right Leg
		drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
		drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
		drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

		// Left Leg
		drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
		drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
		drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

		//Single joints
		drawJoint(joints, KinectPV2.JointType_HandTipLeft);
		drawJoint(joints, KinectPV2.JointType_HandTipRight);
		drawJoint(joints, KinectPV2.JointType_FootLeft);
		drawJoint(joints, KinectPV2.JointType_FootRight);

		drawJoint(joints, KinectPV2.JointType_ThumbLeft);
		drawJoint(joints, KinectPV2.JointType_ThumbRight);

		drawJoint(joints, KinectPV2.JointType_Head);
	}

	//draw a single joint
	private void drawJoint(KJoint[] joints, int jointType) {
		pushMatrix();
		translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
		ellipse(0, 0, 25, 25);
		popMatrix();
	}

	//draw a bone from two joints
	private void drawBone(KJoint[] joints, int jointType1, int jointType2) {
		pushMatrix();
		translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
		ellipse(0, 0, 25, 25);
		popMatrix();
		line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
	}

	//draw a ellipse depending on the hand state
	private void drawHandState(KJoint joint) {
		noStroke();
		handState(joint.getState());
		pushMatrix();
		translate(joint.getX(), joint.getY(), joint.getZ());
		ellipse(0, 0, 70, 70);
		popMatrix();
	}

	/*
	Different hand state
	KinectPV2.HandState_Open
	KinectPV2.HandState_Closed
	KinectPV2.HandState_Lasso
	KinectPV2.HandState_NotTracked
	*/

	//Depending on the hand state change the color
	private void handState(int handState) {
		switch(handState) {
			case KinectPV2.HandState_Open:
				fill(0, 255, 0);
				break;
			case KinectPV2.HandState_Closed:
				fill(255, 0, 0);
				break;
			case KinectPV2.HandState_Lasso:
				fill(0, 0, 255);
				break;
			case KinectPV2.HandState_NotTracked:
				fill(100, 100, 100);
				break;
		}
	}


}
/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateBase {

	Silhouette silhouette;
	float fadeState;

	StateBase(Silhouette silhouette) {
		this.silhouette = silhouette;
		fadeState = 0;
	}

	public void draw() {

	}

	public void fade() {

	}
}
/**
 * StateBlood Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateBlood extends StateBase {


	StateBlood(Silhouette silhouette) {
		super(silhouette);
	}

}
/**
 * StateBones Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateBones extends StateBase {


	StateBones(Silhouette silhouette) {
		super(silhouette);
	}

}
/**
 * StateDigestion Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateDigestion extends StateBase {


	StateDigestion(Silhouette silhouette) {
		super(silhouette);
	}

}
/**
 * StateMuscles Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateMuscles extends StateBase {


	StateMuscles(Silhouette silhouette) {
		super(silhouette);
	}

}
/**
 * StateWater Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateWater extends StateBase {


	StateWater(Silhouette silhouette) {
		super(silhouette);
	}

}
  public void settings() { 	size(800, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BodyAndWater" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
