module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);
    logic [5:0] sum;

    logic [3:0] score1;
    logic [3:0] score2;
    logic [3:0] score3;

    always_comb begin   //tens, jack, queen, kings are 0 score
        if(card1 >= 10)
            score1 = 4'd0;
        else
            score1 = card1;
        if(card2 >= 10)
            score2 = 4'd0;
        else
            score2 = card2;
        if(card3 >= 10)
            score3 = 4'd0;
        else
            score3 = card3;
    end

    assign sum = ({2'b0, score1} + {2'b0, score2} + {2'b0, score3}) % 6'd10;
    assign total = sum[3:0];
endmodule

