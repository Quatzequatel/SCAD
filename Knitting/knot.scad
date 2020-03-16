/*
Work in progress.
We decided to abandon this idea for other priorities.
Concept is to use a cone to de-knot yarn as it travels up
to the machine.
*/
$fn = 360;
OD = 30;
WallThickness = 4;
YarnOD = 6;
Height = 40;
MinkowskiR = 5;
ConeAttachmentWidth = OD;
ConeAttachmentLength = OD;
ConeAttachmentHeight = OD;

function ConeAttachmentX() = - (ConeAttachmentWidth + MinkowskiR);
function ConeAttachmentY() = - ConeAttachmentLength/2;
function ConeAttachmentZ() = MinkowskiR;

Build();

module Build(args) 
{
    // body...
    union()
    {
        Cone(OD, WallThickness, YarnOD, Height);
        ConeAttachment();
    }
    
}

module ConeAttachment()
{
        difference()
        {
            echo( x= ConeAttachmentX(), y=  ConeAttachmentY(), z= ConeAttachmentZ());
            translate([ConeAttachmentX(),  ConeAttachmentY(), ConeAttachmentZ()])
            {
                rotate([90, 0, 90]) 
                linear_extrude(ConeAttachmentHeight)
                minkowski() 
                {
                    square(size=[ConeAttachmentWidth, ConeAttachmentLength], center=false);
                    circle(MinkowskiR);
                }
                
            }
            Cone(OD, WallThickness, YarnOD, Height, solid = true);
        }
}

function ConeAngle(d) = 2 * d;
module Cone(d, wall, yarn, height, solid = false)
{
    poly1 = [[0,0], [d,0], [0, ConeAngle(d)]];
    poly2 = [[0,0], [d - wall,0], [0,ConeAngle(d) - wall]];


    difference()
    {
        //cone1
        rotate_extrude()
        polygon(points = poly1);  
        if(solid == false)
        {
            //cone2
            rotate_extrude()
            polygon(points = poly2);     
            //yarn
            linear_extrude(height > ConeAngle(d) ? height : ConeAngle(d))
            hull() 
            {
                circle(d=yarn);  
                translate([d + yarn, 0, 0]) 
                {
                    circle(d=yarn);  
                }            
            }              
        }
    }
}