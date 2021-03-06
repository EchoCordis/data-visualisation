//This imported library is ued to create on screen GUIs such as the slider.
import controlP5.*;
//Minim is an audio library that uses the JavaSound API
import ddf.minim.*;

//UI Elements
ControlP5 cp5;  //ControlP5 controller  - for UI elements
Slider dateSlider;  //Date control slider
Knob volumeKnob;  //Volume control knob
Button startButton;  //Start button
Toggle volumeToggle;  //Volume toggle
Button highDensityButton;  //Highest density button
Button onlineLButton;  //Online learning date button
int date = 0;  //Used for the date slider

PImage floorPlanbg;  //Image of the floorplan
PImage img;  //Image of the start screen's banner
int volume = -10;  //Used for the volume slider
Table table;  //Table storing contents of the CSV file

Minim minim;  //Minim controller - for background music
AudioPlayer audioplayer;  //Stores the song used for background music
boolean playAudio = true;  //Determines if the music should be playing

//Label for volume toggle
String toggleMusic = "Mute";

//Checks which is current screen - false = start screen, true = main screen
boolean currentScreen = false;
//Checks if the data visualisation for that day is done
boolean visDone = false;


void setup() {
  frameRate(240);
  size(1700, 863);
  //Loads in images for the start screen and main visualisation screen
  img = loadImage("banner2.png");
  floorPlanbg = loadImage("data/02R2.jpg");
  //Loads in the CSV file of data
  table = loadTable("PC0214.csv", "header");
  //background(floorPlanbg);

  // allow audio API to be used here
  minim = new Minim(this);
  // load the audio file
  audioplayer = minim.loadFile("bgmusic.wav");
  //Set the music to loop indefinitely
  audioplayer.loop();
  
  //Initialises ControlP5 controller
  cp5 = new ControlP5(this);
  //Initialises the UI elements
  initialiseUI();
}

//Initialises the different UI elements in the program
void initialiseUI() {
  //Makes a font to be used for the buttons' and sliders' value labels
  ControlFont font = new ControlFont(createFont("calibri", 20));
  
  //Adds a volume slider into the main screen
  volumeKnob = cp5.addKnob("volume")
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(0xffFFFFFF)
              .setPosition(50,60)
              .setRange(-50,50)
              .setRadius(40);
  volumeKnob.getValueLabel().setFont(font);
    
  //Adds a date slider into the main screen
  dateSlider = cp5.addSlider("date").setBroadcast(false)
              //Max value is number of rows - 1 from the csv file (not including the headers)
              //Any higher and there will be an indexoutofbounds error. Currently it still gets the final row of the csv file
              .setRange(0, 25362)
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(0xffFFFFFF)
              .setPosition(250, 85)  //Sets position of the slider
              .setSize(1200, 50)  //Sets slider's size
              .setSliderMode(Slider.FLEXIBLE)
              .setBroadcast(true);
  dateSlider.getValueLabel().setFont(font);
  //Initalises text of the date slider
  cp5.getController("date").setValueLabel(table.getString(date, 0));
  
  //Adds a start button to the start screen
  startButton = cp5.addButton("begin").setBroadcast(false)
                .setPosition(750, 610)
                .setColorForeground(#AFAFAF)
                .setColorBackground(0)
                .setColorActive(0xffFFFFFF)
                .setSize(200,50)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  startButton.getCaptionLabel().setFont(font);
  
  //Adds a volume toggle to the main screen
  volumeToggle = cp5.addToggle("mute").setBroadcast(false)
                  .setCaptionLabel("")
                  .setValue(true)
                  .setColorForeground(255)
                  .setColorBackground(0)
                  .setColorActive(0xffFFFFFF)
                  .setPosition(170,90)
                  .setSize(40,40)
                  .setBroadcast(true);
                  
  //Adds a button showing the day and month of the highest density of visitors
  highDensityButton = cp5.addButton("HighestDensityDate").setBroadcast(false)
                      .setColorForeground(#AFAFAF)
                      .setColorBackground(0)
                      .setColorActive(0xffFFFFFF)
                      .setValue(0)
                      .setCaptionLabel("Most Visitors")
                      .setPosition(1250,25)
                      .setSize(200,50)
                      .setBroadcast(true);
  highDensityButton.getCaptionLabel().setFont(font);
  
  //Adds a button showing the day and month online learning started
  onlineLButton = cp5.addButton("onlineLearning").setBroadcast(false)
                    .setColorForeground(#AFAFAF)
                    .setColorBackground(0)
                    .setColorActive(0xffFFFFFF)
                    .setValue(0)
                    .setCaptionLabel("Online Learning Starts")
                    .setPosition(925,25)
                    .setSize(300,50)
                    .setBroadcast(true);
  onlineLButton.getCaptionLabel().setFont(font);
  
  //Hides the sliders and volume toggle to begin with
  volumeKnob.hide();
  dateSlider.hide();
  volumeToggle.hide();
  highDensityButton.hide();
  onlineLButton.hide();
}

//Hides the start button and shows the other UI elements
void toggleUI() {
    volumeKnob.show();
    dateSlider.show();
    volumeToggle.show();
    highDensityButton.show();
    onlineLButton.show();
    startButton.hide();
}

//Draws the start screen
// This is the main introduction screen. User must click to enter the
// simulation of the data visualisation.
void initialScreen() {
  // white background and text align center
  background(255);
  image(img,0,0);
  textAlign(CENTER, CENTER);
  fill(0);
  
  //Sets font size
  textSize(24);
}

//This is the main screen where the data is visualised.
//Introduce sliders to control the volumne and possible another slider to control
//background contrast
void screenStart() {
  fill(#FF0A0A);
  if (!visDone) { 
    background(floorPlanbg);
    toggleText(); 
    dataVis(date); 
  }
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

//Shows label text next to buttons/sliders
void toggleText() {
  fill(255);
  textSize(17);
  text(toggleMusic,190,150);
  textSize(17);
  text("Volume",90,150);
  textSize(22);
  text("Change Date Region",360,60);
  textSize(22);
  fill(0);
  text("No. of visitors: " + table.getInt(date, 1), 850, 180);
}

//Displays circles on the screen depicting the amount of people on the level
void dataVis(int day) {
  if (day >= 18368) {
    fill(#FF0F0F);
  }
  else {
    fill(#358FFA);
  }
  for (int people = 1; people <= table.getInt(day, 1); people++) {
    float ellipseSize = random(6,10);
    ellipse(random(220, 1520), random(343, 726), ellipseSize, ellipseSize);
    //println(table.getInt(day, 1));
  }
  //println("done");
  visDone = true;
}

//Sets current date to the date with highest density of visitors
public void HighestDensityDate()
{
  println("21 March 2019 at 9:00am - 284");
  date = 3792;
  cp5.getController("date").setValue(date);
}

//Sets current date to the date that online learning started at UTS
void onlineLearning() {
  date = 18386;
  cp5.getController("date").setValue(date);
}

void draw() {
  //Checks if we are in the title screen or the main visualisation screen.
  toggleScreen();
  //Changes volume of BG music depending on the volume slider's value
  audioplayer.setGain(volume);
}

//Event controller for the UI elements
void controlEvent(ControlEvent event){
  //Date slider controls
  if (event.isController()) {
    //Changes value label of the date slider when it is moved
    if (event.getController().getName() == "date"){
      cp5.getController("date").setValueLabel(table.getString(date, 0));
      visDone = false;
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
