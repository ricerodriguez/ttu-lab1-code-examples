This repo is meant to work as a basic guide for the Verilog that you'll use in
Project Lab 1. You can use the example code files to see how it's implemented.
**Do not use the example code directly for your project.** Use it to see syntax
of structures and understand how it works. The example code contains basic
structures you'll need to understand, but you'll have to put the structures
together to complete your project. **If you use the structures in the code
examples for your project or heavily rely on them, you'll need to cite it in
your presentations.** This code is publicly available for everyone to see. It
will be blatantly obvious if you try to plagiarize it.

## Verilog Basics
The number one thing to know is that Verilog is absolutely *not* a programming
language. It's a **hardware description language (HDL)**. You'll be using this
HDL to make digital logic circuits on an Artix-7 FPGA. The FPGA is essentially
just a buttload of NAND gates, and you're using Verilog to hook those NAND gates
up in order to create the digital logic circuit you wrote. This means your
Verilog will describe a digital logic circuit. This does *not* mean you have to
write each individual gate connection. You're writing the structures of the
digital logic circuit and Vivado will figure out the individual connections for
you. You can write the individual connections if you want to, but you really
don't want to, because that would take forever. So save the K-maps for another
day, you won't need them.

### Variable Data Types and Assignments
There are two main variable types you'll be using: `wire` and `reg`. The two are
not interchangeable in most circumstances, although you can use them
interchangeably on the right-hand side of assignments. In other words, if you
are setting the value of a `wire` or `reg`, you can set it to the value of
either a `wire` or `reg` data type.
#### The ``wire`` Type and Continuous Assignments
The `wire` data type is used in **continuous assignments**, where the `wire`
continuously has a value driven into it. They work the same way wires work in
real-world physical connections of digital logic circuits. If you have an AND
gate and you connect it to two inputs and wire up your output somewhere, do you
have to tell your wire to update the value every time you change your inputs?
No, of course not. The `wire` type works the same way.

**Example 0.1: Continuous Assignments**
```verilog
reg A, B;
// You cannot initialize the wire type because wires need to
// be driven by something and cannot store values without
// being driven by something.
wire out;
// out is being driven by A + B
assign out = A + B;
```
The `out` wire will always be the value of `A + B` because it's being driven by
`A + B`.

#### The ``reg`` Type and Procedural Assignments
The ``reg`` data type is used in **procedural assignments**, where the value of
``reg`` is updated. Procedural assignments look and somewhat behave closer to
variable assignments in programming languages like C/C++. The difference is that
because these assignments are *procedural*, these assignments have to be done
inside of *procedural blocks*, e.g. ``always @`` blocks, ``begin...end`` blocks,
etc.

**Example 0.11: Procedural Assignments**
```verilog
// You may initialize reg when declaring it, otherwise
// updating their values must be inside a procedural block
reg A = 0;
reg B = 0;
begin
     // Blocking assignment
     A = 0;
     // Non-blocking assignment
     B <= 0;
     // Note: You usually don't want to mix blocking and
     // non-blocking assignments in the same procedural
     // block. This is just to show the syntax for both.
end
```


##### Blocking and Non-Blocking Assignments
Procedural assignments can be either blocking or non-blocking assignments.
Blocking assignments are evaluated and executed (in a single step) at the time
the blocking assignment occurs and non-blocking assignments are evaluated
immediately, but they're *executed* at the end of the time-step specified. In
`begin...end` blocks, the effective difference is that a blocking assignment
prevents (or *blocks*) the next line from executing until after the blocking
assignment has finished executing. Non-blocking assignments don't do this, and
the line after the a non-blocking assignment may execute before the non-blocking
assignment has finished executing.

**Example 0.2: Blocking Assignments (with Delays)**
```verilog
reg A = 0;
reg B = 0;
begin
     // Delays are denoted with #
     #10 A = 1;
     #10 A = 2;
     #10 B = 1;
     #10 B = 2;
end
```
The assignment after each assignment is not evaluated until after the one before
it has finished executing, so the 10 ns delay for each assignment is 10 ns
*after* the assignment before it has finished executing.  
At 10 ns, `A = 1`.  
At 20 ns, `A = 2`.  
At 30 ns, `B = 1`.  
At 40 ns, `B = 2`.  

**Example 0.21: Non-Blocking Assignments (with Delays)**
```verilog
reg A = 0;
reg B = 0;
begin
     #5  A <= 1;
     #10 A <= 2;
     #15 B <= 1;
     #20 B <= 2;
end
```
These assignments are all evaluated at roughly the same time.  
At 5 ns,  `A = 1`.  
At 10 ns, `A = 2`.  
At 15 ns, `B = 1`.  
At 20 ns, `B = 2`.  

