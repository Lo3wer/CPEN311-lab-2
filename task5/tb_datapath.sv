module tb_datapath();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

    logic slow_clock, fast_clock, resetb;
    logic load_pcard1, load_pcard2, load_pcard3;
    logic load_dcard1, load_dcard2, load_dcard3;
    logic [3:0] pcard3_out, pscore_out, dscore_out;
    logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    datapath dut(.slow_clock(slow_clock), .fast_clock(fast_clock), .resetb(resetb),
                 .load_pcard1(load_pcard1), .load_pcard2(load_pcard2), .load_pcard3(load_pcard3),
                 .load_dcard1(load_dcard1), .load_dcard2(load_dcard2), .load_dcard3(load_dcard3),
                 .pcard3_out(pcard3_out), .pscore_out(pscore_out), .dscore_out(dscore_out),
                 .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), .HEX2(HEX2), .HEX1(HEX1), .HEX0(HEX0));

    int deal_model;

    task fast_cycle;
        begin
            #10 fast_clock = 1;
            #10 fast_clock = 0;
            #10;
            deal_model = (deal_model == 13) ? 1 : deal_model + 1;
        end
    endtask

    task slow_cycle;
        begin
            #10 slow_clock = 1;
            #10 slow_clock = 0;
            #10;
        end
    endtask

    task set_card(input int card_value);
        begin
            while (deal_model != card_value) fast_cycle();
        end
    endtask

    task set_loads(input logic [5:0] load_bits);
        begin
            {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = load_bits;
        end
    endtask

    task reset_dp;
        begin
            set_loads(6'b000000);
            fast_clock = 0;
            slow_clock = 0;
            resetb = 0;
            #10;
            fast_cycle();
            deal_model = 1;
            #10;
            resetb = 1;
            #10;
        end
    endtask

    task load_card(input logic [5:0] load_select, input [3:0] card_value);
        begin
            set_card(card_value);
            set_loads(load_select);
            slow_cycle();
            set_loads(6'b000000);
            #10;
        end
    endtask

    task check_scores(input [3:0] expected_player_score, expected_dealer_score, expected_pcard3);
        begin
            #10;
            if (pscore_out !== expected_player_score)
                $error("Expected pscore %0d, got %0d", expected_player_score, pscore_out);
            if (dscore_out !== expected_dealer_score)
                $error("Expected dscore %0d, got %0d", expected_dealer_score, dscore_out);
            if (pcard3_out !== expected_pcard3)
                $error("Expected pcard3 %0d, got %0d", expected_pcard3, pcard3_out);
        end
    endtask

    initial begin
        set_loads(6'b000000);
        fast_clock = 0;
        slow_clock = 0;
        resetb = 0;

        //reset clears registers
        reset_dp();
        check_scores(0, 0, 0);

        //player 1 3 5 -> 9, dealer 2 4 6 -> 2
        reset_dp();
        load_card(6'b100000, 1);
        load_card(6'b010000, 3);
        load_card(6'b001000, 5);
        load_card(6'b000100, 2);
        load_card(6'b000010, 4);
        load_card(6'b000001, 6);
        check_scores(9, 2, 5);

        //only pcard1 loaded
        reset_dp();
        load_card(6'b100000, 8);
        check_scores(8, 0, 0);

        //no load holds the register
        reset_dp();
        load_card(6'b100000, 5);
        set_card(9);
        slow_cycle();
        check_scores(5, 0, 0);

        //fast clock does not load
        reset_dp();
        set_card(6);
        set_loads(6'b100000);
        fast_cycle();
        fast_cycle();
        check_scores(0, 0, 0);
        set_loads(6'b000000);

        //slow clock loads
        set_card(6);
        set_loads(6'b100000);
        slow_cycle();
        set_loads(6'b000000);
        check_scores(6, 0, 0);

        //pcard3 output
        reset_dp();
        load_card(6'b001000, 13);
        check_scores(0, 0, 13);

        //async reset clears registers
        reset_dp();
        load_card(6'b100000, 4);
        load_card(6'b000100, 9);
        check_scores(4, 9, 0);
        resetb = 0;
        #10;
        check_scores(0, 0, 0);
        resetb = 1;

        $stop(0);
    end

endmodule
