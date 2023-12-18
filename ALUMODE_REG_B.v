module ALUMODEREG_B #(parameter ALUMODEREG=1) (
    
    input wire         CLK,             
    input wire         RSTALUMODE,           
    input wire		   CEALUMODE,
    input wire  [3:0]  ALUMODE,

    output wire [3:0]  ALU_MODE_OUT
    );


wire 	     CLK_ALU;
reg   [3:0]  ALUMODE_REG;

CLK_GATE A1 (.CLK_EN(CEALUMODE),
             .CLK(CLK),
             .GATED_CLK(CLK_ALU));



always @ (posedge CLK_ALU)
begin
	if (RSTALUMODE)
	begin
	ALUMODE_REG<='b0;
	end
	
	else 
	begin
	ALUMODE_REG<=ALUMODE;
	end
end


assign  ALU_MODE_OUT =(ALUMODEREG)? ALUMODE_REG:ALUMODE ;

endmodule 