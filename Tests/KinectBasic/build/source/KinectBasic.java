import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import KinectPV2.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class KinectBasic extends PApplet {




KinectPV2 kinect;
OpenCV opencv;

float polygonFactor = 4;

int threshold = 10;

//Distance in cm
int maxD = 4500; //4.5m
int minD = 50; //50cm

//Create pshapes for single elements
//Skeleton
PShape
_skull,
_neck,
_upperspine,
_lowerspine,
_shoulder_l, _shoulder_r,
_upperarm_l, _upperarm_r,
_forearm_l, _forearm_r,
_hand_l, _hand_r,
_ribcage,
_hip,
_thigh_l, _thigh_r,
_knee_l, _knee_r,
_shin_l, _shin_r,
_foot_l, _foot_r;

int _distance;

public void setup() {
  //fullScreen();
  
  // fullScreen(P3D);

  opencv = new OpenCV(this, 512, 424);
  kinect = new KinectPV2(this);

  kinect.enableBodyTrackImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableSkeleton3DMap(true);


  kinect.init();

  String pathSkeleton = "bodyTypes/skeleton/";
  _skull = loadShape(pathSkeleton + "skull.svg");
  // _neck = loadShape(pathSkeleton + "neck.svg");
  // _upperspine = loadShape(pathSkeleton + "upperspine.svg");
  // _lowerspine = loadShape(pathSkeleton + "lowerspine.svg");
  // _shoulder_l = loadShape(pathSkeleton + "shoulder_l.svg");
  // _shoulder_r = loadShape(pathSkeleton + "shoulder_r.svg");
  _upperarm_l = loadShape(pathSkeleton + "upperarm_l.svg");
  _upperarm_r = loadShape(pathSkeleton + "upperarm_r.svg");
  // _forearm_l = loadShape(pathSkeleton + "forearm_l.svg");
  // _forearm_r = loadShape(pathSkeleton + "forearm_r.svg");
  // _hand_l = loadShape(pathSkeleton + "hand_l.svg");
  // _hand_r = loadShape(pathSkeleton + "hand_r.svg");
  _ribcage = loadShape(pathSkeleton + "ribcage.svg");
  // _hip = loadShape(pathSkeleton + "hip.svg");
  // _thigh_l = loadShape(pathSkeleton + "thigh_l.svg");
  // _thigh_r = loadShape(pathSkeleton + "thigh_r.svg");
  // _knee_l = loadShape(pathSkeleton + "knee_l.svg");
  // _knee_r = loadShape(pathSkeleton + "knee_r.svg");
  // _shin_l = loadShape(pathSkeleton + "shin_l.svg");
  // _shin_r = loadShape(pathSkeleton + "shin_r.svg");
  // _foot_l = loadShape(pathSkeleton + "foot_l.svg");
  // _foot_r = loadShape(pathSkeleton + "foot_r.svg");

}

public void draw() {
  background(0);

  //text(frameRate, 50, 50);

  scale(2.54717f); // scale from 424 to 1080

  drawContour();
  drawSkeleton();
  // printDepthData();
}

public void drawSkeleton() {

  kinect.getDepthMaskImage();

  //get the skeletons as an ArrayList of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  int [] rawData = kinect.getRawDepthData();

  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //if the skeleton is being tracked compute the skeleton joints
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      int col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);

      drawBody(joints, rawData);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }

}

