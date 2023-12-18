module PATTERN_DETECT_REG #(parameter PREG=1)(
    input wire         CLK,             
    input wire         RSTP,           
    input wire		       CEP,
    input wire         P_IN,
    output wire        P_OUT
    );

wire        CLK_P;
reg        P_REG;
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

endmodule 
