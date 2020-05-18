/*
this library is a personal customization of Justin Lin's work
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib2x-along_with.html
 
 library for drawing common lattice designs.

*/
include <constants.scad>;
use <convert.scad>;

// wall constants

NO_WALL = 0;     
UP_WALL = 1;      
RIGHT_WALL = 2;    
UP_RIGHT_WALL = 3;

block_width = 3;
wall_thickness = 1;
maze_rows = 30;
maze_columns = 30;  

Test();

module Test()
{
    // maze_blocks = go_maze(
    //     1, 1,   // the starting point
    //     starting_maze(maze_rows, maze_columns),  
    //     maze_rows, maze_columns
    // );
    frameDimension = [300,300];
    frameBoardDimension = [4 * NozzleWidth, convert_in2mm(0.5)];
    LatticeDimension = [WallThickness(count = 2), layers2Height(8)];
    // cellwidth =  FrameBoardDimension.y;

    DrawMazeFrame(frameDimension = frameDimension, frameBoardDimension = frameBoardDimension, latticeDimension = LatticeDimension);
    
    // DrawMazeFrame
    // (
    //     rows = floor(FrameDimension.x/cellwidth ), 
    //     columns = floor(FrameDimension.y/cellwidth ), 
    //     width = cellwidth, 
    //     thickness = FrameBoardDimension.x
    // );
}

module DrawMazeFrame(frameDimension, frameBoardDimension, latticeDimension)
{
    cellwidth =  latticeDimension.x * 5;
    DrawMaze
    (
        rows = floor(frameDimension.x/cellwidth ), 
        columns = floor(frameDimension.y/cellwidth ), 
        width = cellwidth, 
        thickness = latticeDimension.y
    );
}

module DrawMaze(rows = 10, columns = 10, width = 10, thickness = 4)
{
    echo(DrawMaze = 1, rows = rows, columns = columns, width = width, thickness = thickness)
    let
    (
        maze_rows = rows, 
        maze_columns = columns, 
        // maze_blocks, 
        block_width = width, 
        wall_thickness = thickness

    )
    {
        echo(draw_maze = "WARNING THIS CAN BE SLOW!!!");
        // echo(DrawMaze = 1, rows = rows, columns = columns, width = width, thickness = thickness)
        draw_maze(
            maze_rows, 
            maze_columns, 
            go_maze
            (
                1, 1,   // the starting point
                starting_maze(maze_rows, maze_columns),  
                maze_rows, maze_columns
            ), 
            block_width, 
            wall_thickness
        );
    }    
}



module line(point1, point2, width = 1, cap_round = true) {
    angle = 90 - atan((point2[1] - point1[1]) / (point2[0] - point1[0]));
    offset_x = 0.5 * width * cos(angle);
    offset_y = 0.5 * width * sin(angle);

    offset1 = [-offset_x, offset_y];
    offset2 = [offset_x, -offset_y];

    if(cap_round) {
        translate(point1) circle(d = width, $fn = 24);
        translate(point2) circle(d = width, $fn = 24);
    }

    polygon(points=[
        point1 + offset1, point2 + offset1,  
        point2 + offset2, point1 + offset2
    ]);
}

module polyline(points, width = 1) {
    module polyline_inner(points, index) {
        if(index < len(points)) {
            line(points[index - 1], points[index], width);
            polyline_inner(points, index + 1);
        }
    }

    polyline_inner(points, 1);
}



function block_data(x, y, wall_type, visited) = [x, y, wall_type, visited];
function get_x(block_data) = block_data[0];
function get_y(block_data) = block_data[1];
function get_wall_type(block_data) = block_data[2];

module draw_block(wall_type, block_width, wall_thickness) {
    if(wall_type == UP_WALL || wall_type == UP_RIGHT_WALL) {
        // the upper wall
        polyline(
            [[0, block_width], [block_width, block_width]], wall_thickness
        ); 
    }

    if(wall_type == RIGHT_WALL || wall_type == UP_RIGHT_WALL) {
        // the right wall
        polyline(
            [[block_width, block_width], [block_width, 0]], wall_thickness
        ); 
    }
}

module draw_maze(rows, columns, blocks, block_width, wall_thickness) {
    for(block = blocks) {
        // move the block to its correspond position
        translate([get_x(block) - 1, get_y(block) - 1] * block_width) 
            draw_block(
                get_wall_type(block), 
                block_width, 
                wall_thickness
            );
    }

    // the lowermost wall
    polyline(
        [[0, 0], [block_width * columns, 0]], 
        wall_thickness);
    // the leftmost wall
    polyline(
        [[0, block_width], [0, block_width * rows]], 
        wall_thickness);
} 

// initialize the status of a maze   
function starting_maze(rows, columns) =  [
    for(y = [1:rows]) 
        for(x = [1:columns]) 
            block_data(
                x, y, 
                // all blocks have UP_RIGHT_WALL except the exit
                y == rows && x == columns ? UP_WALL : UP_RIGHT_WALL, 
                // false is unvisited
                false 
            )
];

