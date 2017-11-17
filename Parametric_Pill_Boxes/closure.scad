/*

makes a threaded closure for the pill box




Adjustments may have to be made for other printers -

here diameter of thread is 8 - while diameter of 
inner thread is 9.2 - see body_all.scad - works
fine for my printer - may have to be adjusted
for other printers - easily done here -
make diameter of thread smaller or larger

threads.scad is by Dan Kirshner available at
 http://dkprojects.net/openscad-threads/

PCM February 2016

*/

// screw length can be either 8 or 12 mm
// shorter one is easier to use
// longer one allows octagonal lid to rotate
// while retaining screw in the box


use <threads.scad>


mark = 8;

if (mark==12)

union()
{
    translate([0,0,3])
    metric_thread (diameter=8, pitch=2, length=13, internal=false, n_starts=1,
                      thread_size=-1, groove=false, square=false, rectangle=0);
    
    linear_extrude(height=4)
    octagon(8);
}

else 
    
if (mark==8)
union()
{
    translate([0,0,3])
metric_thread (diameter=8, pitch=2, length=9, internal=false, n_starts=1,
                      thread_size=-1, groove=false, square=false, rectangle=0);
    
    linear_extrude(height=4)
    octagon(8);
}

else
    
{}

module octagon (l)
{

/*
l is the length of the sides
  of the octagon -
  it is centered at the origin
pcm
*/

rr = sqrt((l*l)/(2-2*cos(45)));

polygon([
          [ rr,0 ],
           [ cos(45)*rr,sin(45)*rr],
           [ cos(90)*rr,sin(90)*rr],
           [ cos(135)*rr,sin(135)*rr],
           [ cos(180)*rr,sin(180)*rr],
           [ cos(225)*rr,sin(225)*rr],
           [ cos(270)*rr,sin(270)*rr],
           [ cos(315)*rr,sin(315)*rr],
                      ]);
}

