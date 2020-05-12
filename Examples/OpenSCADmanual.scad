/*
    Examples from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Commented_Example_Projects
*/
use <vectorHelpers.scad>;

build();

module build()
{
    t = [25,0,0];
    dc = rgbToFloat([255,128,128]);
    // echo(dc=dc, dc2 = incrementRGB(dc),  dc2 = incrementRGB(incrementRGB(dc)));

    translate([0,-25,0])
    color(c=dc) dodecahedronExample();
    translate(vSwitch(t,0,1))
    color(c=vSwitch(dc,0,1)) icosahedronExample();
    translate([25,25,0])
    color(c=vSwitch(dc,0,2)) BoundingBoxExample();

    let(t = [-25,50,0], dc = incrementRGB(vSetValue(dc, 0, 200/255)))
    {
        // echo(dc=dc);
        translate([50,50,20])
        color(c=dc) Example_linear_extrude_fs();   

        translate(t)
        color(c=vSwitch(dc,0,1)) Example_linear_extrude_ft();

        translate([100,100,60])
        rotate([0,0,90])
        color(c=vSwitch(dc,0,2)) Example_linear_extrude_ftfs();
    }

    let(t = [-25,50,0], dc = incrementRGB(vSetValue(vSetValue(dc, 0, 200/255), 2, 200/255)))
    {
    //    # translate([50,50,0])
        scale([2,2,2])
        color(c=dc)
        Example_horn();
    }

}
function incrementRGB(rgb) = rgbToFloat
(
    [
        for(i = [0 : (len(rgb) -1) ])
            rgb[i] * 255 + 50
    ]
);

function rgbToFloat(rgb) = 
[
    for(i = [0 : (len(rgb) -1) ])
    rgb[i]/255
];

module dodecahedronExample()
{
    //create 3 stacked dodecahedra 
    //call the module with a height of 1 and move up 2
    translate([0,0,2])dodecahedron(1); 
    //call the module with a height of 2
    dodecahedron(2); 
    //call the module with a height of 4 and move down 4
    translate([0,0,-4])dodecahedron(4);
}

module icosahedronExample()
{
    // display the 3 internal sheets alongside the icosahedron
    phi=0.5*(sqrt(5)+1);
    size=10;
    translate([-20,0,0]) union() {
    cube([size*phi,size,0.01], true);
    rotate([90,90,0]) cube([size*phi,size,0.01], true);
    rotate([90,0,90]) cube([size*phi,size,0.01], true);
    }

    icosahedron(size);
}

module BoundingBoxExample()
{
    // Test module on ellipsoid
    translate([0,0,40]) 
    // scale([1,2,3]) 
    sphere(r=5);
    BoundingBox() 
    // scale([1,2,3]) 
    sphere(r=5);
}

module Example_linear_extrude_fs()
{
    //Top rendered object demonstrating the interpolation steps
    translate([0,0,25])
    linear_extrude_fs(height=20,isteps=4);
    linear_extrude_fs(height=20);
    //Bottom rendered object demonstrating the inclusion of a twist
    translate([0,0,-25])
    linear_extrude_fs(height=20,twist=90,isteps=30);
}

module Example_linear_extrude_ft() 
{
    //Left rendered object demonstrating the interpolation steps
    translate([-20,0])
    linear_extrude_ft(height=30,isteps=5);

    linear_extrude_ft(height=30);

    //Right rendered object demonstrating the scale inclusion
    translate([25,0])
    linear_extrude_ft(height=30,scale=3);
}

module Example_linear_extrude_ftfs() 
{
    //Left rendered objects demonstrating the steps effect
    translate([0,-50,-60])
    rotate([0,0,90])
    linear_extrude_ftfs(height=50,isteps=3);

    translate([0,-50,0])
    linear_extrude_ftfs(height=50,isteps=3);
    //Center rendered objects demonstrating the slices effect
    translate([0,0,-60])
    rotate([0,0,90])
    linear_extrude_ftfs(height=50,isteps=3,slices=20);

    linear_extrude_ftfs(height=50,isteps=3,slices=20);
    //Right rendered objects with default parameters
    translate([0,50,-60])
    rotate([0,0,90])
    linear_extrude_ftfs(height=50);

    translate([0,50,0])
    linear_extrude_ftfs(height=50);    
}

module Example_horn()
{
    translate([3,0])
    mirror([1,0,0]) horn();

    translate([-3,0])
    horn();
}


//create a dodecahedron by intersecting 6 boxes
module dodecahedron(height) 
{
	scale([height,height,height]) //scale by height parameter
	{
		intersection(){
			//make a cube
			cube([2,2,1], center = true); 
			intersection_for(i=[0:4]) //loop i from 0 to 4, and intersect results
			{ 
				//make a cube, rotate it 116.565 degrees around the X axis,
				//then 72*i around the Z axis
				rotate([0,0,72*i])
					rotate([116.565,0,0])
					cube([2,2,1], center = true); 
			}
		}
	}
}


// create an icosahedron by intersecting 3 orthogonal golden-ratio rectangles
module icosahedron(size) {
   phi=0.5*(sqrt(5)+1); // golden ratio
   st=size/10000;  // microscopic sheet thickness
   hull() {
       cube([size*phi,size,st], true);
       rotate([90,90,0]) cube([size*phi,size,st], true);
       rotate([90,0,90]) cube([size*phi,size,st], true);
   }
}

