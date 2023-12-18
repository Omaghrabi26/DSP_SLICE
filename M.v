module Multiplier_out_reg #(parameter MREG=1)(
    
    input  wire               CLK,
    input  wire               RSTM,
    input  wire               CEM,
    //input wire  [42:0] MULT,
    input  wire signed [17:0] B,
    input  wire signed [24:0] A_D, 

    output wire signed [42:0] MULT_OUT       // multiplier output
    );

wire CLK_M;
reg  [42:0]  MULT_REG;
wire [42:0]  MULT;


assign MULT = B*A_D;



CLK_GATE M1 (.CLK_EN(CEM),
             .CLK(CLK),
             .GATED_CLK(CLK_M));



always @ (posedge CLK_M)
begin
    if (RSTM)
    begin
    MULT_REG<='b0;
    end
    else 
    begin
    MULT_REG<=MULT;
    end
end


assign  MULT_OUT =(MREG)? MULT_REG:MULT ;

endmodule
