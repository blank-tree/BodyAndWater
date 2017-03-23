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
 		String pathSkeleton = "bodyTypes/skeleton/";
 		_skull = loadShape(pathSkeleton + "skull.svg");
 		_neck = loadShape(pathSkeleton + "neck.svg");
 		_lowerspine = loadShape(pathSkeleton + "lower_spine.svg");
 		_shoulder_l = loadShape(pathSkeleton + "shoulder_l.svg");
 		_shoulder_r = loadShape(pathSkeleton + "shoulder_r.svg");
 		_upperarm_l = loadShape(pathSkeleton + "upperarm_l.svg");
 		_upperarm_r = loadShape(pathSkeleton + "upperarm_r.svg");
 		_forearm_l = loadShape(pathSkeleton + "forearm_l.svg");
 		_forearm_r = loadShape(pathSkeleton + "forearm_r.svg");
 		_hand_l = loadShape(pathSkeleton + "hand_l.svg");
 		_hand_r = loadShape(pathSkeleton + "hand_r.svg");
 		_ribcage = loadShape(pathSkeleton + "ribcage.svg");
 		_hip = loadShape(pathSkeleton + "hip.svg");
 		_thigh_l = loadShape(pathSkeleton + "thigh_l.svg");
 		_thigh_r = loadShape(pathSkeleton + "thigh_r.svg");
 		_knee_l = loadShape(pathSkeleton + "knee_l.svg");
 		_knee_r = loadShape(pathSkeleton + "knee_r.svg");
 		_shin_l = loadShape(pathSkeleton + "shin_l.svg");
 		_shin_r = loadShape(pathSkeleton + "shin_r.svg");
 		_foot_l = loadShape(pathSkeleton + "foot_l.svg");
 		_foot_r = loadShape(pathSkeleton + "foot_r.svg");

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

		    	color col  = skeleton.getIndexColor();
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

		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
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

	private void drawBoneSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix, PVector _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix;

		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

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

		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
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