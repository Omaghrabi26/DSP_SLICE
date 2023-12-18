module CARRY_IN_SEL #(parameter CARRYINSELREG=1)(
    
    input wire         CLK,             
    input wire         RSTCTRL,           
    input wire		   CECTRL,
    input wire  [2:0]  CARRYINSEL,

    output wire [2:0]  CARRYIN_SEL_OUT
    );


wire CLK_CARRY_IN;
reg [2:0]  CARRYINSEL_REG;

CLK_GATE S1 (.CLK_EN(CECTRL),
             .CLK(CLK),
             .GATED_CLK(CLK_CARRY_IN));



always @ (posedge CLK_CARRY_IN)
begin
	if (RSTCTRL)
	begin
	CARRYINSEL_REG<='b0;
	end
	else 
	begin
	CARRYINSEL_REG<=CARRYINSEL;
	end
end


assign  CARRYIN_SEL_OUT = (CARRYINSELREG)? CARRYINSEL_REG:CARRYINSEL ;

endmodule 