/**
 * StateMuscles Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateMuscles extends StateBase {

	PShape
	_body,
	_foot_l, _foot_r,
	_forearm_l, _forearm_r,
	_hand_l, _hand_r,
	_head,
	_shin_l, _shin_r,
	_shoulder_l, _shoulder_r,
	_thigh_l, _thigh_r;

 	private int[] rawDepthData;

	StateMuscles(String speechPath) {
		super(speechPath);
		 	// Shapes
	 		String path = "bodyTypes/muscle/";
	 		_body = loadShape(path + "body.svg");
	 		_foot_l = loadShape(path + "foot_l.svg");
	 		_foot_r = loadShape(path + "foot_r.svg");
	 		_forearm_l = loadShape(path + "forearm_l.svg");
	 		_forearm_r = loadShape(path + "forearm_r.svg");
	 		_hand_l = loadShape(path + "hand_l.svg");
	 		_hand_r = loadShape(path + "hand_r.svg");
	 		_head = loadShape(path + "head.svg");
	 		_shin_l = loadShape(path + "shin_l.svg");
	 		_shin_r = loadShape(path + "shin_r.svg");
	 		_shoulder_l = loadShape(path + "shoulder_l.svg");
	 		_shoulder_r = loadShape(path + "shoulder_r.svg");
	 		_thigh_l = loadShape(path + "thigh_l.svg");
	 		_thigh_r = loadShape(path + "thigh_r.svg");

	}

	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
 		super.updateSpeech();

 		if (stateActive) {

			this.rawDepthData = rawDepthData;

		    //individual joints
			for (int i = 0; i < skeletonArray.size(); i++) {
				KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
				//if the skeleton is being tracked compute the skeleton joints
			    if (skeleton.isTracked()) {
			    	KJoint[] joints = skeleton.getJoints();

			    	color col  = skeleton.getIndexColor();
			    	fill(col);
			    	stroke(col);

			    	drawBody(joints);
			  	}
			}
 		}
	}

	private void drawBody(KJoint[] joints) {
	  // Draw the SVGs:     joint 1                             joint 2                             grahic        rot fix   scale fix   pos fix
	  //head
	  drawMuscleSvg(joints,	KinectPV2.JointType_Head,           KinectPV2.JointType_SpineShoulder,	_head,   30,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_HipLeft,		KinectPV2.JointType_KneeLeft,		_thigh_l,   60,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_HipRight,		KinectPV2.JointType_KneeRight,		_thigh_r,   60,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_FootLeft,		KinectPV2.JointType_AnkleLeft,		_foot_l,   20,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_FootRight,		KinectPV2.JointType_AnkleRight,		_foot_r,   20,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_HandLeft,		KinectPV2.JointType_HandTipLeft,	_hand_l,   30,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_HandRight,		KinectPV2.JointType_HandTipRight,	_hand_r,   30,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_KneeLeft,		KinectPV2.JointType_AnkleLeft,		_shin_l,   60,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_KneeRight,		KinectPV2.JointType_AnkleRight,		_shin_r,   60,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_SpineShoulder,	KinectPV2.JointType_ElbowLeft,		_shoulder_l,   50,	PI*0.9,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_ElbowLeft,		KinectPV2.JointType_WristLeft,		_forearm_l,   40,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_ElbowRight,		KinectPV2.JointType_WristRight,		_forearm_r,   40,	PI,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_SpineShoulder,	KinectPV2.JointType_ElbowRight,		_shoulder_r,   50,	PI*1.1,       1,          new PVector(0,0));
	  drawMuscleSvg(joints,	KinectPV2.JointType_SpineShoulder,	KinectPV2.JointType_SpineBase,		_body,   110,	PI,       1,          new PVector(0,0));
	}


	private void drawMuscleSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, int length, float _rot_fix, float _scale_fix, PVector _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix;

		float _scaleY = map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, length, 0.3, 1.1);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
		rotate(rot);
		translate(_pos_fix.x, _pos_fix.y);
		scale(0.15, _scaleY*0.15);
		scale(_scale_fix);
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}


}