
max_X = 50.8; //2 inch
max_Y = 152.4; //6 inch
max_Z = Inch2mm(3.5); // 6 inch
WallThickness = 1.5;
TweezerX = 18;
TweezerY = 18;
BrushX = 20;
BrushY = 18;

KnittingMachineHolderX = 32.5 - AttachmentRounding();
KnittingMachineHolderY = 25.5 - AttachmentRounding();
KnittingMachineHolderZ = 50;
// RazorX = 18;
// RazorY = 18;
//X is width, Y is length, Z is height or depth.
function getWallThickness(walls) = WallThickness * walls;
function PaperHolder_Width() = 5 * WallThickness;
function PaperHolder_Length() = ExtraContainer1_Y() + getWallThickness(1);
function PaperHolder_X() = max_X - PaperHolder_Width();

function Tweezer_Width() = TweezerX + 2 * WallThickness;
function Tweezer_Length() = TweezerY + 2 * WallThickness;

function Extra_Container_Length() = TweezerY + getWallThickness(2);
function Extra_Container_Width() = max_X - PaperHolder_Width() - Tweezer_Width() + getWallThickness(2);
function Extra_Container_X() = Tweezer_Width() - getWallThickness(1);

function Brush_Width() = BrushX;
function Brush_Length() = BrushY;
function Brush_X(index) = 0;
function Brush_Y(index) = Tweezer_Length() + (Brush_Length() * index) - (getWallThickness(index) + 1);

function Razor_Width() = 15;
function Razor_Length() = ExtraContainer1_Y() - Tweezer_Length() + getWallThickness(2);
function Razor_X() = PaperHolder_X() - Razor_Width() + getWallThickness(1);
function Razor_Y() = Tweezer_Length() - getWallThickness(1);

function ExtraContainer1_Width() = max_X;
function ExtraContainer1_Height() = max_Y/3;
function ExtraContainer1_X() = Brush_X(3);
function ExtraContainer1_Y() = Brush_Y(3);

function knittingAttachmentLocationX() = max_X/2;
function knittingAttachmentLocationY() = 30;
function knittingAttachmentLocationZ() = -KnittingMachineHolderZ/2;
function AttachmentRounding() = 4;

function Inch2mm(inches) = inches * 25.4 ;

$fn = 100;

Build();

module Build()
{
    MainBox();
    knittingMachineHolder();
}

module MainBox()
{
    linear_extrude(height = max_Z)
    translate([max_X,0,0])
    rotate([0,180,0])
    union()
    {
        //main Box
        color("Lavender") 
        Box(max_X, max_Y, 0, WallThickness);

        //level paper holder
        translate([PaperHolder_X(), 0, 0])
        color("MediumSlateBlue") 
        Box(PaperHolder_Width(), PaperHolder_Length(), 0, WallThickness);
        
        //Tweezer
        color("Plum") 
        Box(Tweezer_Width(), Tweezer_Length(), 0, WallThickness);
        
        //Extra container
        color("Violet") 
        translate([Extra_Container_X(),0,0])
        Box(Extra_Container_Width(), Extra_Container_Length(), 0, WallThickness);
        
        //Brush 1
        color("Fuchsia") 
        translate([Brush_X(0), Brush_Y(0), 0])
        Box(Brush_Width(), Brush_Length(), 0, WallThickness);
        
        //Brush 2
        color("Aqua") 
        translate([Brush_X(1), Brush_Y(1), 0])
        Box(Brush_Width(), Brush_Length(), 0, WallThickness);
        
        //Brush 3
        color("DarkViolet") 
        translate([Brush_X(2), Brush_Y(2), 0])
        Box(Brush_Width(), Brush_Length(), 0, WallThickness);
        
        //Razor holder
        translate([ Razor_X(), Razor_Y(), 0])
        color("Aquamarine") 
        Box(Razor_Width(), Razor_Length(), 0, WallThickness);   

        //Extra container 2
        translate([ExtraContainer1_X(), ExtraContainer1_Y(), 0])
        Box(ExtraContainer1_Width(), ExtraContainer1_Height(), 0, WallThickness); 
    }
    linear_extrude(height = WallThickness)
    square(size=[max_X, max_Y]);
}

module knittingMachineHolder(args) {
    echo(x=knittingAttachmentLocationX(), y=knittingAttachmentLocationY(), z=knittingAttachmentLocationZ());
    translate([knittingAttachmentLocationX(),knittingAttachmentLocationY(),knittingAttachmentLocationZ()])
    minkowski()
    {
        cube(size=[KnittingMachineHolderX, KnittingMachineHolderY, KnittingMachineHolderZ], center=true);  
        cylinder(r=AttachmentRounding(), center=true);      
    }

}

module Box(x,y,z,wall) 
{
    difference()
    {
        square(size=[x, y]);
        translate([wall, wall, 0]) 
        {
            square(size=[x - 2*wall, y - 2*wall]);
        }
    }    
}