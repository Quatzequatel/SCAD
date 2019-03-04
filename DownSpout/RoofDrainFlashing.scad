
FlashingWidth = 155;
FlashingLength = 30;
FlashingWallHeight = 6.35;

translate([-FlashingWidth,-FlashingLength,0])
{
    cube([FlashingWidth,FlashingLength,2]);
    cube([3,FlashingLength,FlashingWallHeight+1]);
    translate([FlashingWidth-3,0,0])
    cube([3,FlashingLength,FlashingWallHeight+1]);
}

//translate([-10,-10,0])
rotate(155)
//translate([-10,-10,0])
cube([FlashingWidth,70,2]);