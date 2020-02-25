//Width of draws in printer room; 633.
//Depth of draw in printer room; 436.

// Width = 633;
// Depth = 436;

// cube([Width/6, Depth/6, 35],true);

Wall = 3;
PostItInWidth = 78;
PostItOutWidth = PostItInWidth + Wall;
FaceX = PostItOutWidth/16;

facePoly = 
[
    [0,0],
    [PostItOutWidth, 0],
    [PostItOutWidth, PostItOutWidth],
    [15 * FaceX, PostItOutWidth],
    [10 * FaceX, FaceX],
    [6 * FaceX, FaceX],
    [FaceX, PostItOutWidth],
    [0, PostItOutWidth]
];

echo(facePoly=facePoly);

rotate([90,0,0]) 
linear_extrude(height=Wall, center=true)
polygon(facePoly);

translate([PostItOutWidth/2,PostItOutWidth/2,PostItOutWidth/2])
difference()
{
    Box(PostItOutWidth,PostItOutWidth,PostItOutWidth,Wall);
    translate([0,-PostItOutWidth/2,Wall])
    rotate([90,0,0]) 
    cube([PostItInWidth,PostItInWidth,Wall], center=true);
}

module Box(width, depth, height, wall)
{
    difference()
    {
        cube([width, depth, height], center = true);
        translate([0, 0, wall]) 
        cube([width-wall, depth-wall, height-wall], center=true);
    }
}

