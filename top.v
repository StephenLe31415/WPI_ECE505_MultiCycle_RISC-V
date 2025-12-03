module top (
    input clk,
    input rst,
    output [31:0] WriteData, DataAddr,
    output MemWrite
);

    wire [31:0] ReadData;

    // RISC-V Multicycle Processor
    RISCV_multicycle riscV_multi (
        .clk(clk),
        .rst(rst),
        .ReadData(ReadData),
        .Addr(DataAddr),
        .MemWrite(MemWrite),
        .WriteData(WriteData)
    );

    // Memory: Instruction + Data
    mem i_d_mem (
        .clk(clk),
        .WrEn(MemWrite),
        .Addr(DataAddr),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

endmodule