module clk_div_tb();
     reg clk,rst;
     reg [31:0] scale = 1000;
     wire out;

     clk_div test(
          .clk(clk),
          .reset(rst),
          .scale(scale),
          .clk_out(out)
          );

     initial begin
          clk = 0;
          rst = 0;
     end

     // Clock is 100 MHz
     always
          #10 clk = !clk;

endmodule
