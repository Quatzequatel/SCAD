/*

*/
// $fn=100;

Build();

module Build(args) 
{
    pixels = 300;
    scale([0.1,0.1,0.05])
    // difference()
    // {
    //     translate([-10, 10, 80]) 
    //     cube([pixels, pixels, 10], center = true);
        union()
        {
            // scale([1,1,0.1])
            surface(file = "Bird4.png", center = true, invert = true);  
            // translate([0, 0, -98.2]) 
            // cylinder(r=pixels/2, h=5, center=true);
            // cube(size=[pixels, pixels, 10], center=true);
        }
    // }


    // echo(surface(file = "Bird2.png", center = true, invert = true));
    
}

function polyCosWave(width, height) =
[
    for(x =[-90 : 1 : 90]) [ x * width/90,  cos(x) * height]
];

function polySinWave(width, height) =
[
    for(x =[0 : 1 : 181]) [ x * width/90,  sin(x) * height]
];