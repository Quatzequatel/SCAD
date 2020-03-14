
Wall = 2;
PostItInWidth = 80;
PostItOutWidth = PostItInWidth + Wall;
FaceX = PostItOutWidth/16;
FloorHeight = 0.4 + 3 * 0.16;

/*
2020.03.13 Changes made were for the slicer.
    FloorHeight was added to be the desired floorHeight
    of initial layer + X * layer height.
    adjustment to the poloygon was so the opening came
    all the way to the bottom.
2013.03.13 the print was a little too tight for post-it notes to fit.
    increased width to 78 -> 80
*/

Build();

module Build() {
    PostIt_NoteBox();
}

module PostIt_NoteBox()
{
    union()
    {
        FrontOfBox();
        translate([PostItOutWidth/2,PostItOutWidth/2,PostItOutWidth/2])
        OpenFaceBox(PostItOutWidth,PostItOutWidth,PostItOutWidth,Wall);
    }
}

module FrontOfBox()
{
    facePoly = 
    [
        [0,0],
        [PostItOutWidth, 0],
        [PostItOutWidth, PostItOutWidth],
        [15 * FaceX, PostItOutWidth],
        [10 * FaceX, FloorHeight],
        [6 * FaceX, FloorHeight],
        [FaceX, PostItOutWidth],
        [0, PostItOutWidth]
    ];
    echo(facePoly=facePoly);

    translate([0,Wall/2,0])
    rotate([90,0,0]) 
    linear_extrude(height=Wall, center=true)
    polygon(facePoly);
}
/*
Was having issue with the slicer not slicing the walls
properly. Refactored to build the box one wall at a time.
*/
module OpenFaceBox(width, depth, height, wall)
{
    //Front - none
    //Top - none
    //Bottom
    translate([0,0,-height/2])
    linear_extrude(height=FloorHeight)
    square(size=[width, depth], center=true);
    //Right
    translate([height/2-wall,0,0])
    rotate([0,90,0])
    linear_extrude(height=wall)
    square(size=[width, height], center=true);
    //left
    translate([-height/2-wall,0,0])
    rotate([0,90,0])
    linear_extrude(height=wall)
    square(size=[width, height], center=true);
    //Back
    translate([0,height/2,0])
    rotate([90,0,0])
    linear_extrude(height=wall)
    square(size=[width, height], center=true);

}

