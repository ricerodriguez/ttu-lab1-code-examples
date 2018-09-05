module disp_LAb1(
     input clk,
     output reg [3:0] an,      // 4 Digits on Basys 3 Board
     output reg [6:0] seg    // 7 Segment Display
     );

     // Use the 2 MSBs of 19-bit counter to create 190 Hz frequency refresh
     reg [18:0] count;
     always @ (posedge clk)
          count = count + 1;

     // This wire is driven by the 2 MSBs of the counter. We'll use it to
     // refresh the display.
     wire [1:0] refresh;
     assign refresh = count[18:17];

     // Usually always @ * is not recommended because it's resource intensive
     // and usually unnecessary, and if you're not careful it will cause timing
     // issues. This isn't an issue for a simple program like this though.
     always @ (*)
          case(refresh)
          2'b00:
               begin
                    an = 4'b0111;
                    seg = 7'b1000111;
               end
          2'b01:
               begin
                    an = 4'b1011;
                    seg = 7'b0001000;
               end
          2'b10:
               begin
                    an = 4'b1101;
                    seg = 7'b0000011;
               end
          2'b11:
               begin
                    an = 4'b1110;
                    seg = 7'b1111001;
               end
          endcase
