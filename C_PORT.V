module C_PORT  #(parameter CREG=1)(
    
    input wire         CLK,             
    input wire         RSTC,           
    input wire		   CEC,
    input wire  signed [47:0] C,

    output wire signed [47:0] C_OUT
    );


wire CLK_C;
reg [47:0]  C_REG;

CLK_GATE C1 (.CLK_EN(CEC),
             .CLK(CLK),
             .GATED_CLK(CLK_C));



always @ (posedge CLK_C)
begin
	if (RSTC)
	begin
	C_REG<='b0;
	end
	else 
	begin
	C_REG<=C;
	end
end


assign  C_OUT =(CREG)? C_REG:C ;

endmodule 