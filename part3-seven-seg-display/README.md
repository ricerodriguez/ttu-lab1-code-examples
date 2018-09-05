## Using the 7-Segment Display
Let's say you want to make your 7-segment display read "LAb1" but you don't know how. Before you even start coding, you need to figure out which of the seven segments you want to turn on for it to read the way you want it to. Then you'll need to create a refresh counter so that you can multiplex between the four digits (common anodes) provided. (If you were wanting to display a value that you calculated from another module, you'd need a binary-to-BCD converter first, then a state machine to convert your BCD to the proper segments needed to display it for each digits place. For now, let's just go over how to display something at all.)

### Choosing the Segments
![Don't forget to read these as right to left (LSB to MSB)](https://reference.digilentinc.com/_media/basys3-_seven_segment_display_driving.png?w=600&tok=0639f2)

In Verilog, the seven segment display (the individual cathodes) is a 7-bit array `output reg [7:0] seg`. (To make procedural updates to it, you'll want to make it a `reg`.) In this diagram, the cathodes are labeled from LSB to MSB (right to left) so keep this in mind when figuring out which segments are needed to display. Don't forget, they're also active LOW. So, for example, to show "LAb1" you would do this:
L: `7'b1000111`
A: `7'b0001000`
b: `7'b0000011`
1: `7'b1111001`

### Using a Counter to Refresh
Don't worry, it's just like any other counter. But you'll need to pick the size of your counter carefully, since this will affect your display rate. For a seven segment display, you won't need much. Definitely keep it under 500 Hz. For this example, I'll use 190 Hz, but honestly you can go as low as 60 Hz. We're going to use the last two bits of the counter to refresh the display. We're using the last two bits because there are four possible values in two bits, and we can use those to correspond to the four common anodes (digits) in the display board.

First, make your counter.
```verilog
reg [18:0] count;
always @ (posedge clk)
     count = count + 1;
```
Notice the register is 19 bits. The frequency is found like this:
<img src="https://latex.codecogs.com/gif.latex?f=\frac{\text{clock&space;speed}}{2^{\text{size&space;of&space;counter}}}" title="f=\frac{\text{clock speed}}{2^{\text{size of counter}}}" />

For us, that means
<img src="https://latex.codecogs.com/gif.latex?f=\frac{100\times10^6\&space;\text{Hz}}{2^{19\&space;\text{bits}}}=190.735" title="f=\frac{100\times10^6\ \text{Hz}}{2^{19\ \text{bits}}}=190.735" />

Make sure your counter frequency is at least higher than 45 Hz (21 bits maximum).

We'll use this counter to refresh the digits by taking the 2 MSB's.
```verilog
case(count[18:17])
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
```
Congrats! You're done.
#### References:
https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html
https://ece.umd.edu/class/enee245.S2015/Lab8.pdf
