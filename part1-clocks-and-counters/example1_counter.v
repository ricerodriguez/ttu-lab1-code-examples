module counter(
     // Module parameters (inputs/outputs) go here
     input clk,                    // 100 MHz clock
     output reg [31:0] count = 0   // Output the value of the counter
);

     // Executes at every positive edge of the clock
     always @ (posedge clk)
          // Counts every positive edge of the clock until overflow
          count = count + 1;

endmodule
