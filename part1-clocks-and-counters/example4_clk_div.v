`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Code adapted from Diligent Inc, divides 100MHz clock to 25KHz
////////////////////////////////////////////////////////////////////////////////

module clk_div(
	input clk,
	input reset,
	input [31:0] scale,
	output reg clk_out = 0
    );

	// f = (100 MHz)/(4*scale)
     // scale = 1000 --> f = 25 kHz
	reg [15:0] count = 16'b0;
	always @(posedge clk)
          if (reset) begin
               count <= 16'b0;
               clk_out <= 1'b0;
          end else if (count == scale - 1) begin
               count <= 16'b0;
               clk_out <= ~clk_out;
          end else begin
               count <= count + 1;
               clk_out <= clk_out;
          end

endmodule
