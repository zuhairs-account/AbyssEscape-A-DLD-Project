`timescale 1ns / 1ps
module gateWrap(
    input clk,
	input signed [10:0] sprite_x, //player
	input signed [10:0] sprite_y,
	input [9:0] x, //hpos and vpos
	input [9:0] y,
	input direction,
	output reg [11:0] rgb,
	output sprite_on);
    parameter WIDTH = 22;
    parameter HEIGHT = 31;
    parameter HEIGHT2 = 36;
	reg [8:0]row;
	reg [8:0]col;
	reg signed [10:0]x_signed,y_signed;
	wire [11:0] crgb, orgb;
	
	assign sprite_on = direction ? 
	((x_signed - sprite_x </*=*/ WIDTH && y_signed - sprite_y < HEIGHT2 && x_signed - sprite_x > 0 && y_signed - sprite_y >= 0) ? 1 : 0) 
	: 
	((x_signed - sprite_x </*=*/ WIDTH && y_signed - sprite_y < HEIGHT && x_signed - sprite_x > 0 && y_signed - sprite_y >= 0) ? 1 : 0);
	always @(posedge clk) begin

		x_signed <= {1'b0,x};
		y_signed <= {1'b0,y};
        if (direction == 0)
            rgb <= crgb;
        else if (direction == 1)
            rgb <= orgb;
		if (sprite_on ) begin
				row<=y_signed-sprite_y;
				col<=x_signed-sprite_x;
			end

		end

	opengate_rom open(.clk(clk), .row(row), .col(col), .color_data(orgb));
	closedgate_rom close(.clk(clk), .row(row), .col(col), .color_data(crgb));

endmodule
