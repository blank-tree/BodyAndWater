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

				color col  = skeleton.getIndexColor();
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