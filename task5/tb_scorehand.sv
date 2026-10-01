module tb_scorehand();

	logic [3:0] card1;
	logic [3:0] card2;
	logic [3:0] card3;
	logic [3:0] total;

	scorehand sh (.card1(card1), .card2(card2), .card3(card3), .total(total));

	task check_score(input logic [3:0] test_card1, input logic [3:0] test_card2,
		input logic [3:0] test_card3, input logic [3:0] expected_total);
		begin
			card1 = test_card1;
			card2 = test_card2;
			card3 = test_card3;
			#1;

			if (total !== expected_total) begin
				$error("Error: card1=%0d card2=%0d card3=%0d: expected total=%0d, got total=%0d", test_card1, test_card2, test_card3, expected_total, total);
			end
			else begin
				$display("Correct answer: card1=%0d card2=%0d card3=%0d -> total=%0d", test_card1, test_card2, test_card3, total);
			end
		end
	endtask

	initial begin
		check_score(1, 2, 3, 6);
		check_score(9, 9, 9, 7);    //modulo 10
		check_score(10, 11, 12, 0);
        check_score(0, 0, 0, 0);
		check_score(9, 10, 8, 7);   //test combo of non zero and zero point cards
		check_score(7, 8, 9, 4);    //above 20
        check_score(0, 0, 0, 0);
        check_score(5, 0, 0, 5);
        check_score(0, 7, 0, 7);
        check_score(0, 0, 9, 9);
        $stop(0);
	end

endmodule

