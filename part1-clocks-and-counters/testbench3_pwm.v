module pwm_tb();
     reg clk;
     wire [7:0] duty = 128;
     wire out;

     pwm test(
          .clk(clk),
          .duty(duty),
          .PWM_output(out)
     );

     initial begin
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #10 clk = !clk;
     end

endmodule
