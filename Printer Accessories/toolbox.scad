
max_X = 50.8; //2 inch
max_Y = 152.4; //6 inch
max_Z = Inch2mm(3.5); // 6 inch
WallThickness = 1.5;
TeaserX = 18;
TeaserY = 18;
BrushX = 20;
BrushY = 18;
// RazorX = 18;
// RazorY = 18;
//X is width, Y is length, Z is height or depth.
function getWallThickness(walls) = WallThickness * walls;
function PaperHolder_Width() = 4 * WallThickness;
function PaperHolder_Length() = ExtraContainer1_Y();
function PaperHolder_X() = max_X - PaperHolder_Width();

function Teaser_Width() = TeaserX + 2 * WallThickness;
function Teaser_Length() = TeaserY + 2 * WallThickness;

function Extra_Container_Length() = TeaserY + getWallThickness(2);
function Extra_Container_Width() = max_X - PaperHolder_Width() - Teaser_Width() + getWallThickness(2);
function Extra_Container_X() = Teaser_Width() - getWallThickness(1);

function Brush_Width() = BrushX;
function Brush_Length() = BrushY;
function Brush_X(index) = 0;
function Brush_Y(index) = Teaser_Length() + (Brush_Length() * index) - (getWallThickness(index + 1));

function Razor_Width() = 15;
function Razor_Length() = ExtraContainer1_Y() - Teaser_Length() + getWallThickness(2);
function Razor_X() = PaperHolder_X() - Razor_Width() + getWallThickness(1);
function Razor_Y() = Teaser_Length() - getWallThickness(1);

function ExtraContainer1_Width() = max_X;
function ExtraContainer1_Height() = max_Y/3;
function ExtraContainer1_X() = Brush_X(3);
function ExtraContainer1_Y() = Brush_Y(3);

function Inch2mm(inches) = inches * 25.4 ;


Build();

module Build()
{
    MainBox();
}

module MainBox()
{
    linear_extrude(height = max_Z)
    union()
    {
        //main Box
        color("Lavender") 
        Box(max_X, max_Y, 0, WallThickness);

        //level paper holder
        translate([PaperHolder_X(), 0, 0])
        color("MediumSlateBlue") 
        Box(PaperHolder_Width(), PaperHolder_Length(), 0, WallThickness);
        
        //teasers
        color("Plum") 
        Box(Teaser_Width(), Teaser_Length(), 0, WallThickness);
        
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