module A_D_PREADDER #(parameter AREG = 1,ACASCREG = 1, DREG = 1,ADREG = 1, USE_DPORT = 1,A_INPUT=0) (
  input wire        CLK,             
  input wire        RSTA,RSTB,RSTD,           
  input wire		    CEA1,CEA2,CED,CEAD,
  //input wire        A_INPUT,
  input wire signed [29:0] A,
  input wire signed [29:0] ACIN,
  input wire signed [24:0] D,
  input wire        [3:0]  INMODE,
  output     signed [29:0] ACOUT,
  output     signed [29:0] XMUX,
  output     signed [24:0] AMULT    
  );
//------------------------------- Path 1-------------------------------//

///////////////// CLOCKS GENERATED FROM GATED CLOCK /////////////////////
wire CLK_A1;
wire CLK_A2;
wire CLK_D;
wire CLK_AD;

///////////////// OUTPUTS OF REGISTERS /////////////////////
reg [29:0]  A1_REG;
reg [29:0]  A2_REG;
reg [24:0]  D_REG;
reg [24:0]  AD_REG;

///////////////// OUTPUTS OF MUXES /////////////////////

wire [29:0] MUX_OUT_A_IN;  // output of mux after a and acin
wire [29:0] MUX_A1_BYPASS; // output of mux after A1 
//MUX_A2_BYPASS = XMUX     // output of mux after A2
wire [24:0] MUX_D_BYPASS;  // output of mux after D
wire [24:0] MUX_AD_BYPASS; // output of mux after AD


///////////////// Internal Signals /////////////////////  
wire [29:0] AND_INPUT;     
wire [24:0] PRE_AMULT;


wire [24:0] AND_OUT;
reg  [24:0] AD_INPUT;

reg SEL_A1,SEL_A2,SEL_ACOUT;



CLK_GATE G1 (.CLK_EN(CEA1),
             .CLK(CLK),
             .GATED_CLK(CLK_A1));

CLK_GATE G2 (.CLK_EN(CEA2),
             .CLK(CLK),
             .GATED_CLK(CLK_A2));

CLK_GATE G3 (.CLK_EN(CED),
             .CLK(CLK),
             .GATED_CLK(CLK_D));
             
CLK_GATE G4 (.CLK_EN(CEAD),
             .CLK(CLK),
             .GATED_CLK(CLK_AD));             




assign MUX_OUT_A_IN = (A_INPUT)? ACIN:A  ;            //NOT SURE OF THE SELECTOR..

 
////////////A1/////////////
always @ (posedge CLK_A1)
begin
	if (RSTA)
	begin
	A1_REG<='b0;
	end
	else begin
	A1_REG<=MUX_OUT_A_IN;
	end
end

always@(*)
begin
case(AREG)
     0:begin
       SEL_A1='b0;
       SEL_A2='b0;
       end


     1:begin
       SEL_A1='b0;
       SEL_A2='b1;
       end


     2:begin
       SEL_A1='b1;
       SEL_A2='b1;
       end

     default:begin
       SEL_A1='b0;
       SEL_A2='b1;
       end
endcase
end


always@(*)
begin
if ((ACASCREG==1)&&(AREG==2))
	SEL_ACOUT=0;
else
    SEL_ACOUT=1;
end

assign MUX_A1_BYPASS = (SEL_A1)?A1_REG:MUX_OUT_A_IN;
assign XMUX          = (SEL_A2)?A2_REG:MUX_A1_BYPASS;
assign ACOUT         =(SEL_ACOUT)? XMUX:A1_REG;

assign AND_INPUT     =(INMODE[0])? A1_REG:XMUX;

assign PRE_AMULT = ~INMODE[1] & AND_INPUT;



///////////	 A2////////////
always @ (posedge CLK_A2)
begin
	if (RSTA)
	begin
	A2_REG<='b0;
	end
	else begin
	A2_REG<=MUX_A1_BYPASS;
	end
end
//----------------------PATH 2-----------------------------//
always @ (posedge CLK_D)
begin
	if (RSTD)
	begin
	D_REG<='b0;
	end
	else begin
	D_REG<= D;
	end
end

assign MUX_D_BYPASS = (DREG)?D_REG:D;
assign AND_OUT = MUX_D_BYPASS & INMODE[2];


always@(*)
  begin
    if(INMODE[3])
      AD_INPUT = PRE_AMULT - AND_OUT;
    else
      AD_INPUT = PRE_AMULT + AND_OUT;
  end
  
always @ (posedge CLK_AD)
begin
	if (RSTD)
	begin
	AD_REG<='b0;
	end
	else begin
	AD_REG<= AD_INPUT;
	end
end  

assign MUX_AD_BYPASS = (ADREG) ? AD_REG : AD_INPUT;
assign AMULT = (USE_DPORT)? MUX_AD_BYPASS : PRE_AMULT;

endmodule

