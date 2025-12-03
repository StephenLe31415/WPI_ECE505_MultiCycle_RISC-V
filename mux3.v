module mux3 #(parameter W = 32) (
    input [W-1:0] a, b, c,
    input [1:0] sel,
    output [W-1:0] y
);

    assign y = (s == 2'b00)? a : ((s == 2'b01)? b : c);

endmodule