`timescale 1ns / 1ps
// Adapted From: http://www.deathbylogic.com/2013/12/binary-to-binary-coded-decimal-bcd-converter/
// Minor changes made to adjust for 12 bit input, 16 bit output
module bin_bcd(binary, thousands, hundreds, tens, ones);
     // I/O Signal Definitions
     input  [11:0] binary;
     output reg [3:0] thousands;
     output reg [3:0] hundreds;
     output reg [3:0] tens;
     output reg [3:0] ones;


     // Internal variable for storing bits
     reg [27:0] shift;
     integer i;

     always @(binary)
     begin
          thousands = 4'b0;
          hundreds = 4'b0;
          tens = 4'b0;
          ones = 4'b0;
          // Clear previous number and store new number in shift register
          shift = 0;
          shift[11:0] = binary;

          // Loop twelve times
          for (i = 0; i < 12; i = i + 1)
          begin
               if (shift[15:12] >= 5)
                    shift[15:12] = shift[15:12] + 3;

               if (shift[19:16] >= 5)
                    shift[19:16] = shift[19:16] + 3;

               if (shift[23:20] >= 5)
                    shift[23:20] = shift[23:20] + 3;

               if (shift[27:24] >= 5)
                    shift[27:24] = shift[27:24] + 3;

               // Shift entire register left once
               shift = shift << 1;
          end

          // Push decimal numbers to output
          thousands = shift[27:24];
          hundreds  = shift[23:20];
          tens      = shift[19:16];
          ones      = shift[15:12];

     end

endmodule
