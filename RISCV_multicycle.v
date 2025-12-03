module RISCV_multicycle (
    input clk,
    input rst,
    input [31:0] ReadData,

    output [31:0] Addr,
    output reg MemWrite,
    output [31:0] WriteData
);

    wire [1:0] ResultSrc, ImmSrc, ALUSrcA, ALUSrcB;
    wire AddrSrc, zero;
    wire [2:0] ALUControl;
    wire IRWrite, PCWrite;
    wire [31:0] Instr;

    // Controller
    multi_cycle_controller cntrllr (
        .clk(clk),
        .rst(rst),
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[31:25]),
        .zero(zero),
        .ImmSrc(ImmSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .AddrSrc(AddrSrc),
        .ALUControl(ALUControl),
        .IRWrite(IRWrite),
        .PCWrite(PCWrite),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite)
    );

    // Datapath
    datapath dp (
        .clk(clk),
        .rst(rst),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl),
        .ResultSrc(ResultSrc),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .PCWrite(PCWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .AddrSrc(AddrSrc),
        .ReadData(ReadData),
        .zero(zero),
        .Addr(Addr),
        .WriteData(WriteData),
        .Instr(Instr)
    );

endmodule