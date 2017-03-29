/**
* Silhouette Class
* Mostly based on the SkeletonMaskDepth example by Thomas Lengeling
* https://github.com/ThomasLengeling/KinectPV2/blob/master/KinectPV2/examples/SkeletonMaskDepth/SkeletonMaskDepth.pde
* @author: HALT Design - Simon Fischer and Fernando Obieta
*/

public class Silhouette {

	private final static int THRESHHOLDCV = 20;

	public boolean active;
	private OpenCV opencv;

	public Silhouette(OpenCV opencv) {
		active = false;
		this.opencv = opencv;
	}

	public void draw(KinectPV2 kinect) {
		opencv.loadImage(kinect.getBodyTrackImage());
		opencv.gray();
		opencv.invert();
		opencv.threshold(THRESHHOLDCV);
		image(opencv.getOutput(),0,0);
	}

	public void drawContour(KinectPV2 kinect) {

		if (active) {

			noFill();
			strokeWeight(3);

			opencv.loadImage(kinect.getBodyTrackImage());
			opencv.gray();
			opencv.invert();
			opencv.threshold(THRESHHOLDCV);
			PImage dst = opencv.getOutput();

			ArrayList<Contour> contours = opencv.findContours(false, false);

			if (contours.size() > 0) {
				for (Contour contour : contours) {

					PShape contourShape = createShape();

					contour.setPolygonApproximationFactor(4);
					if (contour.numPoints() > 50) {

						contourShape.beginShape();
						contourShape.stroke(0, 200, 200);

						for (PVector point : contour.getPolygonApproximation ().getPoints()) {
							contourShape.vertex(point.x, point.y);
						}
						contourShape.endShape();
					}
					shape(contourShape,0,0);
				}
			}
			kinect.setLowThresholdPC(50);
			kinect.setHighThresholdPC(4500);
		}
	}


}
