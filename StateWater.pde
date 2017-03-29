/**
 * StateWater Class
 * @author: HALT Design - Simon Fischer and Fernando Obieta
 */

 public class StateWater extends StateBase {

 	private final static int THRESHHOLDCV = 5;

 	private OpenCV opencv;

 	PImage[] wave;

 	int time;
 	float beginning;
 	float[] change;
 	float duration;
 	boolean direction;

 	StateWater(String speechPath, OpenCV opencv) {
 		super(speechPath);
 		this.opencv = opencv;

 		wave = new PImage[3];
 		wave[0] = loadImage("water_01.png");
 		wave[1] = loadImage("water_02.png");
 		wave[2] = loadImage("water_03.png");

 		time = 0;
 		beginning = 0;

 		change[0] = 20;
 		change[1] = 25;
 		change[2] = 30;

 		duration = 200;
 		direction = true;

 	}

 	public void draw(ArrayList<KSkeleton> skeletonArray, int[] rawDepthData) {
 		super.updateSpeech();
 	}

 	public void draw(KinectPV2 kinect) {
 		super.updateSpeech();

 		if(stateActive) {

 			drawWater();

 			opencv.loadImage(kinect.getBodyTrackImage());
 			opencv.gray();
 			opencv.invert();
 			opencv.threshold(THRESHHOLDCV);
 			PImage mask = opencv.getOutput();

 			mask.loadPixels();

 			for (int i = 0; i < mask.pixels.length; ++i) {
 				if (mask.pixels[i] == color(255,255,255)) {
 					mask.pixels[i] = color(0,0,0,0);
 				}
 			}

 			mask.updatePixels();

			// image(mask,0,0);

		}
	}

	void drawWater() {

		if (direction) {
			// image(wave[0], 0, easeIn(time, beginning, change, duration), 280, 200);
			// image(wave[1], 0, easeIn(time, beginning, change, duration) + 100, 280, 200);
			// image(wave[2], 0, easeIn(time, beginning, change, duration) + 200, 280, 200);
			for (int i = 0; i < 3; ++i) {
				image(wave[0], 0, easeIn(time, beginning, change[i], duration) + 100 * i, 280, 200);
			}
		} else {
			// image(wave[0], 0, easeIn(time, change, -change, duration), 280, 200);
			// image(wave[1], 0, easeIn(time, change, -change, duration) + 100, 280, 200);
			// image(wave[2], 0, easeIn(time, change, -change, duration) + 200, 280, 200);
			for (int i = 0; i < 3; ++i) {
				image(wave[i], 0, easeIn(time, change[i], -change[i], duration) + 100 * i, 280, 200);
			}
		}
		if (time < duration) {
			time++;
		} else {
			time = 0;
			direction = !direction;
		}

	}


	float easeIn (float t, float b, float c, float d) {
		if ((t/=d/2) < 1) {
			return c/2*t*t*t + b;
		}
		return c/2*((t-=2)*t*t + 2) + b;
	}

}