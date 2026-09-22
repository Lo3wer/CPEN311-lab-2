module reg4(input slow_clock, input resetb, input load_card, input [3:0] next_card, output [3:0] curr_card);
    
    reg [3:0] card;

    always_ff @(posedge slow_clock or negedge resetb) begin
        if (!resetb) begin
            card <= 4'h0;
        end else if (load_card) begin
            card <= next_card;
        end
    end
    
    assign curr_card = card;
endmodule