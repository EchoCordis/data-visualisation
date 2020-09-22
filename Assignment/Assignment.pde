import controlP5.*;
//This imported library is ued to create on screen GUIs such as the slider.
//Minim is an audio library that uses the JavaSound API
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;

ControlP5 cp5;
PImage floorPlanbg;
PImage img;
//PImage imgMask;
int slider = 100;
int volume = -10;
PFont f;
Table table;
PShape s;
Textarea introductionBox;
float positionX;
float positionY;
float positionZ;
int row = 0;

Minim minim;
AudioPlayer audioplayer;
boolean playAudio = true;
int button_x = 50;
int button_y = 50;
int button_sz = 30;
PGraphics pg;
String toggleMusic = "Audio On/Off";
int screenStart = 0;
String contrastBG = "Contrast of Background";
String controlVolume = "Control Volume";
String introBox = "Welcome to the Building 11 people counter data visualiser!";
String introBox2 = "In this application, we will simulate the entry of people into building 11, based on sensory data.";
int buttonX = 40;
int buttonY = 40;
int buttonZ = 20;

// This is the main introduction screen. User must click to enter the
// simulation of the data visualisation.
void initialScreen() {
  // white background and text align center

  background(255);
  image(img,0,0);
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(24);
  text(introBox, 800, 600);
  text(introBox2, 830, 620);

  textSize(16);
  fill(0);
  rect(705, 457, 105, 32);
  fill(255);
  text("Click to Start", 757, 470);
}

void startDataVisualiser() {
  screenStart = 1;
}

//This is the main screen where the data is visualised.
//Introduce sliders to control the volumne and possible another slider to control
//background contrast

void screenStart() {
  background(floorPlanbg);
  toggleSliders();
  //Initialises ControlP5 controller
  cp5 = new ControlP5(this);
  //Adds a date slider into the screen
  Slider volumeSlider = cp5.addSlider("volume").setPosition(300,30).setRange(-60, 0).setSize(1000,50);
  //Makes a font to be used for the slider's labels
  ControlFont font = new ControlFont(createFont("Calibri", 20));
  //Adds a date slider into the screen
  Slider dateSlider = cp5.addSlider("Date region")
    //Max value is number of rows - 1 from the csv file (not including the headers)
    //Any higher and there will be an indexoutofbounds error. Currently it still gets the final row of the csv file
    .setRange(0, 13409)  
    .setValue(0)  //Sets initial value of the slider
    .setPosition(300, 100)  //Sets position of the slider
    .setSize(1000, 50)  //Sets slider's size
    .setSliderMode(Slider.FLEXIBLE);
  dateSlider.getValueLabel().setFont(font);

  //Creates the same shape of the floor plan. This will contain all of the plotted data points.
  //Try to use the Coordiantes below
  //X = random(210,1500);
  //Y = random(439, 854);
  s = createShape();
  s.beginShape();
  s.vertex(220,854); //Use these dimensions to plot the data down.
  s.vertex(210, 439);
  s.vertex(1484,465);
  s.vertex(1503,835);
  s.noFill();
  s.noStroke();
  s.endShape(CLOSE);
  shape(s,0,0);
}

void toggleSliders() {
  //background(slider);
  //fill(0, 76, 255);
  textSize(17);
  text(toggleMusic, 7, 100);
  text("Change Volume",154,60);
  text("Change Region",154,130);

  //text(controlVolume, 300, -30, 200, 100);
  rect(buttonX, buttonY, buttonZ, buttonZ);
  audioplayer.setGain(volume);
  if(playAudio){
    audioplayer.play();
  }
  else{
    audioplayer.pause();
  }
}

void setup() {
  frameRate(240);
  size(1700, 1193);
  img = loadImage("banner.png");
  pg = createGraphics(1600, 1122);  
   // allow audio API to be used here
  minim = new Minim(this);
  // load the audio file
  audioplayer = minim.loadFile("bgmusic.wav");
  floorPlanbg = loadImage("data/02RI.png");
  table = loadTable("people.csv", "header");
  background(floorPlanbg);
  f = createFont("Arial", 16, true);
}

//Function used to check the position of your mouse cursor when pressed down.
void mousePressed() {
  //ellipse( mouseX, mouseY, 2, 2 );
  //fill(#FF0A0A);
  //text( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
  //println( "x: " + mouseX + " y: " + mouseY);]
  if( mouseX > buttonX && mouseX < buttonX + buttonZ && mouseY > buttonY && mouseY < buttonY + buttonZ){
    playAudio = !playAudio; // will toggle pause/play music etc
  }
  if (screenStart == 0) {
    startDataVisualiser();
  }
}

void draw() {
  // check if we are in the main menu screen or the visualisation screen.
  if (screenStart == 0) {
    initialScreen();
    //screenStart();
  } else if (screenStart == 1) {
    screenStart();
  }

  // loop through the csv file and save to variables.
  while (row < table.getRowCount()) {
    int people = table.getInt(row, 1);
    String[] date = table.getString(row, 0).split("-");
    String day = date[0];
    String month = date[1];
    row++;
    println(day + " " + month + " : " + people);
    
    // get the amount of people for a specific day and loop through
    for (int i = 0; i <= people; i++) {
      fill(0);
      stroke(255,0,0);
      noSmooth();
      strokeWeight(5);
      //get a random x and y coordinate from the map
      float xCord = random(210,1500);
      float yCord = random(439, 854);
      // plot a point on the map with the x and y coordinate.
      point(xCord, yCord);
      //pg.clear();
    }
  }
}

//Used later on to control the data using the slider
//This method is called whenever the slider is moved (or any other UI elements if we add anymore)
void controlEvent(ControlEvent event){
  //int row = Math.round(cp5.getController("Date region").getValue());
  //cp5.getController("Date region").setValueLabel(table.getString(row, 0));
  //println("Slider moved: " + table.getString(row, 0) + " " + table.getInt(row, 1));
}
