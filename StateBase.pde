/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBase {

 	private final static int SPEECH_INTERVAL = 40000; // 40sec
 	private final static int SPEECH_DELAY = 4000; // 4sec

 	float fadeState;
 	boolean stateActive;

 	// Speech
 	SoundFile speech;
 	long lastSpeech;
 	long speechDelayTrigger;

 	StateBase(Soundfile speech) {
 		fadeState = 0;
 		this.speech = speech;
 		stateActive = false;
 	}

 	public void draw(KinectPV2 kinect) {
 		println("no draw defined for this state");
 	}

 	public void setFadeState(float fadeState) {
 		this.fadeState = fadeState;
 	}

 	private void updateSpeech() {
 		if (stateActive) {
 			if (lastSpeech + SPEECH_INTERVAL > CURRENT_TIME) {
 				if (speechDelayTrigger + SPEECH_DELAY > CURRENT_TIME) {
 					speechDelayTrigger, lastSpeech = CURRENT_TIME;
 					speech.play();
 				}
 			} else {
 				speechDelayTrigger = CURRENT_TIME;
 			}
 		} else {
 			speech.stop();
 			speechDelayTrigger = CURRENT_TIME;
 		}
 	}
 }