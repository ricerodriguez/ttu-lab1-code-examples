// Clock Divider
// ============================================================================
// Divides the onboard 100MHz clock down to a slower clock speed. Useful for
// ensuring a stable connection with the rover. Works similarly to PWM; uses a
// counter and a comparator. Main difference is that the counter resets after
// it's reached the scale.
// ============================================================================
// (Adapted from https://reference.digilentinc.com/learn/programmable-logic/tutorials/counter-and-clock-divider/start)
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
