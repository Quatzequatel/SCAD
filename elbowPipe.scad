

module elbow(radius, length, angle)
{
    translate([-length,radius])
    rotate([0,90,0]) 
    cylinder(r=radius, h = length, $fn=100);
    
    rotate_extrude(angle=angle, convexity=10, $fn=100)
    translate([radius,0])
    circle(radius);
    
    translate([radius,0])
    rotate([90,0,0]) 
    cylinder(r=radius, h = length, $fn=100);
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

elbowPipe(12.5/2,12.6,90,2);
//elbowPipe(10,10,90,2);