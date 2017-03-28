/**
 * StateWater Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateWater extends StateBase {


	StateWater(Soundfile speech) {
		super(speech);
	}

	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
 		super.updateSpeech();
 		
	}

}