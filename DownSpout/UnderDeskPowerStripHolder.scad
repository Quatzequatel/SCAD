/*
2x4 bracket for under rubber
*/
$fn = 100;
minkowski_circle = 1;
wallThickness = 4;

table_thickness = 31.5 + 2* wallThickness ;
plug_width = 46.5 + wallThickness;
plug_height = 27.5 + 2* wallThickness ;
bracketWidth = 7;

translate([-table_thickness,0,0])
//polyCupIn(table_thickness, plug_width,bracketWidth,wallThickness,bracketWidth);
polyCup(table_thickness, plug_width,bracketWidth,wallThickness,bracketWidth);
translate([-wallThickness,plug_width,bracketWidth])
rotate([180,0,0])

polyCup(plug_height, plug_width, bracketWidth, wallThickness, bracketWidth);

echo(table_thickness-wallThickness*6);

translate([14.5,-wallThickness,0])
cube([wallThickness*4+1,wallThickness,bracketWidth]);

difference()
{
translate([plug_height/2 - wallThickness,64,0])
tube(plug_height/2, bracketWidth, wallThickness);

translate([-4,58,0])
cube([wallThickness*3,wallThickness*3,bracketWidth]);
}



module polyCup(od_length, od_width, od_height, wallThickness, lip)
{
    echo(od_length=od_length, od_width=od_width, od_height=od_height, wallThickness=wallThickness, lip=lip);
    
    od_points = [[0,0],[0,od_width],[od_length,od_width],[od_length,0]];
    od_paths = [[0,1,2,3]];

    in_zero = 0+wallThickness;
    in_length = od_length - wallThickness;
    in_width = od_width - wallThickness;
    

    in_points = [[in_zero,in_zero],[in_zero,od_width],[in_length,od_width ],[in_length,in_zero]];
    in_paths = [[4,5,6,7]];
    
    lip1zeroX = od_length-wallThickness;
    lip1zeroY = od_width;
    lip1zeroX2 = od_length + lip;
    lip1zeroY2 = od_width+wallThickness;

    linear_extrude(od_height,true)
    polygon(concat(od_points,in_points), concat(od_paths,in_paths));
}

module tube(od_radius, height, wallThickness)
{
    linear_extrude(height,true)
    difference()
    {
        circle(od_radius);
        circle(od_radius-wallThickness);
    }
}

module polyCupIn(in_length, in_width, in_height, wallThickness, lip)
{
    echo(in_length=in_length, in_width=in_width, in_height=in_height, wallThickness=wallThickness, lip=lip);
    
    od_points = [[0,0],[0,in_width],[in_length,in_width],[in_length,0]];
    od_paths = [[0,1,2,3]];

    in_zero = 0+wallThickness;
    od_length = in_length + wallThickness;
    od_width = in_width + wallThickness;
    
    echo(od_points=od_points);
    echo(in_points=in_points);
    in_points = [[in_zero,in_zero],[in_zero,od_width],[od_length,od_width ],[od_length,in_zero]];
    in_paths = [[4,5,6,7]];
    
    lip1zeroX = od_length-wallThickness;
    lip1zeroY = od_width;
    lip1zeroX2 = od_length + lip;
    lip1zeroY2 = od_width+wallThickness;

    linear_extrude(in_height,true)
    polygon(concat(od_points,in_points), concat(od_paths,in_paths));
}