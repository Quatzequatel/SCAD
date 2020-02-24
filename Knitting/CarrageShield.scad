/*
CarrageShield
2/23/2020
This is a shield that fits on the carrage to trigger passage counters

CarrageShell is the cover over the electronics. This CarrageShield will
hook onto the CarrageShell. the thickness of the CarrageShield presses against the
trigger.

*/
//CarrageShieldSide = CSS_
x0=0;
y0=0;
CSS_FullWidth = 40; //x1
CSS_FaceDepth = 20; //x2
CSS_ClaspWall = 5;  //x4
CSS_ShellWall = CSS_FullWidth - (CSS_FaceDepth + CSS_ClaspWall); //x3
echo(CSS_ShellWall=CSS_ShellWall);

CSS_FaceHeight = 25;        //y1
CSS_ClaspBaseHeight = 5;    //y2
CSS_ClaspFullHeight = CSS_FaceHeight - CSS_ClaspBaseHeight; //y3
CSS_ClaspHeight = CSS_ClaspFullHeight - CSS_ClaspBaseHeight; //y4

CSS_FaceWidth = 200; //z1

x1 = CSS_FullWidth;
x2 = CSS_FaceDepth;
x3 = CSS_ShellWall;
x4 = CSS_ClaspWall;

y1 = CSS_FaceHeight;
y2 = CSS_ClaspBaseHeight;
y3 = CSS_ClaspFullHeight;
y4 = CSS_ClaspHeight;

z1 = CSS_FaceWidth;

CSS_Polygon = [[x0,y0],[x1,y0], [x1,y1], [x3, y1], [x3, y2], [x4, y2], [x4, y4], [x0, y4]];
echo(CSS_Polygon=CSS_Polygon);

linear_extrude(height=z1)
polygon(CSS_Polygon);