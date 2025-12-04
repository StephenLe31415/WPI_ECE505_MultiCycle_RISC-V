// A huge FSM to control the multi-cycle operations

`timescale 1ns / 1ps

module fsm (
    input clk,
    input rst,
    input [6:0] op,
    input [2:0] funct3,

    output reg PCUpdate,
    output reg Branch,
    output reg AdrSrc,
    output reg MemWrite, IRWrite, RegWrite,
    output reg [1:0] ResultSrc,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcA, ALUSrcB,
    output reg [1:0] ImmSrc
);

    // State encoding
    localparam S0_Fetch = 4'd0;
    localparam S1_Decode = 4'd1;
    localparam S2_MemAddr = 4'd2;
    localparam S3_MemRead = 4'd3;
    localparam S4_MemWB = 4'd4;
    localparam S5_MemWrite = 4'd5;
    localparam S6_Execute_R = 4'd6;
    localparam S7_ALUWB = 4'd7;
    localparam S8_Execute_I = 4'd8;
    localparam S9_JAL = 4'd9;
    localparam S10_BEQ = 4'd10;
    localparam S11_HALT = 4'd11;        // Custom

    // Instruction encoding:
    localparam OP_LW = 7'b0000011;
    localparam OP_SW = 7'b0100011;
    localparam OP_R = 7'b0110011;
    localparam OP_Branch = 7'b1100011;
    localparam OP_I = 7'b0010011;
    localparam OP_JAL = 7'b1101111;
    localparam OP_JALR = 7'b1100111;

    // State, next-state regs
    reg [3:0] state, next_state;

    // Seq. next-state logic
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) state <= S0_Fetch;
        else state <= next_state;
    end

    // Comb. next-state logic
    always @ (*) begin
        case (state)
            S0_Fetch : next_state = S1_Decode;

            S1_Decode : begin
                case(op)
                    OP_LW : next_state = S2_MemAddr;
                    OP_SW : next_state = S2_MemAddr;
                    OP_R  : next_state = S6_Execute_R;
                    OP_Branch : next_state = S10_BEQ;
                    OP_I : next_state = S8_Execute_I;
                    OP_JAL : next_state = S9_JAL;
                    OP_JALR : next_state = S2_MemAddr;
                    default : next_state = S0_Fetch;
                endcase
            end

            S2_MemAddr : begin
                if (op[5] == 1'b1) begin
                    if (op[6] == 1'b1) next_state = S9_JAL;     // JALR
                    else next_state = S5_MemWrite;              // SW
                end
                else next_state = S3_MemRead;                   // LW
            end    
            S3_MemRead : next_state = S4_MemWB;
            S4_MemWB : next_state = S0_Fetch;
            S5_MemWrite : next_state = S0_Fetch;
            S6_Execute_R : next_state = S7_ALUWB;
            S7_ALUWB : next_state = S0_Fetch;
            S8_Execute_I : next_state = S7_ALUWB;
            S9_JAL : next_state = S7_ALUWB;
            S10_BEQ : next_state = S0_Fetch;                    // Branch in general

            default : next_state = S11_HALT;
        endcase
    end

    // Output assignment logic
    always @ (*) begin
        case (state)
            S0_Fetch: begin
                Branch = 1'b0;
                PCUpdate = 1'b1;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b1;
                ResultSrc = 2'b10;
                ALUSrcB = 2'b10;
                ALUSrcA = 2'b00;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;
            end

            S1_Decode: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b1;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b01;
                ALUSrcA = 2'b01;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;
            end

            S2_MemAdr: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b01;
                ALUSrcA = 2'b10;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;
            end

            S3_MemRead: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b00;
                ALUSrcA = 2'b00;
                AdrSrc = 1'b1;
                ALUOp = 2'b00;
            end

            S4_MemWB: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b01;
                ALUSrcB = 2'b00;
                ALUSrcA = 2'b00;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;
            end

            S5_MemWrite: begin
                Branch = 1'b0;
                PCUpdate = 1'b1;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b1;
                ResultSrc = 2'b10;
                ALUSrcB = 2'b10;
                ALUSrcA = 2'b00;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;
            end

            S6_Execute_R: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b00;
                ALUSrcA = 2'b10;
                AdrSrc = 1'b0;
                ALUOp = 2'b10;
            end

            S7_ALUWB: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b00;
                ALUSrcA = 2'b00;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;                
            end
            
            S8_Execute_I: begin
                Branch = 1'b0;
                PCUpdate = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b01;
                ALUSrcA = 2'b10;
                AdrSrc = 1'b0;
                ALUOp = 2'b10;
            end

            S9_JAL: begin
                Branch = 1'b0;
                PCUpdate = 1'b1;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b10;
                ALUSrcA = 2'b01;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;                
            end

            S10_BEQ: begin
                Branch = 1'b1;
                PCUpdate = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                ResultSrc = 2'b00;
                ALUSrcB = 2'b00;
                ALUSrcA = 2'b10;
                AdrSrc = 1'b0;
                ALUOp = 2'b00;
            end

            S11_HALT: begin
                Branch = 1'bx;
                PCUpdate = 1'bx;
                RegWrite = 1'bx;
                MemWrite = 1'bx;
                IRWrite = 1'bx;
                ResultSrc = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 2'bxx;
                AdrSrc = 1'bx;
                ALUOp = 2'bxx;                
            end
        endcase
    end

    // ImmSrc logic
    always @ (*) begin
        case (op)
            OP_LW : ImmSrc = 2'b00;
            OP_SW : ImmSrc = 2'b01;
            OP_Branch : ImmSrc = 2'b10;
            OP_I : ImmSrc = 2'b00;
            OP_JAL : ImmSrc = 2'b11;
            OP_JALR : ImmSrc = 2'b00;
            OP_R : ImmSrc = 2'b00;
        endcase
    end

endmodule