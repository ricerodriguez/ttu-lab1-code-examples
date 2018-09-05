// Very simple example of how to display a 1 on the first digit position.
module disp_1(
     input clk,
     output reg [3:0] digits,      // 4 Digits on Basys 3 Board
                                   // In the master constraints file, by default
                                   // this is the an[3:0] array. You can rename
                                   // it whatever you want in your constraints
                                   // file as long as it matches the name you
                                   // give it in your Verilog file.
     output reg [6:0] segments     // 7 Segment Display
     );

     always @ (posedge clk)
     begin
          digits = 4'b0111;        // The anodes are active low. Turn off all
                                   // but one by setting the other 3 to high (1)

          segments = 7'b1111001;   //
     end
