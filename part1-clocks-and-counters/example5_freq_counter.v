// Frequency Counter
// ============================================================================
// This module was coded for a 100 MHz clock, meaning that there should be 100
// million ticks in one second. That means that after the counter has counted
// 100 million ticks / 16 we know that 1/16th of a second has passed. Another
// counter works simultaneously to count the number of positive edges from the
// input coming in from the Pmod port. After 1/16th of a second has elapsed, we
// know that the number of positive edges (cycles) is 1/16th the frequency of
// the signal into the Pmod port. Hertz is measured in cycles/sec, and since we
// know it's 1/16th of a second, all we have to do is multiply the number of
// edges we've counted by 16.
module freq_counter(
	// 100 MHz clock
	input CLK,
     input enable,
	input IN,
	// Register for frequency
	output reg [19:0] freq = 20'b0,
     // 1-bit flag indicates when program finished
     output reg done = 0);

	// Register for one second counter
	reg[31:0] count = 32'b0;
	// Register for input counter
	reg [19:0] edge_count = 20'b0;
	// Register for storing last signal, used for detecting rising edge
	reg last = 0;

     // 100 million / 16 = 625k
	localparam max = 'd6250000;

	// Flip-flop stores last value in register. We'll be using this to detect
	// the positive edges of the incoming signal
	always @(posedge CLK)
		last <= IN;

     always @ (posedge CLK)
          if(~enable) begin
               freq = 0;
               edge_count = 0;
               count = 0;
               done = 0;
          end
          else begin
               if (count < max)
               begin
                    count <= count + 1;
                    // If value was 0 and is now 1, positive edge detected. Use
                    // this instead of always @ posedge var to prevent
                    // unnecessarily using the clock
                    if(~last & IN)
                         edge_count <= edge_count + 1;
               end
               else begin
                    // Reset the frequency variable
                    freq = 0;
                    // Multiply the value counted so far by 16 because it's only
                    // been 1/16th of a second so far
                    freq = edge_count * 16;
                    // Reset the edge count
                    edge_count = 0;
                    // Reset the 1/16th second counter
                    count = 0;
                    // We're done, so set the flag on
                    done = 1;
               end
               end
endmodule
