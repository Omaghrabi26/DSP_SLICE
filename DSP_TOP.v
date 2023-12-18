module DSP_TOP #(parameter 

	AREG = 1,ACASCREG = 1, DREG = 1,ADREG = 1, USE_DPORT = 0,A_INPUT=0, 	//A_D_PREADDER 
	BREG=1,BCASCREG=1,B_INPUT=0, 	//B_DUAL
	INMODEREG=1,     // INmode reg
	CREG=1, 	//C_PORT
	MREG=1, 	//M_REG
	OPMODEREG=1, 	//OPMODE_REG
	CARRYINSELREG=1, 	//CARRY_REG
	CARRYINREG=1,
	ALUMODEREG=1,  	//ALUMODE_REG
	PREG=1,
	PATTERN_INPUT = 48'd0,
	MASK_INPUT = 48'd0,
	SEL_PATTERN = 1'b0, // default is C input as pattern
	SEL_MASK = 1'b1) 	// default mask: all zeros
( 
 //////////////////  CLK   ///////////////////
  input wire        CLK, 
          
 //////////////////  RST  /////////////////////
  input wire        RSTA,RSTB,RSTD,RSTC,RSTM,RSTP,RSTCTRL,
                    RSTALLCARRYIN,RSTALUMODE,RSTINMODE, 
                              
  //////////////////  CLKENABLE  /////////////////////
  input wire	    CEA1,CEA2,CEB1,CEB2,CEC,CED,CEM,CEP,CEAD,
  input wire        CEALUMODE,CECTRL,CECARRYIN,CEINMODE,
  
//////////////////input ports////////////////////
  input wire signed [29:0] A,
  input wire signed [17:0] B,
  input wire signed [47:0] C,
  input wire signed [24:0] D,

  input wire        [4:0]  INMODE,
  input wire        [6:0]  OPMODE,
  input wire        [3:0]  ALUMODE,

  input wire        [2:0]  CARRYINSEL,
  input wire               CARRYIN,

  input wire signed [29:0] ACIN,
  input wire signed [17:0] BCIN,
  input wire signed [47:0] PIN,
  input wire               CARRYCASCIN,MULTSIGNIN,
  
//////////////////output ports////////////////////
  output     signed [29:0] ACOUT, 
  output     signed [17:0] BCOUT,
  output     signed [47:0] PCOUT,
  output     signed [47:0] P,
  

  output                   CARRYOUT,
  output                   CARRYCASCOUT,
  output                   MULTSIGNOUT,
//  
//
  output                   PATTERN_DETECT,
  output                   PATTERNB_DETECT
//  output                   OVERFLOW,
//  output                   UNDERFLOW  
  );

wire        [3:0]  INMODE_W;
wire               INMODE1_W;
wire signed [29:0] XMUX_a_w;
wire signed [24:0] AMULT_w; 



wire signed [17:0] XMUX_B_w;
wire signed [17:0] BMULT_w;

wire signed [47:0] C_OUT_MUXS_IN;


wire signed [42:0] MULT_OUT_MUXS_IN;

wire [6:0]  MUXS_SEL_W;

wire signed [47:0] X_MUX_OUT_ALU_IN;

wire signed [47:0] Y_MUX_OUT_ALU_IN;
wire signed [47:0] Z_MUX_OUT_ALU_IN;

wire [2:0] CARRYIN_SEL_OUT_W;

wire       CIN_ALU;

wire [3:0]  ALU_MODE_OUT_w;

wire signed [47:0] P_ALU_OUT;

wire CARRYOUT_REG_IN;
wire CARRYCASCOUT_REG_IN;
wire PATTERN_DETECT_OUT;
wire PATTERNB_DETECT_OUT;
A_D_PREADDER #( .AREG(AREG),.ACASCREG(ACASCREG), 
	                     .DREG (DREG),.ADREG(ADREG), 
	                     .USE_DPORT(USE_DPORT),.A_INPUT(A_INPUT)) 
