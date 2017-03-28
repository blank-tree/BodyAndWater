/**
 * StateBlood Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBlood extends StateBase {

 	// Shapes
 	private PShape
 	_head,
 	_shoulder_l, _shoulder_r,
 	_upperarm_l, _upperarm_r,
 	_forearm_l, _forearm_r,
 	_body, _heart,
 	_hip,
 	_thigh_l, _thigh_r,
 	_shin_l, _shin_r;

 	private int distance;
 	private int[] rawDepthData;

 	StateBlood() {
 		// Shapes
 		String path = "bodyTypes/blood/";
 		_head = loadShape(path + "head.svg");
 		_shoulder_l = loadShape(path + "shoulder_l.svg");
 		_shoulder_r = loadShape(path + "shoulder_r.svg");
	 	_upperarm_l = loadShape(path + "upperarm_l.svg");
	 	_upperarm_r = loadShape(path + "upperarm_r.svg");
	 	_forearm_l = loadShape(path + "forearm_l.svg");
	 	_forearm_r = loadShape(path + "forearm_r.svg");
	 	_body = loadShape(path + "body.svg");
	 	_heart = loadShape(path + "heart.svg");
	 	// _hip = loadShape(path + "hip.svg");
	 	_thigh_l = loadShape(path + "thigh_l.svg");
	 	_thigh_r = loadShape(path + "thigh_r.svg");
	 	_shin_l = loadShape(path + "shin_l.svg");
	 	_shin_r = loadShape(path + "shin_r.svg");

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
		  	}
		}
	}

	private void drawBody(KJoint[] joints) {
	  // Draw the SVGs:     joint 1                             joint 2                             grahic        rot fix   scale fix   pos fix
	  // shin
	  drawVeinSvg(joints,   KinectPV2.JointType_KneeLeft,       KinectPV2.JointType_AnkleLeft,      _shin_l, 80,      PI,       0.8,          new PVector(0,0));
	  drawVeinSvg(joints,   KinectPV2.JointType_KneeRight,      KinectPV2.JointType_AnkleRight,     _shin_r, 80,      PI,       0.8,          new PVector(0,0));
	  // thigh
	  drawVeinSvg(joints,   KinectPV2.JointType_SpineBase,      KinectPV2.JointType_KneeLeft,       _thigh_l, 100,     -PI*1.1,       0.8,          new PVector(-12,0));
	  drawVeinSvg(joints,   KinectPV2.JointType_SpineBase,      KinectPV2.JointType_KneeRight,      _thigh_r, 100,     PI*1.1,       0.8,          new PVector(12,0));
	  // upper arm
	  drawVeinSvg(joints,   KinectPV2.JointType_ShoulderLeft,   KinectPV2.JointType_ElbowLeft,      _upperarm_l, 80,  -PI*1.07,       1,          new PVector(7,-10));
	  drawVeinSvg(joints,   KinectPV2.JointType_ShoulderRight,  KinectPV2.JointType_ElbowRight,     _upperarm_r, 80,  PI*1.07,       1,          new PVector(-7,-10));
	  // fore arm
	  drawVeinSvg(joints,   KinectPV2.JointType_ElbowLeft,      KinectPV2.JointType_WristLeft,      _forearm_l, 100,   PI,       1,          new PVector(0,0));
	  drawVeinSvg(joints,   KinectPV2.JointType_ElbowRight,     KinectPV2.JointType_WristRight,     _forearm_r, 100,   PI,       1,          new PVector(0,0));
	  // shoulder
	  drawVeinSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderLeft,   _shoulder_l, 70,  PI/2,       1,          new PVector(0,-5));
	  drawVeinSvg(joints,   KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_ShoulderRight,  _shoulder_r, 70,  -PI*0.8,       1,          new PVector(0,-5));
	  //head
	  drawVeinSvg(joints,	KinectPV2.JointType_Head,           KinectPV2.JointType_Neck,           _head, 60,       PI,       1,          new PVector(0,0));
	  //heart
	  drawHeartSvg(joints,	KinectPV2.JointType_SpineMid,  		KinectPV2.JointType_SpineShoulder,	_heart,       PI,       1);
	  //body
	  drawVeinSvg(joints,	KinectPV2.JointType_SpineShoulder,  KinectPV2.JointType_SpineBase,		_body, 110,       PI,       0.8,          new PVector(0,10));
	}

	private void drawHeartSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, float _rot_fix, float _scale_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix - PI/2;

		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/28;

		//draw the svg
		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2 + 10, (joint1.y+joint2.y)/2);
		rotate(rot);
		scale(min(_scale, 2));
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawVeinSvg(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, int length, float _rot_fix, float _scale_fix, PVector _pos_fix) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + _rot_fix;

		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, length, 0.3, 1.1);

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

}