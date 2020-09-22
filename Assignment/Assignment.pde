import controlP5.*;
//This imported library is ued to create on screen GUIs such as the slider.
//Minim is an audio library that uses the JavaSound API
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
PShape s;
float positionX;
float positionY;
float positionZ;


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
String introBox2 = "In this application, we will simulate the entry of people into building 11, based on various sensory data";
int buttonX = 40;
int buttonY = 40;
int buttonZ = 20;

// This is the main introduction screen. User must click to enter the
// simulation of the data visualisation.
void initialScreen() {

  // white background and text align center
  background(255);
  textAlign(CENTER, CENTER);
  fill(0);
  text(introBox, 800, 600);
  text(introBox2, 830, 620);

  fill(0);
  rect(445, 340, 105, 32);
  fill(255);
  text("Click to Start", 500, 350);
}

//This is the main screen where the data is visualised.
//Introduce sliders to control the volumne and possible another slider to control
//background contrast
void screenStart() {
  toggleSliders();
  cp5 = new ControlP5(this);
  cp5.addSlider("Volume").setPosition(350, 40).setRange(-60, 0);
  cp5.addSlider("Slider").setPosition(150, 40).setRange(0, 255);
}


void toggleSliders() {
  //background(slider);
  fill(0, 76, 255);
  text(toggleMusic, 7, -30, 100, 100);
  text(contrastBG, 110, -30, 200, 100);
  text(controlVolume, 300, -30, 200, 100);
  rect(buttonX, buttonY, buttonZ, buttonZ);
  audioplayer.setGain(volume);
  if(playAudio)
    audioplayer.play();
    else
    audioplayer.pause();
}

void setup() {
  
  frameRate(240);
  pg = createGraphics(1600, 1122);
  
  // allow audio API to be used here
  minim = new Minim(this);
  // load the audio file
  audioplayer = minim.loadFile("bgmusic.mp3");
  size(1600, 1122);
  floorPlan = loadImage("data/floor.png");
  table = loadTable("people.csv", "header");
  background(floorPlan);
  f = createFont("Arial", 16, true);

  //UI
  //Makes a font to be used for the slider's labels
  ControlFont font = new ControlFont(createFont("Calibri", 20));
  cp5 = new ControlP5(this);  //Initialises ControlP5 controller
  //Adds a slider into the screen
  cp5.addSlider("")
    //Max value is number of rows - 1 from the csv file (not including the headers)
    //Any higher and there will be an indexoutofbounds error. Currently it still gets the final row of the csv file
    .setRange(0, 13409)  
    .setValue(0)  //Sets initial value of the slider
    .setPosition(300, 100)  //Sets position of the slider
    .setSize(1000, 50)  //Sets slider's size
    .setSliderMode(Slider.FLEXIBLE)
    .getValueLabel().setFont(font);

  //Creates the same shape of the floor plan. This will contain all of the plotted data points.
  s = createShape();
  s.beginShape();
  s.vertex(220, 854); //Use these dimensions to plot the data down.
  s.vertex(210, 439);
  s.vertex(1484, 465);
  s.vertex(1503, 835);
  s.noFill();
  s.noStroke();
  s.endShape(CLOSE);
  shape(s, 0, 0);
}

//Function used to check the position of your mouse cursor when pressed down.
void mousePressed() {
  ellipse( mouseX, mouseY, 2, 2 );
  fill(#FF0A0A);
  text( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
  println( "x: " + mouseX + " y: " + mouseY);
}


void draw() {

  // check if we are in the main menu screen or the visualisation screen.
  if (screenStart == 0) {
    //initialScreen();
    screenStart();
    
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
       float xCord = random(170,1430);
       float yCord = random(342,790);
       // plot a point on the map with the x and y coordinate.
       point(xCord, yCord);
       //pg.clear();
    }
    
  }
  

}


//Used later on to control the data using the slider
//This method is called whenever the slider is moved (or any other UI elements if we add anymore)
void controlEvent(ControlEvent event) {
  //int row = Math.round(cp5.getController("").getValue());
  //cp5.getController("").setValueLabel(table.getString(row, 0));
  //println("Slider moved: " + table.getString(row, 0) + " " + table.getInt(row, 1));
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
