//This imported library is ued to create on screen GUIs such as the slider.
import controlP5.*;
//Minim is an audio library that uses the JavaSound API
import ddf.minim.*;

//UI Elements
ControlP5 cp5;  //ControlP5 controller
Slider volumeSlider;  //Volume slider
Slider dateSlider;  //Date slider
Button startButton;  //Start button
Toggle volumeToggle;  //Volume toggle
Button highDensityButton;  //Highest density button
Button lowDensityButton;  //Lowest density button
int date = 0;  //Used for the date slider

PImage floorPlanbg;  //Image of the floorplan
PImage img;  //Image of the start screen's banner
int volume = -10;  //Used for the volume slider
Table table;  //Table storing contents of the CSV file

Minim minim;
AudioPlayer audioplayer;
boolean playAudio = true;
String toggleMusic = "Audio On/Off";
String contrastBG = "Contrast of Background";
String controlVolume = "Control Volume";
String introBox = "Welcome to the Building 11 people counter data visualiser!";
String introBox2 = "In this application, we will simulate the entry of people into Level 2 of Building 11, based on sensory data.";
String introBox3 = "The aim of this application is to provide a visualisation of the impact of COVID-19 on visits to the university's campus.";
String creditsBox = "Made by: Abderraouf Abbou, Charlie Phong, Donavan Le, Yuhao Song";

//Checks which is current screen - false = start screen, true = main screen
boolean currentScreen = false;
//Checks if the data visualisation for that day is done
boolean visDone = false;


void setup() {
  frameRate(240);
  size(1700, 1193);
  img = loadImage("banner.png");
  floorPlanbg = loadImage("data/02RI.jpg");
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
  ControlFont font = new ControlFont(createFont("Calibri", 20));
  
  //Adds a volume slider into the main screen
  volumeSlider = cp5.addSlider("volume").setPosition(300,30).setRange(-60, 0).setSize(1000,50);
  volumeSlider.getValueLabel().setFont(font);
    
  //Adds a date slider into the main screen
  dateSlider = cp5.addSlider("date").setBroadcast(false)
              //Max value is number of rows - 1 from the csv file (not including the headers)
              //Any higher and there will be an indexoutofbounds error. Currently it still gets the final row of the csv file
              .setRange(0, 25632)  
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
                  .setPosition(80,40)
                  .setSize(40,40)
                  .setBroadcast(true);
                  
  //Adds a button showing the day and month of the highest density of visitors
  highDensityButton = cp5.addButton("HighestDensityDate").setBroadcast(false)
                      .setValue(0)
                      .setCaptionLabel("Highest Density Date")
                      .setPosition(500,1000)
                      .setSize(200,50)
                      .setBroadcast(true);
  highDensityButton.getCaptionLabel().setFont(font);
 
  //Adds a button showing the day and month of the lowest density of visitors
  lowDensityButton = cp5.addButton("LowestDensityDate").setBroadcast(false)
                      .setValue(0)
                      .setCaptionLabel("Lowest Density Date")
                      .setPosition(900,1000)
                      .setSize(200,50)
                      .setBroadcast(true);
  lowDensityButton.getCaptionLabel().setFont(font);
  
  //Hides the sliders and volume toggle to begin with
  volumeSlider.hide();
  dateSlider.hide();
  volumeToggle.hide();
  highDensityButton.hide();
  lowDensityButton.hide();
}

//Hides the start button and shows the other UI elements
void toggleUI() {
    volumeSlider.show();
    dateSlider.show();
    volumeToggle.show();
    highDensityButton.show();
    lowDensityButton.show();
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
  
  //Adds introductory text
  textSize(24);
  text(introBox, 800, 550);
  text(introBox2, 830, 580);
  text(introBox3, 830, 610);
  text(creditsBox, 830, 1100);
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
  textSize(17);
  text(toggleMusic, 100, 100);
  text("Change Volume",1450,55);
  text("Change Date Region",1450,125);
  textSize(25);
  text("Number of visitors: " + table.getInt(date, 1), 800, 200);
}

//Displays circles on the screen depicting the amount of people on the level
void dataVis(int day) {
  for (int people = 1; people <= table.getInt(day, 1); people++) {
    float ellipseSize = random(5,10);
    ellipse(random(191, 1486), random(469, 826), ellipseSize, ellipseSize);
    println(table.getInt(day, 1));
  }
  println("done");
  visDone = true;
}

//Control visibility of highest density date
public void HighestDensityDate()
{
  println("21 March 2019 at 9:00am - 142");
  //Display the highest density date
  text("21 March 2019 at 9:00am", 600,1100);
  text("284 Visitors", 600,1150);

}
 
//Control visibility of Lowest density date
public void LowestDensityDate()
{
  println("6 June");
  //Display the lowest density date
  text("6 June",  1000, 1100);
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
