/*
2020.05.05
i am frequently annoyed with having to rotate objects to get
proper orientation. this library is for drawing basic shapes;
going from point to point. because these modules always use the
2D shape and then extrude to get a "3D" shape the object will always
have an x,y orientation. the side-effect is it starts and ends in the
x,y plane.
*/

use <vectorHelper.scad>
// $fn=100;
Test();

module point_sphere(diameter, p1, p2)
{
    echo(func = "point_sphere", p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) sphere(d = diameter);
        translate(p2) sphere(d = diameter);
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
    echo(func = "point_cube", p1 = p1, p2 = p2);
    
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

module point_circle(diameter, p1, p2, zRes = 0.01)
{
    echo(func = "point_circle", p1 = p1, p2 = p2);
    
    hull()
    {
        translate(p1) 
            linear_extrude(height = zRes)
            circle(d=diameter);
        translate(p2) 
            linear_extrude(height = zRes)
            circle(d=diameter);
    } 
}

module Test()
{
    point_sphere(diameter = 3, p1 = [-10, 0, 0], p2 = [0, 10, 10]);
    point_polygon(points = [[0,0],[0,3],[4,0]], p1 = [10, 0, 0], p2 = [0, -10, 10]);
    point_square(size = [2,4], p1 = [0,0,0], p2 = [0,20,20]);
    point_cylinder(diameter = 3, p1 = [10, 0, 0], p2 = [0, -10, 10]);
}