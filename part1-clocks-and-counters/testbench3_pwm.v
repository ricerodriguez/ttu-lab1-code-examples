module pwm_tb();
     // Make a register for the clock you're going to generate.
     reg clk;
     // Make a wire for the outputs of the module you're testbenching for.
     wire [7:0] duty = 128;
     wire out;
     // Instantiate the module we're testbenching.
     pwm test(
          .clk(clk),
          .duty(duty),
          .PWM_output(out)
     );
     initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end

endmodule
