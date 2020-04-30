/*

*/

$fn=100;
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

module Build(args) 
{
    Tool();
}

module Tool()
{
    radius = 30;
    xvalue = -10;
    slotWidth = 20;
    slotRadius = 2.5;
    WallThickness = WallThickness(9.5);
    echo( xymove=xymove(angle= 90, width = radius));

    linear_extrude(height = layers2Height(20))
    {    
    difference()
        {
            circle(r=radius, $fn=6);
            
            translate([0,18,0])      
            hull() 
            {
                translate([-slotWidth/2,0,0])
                circle(r=slotRadius);

                translate([slotWidth/2,0,0])    
                circle(r=slotRadius);
            }
            
            translate([-15,-9,0])      
            rotate([0, 0, -240]) 

            hull() 
            {
                translate([-slotWidth/2,0,0])
                circle(r=slotRadius);
                
                translate([slotWidth/2,0,0])    
                circle(r=slotRadius);
            }

            translate( [15,-9.5,0])
            rotate([0, 0, 60]) 
            hull() 
            {
                translate([-slotWidth/2,0,0])
                circle(r=slotRadius);
                
                translate([slotWidth/2,0,0])    
                circle(r=slotRadius);
            }        
        }
    }

    // zvalue = 8;
    // translate([0, 0, zvalue])
    // #square(size=[60, 1], center=true);
    // translate([0, 0, zvalue])
    // rotate([0, 0, 60])
    // #square(size=[100, 1], center=true);
    // translate([0, 0, zvalue])
    // rotate([0, 0, -60])
    // #square(size=[100, 1], center=true);    
    function foobar() = radius - bar() ;
    function bar() = (slotRadius * 2 + WallThickness) ;
    function xymove(angle, width) = [cos(angle) * (width - WallThickness), sin(angle) * (width - WallThickness), 0];
}