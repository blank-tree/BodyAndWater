/**
 * StateMuscles Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateMuscles extends StateBase {


	StateMuscles(Soundfile speech) {
		super(speech);
	}

	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
 		super.updateSpeech();
 		
	}

}