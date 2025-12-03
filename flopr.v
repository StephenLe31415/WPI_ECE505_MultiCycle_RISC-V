module flopr #(parameter W = 8) (
    input clk, 
    input rst,
    input [W-1:0] d,
    output reg [W-1:0] q
);
    
    always @ (posedge clk or posedge reset) begin
        if (rst == 1'b1) q <= 0;                  // reset: PC = 0x00000000
        else q <= d;
    end
    
endmodule