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

 	StateDigestion(SoundFile speech) {
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

 		if(stateActive) {
 		
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

		scale(1);
	  drawGulletSvg(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineMid);
	  drawBackgroundSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
	  drawBowelSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
	  drawColonSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
	  drawStomachSvg(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);

	}

	private void drawGulletSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) -PI;

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2+10, (joint1.y+joint2.y)/2);
		rotate(rot);
		scale(0.25);
		shape(_gullet);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawStomachSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y);

		pushMatrix();
		shapeMode(CENTER);
		translate(joint1.x, joint1.y);
		rotate(rot);
		scale(0.23);
		shape(_stomach, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawBackgroundSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + PI;

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2+20);
		rotate(rot);
		scale(0.2);
		shape(_bg, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawColonSvg(KJoint[] _joints, int _jointType1, int _jointType2) {	// side (left=1/right=2/end=3)
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y) + PI;

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2+20);
		rotate(rot);
		scale(0.2);
		shape(_colon, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}

	private void drawBowelSvg(KJoint[] _joints, int _jointType1, int _jointType2) {
		PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
		PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());
		PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
		float rot = -atan2(matu.x, matu.y);

		pushMatrix();
		shapeMode(CENTER);
		translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2+20);
		rotate(rot);
		scale(0.2);
		shape(_bowel, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}


}