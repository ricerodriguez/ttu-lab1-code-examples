## Part 1: Clocks and Counters
### Example 1: Counter
A counter is one of the simplest things to implement in Verilog.
```verilog
module counter(
     input clk,                    // 100 MHz clock
     output reg [31:0] count = 0   // Output the value of the counter
);
     always @ (posedge clk)        // At every rising edge of the clk signal...
          count = count + 1;       // Increment the counter
endmodule

```
This means that at every *rising edge* of the clock (`always @ (posedge clk)`) the counter (`count`) increments by 1. Notice that in our parameters (where are inputs/outputs are) that the output says `output reg [31:0] count` instead of just `output count`.

![Made using LaTeX](https://imgur.com/UPFoyxJ.gif)

So what does the extra stuff mean?
The `reg` means that this output is a `reg` type. If you want your output to be a `reg`, you have to write this because it's assumed to be a `wire` by default. We want ours to be a `reg` because we're making procedural updates to it in the `always @` block and we want our `count` to store a value. The `[31:0]` means that this output has a range of 0-31 bits available. Basically, we're saying that this output is 32 bits wide. That means the maximum value it can hold is 2^32-1. Once it reaches that value, if you try to increment it again, it will just reset back to 0. That property is pretty useful when we're making PWM's and clock dividers.

### Testbench 1: Counter
In Vivado, when you want to make sure your code works, you have to write a testbench for it. You can't just hit the debug button and go. You actually have to write another piece of code for it.
```verilog
module counter_tb();
     reg clk;              // Make a register for your clock.
     wire [31:0] count;    // Make a wire for the output of your counter.

     initial clk = 0;      // Initialize the clock to 0.
     counter tb(
          .clk(clk),       // Tie the input clock to the register clock.
          .count(count)    // Tie the wire count to the output count.
          );
     always #5 clk = ~clk; // Simulate a 100 MHz clock.
endmodule
```

### Example 2: Timer (1 Second Counter)
The counter is useful to us because we know the clock speed (or *frequency* of the clock signal) from the data sheet for the Basys 3. The clock signal on the Basys 3 is 100 MHz. That means that there are 100 million clock cycles (the time it takes for the signal to go from 0 to 1 back to 0, aka *period*) in one second. The other way of saying this is that one Basys 3 clock cycle is 10 nanoseconds.

![Image generated via CodeCogs](http://latex.codecogs.com/gif.latex?%5Ctext%7Bclock%20cycle%20%5Bs%5D%7D%3D%5Cfrac%7B1%7D%7B%5Ctext%7Bclock%20speed%20%5BHz%5D%7D%7D)

Knowing the clock speed, and by extension, the width of a clock cycle, means we can relate the count of clock cycles to a duration of time. We already know that if 100 million cycles on the Basys 3 clock have happened, then one second has passed. So if we use our counter to count 100 million cycles, we know it's been one second. If you notice, in one cycle there is exactly *one* rising edge. So if we only count the *positive edges* of the clock signal, we are also counting the number of *cycles*.

```verilog
module counter_1sec(
     input clk,                      // Input clock signal
     output reg [3:0] seconds = 0    // Output is how many
                                     // seconds have passed.
);
     // Create reg for counter. Counts rising edges of clock.
     reg [31:0] count = 32'b0;

     // Once we've counted 100 million cycles of 100 MHz clock,
     // then one second has passed.
     localparam max = 100_000_000;

     always @ (posedge clk)
     begin
          // If it hit 100 million cycles...
          if(count >= max) begin
               count = 0;               // reset the counter, and...
               seconds = seconds + 1;   // ...increment the seconds counter
          end
          else
               // Otherwise, keep counting.
               count = count + 1;
     end
```
After the counter reaches 100 million rising edges (which is also 100 million cycles) of our 100 MHz clock, then it's been one second.

### Testbench 2: Timer (1 Second Counter)
Now it's time to make your testbench. Do exactly the same thing as the last testbench.
```verilog
module counter_1sec_tb();
     // Make a register for the clock you're going to generate.
     reg clk;
     // Make a wire for the output of the module you're testbenching for.
     wire [3:0] seconds;
     // Instantiate the module we're testbenching.
     counter_1sec tb(
          .clk(clk),
          .seconds(seconds)
          );
     // Initialize the clock to 0.
     initial clk = 0;
     // 100 MHz clock
     always #5 clk = ~clk;
endmodule
```

### Example 3: Pulse Width Modulation (PWM)
Making a PWM module is actually surprisingly easy to do in Verilog. All we have to do is make a square wave with a varying duty cycle using the concepts we've used so far. The basic algorithm behind the PWM is comparing the value of a counter (counts the rising edges of the clock) to a constant value. If the counter is less than the value of the constant, the output PWM signal is high. If the counter is greater than the value of the constant, the output PWM signal is low. We vary the duty cycle by changing the value of the constant we're comparing to.

There's a few things you need to know about counters to understand why this works. For one, you should know that **if you try to increment a counter past its maximum value, the counter will reset back to 0**. You can determine the maximum value that a register can hold is
![Image generated via CodeCogs](http://latex.codecogs.com/gif.latex?2%5En-1)
where *n* is the number of bits in your register. So for an 8-bit register, the maximum value the register can hold is 255. (We subtract by 1 because we start counting from 0.) For a 2-bit register, which is the size of the register I'll use to illustrate how this algorithm works, the maximum size is 3. Since the counter starts counting at 0, the PWM signal starts out at high. It stays high until the point when the value from the counter surpasses the constant (called `duty` here, and assumed to be the same width as `count`, which is 2 bits). Once the value of the counter surpasses the constant `duty`, the output signal of the PWM module is low, and it stays low until the counter tries to count past its maximum and resets back to 0. Thus, you can see that for each individual cycle, the ratio of on-time to off-time (duty cycle) is determined by how early on the constant `duty` shuts off the PWM output signal. If `duty` and `count` are the same width, then the duty cycle is the ratio of `duty` to the maximum value of `count` + 1. The + 1 is because for a 100% duty cycle (always high), if `duty` is more than the maximum value that `count` can be, then `count` will *always* be less than `duty`, so the PWM output signal will always output high.

![Animation created using LaTeX](https://imgur.com/lgvLnk5.gif)

In this animation, the `duty` is half of the max of `count` + 1 (because 2 = 4/2) so the output signal we see is a 50% duty cycle. If we wanted a 25% duty cycle, we'd use a `duty` of 1, because 1/4 = 25%.

![Animation created using LaTeX](https://imgur.com/zYRk5jn.gif)
Now let's actually write our PWM module. All we have to do is make a counter and compare it to the input `duty`. It's typical to use an 8-bit register for making PWM modules, so that's what we use here.
```verilog
module pwm(
	input clk,
	input [7:0] duty,
	output reg PWM_output = 0
);
     // 8-bit counter can count up to 255
	reg [7:0] count = 0;
	always@(posedge clk)
	begin
		count <= count + 1;
		// If count is less than duty, then output is 1.
		// Otherwise, it's 0.
		PWM_output <= (count < duty);
	end
endmodule
```
The line where we compare `count` and `duty` is just a simpified `if`-`else` statement. If `count < duty` is true, `PWM_output` is a logical high. If it is false, then `PWM_output` is a logical low.

### Testbench 3: Pulse Width Modulation (PWM)
Now let's make our testbench. It's made pretty much the same way you made the others.
```verilog
module pwm_tb();
     // Make a register for the clock you're going to generate.
     reg clk;
     // Make a wire for the outputs of the module you're testbenching for.
     wire [7:0] duty = 128;
     wire out;
     // Instantiate the module we're testbenching.
     pwm test(
          .clk(clk),
          .duty(duty),
          .PWM_output(out)
     );
     initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end

endmodule
```

Here we showed an alternative way of simulating the 100 MHz clock. It functionally does the same thing as far as we are concerned.
