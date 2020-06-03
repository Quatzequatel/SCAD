include <constants.scad>;
use <convert.scad>;
use <morphology.scad>;
$fn=100;

throatplateDimensions = [95.55, 344.5, 11.06];


build();

module build() 
{
    dewalt_table_saw_throat_plate();
}

module dewalt_table_saw_throat_plate()
{
    

    difference()
    {
        //rawplate
        union()
        {
            linear_extrude(height = LayersToHeight(12))
            plate();

            linear_extrude(height = throatplateDimensions.z)
            shell(d=-6)
            plate();
        }


        union()
        {
            //Blade cut
            blade_cut_size = [convert_in2mm(in = 1), convert_in2mm(in = 7.25), throatplateDimensions.z + 1];
            blade_cut_offset_Dimension = [24.6, convert_in2mm(in = 2)];
            finger_hole_dia =18.9;
            finger_hole_offset = [16.5, 59, throatplateDimensions.z + 1];

            translate([(throatplateDimensions.y/2 + blade_cut_offset_Dimension.y/2)/2 - blade_cut_size.x/2, -(throatplateDimensions.x/2 - blade_cut_offset_Dimension.x), 0])
            linear_extrude(blade_cut_size.z)
            hull()
            {
                translate([blade_cut_size.y, blade_cut_size.x/2,0])
                circle(d = blade_cut_size.x);
                translate([0, blade_cut_size.x/2,0])
                circle(d = blade_cut_size.x);
            }

            translate([(throatplateDimensions.y - finger_hole_offset.y), (throatplateDimensions.x/2 - blade_cut_offset_Dimension.x), 0])
            linear_extrude(blade_cut_size.z)
            circle(d=finger_hole_dia);
            
            //reference markers
            // color("red")linear_extrude(3 * blade_cut_size.z)
            // union()
            // {
            //     translate([throatplateDimensions.y/2,0,0])
            //     rotate([0,0,90])
            //     square(size=[throatplateDimensions.x, 2], center=true);
            //     // translate([throatplateDimensions.y/2,- (throatplateDimensions.x/2 - blade_cut_offset_Dimension.x),0])
            //     translate([throatplateDimensions.y/2,0,0])
            //     square(size=[throatplateDimensions.y, 2], center=true);
            // }

        }
    }
}

module plate()
{
    hull() 
    {
        translate([throatplateDimensions.x/2, 0, 0]) 
        circle(d=throatplateDimensions.x);    
        translate([throatplateDimensions.y - throatplateDimensions.x/2, 0, 0]) 
        circle(d=throatplateDimensions.x);    
    }     
}