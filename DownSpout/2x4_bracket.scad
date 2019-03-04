/*
2x4 bracket for under rubber
*/
$fn = 100;
minkowski_circle = 1;
wallThickness = 4;
bracketWidth = 20;

width_of24 = 92+( 2* wallThickness);
//height_of24 = 40;
height_of24 = width_of24/2;

//Wood Utensil Organizer Shim
Width = 175;
Depth = 135;


polyCup(width_of24, height_of24,bracketWidth,wallThickness,bracketWidth);
//difference()
//{
//squareTube(Width, Depth, wallThickness,bracketWidth,minkowski_circle);
//translate([0,-(height_of24-3),0])
//block(width_of24+2, height_of24, wallThickness,bracketWidth+2);
//}
//square([width_of24 -minkowski_circle, height_of24 -minkowski_circle],true);

module squareTube(OD_width, OD_height, wallThickness, OD_length, minkowski_circle)
{
    echo(OD_width=OD_width, OD_height=OD_height, wallThickness=wallThickness, OD_length=OD_length, minkowski_circle=minkowski_circle);
    
    linear_extrude(OD_length,true)
    difference()
    {
        minkowski()
        {
        square([OD_width - minkowski_circle, OD_height - minkowski_circle],true);
            circle(minkowski_circle);
        }
        
        minkowski()
        {
        square([OD_width -wallThickness -minkowski_circle,OD_height -wallThickness -minkowski_circle],true);
                        circle(minkowski_circle);
        }
    }
}

module solidTube(OD_width, OD_height, wallThickness, OD_length, minkowski_circle)
{
    echo(OD_width=OD_width, OD_height=OD_height, wallThickness=wallThickness, OD_length=OD_length, minkowski_circle=minkowski_circle);
    
    linear_extrude(OD_length,true)
    minkowski()
    {
        square([OD_width -minkowski_circle, OD_height -minkowski_circle],true);
        circle(minkowski_circle);
    }
}

module block(OD_width, OD_height, wallThickness, OD_length)
{
    echo(OD_width=OD_width, OD_height=OD_height, wallThickness=wallThickness, OD_length=OD_length);
    
    linear_extrude(OD_length,true)
    {
        square([OD_width -minkowski_circle, OD_height -minkowski_circle],true);
    }
}

module polyBlock(od_length, od_width, od_height, wallThickness)
{
    od_points = [[0,0],[0,od_width],[od_length,od_width],[od_length,0]];
    od_paths = [[0,1,2,3]];

    in_zero = 0+wallThickness;
    in_length = od_length - wallThickness;
    in_width = od_width - wallThickness;
    

    in_points = [[in_zero,in_zero],[in_zero,in_width],[in_length,in_width],[in_length,in_zero]];
    in_paths = [[4,5,6,7]];

    linear_extrude(od_height,true)
    polygon(concat(od_points,in_points), concat(od_paths,in_paths));
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
    
    echo(lip1zeroX=lip1zeroX, lip1zeroY=lip1zeroY, lip1zeroX2=lip1zeroX2, lip1zeroY2=lip1zeroY2);
    
    lip1_points = [
        [lip1zeroX,lip1zeroY],
        [lip1zeroX2,lip1zeroY], 
        [lip1zeroX2, lip1zeroY2], 
        [lip1zeroX,lip1zeroY2]];
    lip1_paths = [[8,9,10,11]];
    echo(lip1_points=lip1_points);
    
    
    lip2zeroX = wallThickness;
    lip2zeroY = od_width;
    lip2zeroX2 = (lip) * -1;
    lip2zeroY2 = od_width+wallThickness;
    
    echo(lip2zeroX=lip2zeroX, lip2zeroY=lip2zeroY, lip2zeroX2=lip2zeroX2, lip2zeroY2=lip2zeroY2);
    
    lip2_points = [
        [lip2zeroX,lip2zeroY],
        [lip2zeroX2,lip2zeroY], 
        [lip2zeroX2, lip2zeroY2], 
        [lip2zeroX,lip2zeroY2]];
    lip2_paths = [[12,13,14,15]];
    echo(lip2_points=lip2_points);   
    

    linear_extrude(od_height,true)
    polygon(concat(od_points,in_points,lip1_points,lip2_points), concat(od_paths,in_paths,lip1_paths,lip2_paths));
}