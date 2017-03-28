/**
 * StateDigestion Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateDigestion extends StateBase {

 	// Shapes
 	private PShape
 	_gullet,
 	_bg,
 	_stomach,
 	_colon,
 	_bowel;

 	private int distance;
 	private int[] rawDepthData;

 	StateDigestion(Soundfile speech) {
 		super(speech);

 		// Shapes
 		String path = "bodyTypes/digestion/";
		_gullet = loadShape(path + "gullet.svg");
	 	_bg = loadShape(path + "bg.svg");
	 	_stomach = loadShape(path + "stomach.svg");
	 	_colon = loadShape(path + "colon.svg");
	 	_bowel = loadShape(path + "bowel.svg");

 		distance = 0;
 	}

 	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
 		super.updateSpeech();
 		
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

		scale(1);
	  drawGulletSvg(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineMid);
	  drawBackgroundSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
	  drawStomachSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
	  drawBowelSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
	  drawColonSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);

	}

	private void drawGulletSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) -PI;
		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
		rotate(rot);
		scale(min(_scaleX,2), min(_scaleY, 2));
		shape(_gullet, 0, 0);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawStomachSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y);
		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scale = pow(2, map(distance, 0, 4500, 4, 1))/24;

		pushMatrix();
		shapeMode(CENTER);
		translate(joint1.x-10, joint1.y+20);
		rotate(rot);
		scale(min(_scale, 2));
		shape(_stomach, 0, 0);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawBackgroundSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y);
		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2+20);
		rotate(rot);
		scale(min(_scaleX,2), min(_scaleY, 2));
		shape(_bg, 0, 0);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawColonSvg(KJoint[] _joints, int _jointType1, int _jointType2) {	// side (left=1/right=2/end=3)
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + PI;
		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2+20);
		rotate(rot);
		scale(min(_scaleX,2), min(_scaleY, 2));
		shape(_colon, 0, 0);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawBowelSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y);
		distance = rawDepthData[min(max(int(joint1.y) * 512 + int(joint1.x), 0), rawDepthData.length-1)];
		float _scaleX = pow(2, map(distance, 0, 4500, 4, 1))/24;
		float _scaleY = pow(2, map(distance, 0, 4500, 4, 1))/24 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 80, 0.3, 1.1);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2+20);
		rotate(rot);
		scale(min(_scaleX,2), min(_scaleY, 2));
		shape(_bowel, 0, 0);
		shapeMode(CORNER);
		popMatrix();

	}


}