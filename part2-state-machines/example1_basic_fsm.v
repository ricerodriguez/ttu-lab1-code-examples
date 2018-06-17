module basic_fsm(
     input clk,
     input A, B,         // Input operands
     input [1:0] state,  // Input state
     output reg out      // Output depends on state
     );
     parameter add = 0,
               sub = 1;

     always @ (posedge clk)
          case(state)
               add: out = A + B;
               sub: out = A - B;
          endcase
endmodule
