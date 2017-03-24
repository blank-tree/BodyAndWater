/**
 * StateDigestion Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateDigestion extends StateBase {

 	// Shapes
 	private PShape
 	_gullet,
 	_stomach,
 	_colon_l, _colon_r, _end,
 	_bowel;

 	private int distance;
 	private int[] rawDepthData;

 	StateDigestion() {
 		// Shapes
 		String path = "bodyTypes/blood/";
		_gullet = loadShape(path + "gullet.svg");
	 	_stomach = loadShape(path + "stomach.svg");
	 	_colon_l = loadShape(path + "colon_l.svg");
	 	_colon_r = loadShape(path + "color_r.svg");
	 	_colon_end = loadShape(path + "colon_end.svg");
	 	_bowel = loadShape(path + "bowel.svg");

 		distance = 0;
 	}

 	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
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

	private void drawBody(KJoint[] joints) {
	  // Draw the SVGs:     joint 1                             joint 2                             grahic        rot fix   scale fix   pos fix

	  // NEED ALL CUSTOM FUNCTIONS

	}


}