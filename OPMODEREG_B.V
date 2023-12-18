module OPMODEREG_B #(parameter OPMODEREG=1)(
    
    input wire         CLK,             
    input wire         RSTCTRL,           
    input wire		   CECTRL,
    input wire  [6:0]  OPMODE,

    output wire [6:0]  MUXS_SEL
    );


wire CLK_OP;
reg [6:0]  OPMODE_REG;

CLK_GATE V1 (.CLK_EN(CECTRL),
             .CLK(CLK),
             .GATED_CLK(CLK_OP));



always @ (posedge CLK_OP)
begin
	if (RSTCTRL)
	begin
	OPMODE_REG<='b0;
	end
	else 
	begin
	OPMODE_REG<=OPMODE;
	end
end


assign  MUXS_SEL =(OPMODEREG)? OPMODE_REG:OPMODE ;

endmodule 