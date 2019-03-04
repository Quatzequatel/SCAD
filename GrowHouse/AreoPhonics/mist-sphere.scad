
mist_dome_Top(80, 2, 32, 6);


// The spokes. This scales the design in spoke() to produce the spokes for the wheel. 
// Change this an the spoke() module in order to customize the spokes.  
module spokes( diameter, width, number ) {

	union() {
		cylinder( h=width, r= diameter/2, center = true ); 

		for (step = [0:number-1]) {
		    rotate( a = step*(360/number), v=[0, 0, 1])
		spoke( width );
            //echo(step);
		}
	}

}

module spoke( width ) {
	translate ( [-60/2, 0, 0] )
	cube( [60, width, width], center=true); 
}

module mist_dome_Top(diameter=80, wall= 1.5, vents=32, plugradius=6)
{
difference(){
    radius=diameter/2;
sphere(r=radius, $fn=300);
    sphere(r=(diameter-wall)/2, $fn=100);
   translate([0,00,-radius])  cube(diameter,center=true);
translate([0,0,radius/2]) spokes(radius,5,vents);

translate([0,0,radius-5]) cylinder(h=10, r=plugradius, center=true);
}
    
}