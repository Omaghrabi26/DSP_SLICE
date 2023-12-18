module CARRY_IN #(parameter CARRYINREG=1,MREG=1 )


	(  input wire CARRYIN,
       input wire RSTALLCARRYIN,
       input wire CECARRYIN,
       input wire CLK,
       input wire CARRYCASCIN,
       input wire CARRYCASCOUT,
   
       input wire A,B,       //A[24],B[17]
       input wire CEM,
   
       input wire P,PCIN,  //P[47],PCIN[47]

       input wire [2:0] CARRYINSEL,

       output reg CIN
	);
////////////////////////CARRY IN BYPASS///////////////////////////
wire CLK_CARRYIN;
reg  CARRYIN_REG;
wire CARRYIN_OUT_MUX;
CLK_GATE CI1 (.CLK_EN(CECARRYIN),
             .CLK(CLK),
             .GATED_CLK(CLK_CARRYIN));
always @ (posedge CLK_CARRYIN)
begin
	if (RSTALLCARRYIN)
	begin
	CARRYIN_REG<='b0;
	end
	else 
	begin
	CARRYIN_REG<=CARRYIN;
	end
end
assign  CARRYIN_OUT_MUX =(CARRYINREG)? CARRYIN_REG:CARRYIN ;


///////////////////////ROUND BYPASS////////////////////////
wire CLK_ROUND;
reg  ROUND_REG;
wire ROUND;
wire ROUND_OUT_MUX;

assign ROUND = ~(A ^ B);

CLK_GATE CI2 (.CLK_EN(CEM),
            .CLK(CLK),
             .GATED_CLK(CLK_ROUND));

always @ (posedge CLK_ROUND)
begin
	if (RSTALLCARRYIN)
	begin
	ROUND_REG<='b0;
	end
	else 
	begin
	ROUND_REG<=ROUND;
	end
end
assign  ROUND_OUT_MUX =(MREG)? ROUND_REG:ROUND ;


//////////////////////////////CIN_MUX/////////////////

always @(*)
begin
	case(CARRYINSEL)
    3'b000: CIN = CARRYIN_OUT_MUX;
    3'b001: CIN = ~(PCIN);
    3'b010: CIN = CARRYCASCIN;
    3'b011: CIN = PCIN;
    3'b100: CIN = CARRYCASCOUT;
    3'b101: CIN = ~(P);
    3'b110: CIN = ROUND_OUT_MUX;
    3'b111: CIN = P;
	endcase
end

endmodule