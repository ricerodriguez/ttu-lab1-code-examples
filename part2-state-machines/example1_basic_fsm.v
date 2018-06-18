// Basic Finite State Machine (FSM) Module
// ---------------------------------------
//
module basic_fsm(
     input clk,
     input A, B,         // Input operands
     output reg out      // Output depends on state
     );

     // Define states as parameters
     parameter add = 0,
               sub = 1;

     // Create a register for the state, start it at the "add" state
     reg [1:0] state = add;
     // Create an 8-bit register for our counter
     reg [7:0] count = 8'b0;

     // 8-bit counter counts up to 255
     always @ (posedge clk)
          count = count + 1;

     always @ (posedge clk)
     // State Machine
          case(state)
               // "add" state outputs the sum of the inputs
               add: begin
                    out = A + B;
                    // When counter hits 128, transition to the "sub" state
                    if(count >= 8'd128)
                         state = sub;
                    end
               // "sub" state outputs the difference of the inputs
               sub: begin
                    out = A - B;
                    // When counter overflows back to 0, transition back to
                    // "add" state
                    if(count == 8'd0)
                         state = add;
                    end
          endcase
endmodule