U0_A_D_PREADDER(
  .CLK(CLK),             
  .RSTA(RSTA),.RSTB(RSTB),.RSTD(RSTD),        
  .CEA1(CEA1),.CEA2(CEA2),.CED(CED),.CEAD(CEAD),
  
  .A(A),
  .ACIN(ACIN),
  .D(D),
  .INMODE(INMODE_W),
  .ACOUT(ACOUT),
  .XMUX(XMUX_a_w),
  .AMULT(AMULT_w)    
  );


Dual_B_Register #(.BREG(BREG),.BCASCREG(BCASCREG),.B_INPUT(B_INPUT))

U0_Dual_B_Register
(    
   .CLK(CLK),             
   .RSTB(RSTB),           
   .CEB1(CEB1),.CEB2(CEB2),
   .B(B), 
   .BCIN(BCIN),
   .INMODE(INMODE1_W),
    
    //input wire      B_INPUT,

   .BCOUT(BCOUT),
   .XMUX(XMUX_B_w),
   .BMULT(BMULT_w));

INMODE_REGISTER #(.INMODEREG(INMODEREG)) 
U0_INMODE_REGISTER
( 
   .CEINMODE(CEINMODE),.CLK(CLK),
   .RSTINMODE(RSTINMODE),
   .INMODE(INMODE),
   .INMODE_PRE_ADDER(INMODE_W),
   .INMODE_B_REGISTER(INMODE1_W)
  );

C_PORT  #(.CREG(CREG))
U0_C_PORT

(
    
    .CLK(CLK),             
    .RSTC(RSTC),           
    .CEC(CEC),
    .C(C),

    .C_OUT(C_OUT_MUXS_IN)
    );

Multiplier_out_reg #(.MREG(MREG))
U0_Multiplier_out_reg
(
    
    .CLK(CLK),             
    .RSTM(RSTM),           
    .CEM(CEM),
    
    .B(BMULT_w),
    .A_D(AMULT_w),

    .MULT_OUT(MULT_OUT_MUXS_IN)
    );

OPMODEREG_B #(.OPMODEREG(OPMODEREG))
U0_OPMODEREG_B
(
    
    .CLK(CLK),             
    .RSTCTRL(RSTCTRL),           
    .CECTRL(CECTRL),
    .OPMODE(OPMODE),

    .MUXS_SEL(MUXS_SEL_W)
    );


X_MUX U0_X_MUX(
    .A(XMUX_a_w), 
    .B(XMUX_B_w),
    .P(PCOUT), 
    .M(MULT_OUT_MUXS_IN),
    .OP_MODE(MUXS_SEL_W[3:0]), 
    .X_MUX_OUT(X_MUX_OUT_ALU_IN)
  );
