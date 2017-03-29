/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBase {

 	// Settings
 	private final static int SPEECH_INTERVAL = 30000; // 30sec
 	private final static int SPEECH_DELAY = 4000; // 4sec

 	// Speech
 	private AudioPlayer speech;
 	private long lastSpeech;
 	private long speechDelayTrigger;

 	public boolean stateActive;

 	StateBase(String speechPath) {
 		speech = MINIM.loadFile(speechPath);
 		stateActive = false;
 	}

 	public void draw(KinectPV2 kinect) {
 		println("no draw defined for this state");
 	}

 	private void updateSpeech() {
 		if (stateActive) {
 			if (lastSpeech + SPEECH_INTERVAL > CURRENT_TIME) {
 				if (speechDelayTrigger + SPEECH_DELAY > CURRENT_TIME) {
 					speechDelayTrigger = CURRENT_TIME;
 					lastSpeech = CURRENT_TIME;
 					if (!speech.isPlaying()) {
 						speech.play(0);
 					} 					
 				}
 			} else {
 				speechDelayTrigger = CURRENT_TIME;
 			}
 		} else {
 			if (speech.isPlaying()) {
 				speech.stop();
 			} 			
 			speechDelayTrigger = CURRENT_TIME;
 		}
 	}
 }