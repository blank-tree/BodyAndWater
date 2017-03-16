/**
* Debug Class
* Only for development to display information about the current state and switch states and debug modes with the keyboard
* @author: HALT Design - Simon Fischer and Fernando Obieta
*/

public class Debug {

	private boolean displayText;
	private boolean displaySkeletons;

	public Debug() {
		displayText = false;
		displaySkeletons = false;
	}

	public void draw(Silhouette silhouette) {
		textInformation(silhouette);
		skeletons(silhouette);
	}

	private void textInformation(Silhouette silhouette) {
		if (displayText) {
			noStroke();
			fill(255);
			rect(10, 10, 150, 50);
			stroke(255);
			fill(0);
			textSize(12);
			text("Framerate: " + frameRate, 15, 15);
			text("Skeletons: " + displaySkeletons ? "on" : "off", 15, 30);
		}
	}

	private void skeletons(Silhouette silhouette) {
		if (displaySkeletons) {
			silhouette.drawSkeletons();
		}
	}

	private void checkKeys() {
		if (keyPressed == true) {
			if (key == 'i' || key == 'I') {
				displayText = !displayText;
			}
			if (key == 's' || key == 'S') {
				displaySkeletons = !displaySkeletons;
			}
		}
	}
}