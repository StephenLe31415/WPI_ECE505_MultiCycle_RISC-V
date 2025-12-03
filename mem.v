module mem (
    input clk,
    input WrEn,
    input [31:0] Addr, WriteData,
    output [31:0] ReadData
);

    reg [31:0] RAM[255:0];

    initial begin
        // Init instr. here
    end

    assign ReadData = [RAM[Addr[31:2]]];

    always @ (posedge clk) begin
        if (Wr_En == 1'b1) RAM[Addr[31:2]] <= WriteData;
    end

endmodule