// find the index of block (x, y)
function indexOf(x, y, maze, i = 0) =
    i > len(maze) ? -1 : (
        [get_x(maze[i]), get_y(maze[i])] == [x, y] ? i : 
            indexOf(x, y, maze, i + 1)
    );

// check whether we've visited the block (x, y)
function visited(x, y, maze) = maze[indexOf(x, y, maze)][3];

// is (x, y) visitable?
function visitable(x, y, maze, rows, columns) = 
    y > 0 && y <= rows &&     // y is not out of bound
    x > 0 && x <= columns &&  // x is not out of bound
    !visited(x, y, maze);     // visited or not

// we've visited (x, y)
function set_visited(x, y, maze) = [
    for(b = maze) 
        [x, y] == [get_x(b), get_y(b)] ? 
            [x, y, get_wall_type(b), true] : b
];

// 0（right）、1（up）、2（left）、3（down）
function rand_dirs() =
    [
        [0, 1, 2, 3],
        [0, 1, 3, 2],
        [0, 2, 1, 3],
        [0, 2, 3, 1],
        [0, 3, 1, 2],
        [0, 3, 2, 1],
        [1, 0, 2, 3],
        [1, 0, 3, 2],
        [1, 2, 0, 3],
        [1, 2, 3, 0],
        [1, 3, 0, 2],
        [1, 3, 2, 0],
        [2, 0, 1, 3],
        [2, 0, 3, 1],
        [2, 1, 0, 3],
        [2, 1, 3, 0],
        [2, 3, 0, 1],
        [2, 3, 1, 0],
        [3, 0, 1, 2],
        [3, 0, 2, 1],
        [3, 1, 0, 2],
        [3, 1, 2, 0],
        [3, 2, 0, 1],
        [3, 2, 1, 0]
    ][round(rands(0, 24, 1)[0])];

// given the `x` value and a direction, return the `x` value of the next block
function next_x(x, dir) = x + [1, 0, -1, 0][dir];

// given the `x` value and a direction, return the `x` value of the next block
function next_y(y, dir) = y + [0, 1, 0, -1][dir];

// go right, remove the right wall
function go_right_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x, y] ? (
        get_wall_type(b) == UP_RIGHT_WALL ? 
            [x, y, UP_WALL, visited(x, y, maze)] : 
            [x, y, NO_WALL, visited(x, y, maze)]

    ) : b
]; 


// go up, remove the upper wall    
function go_up_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x, y] ? (
        get_wall_type(b) == UP_RIGHT_WALL ? 
            [x, y, RIGHT_WALL, visited(x, y, maze)] :  
            [x, y, NO_WALL, visited(x, y, maze)]

    ) : b
]; 

// go left, remove the right wall of the left block
function go_left_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x - 1, y] ? (
        get_wall_type(b) == UP_RIGHT_WALL ? 
            [x - 1, y, UP_WALL, visited(x - 1, y, maze)] : 
            [x - 1, y, NO_WALL, visited(x - 1, y, maze)]
    ) : b
]; 

// go down, remove the upper wall of the lower block
function go_down_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x, y - 1] ? (
        get_wall_type(b) == UP_RIGHT_WALL ? 
            [x, y - 1, RIGHT_WALL, visited(x, y - 1, maze)] : 
            [x, y - 1, NO_WALL, visited(x, y - 1, maze)]
    ) : b
]; 

// 0（right）、1（up）、2（left）、3（down）
function try_block(dir, x, y, maze, rows, columns) =
    dir == 0 ? go_right_from(x, y, maze) : (
        dir == 1 ? go_up_from(x, y, maze) : (
            dir == 2 ? go_left_from(x, y, maze) : 
                 go_down_from(x, y, maze)   // dir must be 3

        )
    );


// return visitable directions we can try
function visitable_dirs_from(x, y, maze, rows, columns) = [
    for(dir = [0, 1, 2, 3]) 
        if(visitable(next_x(x, dir), next_y(y, dir), maze, maze_rows, columns)) 
            dir
];  

// walk from (x, y) 
function go_maze(x, y, maze, rows, columns) = 
    // have visitable directions?
    len(visitable_dirs_from(x, y, maze, rows, columns)) == 0 ? 
        set_visited(x, y, maze)      // we visited here and cannot go further.
        : walk_around_from(          // walk randomly from (x, y) 
            x, y, 
            rand_dirs(),             // random directions
            set_visited(x, y, maze), // we visited here 
            rows, columns
        );

// walk randomly from (x, y) 
function walk_around_from(x, y, dirs, maze, rows, columns, i = 4) =
    i > 0 ? 
        walk_around_from(x, y, dirs, 
            try_routes_from(x, y, dirs[4 - i], maze, rows, columns),  
            , rows, columns, 
            i - 1) // try next direction
        : maze;

function try_routes_from(x, y, dir, maze, rows, columns) = 
    // is the next block visitable?
    visitable(next_x(x, dir), next_y(y, dir), maze, rows, columns) ?     
        go_maze(
            next_x(x, dir), next_y(y, dir), 
            try_block(dir, x, y, maze, rows, columns),
            rows, columns
        ) 
        : maze;  


