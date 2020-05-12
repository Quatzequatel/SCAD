

build();

module build(args) 
{
    // echo(c = color("aqua"));
     color("violet") example1() ;
     example2() ;
}

module obj()
{
    union()
    {
        cylinder(r=10.0,h=10,center=false);
        cube(size=[10,10,10],center=false); 
    }   
}

/*
multmatrix
Multiplies the geometry of all child elements with the given affine transformation matrix, 
where the matrix is 4×3 - a vector of 3 row vectors with 4 elements each, 
or a 4×4 matrix with the 4th row always forced to [0,0,0,1].

Usage: multmatrix(m = [...]) { ... }

This is a breakdown of what you can do with the independent elements in the matrix (for the first three rows):
[Scale X]	[Shear X along Y]	[Shear X along Z]	[Translate X]
[Shear Y along X]	[Scale Y]	[Shear Y along Z]	[Translate Y]
[Shear Z along X]	[Shear Z along Y]	[Scale Z]	[Translate Z]
The fourth row is forced to [0,0,0,1] and can be omitted unless you are combining matrices before passing to multmatrix, 
as it is not processed in OpenSCAD. Each matrix operates on the points of the given geometry as 
if each vertex is a 4 element vector consisting of a 3D vector with an implicit 1 as its 4th element, 
such as v=[x, y, z, 1]. The role of the implicit fourth row of m is to preserve the implicit 1 in the 
4th element of the vectors, permitting the translations to work. The operation of multmatrix therefore 
performs m*v for each vertex v. Any elements (other than the 4th row) not specified in m are treated as zeros.

This example rotates by 45 degrees in the XY plane and translates by [10,20,30], 
i.e. the same as translate([10,20,30]) rotate([0,0,45]) would do.
*/
module example1() 
{
    angle=45;
    multmatrix
        (
            m = [ [cos(angle), -sin(angle), 0, 10],
                 [sin(angle),  cos(angle), 0, 20],
                 [         0,           0, 1, 30],
                 [         0,           0, 0,  1]
                ]
        ) 
    obj();
}

/*
The following example demonstrates combining affine transformation matrices by matrix multiplication, 
producing in the final version a transformation equivalent to rotate([0, -35, 0]) translate([40, 0, 0]) Obj();. 
Note that the signs on the sin function appear to be in a different order than the above example, 
because the positive one must be ordered as x into y, y into z, z into x for the rotation angles to correspond to 
rotation about the other axis in a right-handed coordinate system.
*/
module example2() 
{
    y_ang=-35;
    mrot_y = 
        [ 
            [ cos(y_ang), 0,  sin(y_ang), 0],
            [         0,  1,           0, 0],
            [-sin(y_ang), 0,  cos(y_ang), 0],
            [         0,  0,           0, 1]
        ];
    mtrans_x = 
        [ 
            [1, 0, 0, 40],
            [0, 1, 0,  0],
            [0, 0, 1,  0],
            [0, 0, 0,  1]
        ];
    
    echo(example2 = mrot_y*mtrans_x);

    color("grey") obj();
    color("aqua") multmatrix(mtrans_x) obj();
    color("SteelBlue") multmatrix(mrot_y * mtrans_x) obj();
}