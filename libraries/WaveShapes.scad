include <SpiralShapes.scad>;
$fn=100;
NozzleWidth = 0.8;
LayerHeight = 0.32;
InitialLayerHeight = 0.4;
IdealHeight = InitialLayerHeight + (LayerHeight * 8);
LineCount = 8;
LineWidth = NozzleWidth * LineCount;
function LayersToHeight(layers) = InitialLayerHeight + (LayerHeight * layers);

Build();

module Build(args) 
{
    Saucer();
    // SaucerSpacer();
    // Wave();

}

module Saucer()
{
        ripples = 9;

        // amplitude = 100;
        plateThickness = 2;
        length = 100;
        width = (length/(ripples - 1) / 2);

        lipThickness = 2;
        lipHeight = 25;

        union()
        {
            rotate_extrude(angle = 360, convexity = 10)
            union()
            {
                //Sauce Edge
                translate([-(length - 1.04),0,0]) 
                hull()
                {
                    translate([-sin(10) * lipHeight, lipHeight, 0]) 
                        circle(r = lipThickness / 2); 
                    circle(r = lipThickness / 2);                
                }

                //platefloor
                hull()
                {
                    translate([-length, 0, 0]) 
                        square(size=[plateThickness, plateThickness], center=false);
                    translate([-plateThickness, 0, 0]) 
                        square(size=[plateThickness, plateThickness], center=false);
                }

                //Saucer under side
                translate([-length,0,0])
                rotate([180,0,0])
                for(i = [0 : ripples-2])
                {
                    translate([i * (width * 2) + (width),0,0])
                    polygon(points = polyCosWave(width = width, height = LayersToHeight(32)));
                }
            }

            translate([ 0, 0, plateThickness])
            WaveStar(spokes = 16, spokeWidth = 2, centerRadius = 0, spokeLength = 99, height = IdealHeight);
        }
}

module SaucerSpacer()
{

    radius1 = 25;
    radius2 = 268/2;

    union()
    {
        WaveCircle(radius = radius1, width = LineWidth , height = 10);
        WaveCircle(radius = radius2, width = LineWidth , height = 10);
        WaveStar(spokes = 10, spokeWidth = LineWidth , centerRadius = radius1, spokeLength = radius2-radius1, height = 10);
    } 
}

module WaveStar(spokes = 7, spokeWidth = 2, centerRadius = 10,  spokeLength = 100, height = 10)
{
    angle = 360/spokes;
    for(n = [1 : spokes])
    {
        rotate([0, 0, n * angle])
        {
            translate([ 0, -centerRadius, 0 ])
            Wave(width = spokeWidth, length = spokeLength, height = height);
        }
    }
}

module WaveCircle(radius = 100, width = 4, height = 200)
{
    rotate_extrude(angle=360)
    translate([radius,0,0])
    polygon(points = polyCosWave(width, height));
}


module Wave(width = 10, length = 100, height = 200)
{
    rotate([90,0,0])
    linear_extrude(height = length )
    polygon(points = polyCosWave(width, height));
}

function polyCosWave(width, height) =
[
    for(x =[-90 : StepSize(1) : 90]) [ x * width/90,  cos(x) * height]
];

function polySinWave(width, height) =
[
    for(x =[-90 : StepSize(1) : 90]) [ x * width/90,  sin(x) * height]
];

function StepSize(stepsize) = stepsize * 180/$fn;