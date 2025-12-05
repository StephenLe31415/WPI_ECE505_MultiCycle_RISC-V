module multi_cycle_controller (
    input clk, reset,
    input [6:0] op,
    input [2:0] funct3, 
    input [6:0] funct7,
    input zero,
    
    output [1:0] ImmSrc,
    output [1:0] ALUSrcA, ALUSrcB,
    output [1:0] ResultSrc,
    output AddrSrc,
    output [2:0] ALUControl,
    output IRWrite, RegWrite, MemWrite,
    output PCWrite
);

    wire beq, bne;
    wire Branch;
    wire PCUpdate;
    wire [1:0] ALUOp;
    wire [3:0] state;

    // Control Unit FSM
    fsm fsm (
        .clk(clk),
        .reset(reset),
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
        .ImmSrc(ImmSrc),
        .state(state)
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