/*
2020.05.05
i am frequently annoyed with having to rotate objects to get
proper orientation. this library is for drawing basic shapes;
going from point to point. because these modules always use the
2D shape and then extrude to get a "3D" shape the object will always
have an x,y orientation. the side-effect is it starts and ends in the
x,y plane.
*/
include <constants.scad>;
use <hull_polyline2d.scad>;
use <trigHelpers.scad>;

// $fn=100;
Test();

module point_sphere(diameter = 1, p1, p2, fn = 20)
{
    debugEcho
        (
            lable = "point_sphere([0]=diameter, [1]=p1, [2]=p2)", 
            args = [diameter, p1, p2]
        ) ;

    hull()
    {
        translate(p1) sphere(d = diameter, $fn = fn);
        translate(p2) sphere(d = diameter, $fn = fn);
    } 
}

module point_cylinder(diameter, p1, p2, height = 0.01)
{
    debugEcho
        (
            lable = "point_cylinder([0]=diameter, [1]=p1, [2]=p2, [3]=height)", 
            args = [diameter, p1, p2, height]
        ) ;
    
    hull()
    {
        translate(p1) cylinder(d = diameter, h=height, center=true);
        translate(p2) cylinder(d = diameter, h=height, center=true);
    } 
}

module point_polygon(points, paths, p1, p2, height = 0.01)
{
    // echo(func = "point_polygon", points = points, paths = paths, p1 = p1, p2 = p2);
    debugEcho
        (
            lable = "point_polygon([0]=points, [1]=paths, [2]=p1, [3]=p2, [4]=height)", 
            args = [points, paths, p1, p2, height]
        ) ;    
    
    // hull()
    // {
        translate(p1) 
            linear_extrude(height = height)
            polygon(points=points, paths=paths);
        translate(p2) 
            linear_extrude(height = height)
            polygon(points=points, paths=paths);
    // } 
}

module point_square1(size, p1, p2, height = 0.01)
{
    debugEcho("ShapesByPoints1::point_square1() ", [size, p1, p2]);
    let
    (
        points1 = getPoints(p1, size),
        points2 = getPoints(p2, size)
    )
    {
        debugEcho("point_square1() ", [points1, points2]);

        if(p1.z != p2.z && p1.x == p2.x && p1.y == p2.y)
        {
            linear_extrude(height = p1.z)
            polygon(points=getPoints(p1, size));
        }
        else
        {
            linear_extrude(height = height)
            polygon(points=points1);

            translate(p2) 
            polygon(points=points2);
        }
    }
    function getPoints(p1, size) = 
    let
    (
        result = 
            [
                [p1.x, p1.y], 
                [p1.x, p1.y + size.y],
                [p1.x + size.x, p1.y + size.y],
                [p1.x + size.x, p1.y]
            ]
    )
    result;
}

// function getRectPoints(origin, size, angle) = 
// let
// (
//     h =  angle < 45 ? sideBaA(size.y, angle) : sideAaA(size.y, sideA) //hypotenuse
//     result = 
//         [
//             [origin.x, origin.y], 
//             [origin.x, origin.y + size.y],
//             [origin.x + size.x + h, origin.y + size.y],
//             [origin.x + size.x + h, origin.y]
//         ]
// )
// result;


module point_square(size, p1, p2, height = 0.01, center = true)
{
    // debugEcho("ShapesByPoints::point_square() ", [size, p1, p2]);
    
    hull()
    {
        if(p1.y == p2.y)
        {
            translate(p1) 
                linear_extrude(height = height)
                square(size= [size.y, size.x], center = center);
            translate(p2) 
                linear_extrude(height = height)
                square(size= [size.y, size.x], center = center);
        }
        else
        {
            translate(p1) 
                linear_extrude(height = height)
                square(size= [size.x, size.y], center = center);
            translate(p2) 
                linear_extrude(height = height)
                square(size= [size.x, size.y], center = center);            
        }
    } 
}

module point_squareTube(size, wall, p1, p2, height = 0.01)
{
    echo(func = "point_squareTube", size = size, p1 = p1, p2 = p2);
    
    // hull()
    // {
        translate(p1) 
            linear_extrude(height = height)
            polygon(pointsSquareTube(size = size, p0=[p1.x, p1.y], wall=wall));
        translate(p2) 
            linear_extrude(height = height)
            polygon(pointsSquareTube(size = size, p0=[p1.x, p1.y], wall=wall));
    // } 
}

module point_circle(diameter, p1, p2, height = 0.01, fn = 6)
{
    echo(func = "point_circle", diameter = diameter, p1 = p1, p2 = p2, height = height, fn = fn);
    
    hull()
    {
        translate(p1) 
            linear_extrude(height = height)
            circle(d=diameter, $fn = fn);

        translate(p2) 
            linear_extrude(height = height)
            circle(d=diameter, $fn = fn);
    } 
}

function pointsSquare(size, p0) = 
[
    p0,
    [p0.x + size.x, p0.y],
    [p0.x + size.x, p0.y + size.y],
    [p0.x, p0.y + size.y],
    p0
];

/*
    size = width, depth or x, y
    p0 = point zero or orgin for square
    wall = thickness of wall
    p1 = origin for inner square
*/
function pointsSquareTube(size, p0, wall, p1) =
    concat(
        pointsSquare(size=size, p0=p0), 
        pointsSquare(size=[size.x - wall, size.y - wall], p0 = p1 == undef ? [p0.x + wall/2, p0.y + wall/2] : p1)
        );


module Test()
{
    point_sphere(diameter = 3, p1 = [-10, 0, 0], p2 = [0, 10, 10]);
    point_polygon(points = [[0,0],[0,3],[4,0]], p1 = [10, 0, 0], p2 = [0, -10, 10]);
    // point_square(size = [2,4], p1 = [0,0,0], p2 = [0,20,20]);
    point_cylinder(diameter = 3, p1 = [10, 0, 0], p2 = [0, -10, 10]);
    point_squareTube(size = [4,4], wall = 1, p1 = [0,0,0], p2 = [0,0,4]);

    polygon(pointsSquareTube(size = [4,4], p0=[20,0], wall=1));
}