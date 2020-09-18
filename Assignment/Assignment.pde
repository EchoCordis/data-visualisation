import controlP5.*;
//This imported library is ued to create on screen GUIs such as the slider.

ControlP5 cp5;
PImage floorPlanbg;
//PImage imgMask;
Table table;
PShape s;
float positionX;
float positionY;
float positionZ;
int row = 0;

void setup() {
  frameRate(240);
  size(1700, 1193);

  floorPlanbg = loadImage("data/02RI.png");
  //imgMask = loadImage("mask.jpg");
  //floorPlanbg.mask(imgMask);
  table = loadTable("people.csv", "header");
  background(floorPlanbg);
  //We need to add a white background to the image.
  //Currently we are using PNG with an alphamask so we can't set the background to any other colour other than the image.

  //UI
  //Makes a font to be used for the slider's labels
  ControlFont font = new ControlFont(createFont("Calibri",20));
  cp5 = new ControlP5(this);  //Initialises ControlP5 controller
  //Adds a slider into the screen
  cp5.addSlider("")
      //Max value is number of rows - 1 from the csv file (not including the headers)
      //Any higher and there will be an indexoutofbounds error. Currently it still gets the final row of the csv file
      .setRange(0,13409)  
      .setValue(0)  //Sets initial value of the slider
      .setPosition(300,100)  //Sets position of the slider
      .setSize(1000,50)  //Sets slider's size
      .setSliderMode(Slider.FLEXIBLE)
      .getValueLabel().setFont(font);

  //Creates the same shape of the floor plan. This will contain all of the plotted data points.
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
//Function used to check the position of your mouse cursor when pressed down.
void mousePressed(){
  ellipse( mouseX, mouseY, 2, 2 );
  fill(#FF0A0A);
  text( "x: " + mouseX + " y: " + mouseY, mouseX + 2, mouseY );
  println( "x: " + mouseX + " y: " + mouseY);
}

void draw() {    
    while (row < table.getRowCount()) {
      int people = table.getInt(row, 1);
      String[] date = table.getString(row, 0).split("-");
      String day = date[0];
      String month = date[1];
      row++;
      println(day + " " + month + " : " + people);
    }
    
    //We need to figure out, how to plot down randomized data within PShape/BeginShape
    //Is this even possible? if not follow try the solution below.
    
    //I've added an image into the github folder which shows all the zones within the floorplan.
    //I want the data to be generated/placed into these zones. Image:(FloorZones.png)
    //With this done, we will hae a density points within the zone and we'll have the x and y position.
    //The x and y positions allow use to randomise the points for which the data will be randomly plotted.

    //Test. Creates random rectangles around the window screen
    //Use these randomly generates rectangles to test the generation within the floorplan
    //strokeWeight(3);
    //color c = color(255,random(246),random(237));
    //fill(c);
    //tint(c);
    //positionX = random(210,1500);
    //positionY = random(439, 854);
    //rect(positionX,positionY,20,20,10);
}

//Used later on to control the data using the slider
//This method is called whenever the slider is moved (or any other UI elements if we add anymore)
void controlEvent(ControlEvent event){
  int row = Math.round(cp5.getController("").getValue());
  cp5.getController("").setValueLabel(table.getString(row, 0));
  println("Slider moved: " + table.getString(row, 0) + " " + table.getInt(row, 1));
}
