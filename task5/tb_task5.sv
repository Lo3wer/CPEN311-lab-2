module tb_task5();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 100,000 ticks (equivalent to "initial #100000 $finish();").

    logic CLOCK_50;
    logic [1:0] KEY;
    logic [9:0] LEDR;
    logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    task5 dut(.CLOCK_50(CLOCK_50), .KEY(KEY), .LEDR(LEDR),
              .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3),
              .HEX2(HEX2), .HEX1(HEX1), .HEX0(HEX0));

    int deal_model;

    task fast_cycle;
        begin
            #10 CLOCK_50 = 1;
            #10 CLOCK_50 = 0;
            #10;
            deal_model = (deal_model == 13) ? 1 : deal_model + 1;
        end
    endtask

    task slow_cycle;
        begin
            #10 KEY[0] = 1;
            #10 KEY[0] = 0;
            #10;
        end
    endtask

    task set_card(input int card_value);
        begin
            while (deal_model != card_value) fast_cycle();
        end
    endtask

    task step(input int card_value);
        begin
            set_card(card_value);
            slow_cycle();
        end
    endtask

    task reset_game;
        begin
            CLOCK_50 = 0;
            KEY = 2'b00;
            #10;
            fast_cycle();
            deal_model = 1;
            #10;
            KEY[1] = 1;
            #10;
        end
    endtask

    task check_result(input [3:0] expected_player_score, expected_dealer_score,
                      input logic expected_player_win, expected_dealer_win);
        begin
            #10;
            if (LEDR[3:0] !== expected_player_score)
                $error("Expected pscore %0d, got %0d", expected_player_score, LEDR[3:0]);
            if (LEDR[7:4] !== expected_dealer_score)
                $error("Expected dscore %0d, got %0d", expected_dealer_score, LEDR[7:4]);
            if (LEDR[8] !== expected_player_win)
                $error("Expected player light %b, got %b", expected_player_win, LEDR[8]);
            if (LEDR[9] !== expected_dealer_win)
                $error("Expected dealer light %b, got %b", expected_dealer_win, LEDR[9]);
        end
    endtask

    initial begin
        CLOCK_50 = 0;
        KEY = 2'b00;
        #10;

        //player 4 4 -> 8, dealer 3 4 -> 7, player wins
        reset_game();
        step(4);
        step(3);
        step(4);
        step(4);
        slow_cycle();
        check_result(8, 7, 1, 0);

        //player 4 5 -> 9, dealer 4 5 -> 9, tie
        reset_game();
        step(4);
        step(4);
        step(5);
        step(5);
        slow_cycle();
        check_result(9, 9, 1, 1);

        //player 10 10 -> 0, dealer 9 9 -> 8, dealer wins
        reset_game();
        step(10);
        step(9);
        step(10);
        step(9);
        slow_cycle();
        check_result(0, 8, 0, 1);

        //player draws 3rd card, dealer stands on 6, player wins
        reset_game();
        step(1);
        step(2);
        step(3);
        step(4);
        slow_cycle();
        step(5);
        slow_cycle();
        check_result(9, 6, 1, 0);

        //player draws 3rd card, dealer draws 3rd card, player wins
        reset_game();
        step(1);
        step(1);
        step(1);
        step(1);
        slow_cycle();
        step(5);
        slow_cycle();
        step(3);
        check_result(7, 5, 1, 0);

        //player 3 4 -> 7, dealer 3 4 -> 7, tie
        reset_game();
        step(3);
        step(3);
        step(4);
        step(4);
        slow_cycle();
        check_result(7, 7, 1, 1);

        //player 2 4 -> 6, dealer 3 4 -> 7, dealer wins
        reset_game();
        step(2);
        step(3);
        step(4);
        step(4);
        slow_cycle();
        check_result(6, 7, 0, 1);

        //player stands on 7, dealer draws 3rd card, dealer wins
        reset_game();
        step(3);
        step(2);
        step(4);
        step(3);
        slow_cycle();
        step(4);
        check_result(7, 9, 0, 1);

        //reset mid game returns to S0 and clears all
        reset_game();
        step(4);
        step(4);
        step(4);
        step(4);
        slow_cycle();
        check_result(8, 8, 1, 1);
        KEY[1] = 0;
        #10;
        check_result(0, 0, 0, 0);
        KEY[1] = 1;
        #10;

        $stop(0);
    end

endmodule
