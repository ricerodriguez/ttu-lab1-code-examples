module counter_tb();
     reg clk;
     wire [31:0] count;

     initial clk = 0;
     counter tb(
          .clk(clk),
          .count(count)
          );
     always #10 clk = ~clk;
endmodule
