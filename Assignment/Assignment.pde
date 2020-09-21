import controlP5.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;

PImage floorPlan;
Table table;
PFont f;
int row = 0;
ControlP5 cp5;
int slider = 100;
int volume = -10;
Textarea introductionBox;

Minim minim;
AudioPlayer audioplayer;
boolean playAudio;
int button_x = 50;
int button_y = 50;
int button_sz = 30;

String toggleMusic = "Audio On/Off";
int screenStart = 0;
String contrastBG = "Contrast of Background";
String controlVolume = "Control Volume";
String introBox = "Welcome to the Building 11 people counter data visualiser!";
String introBox2 = "In this application, we will simulate the entry of people into building 11, based on various sensory data";
int buttonX = 40;
int buttonY = 40;
int buttonZ = 20;

void initialScreen() {
 
  background(255);
  textAlign(CENTER,CENTER);
  fill(0);
  text(introBox, 800, 600);
  text(introBox2, 830, 620);
  
  fill(0);
  rect(445, 340, 105, 32);
  fill(255);
  text("Click to Start", 500, 350);
  
}

void screenStart() {
  toggleSliders();
  cp5 = new ControlP5(this);
  cp5.addSlider("Volume").setPosition(350,40).setRange(-60,0);
  cp5.addSlider("Slider").setPosition(150,40).setRange(0,255);
  
}

void toggleSliders() {
  //background(slider);
  fill(0,76,255);
  text(toggleMusic, 7, -30,100,100);
  text(contrastBG,110,-30,200,100);
  text(controlVolume,300,-30,200,100);
  rect(buttonX,buttonY,buttonZ,buttonZ);
  //audioplayer.setGain(volume);
  
}

void setup() {

  size(1600, 1122);
  floorPlan = loadImage("data/floor.png");
  table = loadTable("people.csv", "header");
    background(floorPlan);
  f = createFont("Arial",16,true);
}

void draw() {

  if (screenStart == 0) {
    //initialScreen();
    screenStart();
  } else if (screenStart == 1) {
     screenStart(); 
  }
  

  //int size = table.getRowCount();
  //int[] array = new int[size];
  //int i = 0;
  //for (TableRow row : table.rows()) {
  //  int nums = row.getInt("People");
  //  array[i] = nums;
  //  i++;
  //}



  //while (row < table.getRowCount()) {
  //  int people = table.getInt(row, 1);
  //  //int total = table.getInt(row, 2);
  //  //println(total);

  //  String[] date = table.getString(row, 0).split("-");
  //  String day = date[0];
  //  String month = date[1];
  //  row++;
  //  //println(day + " " + month + " : " + people + " " + total);




  //  for (i = 0; i < array.length; i++) {
  //    println(day + " " + array[i]);
  //    float x = random(1600);
  //    float y = random(80,650);
  //        textFont(f,36);
  //  fill(0);
  //  text("Current Date: ",10,700);
  //    stroke(255,0,0);
  //    noSmooth();
  //    strokeWeight(4);
  //    //point(x,y);
  //  }
  }


  //stroke(255,0,0);
  //noSmooth();
  //strokeWeight(3);
  //float x = random(1600);
  //float y = random(80,650);
  //for (int i = 0; i < 1000;i++) {

  //  point(x,y);
  //}


  //float mapX = map(50,-180,180,0,width);
  //float mapY = map(100,-180,180,0,height);
  //float mapMass = map(50000,0,5000000,1.0,3.0);

  //    stroke(255,0,0);
  //    strokeWeight(5);
  //point(30, 20);
  //point(85, 20);
  //point(85, 75);
  //point(30, 75);
