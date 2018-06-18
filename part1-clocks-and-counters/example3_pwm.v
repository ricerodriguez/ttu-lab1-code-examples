// Pulse Width Modulation (PWM) Signal Generator
// ===========================================================================
// Simple module generates a PWM signal using a counter and a comparator. 8-bit
// counter counts positive edges of the clock until it passes the maximum, then
// alternates. The duty cycle in percentage is the duty given / max of the
// counter * 100. So for a duty cycle of 50%, the user would input 128 because
// 128/255*100 is roughly 50%.
// ===========================================================================
module pwm(
	input clk,
	input [7:0] duty,
	output reg PWM_output = 0
);
     // 8-bit counter can count up to 255
	reg [7:0] count = 0;
	always@(posedge clk)
	begin
		count <= count + 1;
		// If count is less than duty, then output is 1.
		// Otherwise, it's 0.
		PWM_output <= (count < duty);
	end
endmodule
