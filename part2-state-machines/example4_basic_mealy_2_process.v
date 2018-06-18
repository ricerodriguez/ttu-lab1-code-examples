// Mealy Machine
// ============================================================================
// Very simple demonstration of how to implement a Mealy machine.
// Uses 2 processes:
//   1. Next State and Output Combinational Logic
//   2. State Register
// Remember that in a Mealy machine, output depends on current state and input
// ============================================================================
module mealy(
     input clk,
     input in,
     output reg out
     );

     // Define states as parameters
     parameter S0 = 0,
               S1 = 1;

     // Create a register for the current state, initialize it to S0
     reg state_now = S0;
     // Create a register for the next state
     reg state_next;

     // Process 1: Determine next state and output
     always @ (state_now)
          case(state_now)
               S0:
                    case(in)
                    0: begin
                         state_next <= S0;
                         out = 0;
                    end

                    1: begin
                         state_next <= S1;
                         out = 1;
                    end
                    endcase
               S1:
                    case(in)
                    0: begin
                         state_next <= S1;
                         out = 1;
                    end

                    1: begin
                         state_next <= S0;
                         out = 0;
                    end
                    endcase
          endcase

     // Process 2: Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

endmodule
