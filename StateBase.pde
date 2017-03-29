/**
 * StateBase Class
 * Class for the other states to extend with all the basics
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateBase {

 	// Settings
 	private final static int SPEECH_DELAY = 4000; // 4sec

 	// Speech
 	private AudioPlayer speech;
 	private long lastSpeech;
 	private long speechDelayTrigger;
 	private int speechInterval;

 	public boolean stateActive;

 	StateBase(String speechPath) {
 		speech = MINIM.loadFile(speechPath);
 		speechInterval = speech.length() + SPEECH_DELAY;
 		stateActive = false;
 		lastSpeech = -speechInterval;
 		speechDelayTrigger = 0;
 	}

 	public void draw(KinectPV2 kinect) {
 		println("no draw defined for this state");
 	}

 	private void updateSpeech() {
 		if (stateActive) {
 			if (CURRENT_TIME > lastSpeech + SPEECH_INTERVAL) {
 				if (CURRENT_TIME > speechDelayTrigger + SPEECH_DELAY) {
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
 				speech.pause();
 			} 			
 			speechDelayTrigger = CURRENT_TIME;
 		}
 	}
 }