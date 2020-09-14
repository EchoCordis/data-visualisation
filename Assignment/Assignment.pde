PImage floorPlan;
Table table;

int row = 0;

void setup() {
   
  size(1600, 1122);
  floorPlan = loadImage("data/floor.png");
  table = loadTable("people.csv", "header");
  
}

void draw() {
   
    background(floorPlan);
    
    //for (TableRow row : table.rows()) {
    //  int people = row.getInt("People");
    //  String date = row.getString("Date");
    //  String day = date.substring(0,2);
    //  String month = date.substring(3,5);
    //  print(people);
      
    //}
  
    while (row < table.getRowCount()) {
      int people = table.getInt(row, 1);
      String[] date = table.getString(row, 0).split("-");
      String day = date[0];
      String month = date[1];
      row++;
      println(day + " " + month + " : " + people);
    }
}
