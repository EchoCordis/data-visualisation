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

void initialScreen() {
 
  background(255);
  
}

void setup() {

  size(1600, 1122);
  floorPlan = loadImage("data/floor.png");
  table = loadTable("people.csv", "header");
    background(floorPlan);
  f = createFont("Arial",16,true);
}

void draw() {


  int size = table.getRowCount();
  int[] array = new int[size];
  int i = 0;
  for (TableRow row : table.rows()) {
    int nums = row.getInt("People");
    array[i] = nums;
    i++;
  }



  while (row < table.getRowCount()) {
    int people = table.getInt(row, 1);
    //int total = table.getInt(row, 2);
    //println(total);

    String[] date = table.getString(row, 0).split("-");
    String day = date[0];
    String month = date[1];
    row++;
    //println(day + " " + month + " : " + people + " " + total);




    for (i = 0; i < array.length; i++) {
      println(day + " " + array[i]);
      float x = random(1600);
      float y = random(80,650);
          textFont(f,36);
    fill(0);
    text("Current Date: ",10,700);
      stroke(255,0,0);
      noSmooth();
      strokeWeight(4);
      //point(x,y);
    }
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
}