Also note that the order of these lines doesn't matter. If the lines were
instead ordered like this:
```verilog
#10 A <= 2;
#15 B <= 1;
#20 B <= 2;
#5  A <= 1;
```
The results are the same. At 5 ns, `A = 1`, etc. Blocking and non-blocking
assignments can still affect the end result without delays. If your assignment
would have a different value if the assignment after it happened first, then
blocking assignments will prevent it from messing up your values. If you need
the two assignments to happen at the same time (e.g. swapping the values of two
variables), you'll want to use non-blocking assignments.

**Example 0.22: Non-Blocking Assignments (without Delays)**
```verilog
reg A = 1;
reg B = 0;
begin
     A <= B; // A = 0
     B <= A; // B = 1
end
```
This will swap the two values of the variables, so `A = 0` and `B = 1`. If you
used blocking assignments for this...
```verilog
reg A = 1;
reg B = 0;
begin
     A = B; // A = 0
     B = A; // B = 0
end
```

### `always @` Blocks
`always @` blocks execute the lines of code inside them every time the condition in the *sensitivity list* is satisfied, meaning that there is a change in the variables listed in the sensitivity list. Here's an example.

**Example 0.3: Always @ Block Template**
```verilog
always @ (sensitivity)
begin
// Code here. Note that if it's just one line of code,
// begin and end are unnecessary
end
```
You will usually be using this for the clock like this:

**Example 0.31: Using the Clock in an Always @ Block**
```verilog
always @ (posedge clk)
begin
// Code here
end
```
This means that at each *positive edge* of the clock, the code will execute.
This is useful for timing and counters, which you'll be using a lot of. You can
put other variables inside the sensitivity list too, however, **you should be
careful about using other variables than the clock in the sensitivity list**.
Using other variables in the sensitivity list isn't bad practice and sometimes
is even necessary, but you should realize that **it will make your code
asynchronous. Doing this without carefully understanding your code can lead to
hard-to-detect issues.** Check the link in resources for more info about how to
use this.

### `case`, `casex`, and `casez` Statements
You'll be making a ton of state machines, and unless you want to write an `if`-`else` statement for every single scenario, you're going to want to use `case` statements. `case` statements work similarly to `switch` statements in C++, except without the annoying bits. You don't need a `break` at the end of every case, it will just skip all the other cases like an `if`-`else` statement.

**Example 0.4: Case Statements**
```verilog
case(A)
     1:  // Code
     2:  // Code
default: // Code
endcase
```
When `A` is 1, that code will execute. When `A` is 2, *that* code will execute. If `A` is neither, then the `default` code will execute. You'll usually set this up for state machines like this:

**Example 0.41 State Machine Template**
```verilog
parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2;
reg [2:0] state = S0;
always @ (posedge clk)
case(state)
     S0: // Do something here
     S1: // Do something here
     S2: // Do something here
     default: // Do something here
endcase
```
Don't forget to have a way for the next state to get calculated. You might also use `casex` statements. This is the same thing as a case statement, except you can use don't care bits.

**Example 0.42 Casex**
```verilog
reg [3:0] thing = 4'b0000;
always @ (posedge clk)
casex(thing)
     4'bxxx1: // Do something here
     default: // Do something here
encase
```
In this case, regardless of what the first three bits of the register are, if
the LSB is 1, that code executes. The rest of the bits are don't-care bits. For
example, if `thing` was a 4-bit binary containing `0011` it would execute that
same line of code as if it were `1101` because the LSB is `1` in both cases and
that's all that matters. In a `casex` statement, you can put x's in place of
don't care bits.

You are very unlikely to use `casez` statements in Project Lab 1. But just in case, `casez` works similarly to `casex`. You can put x's in place of don't care bits. You can also bit z's in place of high-impedance bits. High impedance means it was disconnected. It works like a tri-state buffer (you can crack open your ECE 2372 book or Google it if you want). In Verilog, each bit of variables has four possible variables: 0, 1, X, or Z. 0 and 1 are self-explanatory. X means the value is unknown. Z means the bit is disconnected entirely. You don't need to really know this, but it should help to know what Z means because the only time you're likely to see it is in your test bench. If your values shows up as Z in your test bench, it probably means you either forgot to instantiate the module (it shows as Z because it's *disconnected*) or you tried to pass a value through it that's too big and Vivado just disconnected the whole thing entirely. An example of the latter is if in your module you have `reg [1:0] A` and you tried to pass a 3-bit value to it or you connected it to a 3-bit wire. Always make sure your variable sizes match each other.

## Resources:
https://www.hdlworks.com/hdl_corner/verilog_ref/items/ProceduralAssignment.htm

https://class.ee.washington.edu/371/peckol/doc/Always@.pdf

http://www.asic-world.com/verilog/verilog_one_day.html

https://inst.eecs.berkeley.edu/~cs150/Documents/Nets.pdf

https://www.nandland.com/verilog/tutorials/tutorial-introduction-to-verilog-for-beginners.html
