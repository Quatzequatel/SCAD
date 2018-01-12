
/*
1/9/18 supports for microgreens.
V2 - Added leglength parameter
    reduce the wall height, make up for it with legs. This is to reduce print time.
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
    
//    echo("",aaa);
    
    linear_extrude(height,true)
    polygon(aaa,p,10);
}


module microgreenSupport(rows, width,depth,frameThickness,leglength,wall)
{
        for(x = [1:rows])
        {
            translate([(x*(width-wall)),0,0])
            {
                squareTube(width,depth,frameThickness,wall);
                for(i = [1:4])
                {
                    translate([
                    (i < 3)? (i-1)*(width-wall):(i-3)*(width-wall),
                    (i < 3)? 0                 :(depth-wall),
                    frameThickness])
                    cube([wall,wall,leglength],false);
            }
            }
        }
    
}
microgreenSupport(4,50,200,5,12.7,4);