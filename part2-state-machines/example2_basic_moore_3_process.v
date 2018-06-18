// Moore Machine
// ============================================================================
// Very simple demonstration of how to implement a Moore machine.
// Uses 3 processes:
//   1. Next State Combinational Logic
//   2. State Register
//   3. Output Combinational Logic
// Remember that in a Moore machine, output only depends on current state
// ============================================================================
module moore(
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

     // Process 1: Determine next state
     always @ (state_now)
          case(state_now)
               S0:
                    case(in)
                    0: state_next <= S0;
                    1: state_next <= S1;
                    endcase
               S1:
                    case(in)
                    0: state_next <= S1;
                    1: state_next <= S0;
                    endcase
          endcase

     // Process 2: Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

     // Process 3: Output according to current state
     always @ (state_now)
          case(state_now)
          S0: out = 0;
          S1: out = 1;
          endcase

endmodule
