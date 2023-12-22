
`timescale 1ms / 1ps
module charWrap( 
	input clk,
	input signed [10:0] sprite_x, //player
	input signed [10:0] sprite_y,
	input [9:0] x, //hpos and vpos
	input [9:0] y,
	input [1:0] direction,
	output reg [11:0] rgb,
	output sprite_on);

    parameter WIDTH = 18;
    parameter HEIGHT = 28;
	reg [8:0]row;
	reg [8:0]col;
    
    wire [11:0] frgb, brgb, lrgb, rrgb;
	reg signed [10:0]x_signed,y_signed;
	
	assign sprite_on = (x_signed - sprite_x < WIDTH && y_signed - sprite_y < HEIGHT && x_signed - sprite_x > 0 && y_signed - sprite_y >= 0) ? 1 : 0;
	always @(posedge clk) begin

		x_signed <= {1'b0,x};
		y_signed <= {1'b0,y};
        
        if (direction == 2'b00)
            rgb <= frgb;
        else if (direction == 2'b01)
            rgb <= brgb;
        else if (direction == 2'b10)
            rgb <= lrgb;
        else if (direction == 2'b11)
            rgb <= rrgb;
		if (sprite_on) begin
				row<=y_signed-sprite_y;
				col<=x_signed-sprite_x;
			end

		end

	omorfront_rom omorfront(.clk(clk), .row(row), .col(col), .color_data(frgb));
	omorback_rom omorback(.clk(clk), .row(row), .col(col), .color_data(brgb));
	omorleft_rom omorleft(.clk(clk), .row(row), .col(col), .color_data(lrgb));
	omorright_rom omorright(.clk(clk), .row(row), .col(col), .color_data(rrgb));

endmodule

