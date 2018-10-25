module counter_1sec_tb();
     // Make a register for the clock you're going to generate.
     reg clk;
     // Make a wire for the output of the module you're testbenching for.
     wire [3:0] seconds;
     // Instantiate the module we're testbenching.
     counter_1sec tb(
          .clk(clk),
          .seconds(seconds)
          );
     // Initialize the clock to 0.
     initial clk = 0;
     // At every half cycle, the clock signal oscillates. We want it to do that
     // every half cycle because a whole cycle is the time it takes for two
     // oscillations.
     always #5 clk = ~clk;
     // Unfortunately, Vivado takes an extremely long time to simulate 1 second
     // at 100 MHz. To remedy this, we can change both the max parameter in
     // our module and the clock speed in our testbench. Comment out the previous
     // always statement and uncomment out the one below:
     // always #500_000 clk = clk = ~clk;
     // This will change the clock to be at 1kHz instead of 100 MHz. Make sure
     // that in your module the max is 1000 instead of 100 million.
endmodule
