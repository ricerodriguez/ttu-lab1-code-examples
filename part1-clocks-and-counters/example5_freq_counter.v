// This module was coded for a 100 MHz clock, meaning that there should be 100
// million ticks in one second. That means that after the counter has counted
// 100 million ticks we know that one second has passed. Another counter works
// simultaneously to count the number of inputs coming in from the Pmod port.
// After one second has elapsed, we know that the number of inputs (cycles) is
// the frequency of the signal into the Pmod port. Hertz is measured in
// cycles/sec, and since we know it's one second, we don't have to do any
// further math-- the input counter should be frequency of the input as is.
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

	// Flip-flop stores last value in register
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
                    edge_count = 0;
                    count = 0;
                    done = 1;
               end
               end
endmodule
