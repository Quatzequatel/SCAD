
BoxTopLength=197;
BoxTopWidth=197;
LipHeight=4;
LipThickness=2;
LipOverHangWidth=25;
BoxTopThickness=2;
IsOpenTop=true;


//meshX=26;
meshY=18;
meshZ=40;
Seedrows=4;
Seedcolumns=4;

spokeCount=24;
spokerows=8;
spokeDia=15;
spokeY=2;
wallWidth=2;

//module lip(x,y,wall, height)
//{
//     translate([x/2,y/2,height/2]) difference()
//    {
//    cube([x,y,height],true);
//    cube([x-wall,y-wall,height+1], true);
//    }
//}

//module overlap(x,y,thickness, base)
module overlap(boxTopLength, boxTopWidth, boxTopThickness, lipHeight, lipThickness)
{
    echo(boxTop=4,boxTopLength=boxTopLength, boxTopWidth=boxTopWidth, boxTopThickness=boxTopThickness, lipHeight=lipHeight, lipThickness=lipThickness);
    
    height=boxTopThickness;
    
    echo(boxTopLength=boxTopLength, boxTopWidth=boxTopWidth, lipThickness=lipThickness, lipHeight=lipHeight);
    echo("pink", boxTopLength-lipHeight);
    
    //Box Top Lip
    difference()
    {
     color("red")  cube([boxTopLength,boxTopWidth,lipHeight],true);
     color("pink") cube([boxTopLength-lipThickness,boxTopWidth-lipThickness,lipHeight+2],true);   
    }
    
    //Lid portion of box top.
        translate([0,0,lipHeight/2]) color("blue") cube([boxTopLength,boxTopWidth,boxTopThickness],true);

//    //translate([0,0,lipHeight]) difference()
//    {
//    color("blue") cube([boxTopLength,boxTopWidth,boxTopThickness],true);
//    //color("lightblue") cube([boxTopLength-lipThickness,boxTopWidth-lipThickness,boxTopThickness+1], true);
//    }
}

//module reservoir(x,y,wall, height)
//{
//    //resize([0,0,0]) 
//    translate([x/2,y/2,0]) 
//    cube([x,y,wall],true);
//    difference()
//    {
//    lip(x,y,wall,height);
//    color("blue") translate([-5,y/2,height-(meshZ/2)])
//    rotate(a=180, v=[1,0,1]) cylinder(20,5,5, false);
//    }
//    
//}


module BoxTop(boxTopLength, boxTopWidth, boxTopThickness, lipHeight, lipThickness, isOpenTop, lipOverHangWidth)
{
    echo(boxTop=3,boxTopLength=boxTopLength, boxTopWidth=boxTopWidth, boxTopThickness=boxTopThickness, lipHeight=lipHeight, lipThickness=lipThickness, isOpenTop=isOpenTop, lipOverHangWidth=lipOverHangWidth);
    
        if(isOpenTop)
        {
            rotate([0,180,0]) difference()
            {
                //module overlap(boxTopLength, boxTopWidth, boxTopThickness, lipHeight, lipThickness)
                overlap(boxTopLength, boxTopWidth, boxTopThickness, lipHeight, lipThickness);
                translate(0,0,-2) cube([boxTopLength-lipOverHangWidth,boxTopWidth-lipOverHangWidth,lipHeight+7],true);
            }            
            translate(0,0,-4) color("pink") cylinder(h=lipHeight+7, r= 47.5,true);
        }
        else
        {
            overlap(boxTopLength, boxTopWidth, boxTopThickness, lipHeight, lipThickness);
        }
}

echo(BoxTopLength=BoxTopLength, BoxTopWidth=BoxTopWidth, BoxTopThickness=BoxTopThickness, LipHeight=LipHeight, LipThickness=LipThickness, IsOpenTop=IsOpenTop, LipOverHangWidth=LipOverHangWidth);
BoxTop(BoxTopLength, BoxTopWidth, BoxTopThickness, LipHeight, LipThickness, IsOpenTop, LipOverHangWidth);