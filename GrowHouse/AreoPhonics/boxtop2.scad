BoxTopLength=197;
BoxTopWidth=197;
LipHeight=2;
LipThickness=2;
LipOverHangWidth=25;
BoxTopThickness=2;
IsOpenTop=true;


module BoxTop( boxTopLength, 
                boxTopWidth, 
                boxTopThickness, 
                lipHeight, 
                lipWallThicknesss, 
                isOpenTop, 
                OverHangMargin)


{
    if(isOpenTop)
    {
        //Create the overhang for the lid
        difference()
        {
             color("red")  cube([boxTopLength,boxTopWidth,lipHeight],true);
             translate([0,0,boxTopThickness ]) color("pink") cube([boxTopLength-lipWallThicknesss,boxTopWidth-lipWallThicknesss,lipHeight+2],true); 
          translate([0,0,-boxTopThickness-3]) color("orange") cylinder(10,47.5,47.5,$fn=100);

        }
    }
}



difference()
{
BoxTop(BoxTopLength,BoxTopLength,LipHeight,8, LipThickness, IsOpenTop, LipOverHangWidth);    
    //translate([0,0,8]) color("orange") cylinder(8,47.5,47.5,$fn=100);
}