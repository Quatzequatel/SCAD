/* 
sacuers for planters.
Design 1
just a spacer under the planter to protect the wood.

design 2
a saucer that captures drained.
*/
$fn=360;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;
wallCount = 2;

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;

Build();

module Build()
{
    Saucer(radius = InchTomm(12.5)/2, depth = mmPerInch, thickness = BaseHeight());
}

module Saucer(radius = 100, depth = mmPerInch, thickness = BaseHeight()) 
{
    rotate_extrude(convexity=10) 
    {
        union()
        {
            hull() 
            {
                translate([radius, 0, 0]) 
                    square(size=[thickness, thickness], center=false);

                square(size=[thickness, thickness], center=false);        
            }
            translate([radius +  WallThickness( wallCount ) / 2, WallThickness( wallCount ) / 2, 0])
            hull()
            {
                translate([sin(10) * depth, depth, 0]) 
                circle(r = WallThickness( wallCount ) / 2); 
                circle(r = WallThickness( wallCount ) / 2);                
            }   

            // rotate([0,0,230])
            translate([0, WallThickness( wallCount ) / 2, 0])
            polygon(points = [[radius - radius/20, 0], [radius, 0], [radius + (depth * sin(5)), depth/2]]);     
        }        
    }

}

function StepSize(stepsize) = stepsize * 180/$fn;
function polySinWave(width, height) =
[
    for(x =[0 : StepSize(1) : 181]) [ x * width/90,  sin(x) * height]
];