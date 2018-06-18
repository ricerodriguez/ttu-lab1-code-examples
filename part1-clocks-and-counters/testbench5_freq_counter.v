// Frequency Counter Testbench Module
// ============================================================================
// For this to work, change the localparam max in freq_counter to match the
// clock cycle here. The testbench creates a clock signal and a test signal to
// use in the freq_counter module. To see the results, run the simulation for a
// little while longer until the freq_counter's counter has reached the
// localparam max.
module freq_count_tb();
     wire [19:0] freq;
     reg clk, in, enable;
     wire done;

     initial begin
          clk = 0;
          in = 0;
          enable = 1;
          // Test frequency is 500 kHz
          forever #2000 in = !in;
     end

     // Clock is 100 MHz
     always
          #10 clk = !clk;

     freq_counterdiv16 tb1(
          .CLK(clk),
          .enable(enable),
          .IN(in),
          .freq(freq),
          .done(done)
          );

endmodule
