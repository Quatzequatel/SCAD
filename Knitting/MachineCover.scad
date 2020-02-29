/*
Needle cover for knitting machines.
*/
$fn=180;
Diameter = 14;
Radius = Diameter/2;
Length = 118;
LineWidth = 3;
BuildSilverReedCover = 1;
BuildBrotherCover = 2;


Build(BuildBrotherCover);

module Build(item)
{
    if(item == BuildSilverReedCover) SilverReedCover();
    if(item == BuildBrotherCover) BrotherCover();
}

module BrotherCover() {
    height = 10;
    length = 118-30;
    lineWidth = LineWidth;
    diameter = 14;
    catchLength = 10;

    union()
        {
            CoverV2(height, length, lineWidth, diameter);

            translate([(length/2 - catchLength/2), (diameter + lineWidth), 0])
            linear_extrude(height =height)
            square(size=[catchLength, lineWidth], center=true);
        }
}

module SilverReedCover() {
    height = 10;
    length = 118;
    lineWidth = LineWidth;
    diameter = 14;
    Cover(height, length, lineWidth, diameter);
}

module Cover(height, length, lineWidth, hookOD)
{
    radius = hookOD/2;
    linear_extrude(height =height)
    union()
    {
        square(size=[length, lineWidth], center=true);
        translate([length/2 + lineWidth * 2, Radius-1.6 , 0])
        difference()
        {
            circle(r=radius+lineWidth);
            circle(r=radius);
            translate([-radius-8,-4,0])
            square(size=[hookOD + lineWidth, hookOD + lineWidth]);
        }
    }
}

module CoverV2(height, length, lineWidth, hookOD)
{
    echo(height=height, length=length, lineWidth=LineWidth, hookOD=hookOD, radius=radius);
    radius = hookOD/2;
    linear_extrude(height =height)
    union()
    {
        square(size=[length, lineWidth], center=true);
        translate([length/2 ,radius + lineWidth/2 , 0])
        difference()
        {
            circle(r=radius+lineWidth);
            circle(r=radius);
            translate([-(2 * radius + lineWidth),-radius,0])
            #square(size=[hookOD + lineWidth, hookOD + lineWidth]);
        }
    }
}