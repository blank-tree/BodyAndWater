/**
 * StateWater Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

public class StateWater extends StateBase {

	private final static int THRESHHOLDCV = 5;

	private OpenCV opencv;
	float x;
	float y;
	float easing = 0.05;

	PImage[] wave = new PImage[3];

	int[] pos = {0,0,0};

	StateWater(String speechPath) {
		super(speechPath);
		this.opencv = opencv;


	  wave[0] = loadImage("water_01.png");
	  wave[1] = loadImage("water_02.png");
	  wave[2] = loadImage("water_03.png");

	}

	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
 		super.updateSpeech();

 		
 		
	}

	public void draw(KinectPV2 kinect) {

		if(stateActive) {
 			
 		
			drawWater();
			// Draw water

			// noStroke();
			// fill(255,0,0);
			// rect(0,0,width,height);

			// opencv.loadImage(kinect.getBodyTrackImage());
			// opencv.gray();
			// opencv.invert();
			// opencv.threshold(THRESHHOLDCV);
			// PImage mask = opencv.getOutput();

			// mask.loadPixels();

			// for (int i = 0; i < mask.pixels.length; ++i) {
				// if (mask.pixels[i] == color(255,255,255)) {
					// mask.pixels[i] = color(0,0,0,0);
				// }
			// }

			// mask.updatePixels();

			// image(mask,0,0);

		}
	}

	void drawWater() {
	  
	  float targetY = random(0, 400);
	  float dy = targetY - y;
	  y += dy * easing;

	  for (int i = 0; i < 3; i++) {
	    drawWaterAnim((i+1)*2, color(i*50, i*80, i*100), i);
	  }
	}

	void drawWaterAnim(int _spd, color _color, int _i) {
	  fill(_color);
	  image(wave[_i], pos[_i], y+(_i*120));
	  image(wave[_i], pos[_i]-1100, y+(_i*120));
	  if (pos[_i] < width) {
	    pos[_i] += _spd;
	  } else {
	    pos[_i] = 0;
	  }
	}

}