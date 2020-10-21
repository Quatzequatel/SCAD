/*
    flashing spacer is to ensure flashing gap is correct for panel and
    properly adjust panel to proper location when inserted.
*/

include <constants.scad>;

use <convert.scad>;
use <trigHelpers.scad>;
use <ObjectHelpers.scad>;
use <dictionary.scad>;

build();

module build() 
{
    flashing_spacer(flashing_spacer_bag);
}

module flashing_spacer(properties)
{
    // echo(str("Variable = ", properties));
    // properties_echo(properties);
    difference()
    {
        linear_extrude(gdv(properties, "depth"))
        polygon(points=triangle(w = gdv(properties, "width"), l = gdv(properties, "length")));
        

        translate(gdv(properties, "nail location")) 
        #cylinder
        (
            d=gdv(properties, "nail hole diameter"), 
            h=gdv(properties, "depth"), 
            center=false,
            $fn= 100
        );

        translate(gdv(properties, "nail location 2")) 
        cylinder
        (
            d=gdv(properties, "nail hole diameter"), 
            h=gdv(properties, "depth") + 1, 
            center=false,
            $fn= 100
        );        
    }
}

/*
    width,
    length,
    origin [0,0]
*/
function triangle(w, l, o = [0,0]) = //echo(w = w, l = l, o = o)
// [1,2,3];
[
    [o.x, o.y],
    [o.x + w, o.y],
    [o.x + w - w/2, o.y + l]
];


Width = convert_in2mm(3/8);

flashing_spacer_bag = 
[
    "flashing_spacer_bag",
        ["width", Width],
        ["length", convert_in2mm(1.5)],
        ["depth", 10],
        ["nail hole diameter", convert_in2mm(1/8)],
        ["nail location", [center(Width), convert_in2mm(1/8), 0,]],
        ["nail location 2", [center(Width), convert_in2mm(5/8), 0,]]
];

function center(x) = x/2;