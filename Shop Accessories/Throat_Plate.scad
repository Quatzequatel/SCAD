include <constants.scad>;
use <convert.scad>;
$fn=100;

build();

module build() 
{
    dewalt_table_saw_throat_plate();
}

module dewalt_table_saw_throat_plate()
{
    throatplateDimensions = [94.55, 343, 11.06];

    difference()
    {
        //rawplate
        linear_extrude(height = throatplateDimensions.z)
        hull() 
        {
            translate([throatplateDimensions.x/2, 0, 0]) 
            circle(d=throatplateDimensions.x);    
            translate([throatplateDimensions.y - throatplateDimensions.x/2, 0, 0]) 
            circle(d=throatplateDimensions.x);    
        }    

        union()
        {
            //Blade cut
            blade_cut_size = [convert_in2mm(in = 1), convert_in2mm(in = 6.75), throatplateDimensions.z + 1];
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
            
            // //reference markers
            // color("blue")linear_extrude(blade_cut_size.z)
            // union()
            // {
            //     translate([throatplateDimensions.y/2,0,0])
            //     rotate([0,0,90])
            //     square(size=[throatplateDimensions.x, 1], center=true);
            //     translate([throatplateDimensions.y/2,- (throatplateDimensions.x/2 - blade_cut_offset_Dimension.x),0])
            //     square(size=[throatplateDimensions.y, 1], center=true);
            // }

        }
    }

}