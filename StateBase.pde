/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBase {

 	private final static int SPEECH_INTERVAL = 40000; // 40sec
 	private final static int SPEECH_DELAY = 4000; // 4sec

 	public boolean stateActive;

 	// Speech
 	private SoundFile speech;
 	private long lastSpeech;
 	private long speechDelayTrigger;

 	StateBase(Soundfile speech) {
 		this.speech = speech;
 		stateActive = false;
 	}

 	public void draw(KinectPV2 kinect) {
 		println("no draw defined for this state");
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