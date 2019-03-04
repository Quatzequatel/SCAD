/*
3499 x 10200
*/

width = 106;
depth = 40; //Was 35s
height = 10;
wall = 2;
thickness=3;




function totalLength(w,d) = w+d;
function squareLength(tw,d) = tw - d;
function radius(d) = d/2;
function focus2(w,d)=w-radius(d);

module oval(w, d, h)
{
    hull()
    {
        translate([focus2(w,d), radius(d), 0])
        cylinder($fn=100, h, d=d, false);
        
        translate([radius(d), radius(d), 0])
        cylinder($fn=100, h, d=d, false);
    }
}

module ovalWall(w, d, h, wall)
{
    difference()
    {
    oval(w, d, h);
    translate([wall,wall,h/2])
        oval(w-(2*wall), d-(2*wall), h*wall);
    }
}

difference()
{
    ovalWall(width, depth, height, wall);
    translate([width/4, depth/4,-wall])
    oval(width/2, depth/2, 20);
    
//        ovalWall(102, 34.9, 3, 2);
//    translate([51/2, 17.5/2,-2])
//    oval(51, 17.5,20);
}

