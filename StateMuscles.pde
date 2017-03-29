/**
 * StateMuscles Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateMuscles extends StateBase {

	PShape _head;
 	private int[] rawDepthData;

	StateMuscles(String speechPath) {
		super(speechPath);
		 	// Shapes
	 		String path = "bodyTypes/blood/";
	 		_head = loadShape(path + "head.svg");

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
	  drawMuscleSvg(joints,	KinectPV2.JointType_Head,           KinectPV2.JointType_Neck,           _head, 60,			PI,       1,          new PVector(0,0));
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
		scale(0.3, _scaleY*0.3);
		scale(_scale_fix);
		shape(_theShape, 0, 0);
		scale(1);
		shapeMode(CORNER);
		popMatrix();

	}


}