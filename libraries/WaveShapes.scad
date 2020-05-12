// include <SpiralShapes.scad>;
$fn=100;
NozzleWidth = 0.8;
LayerHeight = 0.32;
InitialLayerHeight = 0.4;
IdealHeight = InitialLayerHeight + (LayerHeight * 8);
LineCount = 8;
LineWidth = NozzleWidth * LineCount;

function LayersToHeight(layers) = InitialLayerHeight + (LayerHeight * (layers - 1));
function HeightToLayers(height) = (height - InitialLayerHeight)/LayerHeight;
function ThicknessOfPlate() = LayersToHeight(8);
function heightAdjustment1() = LayerHeight/2;
function heightAdjustment2() = heightAdjustment1() + ThicknessOfPlate() - (0.32*4) ;
function widthAdjustment1(i, width) = (i * (width * 2) + (width)) + width/2 + 3;

Build();

module Build(args) 
{
    Saucer();
    // SaucerSpacer();
    // Wave();
    // WaveStar();

}

module Saucer()
{
        plateThickness = ThicknessOfPlate();
        length = 268/2;
        width = NozzleWidth * 3;
        ripples = (length / width)/2;
        rippleEveryIth = 2;
        
        layers = 28;  //height of ripple via LayersToHeight(layers);

        lipThickness = NozzleWidth * 4;
        lipHeight = 25;
        echo(plateThickness = plateThickness);

        union()
        {
            rotate_extrude(angle = 360, convexity = 10)
            union()
            {
                // translate([ 0, heightAdjustment2(),0])
                // square([2,2]);
                //Sauce Edge
                translate([-(widthAdjustment1(ripples-1, width)),0,0]) 
                hull()
                {
                    translate([-sin(10) * lipHeight, lipHeight, 0]) 
                        circle(r = lipThickness / 2); 
                    circle(r = lipThickness / 2);                
                }

                //platefloor
                hull()
                {
                    translate([-length-1, heightAdjustment1(), 0]) 
                        square(size=[plateThickness, plateThickness], center=false);
                    translate([-plateThickness, heightAdjustment1(), 0]) 
                        square(size=[plateThickness, plateThickness], center=false);
                }

                //Saucer under side
                translate([-length-width-1,0,0])
                rotate([180,0,0])
                for(i = [0 : ripples-1])
                {
                    if(i % rippleEveryIth == 0 )
                    {
                        echo(i = i);
                        translate([i * (width * 2) + (width),0,0])
                        polygon(points = polyTriangle(width = width, height = LayersToHeight(layers)));                        
                    }

                }
            }

            translate([ 0, 0, heightAdjustment2()])
            {
                WaveCircle(radius = lipHeight, width = NozzleWidth * 3 , height = 4);
                WaveStar(spokes = 16, spokeWidth = NozzleWidth * 3, centerRadius = lipHeight, spokeLength = length - lipHeight + width, height = 4);            
            }
            
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
            // Wave(width = spokeWidth, length = spokeLength, height = height);
            polyExtrude(length = spokeLength, points = polyTriangle(width = spokeWidth, height=height));
        }
    }
}

module WaveCircle(radius = 100, width = 4, height = 200)
{
    rotate_extrude(angle=360)
    translate([radius,0,0])
    polygon(points = polyTriangle(width = width, height=height));
}


module Wave(width = 10, length = 100, height = 200)
{
    rotate([90,0,0])
    linear_extrude(height = length )
    polygon(points = polyCosWave(width, height));
}

module polyExtrude(length, points)
{
    rotate([90, 0, 0])
    linear_extrude(height = length)
    polygon(points = points);
}

// function polyCosWave(width, height) =
// [
//     for(x =[-90 : 1 : 90]) [ x * width/90,  cos(x) * height]
// ];

// function polySinWave(width, height) =
// [
//     for(x =[0 : 1 : 181]) [ x * width/90,  sin(x) * height]
// ];

//[width, height, length] => [period, amplitude, length]
function polyCosWave(width, height, length) =
[
    for(x =[0 : 180/$fn : length/width * 90]) [ x * width/90,  cos(x) * height]
];

function polySinWave(width, height, length) =
[
    for(x =[-90 : 180/$fn : length/width * 90]) [ (x + 90) * width/90,  sin(x) * height]
];

function polyTriangle(width, height) =
[
    [-width,0], [width,0], [0, height]
];

function StepSize(stepsize) = stepsize * 180/$fn;