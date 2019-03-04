//translate([-38.35,-56.5,0])
//translate([30,25.7,0]){
//#rotate([90,0,0])
//{
//    //Gutter dimensions are [76.7,113.1,185]
//import("C:/Users/Steven/Downloads/Gutter_downspout.stl");
//}
//}

//translate([0,0,30])
//difference()
//{
//cube([56.5,76.5,8],true);
//    translate([0,0,-1])cube([71.7,108.1,11],true);
//}

//translate([45,55,0])
//tube(60.5/2,4.25,25);
//translate([0,0,60])
squareTube(58,78,4.25,25);

//translate([-60.5,0,25])
//rotate([90,0,0])
//elbowPipe(60.5, 20, 90, 4.25);


module tube(outerDiameter, wallThickness, height)
{
    linear_extrude(height,true)
    difference()
    {
        circle(outerDiameter,true);
        circle(outerDiameter-wallThickness,true);
    }
}

module elbow(radius, length, angle)
{
    translate([-length,radius])
    rotate([0,90,0]) 
    cylinder(r=radius, h = length, $fn=100);
    
    #rotate_extrude(angle=angle, convexity=10, $fn=100)
    translate([radius,0])
    #circle(radius);
    
    translate([radius,0])
    rotate([90,0,0]) 
    cylinder(r=radius, h = length*2, $fn=100);
}


module elbowPipe(radius,length, angle, wallThickness)
{
    difference()
    {
        elbow(radius,length,angle);
        
        translate([wallThickness,wallThickness])
        elbow(radius-wallThickness, length+wallThickness+1, angle);
    }
}

module squareTube(outerwidth, outerheight, wallThickness, height)
{
        linear_extrude(height,true)
    difference()
    {
        square([outerwidth, outerheight],true);
        square([outerwidth-wallThickness,outerheight-wallThickness],true);
    }
}