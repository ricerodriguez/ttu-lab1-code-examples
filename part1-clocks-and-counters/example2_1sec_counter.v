module counter_1sec(
     input clk,
     // 4-bit register can count up to 16 seconds
     output reg [3:0] seconds
);

     // 32-bit register is more than enough to hold 100 million. When counter
     // hits 100 million - 1 positive clock edges (of a 100 MHz clock), one
     // second has passed.
     reg [31:0] count = 32'b0;
     wire one_second_passed;
     // If counter hit 100 million - 1, one_second_passed = 1, otherwise = 0
     assign one_second_passed = (count == 100000000 - 1)?1:0;

     always @ (posedge clk)
     begin
          // If it reached the max, reset back to 0
          if(count >= 100000000 - 1)
               count = 0;
          // Otherwise keep counting
          else
               count = count + 1;
     end

     // Every time one_second_passed switches from 0 to 1, seconds counter + 1
     always @ (posedge one_second_passed)
          seconds = seconds + 1;

endmodule
