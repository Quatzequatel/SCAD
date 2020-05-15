/*
2020.05.05
i am frequently annoyed with having to rotate objects to get
proper orientation. this library is for drawing basic shapes;
going from point to point. because these modules always use the
2D shape and then extrude to get a "3D" shape the object will always
have an x,y orientation. the side-effect is it starts and ends in the
x,y plane.
*/
use <hull_polyline2d.scad>;

// $fn=100;
Test();

module point_sphere(diameter, p1, p2, fn = 20)
{
    // echo(func = "point_sphere", diameter = diameter, p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) sphere(d = diameter, $fn = fn);
        translate(p2) sphere(d = diameter, $fn = fn);
    } 
}

module point_cylinder(diameter, p1, p2, zRes = 0.01)
{
    echo(func = "point_sphere", p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) cylinder(d = diameter, h=zRes, center=true);
        translate(p2) cylinder(d = diameter, h=zRes, center=true);
    } 
}

module point_polygon(points, paths, p1, p2, zRes = 0.01)
{
    echo(func = "point_polygon", p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) 
            linear_extrude(height = zRes)
            polygon(points=points, paths=paths);
        translate(p2) 
            linear_extrude(height = zRes)
            polygon(points=points, paths=paths);
    } 
}

module point_square(size, p1, p2, zRes = 0.01)
{
    echo(func = "point_square", size = size, p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) 
            linear_extrude(height = zRes)
            square(size=size, center = true);
        translate(p2) 
            linear_extrude(height = zRes)
            square(size=size, center = true);
    } 
}

module point_squareTube(size, wall, p1, p2, zRes = 0.01)
{
    echo(func = "point_squareTube", size = size, p1 = p1, p2 = p2);
    
    // hull()
    // {
        translate(p1) 
            linear_extrude(height = zRes)
            polygon(pointsSquareTube(size = size, p0=[p1.x, p1.y], wall=wall));
        translate(p2) 
            linear_extrude(height = zRes)
            polygon(pointsSquareTube(size = size, p0=[p1.x, p1.y], wall=wall));
    // } 
}

module point_circle(diameter, p1, p2, zRes = 0.01, fn = 6)
{
    echo(func = "point_circle", diameter = diameter, p1 = p1, p2 = p2, zRes = zRes, fn = fn);
    
    hull()
    {
        translate(p1) 
            linear_extrude(height = zRes)
            circle(d=diameter, $fn = fn);

        translate(p2) 
            linear_extrude(height = zRes)
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