public void drawContour() {
  noFill();
  strokeWeight(3);

  opencv.loadImage(kinect.getBodyTrackImage());
  opencv.gray();
  opencv.invert();
  opencv.threshold(threshold);
  PImage dst = opencv.getOutput();

  ArrayList<Contour> contours = opencv.findContours(false, false);

  if (contours.size() > 0) {
    for (Contour contour : contours) {

      PShape contourShape = createShape();

      contour.setPolygonApproximationFactor(polygonFactor);
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

  // noStroke();

  // fill(0);
  // rect(0, 0, 130, 100);
  // fill(255, 0, 0);
  // text("fps: "+frameRate, 20, 20);
  // text("threshold: "+threshold, 20, 40);
  // text("minD: "+minD, 20, 60);
  // text("maxD: "+maxD, 20, 80);

  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);
}


public void keyPressed() {
  if (key == 'a') {
    threshold+=1;
  }
  if (key == 's') {
    threshold-=1;
  }

  if (key == '1') {
    minD += 10;
  }

  if (key == '2') {
    minD -= 10;
  }

  if (key == '3') {
    maxD += 10;
  }

  if (key == '4') {
    maxD -= 10;
  }

  if (key == '5') {
    polygonFactor += 0.1f;
  }

  if (key == '6') {
    polygonFactor -= 0.1f;
  }
}

//draw the body
public void drawBody(KJoint[] joints, int[] rawData) {
  // drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  // drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  // drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  // drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  // drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  // drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  // drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  // drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);
  //
  // // Right Arm
  // drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  // drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  // drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  // drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  // drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);
  //
  // // Left Arm
  // drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  // drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  // drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  // drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  // drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);
  //
  // // Right Leg
  // drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  // drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  // drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);
  //
  // // Left Leg
  // drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  // drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  // drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);
  //
  // //Single joints
  // drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  // drawJoint(joints, KinectPV2.JointType_HandTipRight);
  // drawJoint(joints, KinectPV2.JointType_FootLeft);
  // drawJoint(joints, KinectPV2.JointType_FootRight);
  //
  // drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  // drawJoint(joints, KinectPV2.JointType_ThumbRight);
  //
  // drawJoint(joints, KinectPV2.JointType_Head);

  drawSvgJoint(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck, _skull, rawData, PI);
  drawSvgBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid, _ribcage, rawData, PI);
  drawSvgBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft, _upperarm_r, rawData, PI);
  drawSvgBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight, _upperarm_l, rawData, PI);

}

//draw a single joint
public void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw a bone from two joints
public void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw a ellipse depending on the hand state
public void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */

//Depending on the hand state change the color
public void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    break;
  }
}

public void drawSvgJoint(KJoint[] _joints, int _jointType, int _jointTypeRot, PShape _theShape, int[] _rawData, float _rot_fix) {

  // 1 main joint, 1 support joint for rotation
  PVector joint1 = new PVector(_joints[_jointType].getX(), _joints[_jointType].getY());
  PVector joint2 = new PVector(_joints[_jointTypeRot].getX(), _joints[_jointTypeRot].getY());

  PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
  float rot = -atan2(matu.x, matu.y) + _rot_fix;

  _distance = _rawData[min(max(PApplet.parseInt(joint1.y) * 512 + PApplet.parseInt(joint1.x), 0), _rawData.length)];
  float _scale = pow(2, map(_distance, 0, 4500, 3, 0))/12;

  //draw the svg
  pushMatrix();
  shapeMode(CENTER);
  translate(joint1.x, joint1.y);
  rotate(rot);
  scale(_scale);
  shape(_theShape, 0, 0);
  scale(1);
  shapeMode(CORNER);
  popMatrix();

}

public void drawSvgBone(KJoint[] _joints, int _jointType1, int _jointType2, PShape _theShape, int[] _rawData, float _rot_fix) {

  // 2 main joint, draw svg inbetween
  PVector joint1 = new PVector(_joints[_jointType1].getX(), _joints[_jointType1].getY());
  PVector joint2 = new PVector(_joints[_jointType2].getX(), _joints[_jointType2].getY());

  PVector matu = new PVector(joint1.x - joint2.x, joint1.y - joint2.y);
  float rot = -atan2(matu.x, matu.y) + _rot_fix;

  _distance = _rawData[min(max(PApplet.parseInt(joint1.y) * 512 + PApplet.parseInt(joint1.x), 0), _rawData.length)];
  float _scaleX = pow(2, map(_distance, 0, 4500, 3, 0))/12;
  float _scaleY = pow(2, map(_distance, 0, 4500, 3, 0))/12 * map(dist(joint1.x, joint1.y, joint2.x, joint2.y), 0, 100, 0.3f, 1);

  //draw the svg
  pushMatrix();
  shapeMode(CENTER);
  translate((joint1.x+joint2.x)/2, (joint1.y+joint2.y)/2);
  rotate(rot);
  scale(_scaleX, _scaleY);
  shape(_theShape, 0, 0);
  scale(1);
  shapeMode(CORNER);
  popMatrix();

}


public void printDepthData() {
  int [] rawData = kinect.getRawDepthData();

  for (int i = 0; i < rawData.length; ++i) {
    println(i + " " + rawData[i]);
  }

}
  public void settings() {  size(1920, 1080, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "KinectBasic" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
