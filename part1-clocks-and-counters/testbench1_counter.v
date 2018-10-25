module counter_tb();
     // Make a register for the clock you're going to generate.
     reg clk;
     // Make a wire for the output of the module you're testbenching for.
     wire [31:0] count;
     // Instantiate the module we're testbenching.
     counter tb(
          .clk(clk),
          .count(count)
          );
     // Initialize the clock to 0.
     initial clk = 0;
     // At every half cycle, the clock signal oscillates. We want it to do that
     // every half cycle because a whole cycle is the time it takes for two
     // oscillations.
     always #5 clk = ~clk;
endmodule
