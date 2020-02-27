$fn=180;
Diameter = 14;
Radius = Diameter/2;
Length = 118;
LineWidth = 3;
BuildSilverReedCover = 1;
BuildBrotherCover = 2;

// intersection() {
//   surface(file = "sample.dat", center = true, convexity = 5);
// //   rotate(45, [0, 0, 1]) 
// //   surface(file = "sample.dat"); 
// }

// linear_extrude(height =10)
// union()
// {
//     square(size=[Length, lineWidth], center=true);
//     translate([Length/2 + lineWidth * 2, Radius-1.6 , 0])
//     difference()
//     {
//         circle(r=Radius+lineWidth);
//         circle(r=Radius);
//         translate([-Radius-8,-4,0])
//         #square(size=[Diameter+lineWidth,Diameter+lineWidth]);
//     }
// }

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

    union()
        {
            Cover(height, length, lineWidth, diameter);

            translate([length/2 - lineWidth/2-0.5,diameter-lineWidth+1.15,0])
            linear_extrude(height =height)
            square(size=[10, lineWidth]);
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