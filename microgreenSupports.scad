
/*
1/9/18 supports for microgreens.
*/

$fn=100;


module tube(outerDiameter, wallThickness, height)
{
    linear_extrude(height,true)
    difference()
    {
        circle(outerDiameter,true);
        circle(outerDiameter-wallThickness,true);
    }
}

module squareTube(width,depth,height,wall)
{
        w = width;
        d = depth;
        q = wall;  
    
    a=[[0,0],[w,0],[w,d],[0,d]];
    aa=[[q,q],[w-q,q],[w-q,d-q],[q,d-q]];
    p=[[0,1,2,3],[4,5,6,7]];
    aaa=concat(a,aa);
    
    echo("",aaa);
    
    linear_extrude(height,true)
    polygon(aaa,p,10);
}


module microgreenSupport(rows, width,depth,height,wall)
{
        for(x = [1:rows])
        {
            translate([(x*(width-wall)),0,0])
            difference()
                {
                squareTube(width,depth,height,wall);
                translate([width/4,-10,height*.8])
                squareTube(width/2,depth+20,height/3,wall);
                }
        }
    
}
microgreenSupport(4,50,200,30,4);