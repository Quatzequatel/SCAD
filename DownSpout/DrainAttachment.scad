

$fn=100;


difference()
{
    drain_attachment(30,30,19,55);
    //translate([0,0,2.5])
    spokes(14, 75,4,16);
}


module drain_attachment(pyramidside, pyramidheight, attachmentOD, attachmentLength)
{
    pyramid(pyramidside,pyramidheight);
    translate([0,0,attachmentLength/2])
    cylinder(h=attachmentLength,r=attachmentOD/2,center=true);
}

module spokes( diameter, spokelength, spokewidth, spokenumber ) {

	union() {
		cylinder( h=spokewidth*30, r= diameter/2, center = true ); 

		for (step = [0:spokenumber-1]) {
		    rotate( a = step*(360/spokenumber), v=[0, 0, 1])
		spoke( spokelength, spokewidth );
            //echo(step);
		}
	}

}

/*
Single spoke used in Spokes()
*/
module spoke( length, width ) {
	translate ( [-length/2, 0, 0] )
	cube( [length, width, width], center=true); 
}

module pyramid(side, height)
{
    points = [
        [side,side,0],
        [side, -side,0],
        [-side,-side,0],
        [-side,side,0],
        [0,0,height]];
    
    faces=[[0,1,4],[1,2,4],[2,3,4],[3,0,4],[1,0,3],[2,1,3]];
    
    polyhedron(points,faces);
}