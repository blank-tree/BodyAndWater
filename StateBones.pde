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

 	StateBones(SoundFile speech) {
 		super(speech);

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
		// Draw the SVGs:     joint 1							joint 2								grahic			rot		scale	pos fix
		// thigh
		drawBoneSvg(joints,	KinectPV2.JointType_HipLeft,        KinectPV2.JointType_KneeLeft,       _thigh_l, 100,	0,		1,		new PVector(0,0));
		drawBoneSvg(joints,	KinectPV2.JointType_HipRight,       KinectPV2.JointType_KneeRight,      _thigh_r, 100,	0,		1,		new PVector(0,0));
		// hip
		drawHipSvg(joints,	KinectPV2.JointType_SpineBase, 		KinectPV2.JointType_HipLeft, KinectPV2.JointType_HipRight, _hip, 0, 0);
		// lower spine
		drawBoneSvg(joints,	KinectPV2.JointType_SpineMid,       KinectPV2.JointType_SpineBase,      _lowerspine,50,0,		1,		new PVector(0,0));
		// neck
		drawJointSvg(joints,	KinectPV2.JointType_Neck,		KinectPV2.JointType_Head,           _neck,			0,		1,		0);
		// upper arm
		drawBoneSvg(joints,	KinectPV2.JointType_ShoulderLeft,   KinectPV2.JointType_ElbowLeft,      _upperarm_l,80,	0,		1,		new PVector(0,0));
		drawBoneSvg(joints,	KinectPV2.JointType_ShoulderRight,  KinectPV2.JointType_ElbowRight,     _upperarm_r,80,	0,		1,		new PVector(0,0));
		// fore arm
		drawBoneSvg(joints,	KinectPV2.JointType_ElbowLeft,      KinectPV2.JointType_WristLeft,      _forearm_l,100,	0,		1,		new PVector(0,0));
		drawBoneSvg(joints,	KinectPV2.JointType_ElbowRight,     KinectPV2.JointType_WristRight,     _forearm_r,100,	0,		1,		new PVector(0,0));
		// shins
		drawBoneSvg(joints,	KinectPV2.JointType_KneeLeft,       KinectPV2.JointType_AnkleLeft,      _shin_l,	100,	0,		1,		new PVector(0,0));
		drawBoneSvg(joints,	KinectPV2.JointType_KneeRight,      KinectPV2.JointType_AnkleRight,     _shin_r,	100,	0,		1,		new PVector(0,0));
		// ribcage
		drawRibSvg(joints,	KinectPV2.JointType_SpineShoulder,	KinectPV2.JointType_SpineMid, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ShoulderRight, _ribcage, 0, 15);
		// shoulder
		drawBoneSvg(joints,	KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderLeft,   _shoulder_l, 70,	0,		1,		new PVector(0,0));
		drawBoneSvg(joints,	KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderRight,  _shoulder_r, 70,	0,		1,		new PVector(0,0));
		// hands
		drawJointSvg(joints,	KinectPV2.JointType_HandLeft,	KinectPV2.JointType_HandTipLeft,    _hand_l,		0,		1,		0);
		drawJointSvg(joints,	KinectPV2.JointType_HandRight,	KinectPV2.JointType_HandTipRight,   _hand_r,		0,		1,		0);
		// feet
		drawJointSvg(joints,	KinectPV2.JointType_FootLeft,	KinectPV2.JointType_AnkleLeft,      _foot_l,		PI,		1,		0);
		drawJointSvg(joints,	KinectPV2.JointType_FootRight,	KinectPV2.JointType_AnkleRight,     _foot_r,		PI,		1,		0);
		// knees
		drawJointSvg(joints,	KinectPV2.JointType_KneeLeft,	KinectPV2.JointType_AnkleLeft,      _knee_l,		0,		1,		0);
		drawJointSvg(joints,	KinectPV2.JointType_KneeRight,	KinectPV2.JointType_AnkleRight,     _knee_r,		0,		1,		0);
		// JointType_Head
		drawJointSvg(joints,	KinectPV2.JointType_Head,		KinectPV2.JointType_Neck,           _skull,			0,		1,		0);
	}

	private void drawRibSvg(KJoint[] _joints, int _jointType1, int _jointType2, int _jointType3, int _jointType4, PShape _theShape, float _rot_fix, float _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector joint3 = new PVector(_joints[_jointType3].getX(), _joints[_jointType3].getY());
		PVector joint4 = new PVector(_joints[_jointType4].getX(), _joints[_jointType4].getY());

		PVector matu = new PVector(joint3.x - joint4.x, joint3.y - joint4.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix - PI/2;

		//draw the svg
		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
		rotate(rot);
		translate(0, _pos_fix);
		scale(0.3);
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

		//draw the svg
		pushMatrix();
		shapeMode(CENTER);
		translate(joint1.x, joint1.y);
		rotate(rot);
		translate(0, _pos_fix);
		scale(0.3);
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawBoneSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, int length, float _rot_fix, float _scale_fix, PVector _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix + PI;

		float _scaleY = map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, length, 0.3, 1.1);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
		rotate(rot);
		translate(_pos_fix.x, _pos_fix.y);
		scale(0.3, _scaleY*0.3);
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawJointSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix, float _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix + PI;

		pushMatrix();
		shapeMode(CENTER);
		translate(joint1.x, joint1.y);
		rotate(rot);
		translate(0, _pos_fix);
		scale(0.3);
		scale(_scale_fix);
		shape(_theShape, 0, 0);
		shapeMode(CORNER);
		popMatrix();
	}

}