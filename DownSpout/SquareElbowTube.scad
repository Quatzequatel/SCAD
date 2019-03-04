

//rotate_extrude(angle=-90, convexity=10, $fn=100)
//rotate([90,0,0]) 
//translate([15,0,0]);
squareElbowTube(78,58,4.25,25);
//58,78,4.25,25

rotate([90,0,90]) 
translate([58,38,-20])
squareTube(78,58,4.25,25);

rotate([90,0,0]) 
translate([58,38,-5])
squareTube(78,58,4.25,25);

module squareElbowTube(outerwidth, outerheight, wallThickness, height)
{
        //linear_extrude(height,true)
    rotate_extrude(angle=90, convexity=10, $fn=100)
    translate([outerwidth-20, outerheight-20,0])
    difference()
    {
        square([outerwidth, outerheight],true);
        square([outerwidth-wallThickness,outerheight-wallThickness],true);
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