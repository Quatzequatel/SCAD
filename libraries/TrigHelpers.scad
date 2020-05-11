/*
    library of useful Trigonometry functions.
*/

//length of hypotenuse for right angled triangle.
function hypotenuse(a, b) = sqrt((a * a) + (b * b));
//point 2 given point 1 and angle assuming in a right angle triangle.
function p2(p1, angle) = [p1.x * cos(angle), p1.y * sin(angle)];