Y_MUX U0_Y_MUX(

  .C(C_OUT_MUXS_IN), // Data output from C
  //.M(MULT_OUT_MUXS_IN), // Must select with OPMODE[3:2] = 01
  .M(43'b0),
  .OP_MODE(MUXS_SEL_W[3:0]), // selector
  .Y_MUX_OUT( Y_MUX_OUT_ALU_IN)
  );


Z_MUX U0_Z_MUX (

  .C(C_OUT_MUXS_IN), // Data output from C
  .PCIN(PIN),
  .P(P),
  
  .OP_MODE(MUXS_SEL_W), // selector
  .Z_MUX_OUT(Z_MUX_OUT_ALU_IN)
  );

CARRY_IN_SEL #(.CARRYINSELREG(CARRYINSELREG))

U0_CARRY_IN_SEL(
    
    .CLK(CLK),             
    .RSTCTRL(RSTCTRL),           
    .CECTRL(CECTRL),
    .CARRYINSEL(CARRYINSEL),

    .CARRYIN_SEL_OUT(CARRYIN_SEL_OUT_W)
 );


CARRY_IN #(.CARRYINREG(CARRYINREG),.MREG(MREG)) 
U0_CARRY_IN

	(  .CARRYIN(CARRYIN),
       .RSTALLCARRYIN(RSTALLCARRYIN),
       .CECARRYIN(CECARRYIN),
       .CLK(CLK),
       .CARRYCASCIN(CARRYCASCIN),
       .CARRYCASCOUT(CARRYCASCOUT),
   
       .A(A[24]),.B(B[17]),       //A[24],B[17]
       .CEM(CEM),
   
       .P(P[47]),
       .PCIN(PIN[47]),  //P[47],PCIN[47]

      .CARRYINSEL(CARRYIN_SEL_OUT_W),

      .CIN(CIN_ALU)
	);


ALUMODEREG_B #(.ALUMODEREG(ALUMODEREG))

U0_ALUMODEREG_B(
    
     .CLK(CLK),             
     .RSTALUMODE(RSTALUMODE),           
     .CEALUMODE(CEALUMODE),
     .ALUMODE(ALUMODE),

     .ALU_MODE_OUT(ALU_MODE_OUT_w)
    );


ALU_BLOCK U0_ALU_BLOCK(
   .X(X_MUX_OUT_ALU_IN),
   .Y(Y_MUX_OUT_ALU_IN),
   .Z(Z_MUX_OUT_ALU_IN),

   .CARRYIN(CIN_ALU),

   .ALUMODE_SEL(ALU_MODE_OUT_w),
   .OPMODE(MUXS_SEL_W[3:0]),           //opmode 3,2 bit

   .MULTSIGNIN(MULTSIGNIN),

   .MULTSIGOUT(MULTSIGNOUT),


   .P_OUT(P_ALU_OUT),
   .CARRYCASCOUT(CARRYCASCOUT_REG_IN),
   .CARRYOUT(CARRYOUT_REG_IN) 
     );
     
P_OUT_REG #(.PREG(PREG))
U0_P_OUT_REG(
    .CLK(CLK),             
    .RSTP(RSTP),           
    .CEP(CEP),
    .P_IN(P_ALU_OUT),
    .P_OUT(P),
    .PC_OUT(PCOUT)
    );
    
PCOUT_REG #(.PREG(PREG))
U1_P_COUT_REG(
    .CLK(CLK),             
    .RSTP(RSTP),           
    .CEP(CEP),
    .P_COUT_IN(CARRYOUT_REG_IN),
    .P_COUT(CARRYOUT)
    );

PCOUT_REG #(.PREG(PREG))
U2_P_COUT_REG(
    .CLK(CLK),             
    .RSTP(RSTP),           
    .CEP(CEP),
    .P_COUT_IN(CARRYCASCOUT_REG_IN),
    .P_COUT(CARRYCASCOUT)
    );
    
PATTERN_DETECT #(.pattern_input(PATTERN_INPUT),.mask_input(MASK_INPUT)) U3
(
.P(P_ALU_OUT),
.C(C_OUT_MUXS_IN),
.SEL_PATTERN(SEL_PATTERN),
.SEL_MASK(SEL_MASK),
.PATTERN_DETECT(PATTERN_DETECT_OUT), 
.PATTERNB_DETECT(PATTERNB_DETECT_OUT)
);

//registering output of pattern detect
 PATTERN_DETECT_REG #(.PREG(PREG))
U1_PATTERN_DETECT_REG(
    .CLK(CLK),             
    .RSTP(RSTP),           
    .CEP(CEP),
    .P_IN(PATTERN_DETECT_OUT),
    .P_OUT(PATTERN_DETECT)
    ); 
    
 PATTERN_DETECT_REG #(.PREG(PREG))
U2_PATTERN_DETECT_REG(
    .CLK(CLK),             
    .RSTP(RSTP),           
    .CEP(CEP),
    .P_IN(PATTERNB_DETECT_OUT),
    .P_OUT(PATTERNB_DETECT)
    );       
endmodule