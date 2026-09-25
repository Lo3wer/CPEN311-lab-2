module card7seg(input [3:0] SW, output [6:0] HEX0);

   logic [6:0] hex_out;

   always_comb begin
      case (SW)
         4'b0000: hex_out = 7'b1111111; // blank
         4'b0001: hex_out = 7'b0001000; // Ace -> "A"
         4'b0010: hex_out = 7'b0100100; // 2
         4'b0011: hex_out = 7'b0110000; // 3
         4'b0100: hex_out = 7'b0011001; // 4
         4'b0101: hex_out = 7'b0010010; // 5
         4'b0110: hex_out = 7'b0000010; // 6
         4'b0111: hex_out = 7'b1111000; // 7
         4'b1000: hex_out = 7'b0000000; // 8
         4'b1001: hex_out = 7'b0010000; // 9
         4'b1010: hex_out = 7'b1000000; // 10 -> "0"
         4'b1011: hex_out = 7'b1100001; // Jack -> "J"
         4'b1100: hex_out = 7'b0011000; // Queen -> "q"
         4'b1101: hex_out = 7'b0001001; // King -> "H"
         default: hex_out = 7'b1111111; // 1110, 1111: not used -> blank
      endcase
   end
   assign HEX0 = hex_out;

endmodule

