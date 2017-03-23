/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBase {

 	float fadeState;

	StateBase() {
		fadeState = 0;
	}

	public void draw(KinectPV2 kinect) {
		
	}

	public void setFadeState(float fadeState) {
		this.fadeState = fadeState;
	}
}