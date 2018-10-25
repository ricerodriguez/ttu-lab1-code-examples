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
// ============================================================================
module freq_counter(
     // The inputs are...
     input CLK,          // 100 MHz clock signal from the Basys3 oscillator
     input enable,       // Enable bit to turn this module on from another module
     input IN,           // The signal we're counting the frequency of
     // The outputs are...
     output reg [19:0] freq = 20'b0,    // The frequency we found for the input signal
     output reg done = 0);              // Done flag so that we can tell that this module
                                        // has finished counting the frequency of the signal

     // Create a register for the clock signal edge counter. This register will
     // hold the number of positive edges of the clock we've seen. We will use
     // this to know how much time has passed since we started counting our signal.
     reg[31:0] count = 32'b0;
     // Create a register for the signal edge counter. This register will hold the
     // number of positive edges of the input signal we're trying to find the
     // frequency of. We will use this to count how many signal cycles have passed.
     reg [19:0] edge_count = 20'b0;
     // Create a register for the D flip-flop (D-FF). This is the output Q of the
     // D-FF. We're using this to store the state of the input signal (high or low).
     // We do this so we can compare the last known state of the input signal to the
     // current state of the signal.
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
