module PCOUT_REG #(parameter PREG=1)(
    input wire         CLK,             
    input wire         RSTP,           
    input wire		       CEP,
    input wire         P_COUT_IN,

    output wire        P_COUT
    );

wire        CLK_P;
reg         PCOUT_REG;
CLK_GATE G7 (.CLK_EN(CEP),
             .CLK(CLK),
             .GATED_CLK(CLK_P));

always @ (posedge CLK_P)
begin
	if (RSTP)
	begin
	 PCOUT_REG<='b0;
	end

	else 
	begin
	 PCOUT_REG<=P_COUT_IN;
	end
end
assign  P_COUT =(PREG)? PCOUT_REG:P_COUT_IN ;

endmodule 