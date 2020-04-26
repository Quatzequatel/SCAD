
$fn=100;
NozzleWidth = 1.0;
LayerHeight = 0.24;
InitialLayerHeight = 0.4;
mmPerInch = 25.4;

function InchTomm(inches = 1) = inches * mmPerInch;
function height2layers(mm = 1) = mm/LayerHeight;
function layers2Height(layers) = InitialLayerHeight + ((layers - 1) * LayerHeight);
function BaseHeight() = layers2Height(6);
function WallThickness(count) = count * NozzleWidth;

ply48 = InchTomm(48);
ply24 = InchTomm(24);
plyThickness = InchTomm(5/8);
plyHeight = ply48;
plyWidth = ply24;
BoxWidth = InchTomm(12.5);
BoxLength = ply48;
BladeWidth = InchTomm(1/8);

Build();

module Build(args) 
{
    // BuildBox();
    Cuts();
}

module BuildBox(args) 
{
    //Right Side
    translate([0, BoxWidth, plyThickness]) 
    rotate([90,0,0])
    PlywoodSheet(length = plyHeight, width= plyWidth, thickness = plyThickness);

    //Left Side
    translate([0, plyThickness, plyThickness]) 
    rotate([90,0,0])
    PlywoodSheet(length = plyHeight, width= plyWidth, thickness = plyThickness);

    //Front Side
    translate([0, plyThickness, plyWidth + plyThickness ]) 
    rotate([0,90,0])
    PlywoodSheet(length = plyWidth , width= BoxWidth - 2*plyThickness, thickness = plyThickness);

    //Back Side
    translate([BoxLength - plyThickness, plyThickness, plyWidth + plyThickness ]) 
    rotate([0,90,0])
    PlywoodSheet(length = plyWidth , width= BoxWidth - 2*plyThickness, thickness = plyThickness);

    //Bottom
    PlywoodSheet(length = BoxLength, width= BoxWidth, thickness = plyThickness);

    echo("Cut List");
    echo(part = "Sides", Height = plyHeight/mmPerInch, Width = plyWidth/mmPerInch);
    echo(part = "Bottom", Height = BoxLength/mmPerInch, Width = BoxWidth/mmPerInch);
    echo(part = "Front & Back", Height = plyWidth/mmPerInch, Width = (BoxWidth - 2*plyThickness)/mmPerInch);
}

module Cuts()
{
    //sheet
    color("blue")PlywoodSheet(length = plyHeight, width= plyWidth, thickness = plyThickness);

    //Front
    // echo(length = plyWidth/mmPerInch , width= (BoxWidth - 2*plyThickness)/mmPerInch);
    translate([0,0,plyThickness])
    rotate([0,0,0])
    color("red")PlywoodSheet(length = plyWidth , width= BoxWidth - 2*plyThickness, thickness = plyThickness);

    //Back
    translate([plyWidth,0,plyThickness])
    rotate([0,0,0])
    color("pink")PlywoodSheet(length = plyWidth , width= BoxWidth - 2*plyThickness, thickness = plyThickness);

    //Bottom
    translate([0, BoxWidth - ( 2*plyThickness) + BladeWidth, plyThickness])
    rotate([0,0,0])
    color("yellow")PlywoodSheet(length = BoxLength , width= BoxWidth, thickness = plyThickness);

    echo("Cut List");
    echo(part = "Sides", Height = plyHeight/mmPerInch, Width = plyWidth/mmPerInch);
    echo(part = "Bottom", Height = BoxLength/mmPerInch, Width = BoxWidth/mmPerInch);
    echo(part = "Front & Back", Height = plyWidth/mmPerInch, Width = (BoxWidth - 2*plyThickness)/mmPerInch);
}

module PlywoodSheet(length = 0, width= 0, thickness = 0)
{
    cube(size=[length, width, thickness], center=false);
}