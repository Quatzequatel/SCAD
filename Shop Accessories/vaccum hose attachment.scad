//35 mm diameter of attachment
//30 mm initial dia of vacuum hose
//31.5 mm final dia of vacuum hose
//30 mm lenght of attachment

$fn=100;

attachmentHeight = 30;
receptorDiameter = 35;
vacuumHoseStartDia = 30;
vacuumHoseEndDia = 31.5;

difference()
{
cylinder(d1 = receptorDiameter-1, d2 = receptorDiameter , h=attachmentHeight, center=true);
cylinder(d1 = vacuumHoseStartDia, d2 = vacuumHoseEndDia , h=attachmentHeight, center=true);
}