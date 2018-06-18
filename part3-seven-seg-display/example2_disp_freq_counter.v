// Display Controller Module
// Adapted From: [FPGA Tutorial] Seven-Segment LED Display on Basys 3 FPGA
//         http://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html
// Methodology: This module uses a 21 bit register as a refresh counter for the display. It uses the
//              first 19 bits of this register for creating a 190 Hz refresh rate for the segment
//              display, and uses the last two bits cycle through each of the four possible digits
//              and refresh its display.
module disp_freq_counter(
     input CLK,                    // 100 MHz clock source on Basys 3 FPGA
     input reset,                  // Reset button
     input IN,                     // Input frequency
     output reg [3:0] digits,      // 4 Digits on Basys 3 Board
     output reg [6:0] segments    // 7 Segment Display
    );
     // Wire for frequency signal (binary)
     wire [11:0] sig_bin;
     // Wire for displayed number to the 4 digit output
     wire [15:0] displayed_number;
     // Wires for number value of each digit place
     wire [3:0] thousands, hundreds, tens, ones;
     // Output to display
     reg [3:0] disp_out;
     // Counter to refresh display
     reg [20:0] refresh_counter;   // The first 19 bits are for creating 190Hz refresh rate
                                   // The other 2 bits are for creating 4 LED-activating signals
     // Counter to refresh digit place to display
     wire [1:0] digit_refresh;
     // Register to hold value of color select
     reg [1:0] color_sel = 0;

     // Refresh counter, used to refresh display
     always @(posedge CLK)
        if(reset)
          refresh_counter <= 0;
        else
          refresh_counter <= refresh_counter + 1;

     // Last 2 bits used to refresh display
     // (100 x 10^6)/(2^19) = 190 Hz, 5.24 ms to change display
     assign digit_refresh = refresh_counter[20:19];

     // Frequency counter from part 1 example 5
     freq_counter sigin(
          .CLK(CLK),
          .IN(IN),
          .freq(sig_bin)
          );
     // Binary to BCD converter from example 1
     bin_bcd converter(
          .binary(sig_bin),
          .thousands(thousands),
          .hundreds(hundreds),
          .tens(tens),
          .ones(ones)
          );

     always @(*)
     begin
          case(digit_refresh)
               2'b00: begin
                    digits = 4'b0111;
                    // activate LED1 and Deactivate LED2, LED3, LED4
                    disp_out = thousands;
                    // the first digit of the 16-bit number
               end
               2'b01: begin
                    digits = 4'b1011;
                    // activate LED2 and Deactivate LED1, LED3, LED4
                    disp_out = hundreds;
                    // the second digit of the 16-bit number
               end
               2'b10: begin
                    digits = 4'b1101;
                    // activate LED3 and Deactivate LED2, LED1, LED4
                    disp_out = tens;
                    // the third digit of the 16-bit number
               end
               2'b11: begin
                    digits = 4'b1110;
                    // activate LED4 and Deactivate LED2, LED3, LED1
                    disp_out = ones;
                    // the fourth digit of the 16-bit number
               end
          endcase
     end

     // Cathode patterns of the 7-segment LED display
     always @(*)
          case(disp_out)
               4'b0000: segments = 7'b1000000; // "0"
               4'b0001: segments = 7'b1111001; // "1"
               4'b0010: segments = 7'b0100100; // "2"
               4'b0011: segments = 7'b0110000; // "3"
               4'b0100: segments = 7'b0011001; // "4"
               4'b0101: segments = 7'b0010010; // "5"
               4'b0110: segments = 7'b0000010; // "6"
               4'b0111: segments = 7'b1111000; // "7"
               4'b1000: segments = 7'b0000000; // "8"
               4'b1001: segments = 7'b0011000; // "9"
               default: segments = 7'b1000000; // "0"
          endcase
endmodule
