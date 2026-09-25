module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						
// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.
    logic [3:0] new_card;

    logic [3:0] outp1;  //wire between player/dealer reg and hex/scorehand
    logic [3:0] outp2;
    logic [3:0] outp3;

    logic [3:0] outd1;
    logic [3:0] outd2;
    logic [3:0] outd3;

    dealcard DEAL(.clock(fast_clock), .resetb(resetb), .new_card(new_card));

    reg4 PCARD1_REG(.slow_clock(slow_clock), .resetb(resetb), .load_card(load_pcard1), .next_card(new_card), .curr_card(outp1));
    reg4 PCARD2_REG(.slow_clock(slow_clock), .resetb(resetb), .load_card(load_pcard2), .next_card(new_card), .curr_card(outp2));
    reg4 PCARD3_REG(.slow_clock(slow_clock), .resetb(resetb), .load_card(load_pcard3), .next_card(new_card), .curr_card(outp3));

    reg4 DCARD1_REG(.slow_clock(slow_clock), .resetb(resetb), .load_card(load_dcard1), .next_card(new_card), .curr_card(outd1));
    reg4 DCARD2_REG(.slow_clock(slow_clock), .resetb(resetb), .load_card(load_dcard2), .next_card(new_card), .curr_card(outd2));
    reg4 DCARD3_REG(.slow_clock(slow_clock), .resetb(resetb), .load_card(load_dcard3), .next_card(new_card), .curr_card(outd3));

    assign pcard3_out = outp3;

    scorehand PSCORE_HAND(.card1(outp1), .card2(outp2), .card3(outp3), .total(pscore_out));
    scorehand DSCORE_HAND(.card1(outd1), .card2(outd2), .card3(outd3), .total(dscore_out));

    card7seg PCARD1_7SEG(.SW(outp1), .HEX0(HEX0));
    card7seg PCARD2_7SEG(.SW(outp2), .HEX0(HEX1));
    card7seg PCARD3_7SEG(.SW(outp3), .HEX0(HEX2));

    card7seg DCARD1_7SEG(.SW(outd1), .HEX0(HEX3));
    card7seg DCARD2_7SEG(.SW(outd2), .HEX0(HEX4));
    card7seg DCARD3_7SEG(.SW(outd3), .HEX0(HEX5));


endmodule

