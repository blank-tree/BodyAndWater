/**
 * KinectHandler Class
 * Handles all the Kinect related stuff
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class KinectHandler {

	private Kinect2 kinect;

	KinectHandler() {
		kinect = new Kinect(this);
  		kinect.initDevice();
  		kinect.initVideo();
		kinect.initDevice();
	}

	public void drawCameraImage() {
		PImage videoImage = kinect.getVideoImage();
		image(videoImage, 0, 0);
	}

	public Kinect2 getKinect() {
		return kinect;
	}

}