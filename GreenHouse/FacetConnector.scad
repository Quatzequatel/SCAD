include <constants.scad>;
use <shapesByPoints.scad>;
use <convert.scad>;
use <ObjectHelpers.scad>;
use <trigHelpers.scad>;

use <box_extrude.scad>;
/*
Connect beam to square railing
*/
tollerance = 1*NozzleWidth;
shell_thickness = 4 * NozzleWidth;
shell_bottom = LayersToHeight(7);

BeamDimension = [convert_in2mm(1) + 2*tollerance, convert_in2mm(6) + tollerance, convert_in2mm(96)];
RailingDimension = [convert_in2mm(0.75) + tollerance, convert_in2mm(0.75) + tollerance, convert_in2mm(96)];

RailingAttachementDimension = 
[
    RailingDimension.x + 2 * shell_thickness, 
    RailingDimension.y + 2 * shell_thickness, 
    convert_in2mm(1)
];

BeamAttachementDimension = 
[
    BeamDimension.x + 2 * shell_thickness, 
    BeamDimension.y + 2 * shell_thickness, 
    convert_in2mm(1)
];

//[radius, length]
screwDimension = [woodScrewShankDiaN_8, convert_in2mm(1)];

build();

module build() 
{
    difference()
    {
        FacetConnector(showRailing=true);
        screwholes();        
    }
}

module FacetConnector(showRailing=false)
{

        echo(BeamAttachementDimension = BeamAttachementDimension);
        // railing attachment
        rotate([180,0,0])
          
            union()
            {
                difference()
                {
                    hull() 
                    {
                        zRes = 0.01;
                        linear_extrude(height = zRes)
                        square(size=[BeamAttachementDimension.x, BeamAttachementDimension.x], center=true); 
                        translate([0,0,BeamAttachementDimension.z])
                        linear_extrude(height = zRes)
                        square(size=[RailingAttachementDimension.x, RailingAttachementDimension.y], center=true);    
                    }      

                    linear_extrude(height =  RailingDimension.z + 10)
                    square(size=[RailingDimension.x, RailingDimension.y], center=true) ;                     
                }
            }        

        //beam attachment
        difference()
        {
            linear_extrude(height = BeamAttachementDimension.z)
            square(size=[BeamAttachementDimension.x, BeamAttachementDimension.x], center = true);

            translate([0, 0, shell_bottom]) 
            linear_extrude(height = 100)
            square(size=[BeamDimension.x, BeamDimension.y], center = true);
        } 
}

module screwholes(screwDimension = screwDimension) 
{
    p1 = [-BeamAttachementDimension.x/2 - tollerance, 0, BeamAttachementDimension.z/2];
    p2 =  [BeamAttachementDimension.x/2 + tollerance, 0, BeamAttachementDimension.z/2];

    p3 = [-BeamAttachementDimension.x/2 - tollerance, 0, -BeamAttachementDimension.z/2];
    p4 =  [BeamAttachementDimension.x/2 + tollerance, 0, -BeamAttachementDimension.z/2];

    point_sphere(diameter = screwDimension.x, p1=p1, p2 = p2);

    point_sphere(diameter = screwDimension.x, p1=p3, p2 = p4);
}

