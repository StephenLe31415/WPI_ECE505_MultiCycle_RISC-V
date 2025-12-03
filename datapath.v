module datapath (
    input clk,
    input rst,
    
    input [1:0] ImmSrc,
    input [3:0] ALUControl,
    input [1:0] ResultSrc,
    input IRWrite, RegWrite, PCWrite,
    input [1:0] ALUSrcA, ALUSrcB,
    input AddrSrc,
    input [31:0] ReadData,
    
    output zero,
    output [31:0] Addr,
    output [31:0] WriteData,
    output [31:0] Instr
);

   wire [31:0] Result, ALUOut, ALUResult;
   wire [31:0] RD1, RD2, A, SrcA, SrcB, Data;
   wire [31:0] ImmExt;
   wire [31:0] PC, OldPC;

   // PC
   flopenr #(32) pcFlop (
        .clk(clk),
        .rst(rst),
        .en(PCWrite),
        .d(Result),
        .q(PC)
   );

   /***** REG FILE *****/
   reg_file rf (
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite),
        .WD3(Result),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .RD1(RD1),
        .RD2(RD2)
   );

   // Extend
   extend xtnd (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
   );

    // Reg file flop for RD1
   flopr #(32) rf_1 (
        .clk(clk),
        .rst(rst),
        .d(RD1),
        .q(A)
   );

    // Reg file flop for RD2
    flopr #(32) rf_2 (
        .clk(clk),
        .rst(rst),
        .d(RD2),
        .q(WriteData)
    );

    /***** ALU *****/
    alu ALU (
        .a(SrcA),
        .b(SrcB),
        .ALUControl(ALUControl),
        .zero(zero),
        .ALUResult(ALUResult)
    );

    // SrcA mux
    mux3 #(32) SrcA_mux (
        .a(PC),
        .b(OldPC),
        .c(A),
        .sel(ALUSrcA),
        .y(SrcA)
    );

    // SrcB mux
    mux3 #(32) SrcB_mux (
        .a(WriteData),
        .b(ImmExt),
        .c(32'd4),
        .sel(ALUSrcB),
        .y(SrcB)
    );

    // ALUOut flop
    flopr #(32) ALUOut_flop (
        .clk(clk),
        .rst(rst),
        .d(ALUResult),
        .q(ALUOut)
    );

    // Result Mux
    mux4 res_mux (
        .a(ALUOut),
        .b(Data),
        .c(ALUResult),
        .d(ImmExt),
        .sel(ResultSrc),
        .y(Result)
    );

    /***** MEM *****/
    mux2 Addr_mux (
        .a(PC),
        .b(Result),
        .sel(AddrSrc),
        .y(Addr)
    );

    // Mem PC flop
    flopenr #(32) PC_flop (
        .clk(clk),
        .rst(rst),
        .en(IRWRite),
        .d(PC),
        .q(OldPC)
    );

    // Mem Instr. flop
    flopenr #(32) Instr_flop (
        .clk(clk),
        .rst(rst),
        .en(IRWrite),
        .d(ReadData),
        .q(Instr)
    );

    // Mem Data flop
    flopr #(32) memDataFlop (
        .clk(clk),
        .rst(rst),
        .d(ReadData),
        .q(Data)
    );

endmodule