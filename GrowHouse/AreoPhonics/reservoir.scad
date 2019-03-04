
meshX=26;
meshY=18;
meshZ=40;
Seedrows=4;
Seedcolumns=4;

spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

//Single Plant Box
//reservoir(130,130,2,121);

module lip(x,y,wall, height)
{
     translate([x/2,y/2,height/2]) difference()
    {
    cube([x,y,height],true);
    cube([x-wall,y-wall,height+1], true);
    }
}

module overlap(x,y,thickness, base)
{
    height=3;
    wall=3;
    
    echo(x=x,y=y,thickness=thickness, base=base);
    difference()
    {
    color("red")  cube([x,y,thickness],true);
     color("pink") cube([x-base,y-base,thickness+2],true);   
    }
    
    translate([0,0,thickness]) difference()
    {
    color("blue") cube([x,y,height],true);
    //color("lightblue") cube([x-wall,y-wall,height+1], true);
    }
}

module reservoir(x,y,wall, height)
{
    echo(x=x,y=y,wall=wall, height=height);
    //resize([0,0,0]) 
    translate([x/2,y/2,0]) 
    cube([x,y,wall],true);
    difference()
    {
    lip(x,y,wall,height);
    color("blue") translate([-5,y/2,height-(meshZ/2)])
    rotate(a=180, v=[1,0,1]) cylinder(20,7,7, false);
    }
    
}

//difference()
//{
//overlap(198,198,3,3);
//translate(0,0,-2) cube([170,170,10],true);
//}

reservoir(130,130,2,121);