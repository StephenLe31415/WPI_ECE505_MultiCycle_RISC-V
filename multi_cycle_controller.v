module multi_cycle_controller (
    input clk, rst,
    input [6:0] op,
    input [2:0] funct3, 
    input [6:0] funct7,
    input zero,
    output reg [2:0] ImmSrc,
    output reg [1:0] ALUSrcA, ALUSrcB,
    output reg [1:0] ResultSrc,
    output reg AddrSrc,
    output reg [2:0] ALUControl,
    output reg IRWrite, PCWrite, RegWrite, MemWrite
);

    wire beq, bne;
    wire Branch;
    wire PCUpdate;
    reg [1:0] ALUOp;

    // Control Unit FSM
    fsm FSM (
        .clk(clk),
        .rst(rst),
        .op(op),
        .funct3(funct3),
        .PCUpdate(PCUpdate),            // = Jump
        .Branch(Branch),
        .AddrSrc(AddrSrc),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .ResultSrc(ResultSrc),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc)
    );

    // ALU Decoder
    aludec ALUDec (
        .op(op),
        .funct7(funct7),
        .funct3(funct3),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    // Branch Decoder
    branch_dec BranchDec(
        .op(op),
        .funct3(funct3),
        .Branch(Branch),
        .beq(beq),
        .bne(bne)
    );

    assign PCWrite = (beq & zero) | (bne & ~zero) | PCUpdate;

endmodule