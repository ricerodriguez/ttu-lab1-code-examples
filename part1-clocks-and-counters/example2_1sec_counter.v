// 1 Second Counter
// ============================================================================
// Simple module counts how many seconds have passed until the seconds register
// overflows back to 0 after it hits 15. Uses two counters, the first counter
// just counts the positive edges of the clock, the second counts the seconds.
// When the first counter has reached half the clock cycles in a second (half
// because it's only counting positive edges) then it's been 1 second. When this
// happpens, reset the first counter and increment the second counter.
// ============================================================================
module counter_1sec(
     input clk,
     // 4-bit register can count up to 2^4 - 1 = 15 seconds
     output reg [3:0] seconds = 0
);

     // 32-bit register is more than enough to hold 100 million. When counter
     // hits 100 million - 1 positive clock edges (of a 100 MHz clock), one
     // second has passed.
     reg [31:0] count = 32'b0;

     // The Basys 3 clock is 100 MHz, meaning there are 100 million cycles in
     // one second. There is one rising edge in one cycle (period), so counting
     // the rising edges also gives us the number of cycles.
     localparam max = 100000000;

     // This line is used for testbenching. If you don't do this, you'll have to
     // wait for the simulator to count all the way to a 100 million when you
     // testbench it. Adjust the simulated clock in your testbench to a slower
     // clock. The 1000 indicates we're using a 1kHz clock. In your testbench,
     // alternate your clock for the period of 1kHz (1 million nanoseconds)
     // localparam max = 1000;

     always @ (posedge clk)
     begin
          // If it reached the max, reset back to 0
          if(count >= max) begin
               count = 0;
               seconds = seconds + 1;
          end
          // Otherwise keep counting
          else
               count = count + 1;
     end

endmodule
