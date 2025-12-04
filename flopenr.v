module flopenr #(parameter W = 8)(
    input clk, 
    input reset,
    input en,
    input [W-1:0]d,
    output reg [W-1:0]q
);
    
    always @ (posedge clk or posedge reset) begin
        if (reset == 1'b1) q <= 0;
        else if (en == 1'b1) q <= d;
    end
endmodule