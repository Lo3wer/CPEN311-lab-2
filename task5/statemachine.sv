`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
`define S7 4'b0111
`define S8 4'b1000

module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

    logic [3:0] present_state;
    logic [7:0] output_vector;

    always_ff @(posedge slow_clock) begin   //update present_state based on game rules
        if(!resetb)
            present_state <= `S0;

        else begin
            case (present_state)
                `S0: present_state <= `S1;
                `S1: present_state <= `S2;
                `S2: present_state <= `S3;
                `S3: present_state <= `S4;
                `S4: begin
                    if (pscore >= 8 || dscore >= 8)
                        present_state <= `S5;
                    else if(pscore <= 5)
                        present_state <= `S6;
                    else if(dscore <= 5)
                        present_state <= `S8;
                    else
                        present_state <= `S5;
                end
                //do nothing at S5 since it's the end, need to press reset to go back to S0
                `S6: begin
                    if((dscore == 6 && (pcard3 == 6 || pcard3 == 7))
                    || (dscore == 5 && (pcard3 >= 4 && pcard3 <= 7))
                    || (dscore == 4 && (pcard3 >= 2 && pcard3 <= 7))
                    || (dscore == 3 && pcard3 != 8)
                    || (dscore >= 0 && dscore <= 2))
                        present_state <= `S7;
                    else
                        present_state <= `S5; //covers both dscore == 7 and all other cases that dont satisfy the bacarat rules to get a 3rd card
                end
                `S7: present_state <= `S5;
                `S8: present_state <= `S5;
                `S5: present_state <= `S5;
                default: present_state <= `S0;
            endcase
        end
    end
    always_comb begin
        case(present_state)
            `S1: output_vector = 8'b10000000;
            `S2: output_vector = 8'b00010000;
            `S3: output_vector = 8'b01000000;
            `S4: output_vector = 8'b00001000;
            `S5: begin 
                if(pscore > dscore)
                    output_vector = 8'b00000010;
                else if (dscore > pscore)
                    output_vector = 8'b00000001;
                else
                    output_vector = 8'b00000011;
            end
            `S6: output_vector = 8'b00100000;
            `S7: output_vector = 8'b00000100;
            `S8: output_vector = 8'b00000100;
            default: output_vector = 8'b00000000;
        endcase
    end

    //use assign since we need to continuously drive the output wires
    assign {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light} = output_vector;

endmodule

