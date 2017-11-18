


   
module hook(radius)
{
    translate([0,60,0])
       rotate_extrude(angle=270, convexity=10, $fn=100)
           translate([40, 0]) circle(radius);
    rotate_extrude(angle=90, convexity=10, $fn=100)
       translate([20, 0]) circle(radius);
    translate([20,0,0]) 
       rotate([90,0,0]) cylinder(r=radius,h=80, $fn=100);    
}

difference()
{
hook(12);
hook(10);
}

