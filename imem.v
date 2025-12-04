`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2022 08:29:23 AM
// Design Name: 
// Module Name: register ROM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module imem (
    input [31:0] addr,       //5 bit register address input
    output [31:0] rd        //read data outputs
);

    reg [31:0] file [63:0]; //32 registers 32bits wide
    integer i;
    
      initial begin
          // Inti the instruction codes
          // PROGRAM 1 --- PASSED
//          file[0] = 32'h00000093;
//          file[1] = 32'h01000113;
//          file[2] = 32'h06400193;
//          file[3] = 32'h00800213;
//          file[4] = 32'h002082b3;
//          file[5] = 32'h00418333;
//          file[6] = 32'h0050a023;
//          file[7] = 32'h00612223;
//          file[8] = 32'h11111111;       // HALT
//          for (i = 9; i < 32; i = i + 1) begin
//            file[i] = 32'd0;
//          end
    
 /***********************************************************************************************/         
 
          // PROGRAM 2 --- PASSED
//          file[0] = 32'h00800293;
//          file[1] = 32'h00f00313;
//          file[2] = 32'h0062a023;
//          file[3] = 32'h005303b3;
//          file[4] = 32'h40530e33;
//          file[5] = 32'h03c384b3;
//          file[6] = 32'h00428293;
//          file[7] = 32'hffc2a903;
//          file[8] = 32'h41248933;
//          file[9] = 32'h00291913;
//          file[10] = 32'h0122a023;
//          for (i = 11; i < 32; i = i + 1) begin
//            file[i] = 32'd0;
//          end
    
/***********************************************************************************************/
    
          //factorial 6 --- FAILED
          file[0] = 32'h00c00513;
          file[1] = 32'h008000ef;
          file[2] = 32'h00a02023;
          file[3] = 32'hff810113;
          file[4] = 32'h00112223;
          file[5] = 32'h00a12023;
          file[6] = 32'hfff50513;
          file[7] = 32'h00051863;
          file[8] = 32'h00100513;
          file[9] = 32'h00810113;
          file[10] = 32'h00008067;
          file[11] = 32'hfe1ff0ef;
          file[12] = 32'h00050293;
          file[13] = 32'h00012503;
          file[14] = 32'h00412083;
          file[15] = 32'h00810113;
          file[16] = 32'h02550533;
          file[17] = 32'h00008067;
          for (i = 18; i < 32; i = i + 1) begin
            file[i] = 32'd0;
          end

/***********************************************************************************************/

    // ADDITIONAL TEST PROGRAM TO TEST BRANCH & JUMP (From Harris & Harris) --- PASSED
//    file[0] = 32'h00500113;  
//    file[1] = 32'h00C00193;
//    file[2] = 32'hFF718393;
//    file[3] = 32'h0023E233;
//    file[4] = 32'h0041F2B3;
//    file[5] = 32'h004282B3;
//    file[6] = 32'h02728863;
//    file[7] = 32'h0041A233;
//    file[8] = 32'h00020463;
//    file[9] = 32'h00000293;
//    file[10] = 32'h0023A233;
//    file[11] = 32'h005203B3;
//    file[12] = 32'h402383B3;
//    file[13] = 32'h0471AA23;
//    file[14] = 32'h06002103;
//    file[15] = 32'h005104B3;
//    file[16] = 32'h008001EF;
//    file[17] = 32'h00100113;
//    file[18] = 32'h00910133;
//    file[19] = 32'h0221A023;
//    file[20] = 32'h00210063;
//    for (i = 21; i < 32; i = i + 1) begin
//        file[i] = 32'd0;
//    end
    
      end

//*****************************************************************************************//

    // output the Instruction code
    //  assign rd = file[{25'd0, addr[6:2], 2'd0}];
    assign rd = file[addr[31:2]];

endmodule
