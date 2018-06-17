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
