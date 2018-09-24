## Counters
A counter is one of the simplest things to implement in Verilog.
```verilog
reg [2:0] counter;
always @ (posedge clk)
     counter = counter + 1;
```

What does this mean? It means at the rising edge (`posedge`) of every clock pulse on the Basys 3, the counter increments.
![Made using LaTeX](https://imgur.com/UPFoyxJ.gif)

I'll finish writing more on this later, but hopefully this animation helps.
