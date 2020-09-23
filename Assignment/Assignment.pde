import controlP5.*;
//This imported library is ued to create on screen GUIs such as the slider.
//Minim is an audio library that uses the JavaSound API
import ddf.minim.*;

//UI Elements
ControlP5 cp5;
Slider volumeSlider;
Slider dateSlider;
Button startButton;
Toggle volumeToggle;
int date = 0;  //Used for the date slider

PImage floorPlanbg;
PImage img;
//PImage imgMask;
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
PGraphics pg;
String toggleMusic = "Audio On/Off";
String contrastBG = "Contrast of Background";
String controlVolume = "Control Volume";
String introBox = "Welcome to the Building 11 people counter data visualiser!";
String introBox2 = "In this application, we will simulate the entry of people into building 11, based on sensory data.";

//Checks which is current screen - false = start screen, true = main screen
boolean currentScreen = false;
//Checks if the data visualisation for that day is done
boolean visDone = false;

// This is the main introduction screen. User must click to enter the
// simulation of the data visualisation.

void setup() {
  frameRate(240);
  size(1700, 1193);
  img = loadImage("banner.png");
  floorPlanbg = loadImage("data/02RI.png");
  table = loadTable("people.csv", "header");
  //background(floorPlanbg);
  pg = createGraphics(1600, 1122);  
  // allow audio API to be used here
  minim = new Minim(this);
  // load the audio file
  audioplayer = minim.loadFile("bgmusic.wav");
  f = createFont("Arial", 16, true);
  
  //Initialises ControlP5 controller
  cp5 = new ControlP5(this);
  //Initialises the UI elements
  initialiseUI();
}

//Initialises the different UI elements in the program
void initialiseUI() {
  //Makes a font to be used for the slider's labels
  ControlFont font = new ControlFont(createFont("Calibri", 20));
  
  //Adds a volume slider into the main screen
  volumeSlider = cp5.addSlider("volume").setPosition(300,30).setRange(-60, 0).setSize(1000,50);
  volumeSlider.getValueLabel().setFont(font);
    
  //Adds a date slider into the main screen
  dateSlider = cp5.addSlider("date").setBroadcast(false)
              //Max value is number of rows - 1 from the csv file (not including the headers)
              //Any higher and there will be an indexoutofbounds error. Currently it still gets the final row of the csv file
              .setRange(0, 13409)  
              .setPosition(300, 100)  //Sets position of the slider
              .setSize(1000, 50)  //Sets slider's size
              .setSliderMode(Slider.FLEXIBLE)
              .setBroadcast(true);
  dateSlider.getValueLabel().setFont(font);
  //Initalises text of the date slider
  cp5.getController("date").setValueLabel(table.getString(date, 0));
  
  //Adds a start button to the start screen
  startButton = cp5.addButton("begin").setBroadcast(false)
                .setPosition(750, 700)
                .setSize(200,50)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  startButton.getCaptionLabel().setFont(font);
  
  //Adds a volume toggle to the main screen
  volumeToggle = cp5.addToggle("mute").setBroadcast(false)
                  .setValue(true)
                  .setPosition(60,40)
                  .setSize(40,40)
                  .setBroadcast(true);
  
  //Hides the sliders and volume toggle to begin with
  volumeSlider.hide();
  dateSlider.hide();
  volumeToggle.hide();
}

//Toggles the screen between the start screen and the main visualisation screen
void toggleScreen() {
  if (currentScreen) {
    screenStart();
  }
  else if (!currentScreen) {
    initialScreen();
  }
}

//Hides the start button and shows the other UI elements
void toggleUI() {
    volumeSlider.show();
    dateSlider.show();
    volumeToggle.show();
    startButton.hide();
}

void initialScreen() {
  // white background and text align center

  background(255);
  image(img,0,0);
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(24);
  text(introBox, 800, 600);
  text(introBox2, 830, 620);
}

//This is the main screen where the data is visualised.
//Introduce sliders to control the volumne and possible another slider to control
//background contrast

void screenStart() {
  background(floorPlanbg);
  
  toggleSliders();
  if (!visDone) { dataVis(date); }
  
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
  text(toggleMusic, 100, 100);
  text("Change Volume",1450,55);
  text("Change Date Region",1450,125);

  //text(controlVolume, 300, -30, 200, 100);
  audioplayer.setGain(volume);
  
}

//Displays circles on the screen depicting the amount of people on the level
void dataVis(int day) {
  
  for (int people = 0; people <= table.getInt(day, 1); people++) {
    float ellipseSize = random(5,10);
    ellipse(random(10, 1000), random(10, 1000), ellipseSize, ellipseSize);
    println(table.getInt(day, 1));
  }
  println("done");
  visDone = true;
}

//Function used to check the position of your mouse cursor when pressed down.
void mousePressed() {  
  ellipse( mouseX, mouseY, 2, 2 );
  fill(#FF0A0A);
  text( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
  //println( "x: " + mouseX + " y: " + mouseY);]
}

void draw() {
  //strokeWeight(3);
  //positionX = random(220,1500);
  //positionY = random(439, 854);
  //rect(positionX,positionY,20,20,10);
  
  //Checks if we are in the title screen or the main visualisation screen.
  toggleScreen();
  
  // loop through the csv file and save to variables.
  //while (row < table.getRowCount()) {
  //  int people = table.getInt(row, 1);
  //  String[] date = table.getString(row, 0).split("-");
  //  String day = date[0];
  //  String month = date[1];
  //  row++;
  //  //println(day + " " + month + " : " + people);
    
    
  //   //get the amount of people for a specific day and loop through
  //  for (int i = 0; i <= people; i++) {
  //    fill(0);
  //    stroke(255,0,0);
  //    noSmooth();
  //    strokeWeight(5);
  //    //get a random x and y coordinate from the map
  //    float xCord = random(220,1500);
  //    float yCord = random(439, 850);
  //    // plot a point on the map with the x and y coordinate.
  //    point(xCord, yCord);
  //    //pg.clear();
  //  }
  //}
}

//Event controller for the UI
void controlEvent(ControlEvent event){
  //Date slider controls
  if (event.isController()) {
    if (event.getController().getName() == "date"){
      cp5.getController("date").setValueLabel(table.getString(date, 0));
       
      visDone = false;
      
      //println("Slider moved: " + table.getString(date, 0) + " " + table.getInt(date, 1));
    }
    //Start button controls
    //Disables the title screen and enables the main visualisation screen
    //Also starts playing the background music
    if (event.getController().getName() == "begin"){
      toggleUI();
      currentScreen = true;
      audioplayer.play();
      playAudio = !playAudio;
    }
    //Mute button controls
    //Mutes/Unmutes the audio depending on the playAudio boolean's state
    if (event.getController().getName() == "mute"){
      if(playAudio){
        audioplayer.play();
        playAudio = !playAudio;
      }
      else {
        audioplayer.pause();
        playAudio = !playAudio;
      }
    }
  }
}
