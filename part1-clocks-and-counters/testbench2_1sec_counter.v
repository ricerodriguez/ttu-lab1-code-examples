module counter_1sec_tb();
     reg clk;
     wire [3:0] seconds;

     counter_1sec tb(
          .clk(clk),
          .seconds(seconds)
          );
     initial clk = 0;
     // This is how to actually simulate the 100 MHz clock, however it's
     // impractical for this case
     // always #10 clk = ~clk;

     // Simulate 1 kHz clock. Every 1 million nanoseconds (period of 1000 Hz),
     // clock alternates
     always #1000000 clk = ~clk;
endmodule