// Rather kludgy module for determining bounding box from intersecting projections
module BoundingBox()
{
	intersection()
	{
		translate([0,0,0])
		linear_extrude(height = 1000, center = true, convexity = 10, twist = 0) 
		projection(cut=false) intersection()
		{
			rotate([0,90,0]) 
			linear_extrude(height = 1000, center = true, convexity = 10, twist = 0) 
			projection(cut=false) 
			rotate([0,-90,0]) 
			children(0);

			rotate([90,0,0]) 
			linear_extrude(height = 1000, center = true, convexity = 10, twist = 0) 
			projection(cut=false) 
			rotate([-90,0,0]) 
			children(0);
		}
		rotate([90,0,0]) 
		linear_extrude(height = 1000, center = true, convexity = 10, twist = 0) 
		projection(cut=false) 
		rotate([-90,0,0])
		intersection()
		{
			rotate([0,90,0]) 
			linear_extrude(height = 1000, center = true, convexity = 10, twist = 0) 
			projection(cut=false) 
			rotate([0,-90,0]) 
			children(0);

			rotate([0,0,0]) 
			linear_extrude(height = 1000, center = true, convexity = 10, twist = 0) 
			projection(cut=false) 
			rotate([0,0,0]) 
			children(0);
		}
	}
}

//Linear Extrude with Scale as an interpolated function
// This module does not need to be modified, 
// - unless default parameters want to be changed 
// - or additional parameters want to be forwarded (e.g. slices,...)
module linear_extrude_fs(height=1,isteps=20,twist=0)
{
    //union of piecewise generated extrudes
    union()
        { 
            for(i = [ 0: 1: isteps-1])
            {
                //each new piece needs to be adjusted for height
                translate([0,0,i*height/isteps])
                linear_extrude
                (
                    height=height/isteps,
                    twist=twist/isteps,
                    scale=f_lefs((i+1)/isteps)/f_lefs(i/isteps)
                )
                // if a twist constant is defined it is split into pieces
                rotate([0,0,-(i/isteps)*twist])
                    // each new piece starts where the last ended
                    scale(f_lefs(i/isteps))
                    obj2D_lefs();
            }
        }
}

// This function defines the scale function
// - Function name must not be modified
// - Modify the contents/return value to define the function
function f_lefs(x) = 
    let(span=150,start=20,normpos=45)
        sin(x*span+start)/sin(normpos);
// This module defines the base 2D object to be extruded
// - Function name must not be modified
// - Modify the contents to define the base 2D object
module obj2D_lefs()
{ 
    translate([-4,-3])
    square([9,12]);
}

//Linear Extrude with Twist as an interpolated function
// This module does not need to be modified, 
// - unless default parameters want to be changed 
// - or additional parameters want to be forwarded (e.g. slices,...)
module linear_extrude_ft(height=1,isteps=20,scale=1)
{
    //union of piecewise generated extrudes
    union()
    {
        for(i = [ 0: 1: isteps-1])
        {
            //each new piece needs to be adjusted for height
            translate([0,0,i*height/isteps])
            linear_extrude
            (
                height=height/isteps,
                twist=f_left((i+1)/isteps)-f_left((i)/isteps),
                scale=(1-(1-scale)*(i+1)/isteps)/(1-(1-scale)*i/isteps)
            )

            //Rotate to next start point
            rotate([0,0,-f_left(i/isteps)])
            //Scale to end of last piece size  
            scale(1-(1-scale)*(i/isteps))
                obj2D_left();
        }
    }
}

// This function defines the twist function
// - Function name must not be modified
// - Modify the contents/return value to define the function
function f_left(x) = 
    let(twist=90,span=180,start=0)
        twist*sin(x*span+start);

// This module defines the base 2D object to be extruded
// - Function name must not be modified
// - Modify the contents to define the base 2D object
module obj2D_left()
{
    translate([-4,-3]) 
    square([12,9]);
}

//Linear Extrude with Twist and Scale as interpolated functions
// This module does not need to be modified, 
// - unless default parameters want to be changed 
// - or additional parameters want to be forwarded
module linear_extrude_ftfs(height=1,isteps=20,slices=0)
{
  //union of piecewise generated extrudes
    union()
    { 
        for(i=[0:1:isteps-1])
        {
            translate([0,0,i*height/isteps])
            linear_extrude
            (
                height=height/isteps,
                twist=leftfs_ftw((i+1)/isteps)-leftfs_ftw(i/isteps), 
                scale=leftfs_fsc((i+1)/isteps)/leftfs_fsc(i/isteps),
                slices=slices
            )
            
            rotate([0,0,-leftfs_ftw(i/isteps)])
            scale(leftfs_fsc(i/isteps))
            obj2D_leftfs();
        }
    }
}

// This function defines the scale function
// - Function name must not be modified
// - Modify the contents/return value to define the function
function leftfs_fsc(x)=
  let(scale=3,span=140,start=20)
  scale*sin(x*span+start);

// This function defines the twist function
// - Function name must not be modified
// - Modify the contents/return value to define the function
function leftfs_ftw(x)=
  let(twist=30,span=360,start=0)
  twist*sin(x*span+start);

// This module defines the base 2D object to be extruded
// - Function name must not be modified
// - Modify the contents to define the base 2D object
module obj2D_leftfs()
{
   square([12,9]);
}

// The idea is to twist a translated circle:
// -
/*
	linear_extrude(height = 10, twist = 360, scale = 0)
	translate([1,0])
	circle(r = 1);
*/

module horn(height = 10, radius = 3, 
			twist = 720, $fn = 50) 
{
	// A centered circle translated by 1xR and 
	// twisted by 360° degrees, covers a 2x(2xR) space.
	// -
	radius = radius/4;
	// De-translate.
	// -
	translate([-radius,0])
	// The actual code.
	// -
	linear_extrude(height = height, twist = twist, 
				   scale=0, $fn = $fn)
	translate([radius,0])
	circle(r=radius);
}