diameter=12.7;//11.5; changed to 1/2 inch
length=12.5;
angle=90;

function radius(x)=x/2;

module elbow(r, l, a)
{
    translate([-l,r])
    rotate([0,90,0]) 
    cylinder(r=r, h = l, $fn=100);
    
    rotate_extrude(angle=a, convexity=10, $fn=100)
    translate([r,0])
    circle(r);
    
    translate([r,0])
    rotate([90,0,0]) 
    cylinder(r=r, h = l*2, $fn=100);
}


module elbowPipe(r,l, a, wallThickness)
{
    difference()
    {
        elbow(r,l,a);
        
        translate([wallThickness,wallThickness])
        elbow(r-wallThickness, l+wallThickness+1, a);
    }
}

elbowPipe(radius(diameter),length,angle,2);
//elbowPipe(10,10,90,2);
translate([radius(diameter),-25,radius(diameter)])
rotate([180,90,0])
elbowPipe(radius(diameter),length,angle,2);