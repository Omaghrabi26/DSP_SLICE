module P_OUT_REG #(parameter PREG=1)(
    input wire         CLK,             
    input wire         RSTP,           
    input wire		   CEP,
    input wire  signed [47:0] P_IN,

    output wire signed [47:0] P_OUT,
    output wire signed [47:0] PC_OUT
    );

wire        CLK_P;
reg [47:0]  P_REG;
CLK_GATE P1 (.CLK_EN(CEP),
             .CLK(CLK),
             .GATED_CLK(CLK_P));

always @ (posedge CLK_P)
begin
	if (RSTP)
	begin
	P_REG<='b0;
	end
	else 
	begin
	P_REG<=P_IN;
	end
end
assign  P_OUT =(PREG)? P_REG:P_IN ;
assign  PC_OUT=P_OUT;


endmodule 