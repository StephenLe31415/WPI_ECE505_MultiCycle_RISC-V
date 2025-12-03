module branch_dec (
    input [6:0] op,
    input [2:0] funct3,
    input Branch,
    output beq, bne
);

    assign beq = (op == 7'b1100011) & (funct3 == 3'b000) & Branch;
    assign bne = (op == 7'b1100011) & (funct3 == 3'b001) & Branch;

endmodule