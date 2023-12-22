`timescale 1ns / 1ps

module numbers(
    input clk,
    input [9:0]xloc,
    input [9:0]yloc,
    input [9:0]charx,
    input [9:0]chary,
    input [3:0] num,
    output reg sprite_on
    );
    
wire [11:0] zero;
wire [11:0] one;
wire [11:0] two;
wire [11:0] three;
wire [11:0] four;
wire [11:0] five;
wire [11:0] six;
wire [11:0] seven;
wire [11:0] eight;
wire [11:0] nine;

assign zero =
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)
||(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+4 && yloc <= chary+15)||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+4 && yloc <= chary+15);

assign one = 
(xloc >= charx+0 && xloc <= charx+13 && yloc >= chary+18 && yloc <= chary+21)||(xloc >= charx+2 && xloc <= charx+9 && yloc >= chary+0 && yloc <= chary+3)
||(xloc >= charx+6 && xloc <= charx+9 && yloc >= chary+2 && yloc <= chary+17);

assign two =
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+8 && yloc <= chary+11)
||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)||(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+12 && yloc <= chary+15)
||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+4 && yloc <= chary+7);

assign three = 
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+4 && xloc <= charx+15 && yloc >= chary+8 && yloc <= chary+11)
||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+19);

assign four = 
(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+0 && yloc <= chary+11)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+8 && yloc <= chary+11)
||(xloc >= charx+10 && xloc <= charx+13 && yloc >= chary+2 && yloc <= chary+19);

assign five =
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+8 && yloc <= chary+11)
||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)||(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+4 && yloc <= chary+7)
||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+12 && yloc <= chary+15);

assign six =
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+8 && yloc <= chary+11)
||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)||(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+4 && yloc <= chary+15)
||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+12 && yloc <= chary+15);

assign seven =
(xloc >= charx+2 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+4 && yloc <= chary+19);

assign eight =
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)
||(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+3 && yloc <= chary+15)||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+4 && yloc <= chary+15)
||(xloc >= charx+4 && xloc <= charx+11 && yloc >= chary+8 && yloc <= chary+11);

assign nine = 
(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+0 && yloc <= chary+3)||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+8 && yloc <= chary+11)
||(xloc >= charx+0 && xloc <= charx+15 && yloc >= chary+16 && yloc <= chary+19)||(xloc >= charx+0 && xloc <= charx+3 && yloc >= chary+4 && yloc <= chary+7)
||(xloc >= charx+12 && xloc <= charx+15 && yloc >= chary+4 && yloc <= chary+19);

always @(posedge clk)
begin
    if (num == 4'd0)
        sprite_on <= zero;
    else if (num == 4'd1)
        sprite_on <= one;
    else if (num == 4'd2)
        sprite_on <= two;
    else if (num == 4'd3)
        sprite_on <= three;
    else if (num == 4'd4)
        sprite_on <= four;
    else if (num == 4'd5)
        sprite_on <= five;
    else if (num == 4'd6)
        sprite_on <= six;
    else if (num == 4'd7)
        sprite_on <= seven;
    else if (num == 4'd8)
        sprite_on <= eight;
    else if (num == 4'd9)
        sprite_on <= nine;
    else
        sprite_on <= 0;
end

endmodule
