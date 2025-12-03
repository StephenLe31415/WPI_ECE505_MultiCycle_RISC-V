module mux2 #(parameter W = 32) (
    input [W-1:0] a, b,
    input sel,
    output [W-1:0] y
);

    assign y = (sel == 1'b0)? a : b;

endmodule