module tb_statemachine();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

    //inputs
    logic slow_clock, resetb;
    logic [3:0] dscore, pscore, pcard3;

    //outputs
    logic load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, player_win_light, dealer_win_light;

    statemachine sm(.slow_clock(slow_clock),
                    .resetb(resetb),
                    .dscore(dscore),
                    .pscore(pscore),
                    .pcard3(pcard3),
                    .load_pcard1(load_pcard1),
                    .load_pcard2(load_pcard2),
                    .load_pcard3(load_pcard3),						  
                    .load_dcard1(load_dcard1),
                    .load_dcard2(load_dcard2),
                    .load_dcard3(load_dcard3),	
                    .player_win_light(player_win_light), 
                    .dealer_win_light(dealer_win_light));
    
    task reset_game;
        begin
            #1;
            resetb = 0;
            dscore = 0;
            pscore = 0;
            pcard3 = 0;

            #1;
            resetb = 1;
            #1;
        end
    endtask

    task run_initial_deal;
        begin

            #1;

            if (!load_pcard1)
                $error("Expected load_pcard1");

            run_clock_cycle();

            if (!load_dcard1)
                $error("Expected load_dcard1");

            run_clock_cycle();

            #1;
            if (!load_pcard2)
                $error("Expected load_pcard2");

            run_clock_cycle();

            #1;
            if (!load_dcard2)
                $error("Expected load_dcard2");

            run_clock_cycle();

            #1;
        end
    endtask

    task run_clock_cycle;
        begin
            #1;
            slow_clock = 1;
            #1;
            slow_clock = 0;
            #1;
        end
    endtask

    initial begin

        reset_game();
        run_initial_deal();

        //player score 8, dealer score 7, player wins
        pscore = 8;
        dscore = 7;

        run_clock_cycle();
        
        if (load_pcard3)
            $error("Expected player to NOT receive a third card");
        if (load_dcard3)
            $error("Expected dealer to NOT receive a third card");

        if (player_win_light && !dealer_win_light)
            $display("Correct: player wins");
        else
            $error("Expected player to win");

        
        reset_game();
        run_initial_deal();

        //player score 7, dealer score 8, dealer wins
        pscore = 7;
        dscore = 8;

        run_clock_cycle();
        
        if (load_pcard3)
            $error("Expected player to NOT receive a third card");
        if (load_dcard3)
            $error("Expected dealer to NOT receive a third card");

        if (!player_win_light && dealer_win_light)
            $display("Correct: dealer wins");
        else
            $error("Expected dealer to win");


        reset_game();
        run_initial_deal();

        //player score 8, dealer score 8, tie
        pscore = 8;
        dscore = 8;

        run_clock_cycle();

        if (load_pcard3)
            $error("Expected player to NOT receive a third card");
        if (load_dcard3)
            $error("Expected dealer to NOT receive a third card");

        if (player_win_light && dealer_win_light)
            $display("Correct: tie");
        else
            $error("Expected tie");

        
        reset_game();
        run_initial_deal();

        //PLAYER SCORE 5

        //player draws 3rd card, dealer score 7, dealer wins

        pscore = 5;
        dscore = 7;
        run_clock_cycle();
        if (!load_pcard3)
            $error("Expected player to receive a third card");

        pcard3 = 7;     // 5 + 7 = 12 % 10 = 2 < 7, dealer wins
        pscore = 2;

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(load_dcard3)
            $error("Expected dealer to NOT receive a third card");

        if (!player_win_light && dealer_win_light)
            $display("Correct: dealer wins");
        else
            $error("Expected dealer to win");

        reset_game();
        run_initial_deal();

        //player draws 3rd card (6), dealer score 6, player wins

        pscore = 5;
        dscore = 6;
        run_clock_cycle();
        if (!load_pcard3)
            $error("Expected player to receive a third card");

        pcard3 = 7; //score = 2
        pscore = 2;

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(!load_dcard3)
            $error("Expected dealer to receive a third card");
        
        dscore = 1; //pretend dcard3 is 5

        run_clock_cycle();

        if(player_win_light && !dealer_win_light)
            $display("Correct: player wins");
        else
            $error("Expected player to win");

        reset_game();
        run_initial_deal();

        //PLAYER SCORE 0

        //player draws 3rd card (4), dealer score 5, dealer draws 3rd card (2), dealer wins (S7 to S5)
        pscore = 0;
        dscore = 5;

        run_clock_cycle();
        if (!load_pcard3)
            $error("Expected player to receive a third card");

        pcard3 = 4;
        pscore = 4;

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(!load_dcard3)
            $error("Expected dealer to receive a third card");
        
        dscore = 7; //pretend dcard3 is 2

        run_clock_cycle();

        if (!player_win_light && dealer_win_light)
            $display("Correct: dealer wins");
        else
            $error("Expected dealer to win");

        reset_game();
        run_initial_deal();

        //player draws 3rd card (2), dealer score 4, dealer draws 3rd card (7), player wins
        pscore = 0;
        dscore = 4;

        run_clock_cycle();
        if (!load_pcard3)
            $error("Expected player to receive a third card");

        pcard3 = 2;
        pscore = 2;

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(!load_dcard3)
            $error("Expected dealer to receive a third card");
        
        dscore = 1; //pretend dcard3 is 7

        run_clock_cycle();

        if(player_win_light && !dealer_win_light)
            $display("Correct: player wins");
        else
            $error("Expected player to win");

        reset_game();
        run_initial_deal();

        //player draws 3rd card (9), dealer score 3, dealer draws 3rd card (10), player wins
        pscore = 0;
        dscore = 3;

        run_clock_cycle();
        if (!load_pcard3)
            $error("Expected player to receive a third card");

        pcard3 = 9;
        pscore = 9;

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(!load_dcard3)
            $error("Expected dealer to receive a third card");
        
        dscore = 3; //pretend dcard3 is 10

        run_clock_cycle();

        if(player_win_light && !dealer_win_light)
            $display("Correct: player wins");
        else
            $error("Expected player to win");

        reset_game();
        run_initial_deal();

        //player draws 3rd card (4), dealer score 0, dealer draws 3rd card (4), tie

        pscore = 0;
        dscore = 0;

        run_clock_cycle();
        if(!load_pcard3)
            $error("Expected player to receive a third card");
        
        pcard3 = 4;
        pscore = 4;

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(!load_dcard3)
            $error("Expected dealer to receive a third card");

        dscore = 4; //pretend dcard3 is 4

        run_clock_cycle();

        if(player_win_light && dealer_win_light)
            $display("Correct: tie");
        else
            $error("Expected tie");

        reset_game();
        run_initial_deal();

        //test S7 to S5 (no 3rd card for dealer) if dealer score is 3, player draws 3rd card (8), dealer wins

        pscore = 3;
        dscore = 3;

        run_clock_cycle();
        if(!load_pcard3)
            $error("Expected player to receive a third card");

        pcard3 = 8;
        pscore = 1; //pretend player draws 8, so banker doesn't draw a 3rd card

        run_clock_cycle();
        run_clock_cycle(); //evaluate S7

        if(load_dcard3)
            $error("Expected dealer to NOT receive a third card");
        
        if(!player_win_light && dealer_win_light)
            $display("Correct: dealer wins");
        else
            $error("Expected dealer to win");

        reset_game();
        run_initial_deal();

        //PLAYER SCORE 6, dealer score 5, dealer draws 3rd card (4), dealer wins

        pscore = 6;
        dscore = 5;

        run_clock_cycle();
        if(!load_dcard3)
            $error("Expected dealer to receive a third card");

        dscore = 9; //pretend dealer draws 4

        run_clock_cycle();

        if(!player_win_light && dealer_win_light)
            $display("Correct: dealer wins");
        else
            $error("Expected dealer to win");

        reset_game();
        run_initial_deal();

        //PLAYER SCORE 7, dealer score 5, dealer draws 3rd card (1), player wins

        pscore = 7;
        dscore = 5;

        run_clock_cycle();
        if(!load_dcard3)
            $error("Expected dealer to receive a third card");

        dscore = 6; //pretend dealer draws 1

        run_clock_cycle();

        if(player_win_light && !dealer_win_light)
            $display("Correct: player wins");
        else
            $error("Expected player to win");

        reset_game();
        run_initial_deal();

        //PLAYER SCORE 7, dealer score 6, player wins
        pscore = 7;
        dscore = 6;

        run_clock_cycle();
        
        if (load_pcard3)
            $error("Expected player to NOT receive a third card");
        if (load_dcard3)
            $error("Expected dealer to NOT receive a third card");

        if(player_win_light && !dealer_win_light)
            $display("Correct: player wins");
        else
            $error("Expected player to win");

        reset_game();
        run_initial_deal();

        //PLAYER SCORE 7, dealer score 7, tie

        pscore = 7;
        dscore = 7;

        run_clock_cycle();

        if (load_pcard3)
            $error("Expected player to NOT receive a third card");
        if (load_dcard3)
            $error("Expected dealer to NOT receive a third card");

        if(player_win_light && dealer_win_light)
            $display("Correct: tie");
        else
            $error("Expected tie");

        reset_game();
        run_initial_deal();

        $stop(0);
    end

endmodule

