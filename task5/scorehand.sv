module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);
    logic [5:0] sum;
    assign sum = ({2'b0, card1} + {2'b0, card2} + {2'b0, card3}) % 6'd10;
    assign total = sum[3:0];
endmodule

