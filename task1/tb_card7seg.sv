module tb_card7seg();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

    logic [3:0] SW;
    logic [6:0] HEX0;

    // instantiate the design under test
    card7seg dut (
        .SW   (SW),
        .HEX0 (HEX0)
    );

    initial begin
        // 0
        SW = 4'b0000;
        #10;

        if (HEX0 === 7'b1111111)
            $display("PASS: SW=0000 -> HEX0=%b (blank)", HEX0);
        else
            $display("FAIL: SW=0000 -> HEX0=%b, expected 1111111", HEX0);

        // 1
        SW = 4'b0001;
        #10;

        if (HEX0 === 7'b0001000)
            $display("PASS: SW=0001 -> HEX0=%b (Ace)", HEX0);
        else
            $display("FAIL: SW=0001 -> HEX0=%b, expected 0001000", HEX0);

        // 2
        SW = 4'b0010;
        #10;

        if (HEX0 === 7'b0100100)
            $display("PASS: SW=0010 -> HEX0=%b (2)", HEX0);
        else
            $display("FAIL: SW=0010 -> HEX0=%b, expected 0100100", HEX0);

        // 3
        SW = 4'b0011;
        #10;

        if (HEX0 === 7'b0110000)
            $display("PASS: SW=0011 -> HEX0=%b (3)", HEX0);
        else
            $display("FAIL: SW=0011 -> HEX0=%b, expected 0110000", HEX0);

        // 4
        SW = 4'b0100;
        #10;

        if (HEX0 === 7'b0011001)
            $display("PASS: SW=0100 -> HEX0=%b (4)", HEX0);
        else
            $display("FAIL: SW=0100 -> HEX0=%b, expected 0011001", HEX0);

        // 5
        SW = 4'b0101;
        #10;

        if (HEX0 === 7'b0010010)
            $display("PASS: SW=0101 -> HEX0=%b (5)", HEX0);
        else
            $display("FAIL: SW=0101 -> HEX0=%b, expected 0010010", HEX0);

        // 6
        SW = 4'b0110;
        #10;

        if (HEX0 === 7'b0000010)
            $display("PASS: SW=0110 -> HEX0=%b (6)", HEX0);
        else
            $display("FAIL: SW=0110 -> HEX0=%b, expected 0000010", HEX0);

        // 7
        SW = 4'b0111;
        #10;

        if (HEX0 === 7'b1111000)
            $display("PASS: SW=0111 -> HEX0=%b (7)", HEX0);
        else
            $display("FAIL: SW=0111 -> HEX0=%b, expected 1111000", HEX0);

        // 8
        SW = 4'b1000;
        #10;

        if (HEX0 === 7'b0000000)
            $display("PASS: SW=1000 -> HEX0=%b (8)", HEX0);
        else
            $display("FAIL: SW=1000 -> HEX0=%b, expected 0000000", HEX0);

        // 9
        SW = 4'b1001;
        #10;

        if (HEX0 === 7'b0010000)
            $display("PASS: SW=1001 -> HEX0=%b (9)", HEX0);
        else
            $display("FAIL: SW=1001 -> HEX0=%b, expected 0010000", HEX0);

        // 10
        SW = 4'b1010;
        #10;

        if (HEX0 === 7'b1000000)
            $display("PASS: SW=1010 -> HEX0=%b (10)", HEX0);
        else
            $display("FAIL: SW=1010 -> HEX0=%b, expected 1000000", HEX0);

        // 11
        SW = 4'b1011;
        #10;

        if (HEX0 === 7'b1100001)
            $display("PASS: SW=1011 -> HEX0=%b (Jack)", HEX0);
        else
            $display("FAIL: SW=1011 -> HEX0=%b, expected 1100001", HEX0);

        // 12
        SW = 4'b1100;
        #10;

        if (HEX0 === 7'b0011000)
            $display("PASS: SW=1100 -> HEX0=%b (Queen)", HEX0);
        else
            $display("FAIL: SW=1100 -> HEX0=%b, expected 0011000", HEX0);

        // 13
        SW = 4'b1101;
        #10;

        if (HEX0 === 7'b0001001)
            $display("PASS: SW=1101 -> HEX0=%b (King)", HEX0);
        else
            $display("FAIL: SW=1101 -> HEX0=%b, expected 0001001", HEX0);

        // 14
        SW = 4'b1110;
        #10;

        if (HEX0 === 7'b1111111)
            $display("PASS: SW=1110 -> HEX0=%b (blank)", HEX0);
        else
            $display("FAIL: SW=1110 -> HEX0=%b, expected 1111111", HEX0);

        // 15
        SW = 4'b1111;
        #10;

        if (HEX0 === 7'b1111111)
            $display("PASS: SW=1111 -> HEX0=%b (blank)", HEX0);
        else
            $display("FAIL: SW=1111 -> HEX0=%b, expected 1111111", HEX0);

        $finish;
    end
						
endmodule
