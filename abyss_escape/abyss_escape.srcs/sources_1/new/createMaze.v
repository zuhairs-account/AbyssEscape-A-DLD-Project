`timescale 1ns / 1ps

module createMaze(
    input [9:0]xloc,
    input [9:0]yloc,
    output maze_on
    );

assign maze_on = 
(xloc >= 15 & xloc <= 55 & yloc >= 15 & yloc <= 260) ||(xloc >= 15 & xloc <= 55 & yloc >= 275 & yloc <= 395) 
||(xloc >= 15 & xloc <= 625 & yloc >= 410 & yloc <= 465)
||(xloc >= 15 & xloc <= 250 & yloc >= 15 & yloc <= 70) ||(xloc >= 335 & xloc <= 625 & yloc >= 15 & yloc <= 70) 
||(xloc >= 570 & xloc <= 625 & yloc >= 15 & yloc <= 140) ||(xloc >= 265 & xloc <= 320 & yloc >= 0 & yloc <= 140) 
||(xloc >= 70 & xloc <= 320 & yloc >=85 & yloc <=140) ||(xloc >= 505 & xloc <= 625 & yloc >=85 & yloc <=140)
||(xloc >= 335 & xloc <= 490 & yloc >=85 & yloc <= 140) ||(xloc >=505 & xloc <=640 & yloc >= 155 & yloc <= 205) 
||(xloc >=505 & xloc <= 555 & yloc >=85 & yloc <= 205) ||(xloc >= 265 & xloc <= 320 & yloc >=300 & yloc <= 465) 
||(xloc >= 570 & xloc <=625 & yloc >= 155 & yloc <= 245) ||(xloc >= 445 & xloc <= 625 & yloc >= 213 & yloc <= 245)
||(xloc >= 445 & xloc <= 490 & yloc >= 85 & yloc <= 245) ||(xloc >= 505 & xloc <=555 & yloc >= 220 & yloc <=300) 
||(xloc >= 445 & xloc <= 555 & yloc >= 260 & yloc <= 300)||(xloc >= 585 & xloc <= 625 & yloc >=315 & yloc <= 465) 
||(xloc >= 515 & xloc <=570 & yloc >= 315 & yloc <= 395) ||(xloc >= 335 & xloc <= 380 & yloc >=85  & yloc <= 260)
||(xloc >= 395 & xloc <= 625 & yloc >=315 & yloc <= 360) ||(xloc >= 390 & xloc <=435 & yloc >= 85 & yloc <= 140)
||(xloc >= 390 & xloc <=435 & yloc >= 155 & yloc <= 360) 
||(xloc >= 265 & xloc <=390 & yloc >= 375 & yloc <= 410)||(xloc >= 265 & xloc <= 350 & yloc >=300 & yloc <= 345) 
||(xloc >= 265 & xloc <=380 & yloc >= 215 & yloc <= 260) ||(xloc >= 185 & xloc <= 235 & yloc >= 215 & yloc <= 465)
||(xloc >= 70 & xloc <= 125 & yloc >=85 & yloc <= 200) ||(xloc >= 15  & xloc <=125 & yloc >= 155 & yloc <= 200) 
||(xloc >=15 & xloc <= 125 & yloc >= 215 & yloc <= 260)||(xloc >= 15 & xloc <= 125 & yloc >=275 & yloc <= 315) 
||(xloc >= 70 & xloc <=125 & yloc >= 215 & yloc <= 315) ||(xloc >= 15 & xloc <= 175 & yloc >= 355 & yloc <= 395)
||(xloc >= 135 & xloc <=235 & yloc >= 315 & yloc <= 395)
||(xloc >= 135 & xloc <= 435 & yloc >= 155 & yloc <= 200)||(xloc >= 135 & xloc <= 180 & yloc >=155 & yloc <= 300) 
||(xloc >= 135 & xloc <=235 & yloc >= 215 & yloc <= 300);

endmodule