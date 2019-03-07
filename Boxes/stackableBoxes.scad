/*
Stackable boxes
*/
LIP = 2;

/*
Project Box
These are sold at Costco.
*/
ProjectBoxWidth=315;
ProjectBoxHeight = 55;
StackCount = 2;

function actualLip(value) = value * 2;
function stackBoxHeight(height, count, lip) = height/count + (count-1) * lip;
function half(width) = width/2;
function third(width) = width/3;
function quarter(width) = width/4;
function sixth(width) = width/6;

stackableBox(third(ProjectBoxWidth),sixth(ProjectBoxWidth),stackBoxHeight(ProjectBoxHeight,StackCount,LIP));

module stackableBox(width, length, height)
{
    lip = actualLip(LIP);
    tolerance = 1;
    echo(width, length, height, lip);
//    difference()
//    {
    union()
    {
        Box(width,length,height,lip);
        translate([(lip+tolerance)/2,(lip+tolerance)/2,-lip])
        {
            Box(width-lip-tolerance,length-lip-tolerance,lip,lip);
        }
//    }
//    translate([4,5,-3])
//    cube([width-lip*2-tolerance,length-lip*2-tolerance,lip*2],false);
}
}

module Box(width, length, height, wall)
{
    echo(width, length, height, wall);
    b_floor = wall;
    //resize([0,0,0]) 
    translate([width/2,length/2,0]) 
    cube([width, length,b_floor],true); //box floor
    BoxWalls(width,length,height,wall);

}

module BoxWalls(width, length, height, wall)
{
     translate([width/2,length/2,height/2]) 
    difference()
    {
    cube([width, length,height],true);
    cube([width-wall,length-wall,height+wall], true);
    }
}

 module cubeWithTopOverhang(width, length, height)
 {
     lip = actualLip(LIP);
//     echo(width, length, height, lip);
     
     t = [[0,0],[lip,0],[0,lip]];
//     echo(t);
     
     cube([width, length, height]);
     
     translate([0,length,height])
     rotate([180,0,0]) union()
     {
        translate([width/2,0,0])
        rotate([0,-90,0])
        linear_extrude(height = width, center = true, convexity = 10)
        polygon(t);

        translate([width/2,length,0])
        rotate([90,-90,90])
        linear_extrude(height = width, center = true, convexity = 10)
        polygon(t);
             
        translate([0,length/2,0])
        rotate([270,-90,0])
        linear_extrude(height = length, center = true, convexity = 10)
        polygon(t);
             
        translate([width,length/2,0])
        rotate([90,-90,0])
        linear_extrude(height = length, center = true, convexity = 10)
        polygon(t);   
     }
}
//translate([0,0,stackBoxHeight(ProjectBoxHeight,StackCount,LIP)])
//rotate([180,0,0])
