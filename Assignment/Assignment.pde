PImage floorPlan;
Table table;

void setup() {
   
  size(1600, 624);
  floorPlan = loadImage("data/floor.png");
  table = loadTable("people.csv", "header");
  
}

void draw() {
   
    background(floorPlan);
    
    for (TableRow row : table.rows()) {
      int people = row.getInt("People");
      String date = row.getString("Date");
      String day = date.substring(0,2);
      String month = date.substring(3,5);
      
    }
  
}
