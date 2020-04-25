/*
4/24/2020
Changed pyramid points, replaced side => 7.
Changed rotate from 360 to 180.
Changed pyramidside = 30 => 20
changed pyramidheight = 30 => 25
*/

$fn=100;


difference()
{
    // drain_attachment(30,30,19,55);
    drain_attachment(pyramidside = 20, pyramidheight = 25, attachmentOD = 19, attachmentLength = 55);
    //translate([0,0,2.5])
    spokes(diameter = 14, spokelength = 75, spokewidth = 4, spokenumber = 8);
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

		for (step = [0:spokenumber]) {
		    rotate( a = step*(180/spokenumber), v=[0, 0, 1])
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
        [side,7,0],
        [side, -side,0],
        [-side,-side,0],
        [-side,7,0],
        [0,0,height]];
    
    faces=[[0,1,4],[1,2,4],[2,3,4],[3,0,4],[1,0,3],[2,1,3]];
    
    polyhedron(points,faces);
}