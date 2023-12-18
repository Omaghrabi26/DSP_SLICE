`timescale 1ns/1ps
module DSP_TOP_TB ();
  
/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter CLK_PER = 10;    // 100 MHz

/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg CLK_tb;        

reg        RSTA_tb,RSTB_tb,RSTD_tb,RSTC_tb,RSTM_tb,RSTP_tb,RSTCTRL_tb;
reg        RSTALLCARRYIN_tb,RSTALUMODE_tb,RSTINMODE_tb;                           //////////////////  RST  /////////////////////   

reg	       CEA1_tb,CEA2_tb,CEB1_tb,CEB2_tb,CEC_tb,CED_tb,CEM_tb,CEP_tb,CEAD_tb;      //////////////////  CLK ENABLE  /////////////////////
reg        CEALUMODE_tb,CECTRL_tb,CECARRYIN_tb,CEINMODE_tb;
  
//////////////////input ports////////////////////
reg signed [29:0] A_tb;
reg signed [17:0] B_tb;
reg signed [47:0] C_tb;
reg signed [24:0] D_tb;

reg        [4:0]  INMODE_tb;
reg        [6:0]  OPMODE_tb;
reg        [3:0]  ALUMODE_tb;

reg        [2:0]  CARRYINSEL_tb;
reg               CARRYIN_tb;

reg signed [29:0] ACIN_tb;
reg signed [17:0] BCIN_tb;
reg signed [47:0] PIN_tb;
reg               CARRYCASCIN_tb,MULTSIGNIN_tb;

//////////////////output ports////////////////////
wire     signed [29:0] ACOUT_tb; 
wire     signed [17:0] BCOUT_tb;
wire     signed [47:0] PCOUT_tb;
wire     signed [47:0] P_tb;


wire                   CARRYOUT_tb;
wire                   CARRYCASCOUT_tb;
wire                   MULTSIGNOUT_tb;

wire                   PATTERN_DETECT_tb;
wire                   PATTERNB_DETECT_tb;


 

//////////////////////////////////////////////////////// 
///////////////////// Clock Generator //////////////////
////////////////////////////////////////////////////////


  always #(CLK_PER/2) CLK_tb = ~CLK_tb ;



////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial
 begin

 // Initialization
 initialize() ;

 // Reset
 reset() ; 
 
  //                      --------------Default: reg = 1---------
 
 // Test Case 1: ------------------>> Addition (A:B + C) <<-----------------------

 
 $display("------Test Case 1-----");
 A_tb = 2; //30 bits
 B_tb = 3; //18 bits
 C_tb = 4; //48 bits
 
 Addition_Configurations();
 
 #(3*CLK_PER)
 if(P_tb ==  ({A_tb, B_tb} + C_tb) )
   $display("Addition Test Passed");
 else
   $display("Addition Test Failed");



// Test Case 2: ------------------>> Multiplication (A*B) <<-----------------------

 
  $display("------Test Case 2-----");
 A_tb = 2; //30 bits: 000000000000000000000000000010 
 B_tb = 3; //18 bits: 000000000000000011
 
 Multiplication_Configurations();
 
 #(4*CLK_PER)
 if(P_tb ==  (A_tb*B_tb))
   $display("Multiplication Test Passed");
 else
   $display("Multipllication Test Failed");

// Test Case 3: ------------------>> Signed Multiplication Operations (A*B) <<-----------------------

 
  $display("------Test Case 3-----");
 A_tb = -2; //30 bits 
 B_tb = -4; //18 bits
 
Multiplication_Configurations();
 
 #(4*CLK_PER)
 if(P_tb ==  (A_tb*B_tb))
   $display("Signed Multiplication Test Passed");
 else
   $display("Signed Multipllication Test Failed");
   
// Test Case 4: ------------------>> Signed Multiplication Case 2 Operations ((-A)*B) <<-----------------------

 
   $display("------Test Case 4-----");
 A_tb = -2; //30 bits 
 B_tb = 4; //18 bits
 
Multiplication_Configurations();

 
 #(4*CLK_PER)
 if(P_tb ==  (A_tb*B_tb))
   $display("Signed Multiplication Test Passed");
 else
   $display("Signed Multipllication Test Failed");   

// Test Case 5: ------------------>> Logic Operations  <<-----------------------

 
   $display("------Test Case 5-----");
 A_tb = 2; //30 bits 
 B_tb = 4; //18 bits
 C_tb = 7;
 
 Logic_Configurations();
 
 #(3*CLK_PER)
 if(P_tb ==  ({A_tb,B_tb} ^ C_tb))
   $display("XOR Test Passed");
 else
   $display("XOR Test Failed");
   
// Test Case 6: ------------------>> Pattern Detector  <<-----------------------

 
   $display("------Test Case 6-----");
 // Default configurations are 
 //>>pattern : pattern is c (pattern_sel = 0)
 //>>mask : all zeros (mask_sel = 1)
 
 // TEST: Compare between output of alu {A,B} and input pattern c, and mask is zero

   
 A_tb = 2; //30 bits 
 B_tb = 4; //18 bits
 C_tb = {A_tb,B_tb}; // input pattern

OPMODE_tb = 'b0000011;
CARRYIN_tb = 'b0;
CARRYINSEL_tb = 'b000; 
ALUMODE_tb = 4'b0000;
 
 #(3*CLK_PER)
 if(PATTERN_DETECT_tb == 1)
   $display("Pattern is Detected");
 else
   $display("Pattern is not Detected"); 
   
#(10*(CLK_PER))
$stop;
end

////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
  begin
	CLK_tb            = 1'b0;
	
	// Initiallizing all reset values
	RSTA_tb='b0; RSTB_tb='b0; RSTD_tb='b0; RSTC_tb='b0;
	RSTM_tb='b0; RSTP_tb='b0; RSTCTRL_tb='b0;
  RSTALLCARRYIN_tb='b0; RSTALUMODE_tb='b0; RSTINMODE_tb='b0;

  // Initializing all clock enables
  CEA1_tb='b0; CEA2_tb='b0; CEB1_tb='b0; CEB2_tb='b0; CEC_tb='b0; CED_tb='b0; CEM_tb='b0;
  CEP_tb='b0; CEAD_tb='b0; CEALUMODE_tb='b0; CECTRL_tb='b0; CECARRYIN_tb='b0; CEINMODE_tb='b0;
  
  // Initializing Input Signals
  A_tb              ='d0;
  B_tb              ='d0;
  C_tb              ='d0;
  D_tb              ='d0;
  
  INMODE_tb         ='d0;
  OPMODE_tb         ='d0;
  ALUMODE_tb        ='d0;
  
  CARRYINSEL_tb     ='d0;
  CARRYIN_tb        ='d0;
  
  ACIN_tb           ='d0;
  BCIN_tb           ='d0;
  PIN_tb            ='d0;
  CARRYCASCIN_tb    ='b0;
  MULTSIGNIN_tb     ='d0;
  end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
  begin
	#(CLK_PER)
  RSTA_tb             = 'b1;
  RSTB_tb             = 'b1;
  RSTD_tb             = 'b1;
  RSTC_tb             = 'b1;
  RSTM_tb             = 'b1;
  RSTP_tb             = 'b1;
  RSTCTRL_tb          = 'b1;
  RSTALLCARRYIN_tb    = 'b1;
  RSTALUMODE_tb       = 'b1;
  RSTINMODE_tb        = 'b1;           // rst is activated
  
	#(CLK_PER)
  RSTA_tb             = 'b0;
  RSTB_tb             = 'b0;
  RSTD_tb             = 'b0;
  RSTC_tb             = 'b0;
  RSTM_tb             = 'b0;
  RSTP_tb             = 'b0;
  RSTCTRL_tb          = 'b0;
  RSTALLCARRYIN_tb    = 'b0;
  RSTALUMODE_tb       = 'b0;
  RSTINMODE_tb        = 'b0;           // rst is deactivated
  
	#(CLK_PER) ;
  end
endtask

///////////////////////// Addition Configurations /////////////////////////
task Addition_Configurations();
  begin

 CARRYIN_tb = 'b0;
 CARRYINSEL_tb = 'b000; 
 ALUMODE_tb = 4'b0000;
 OPMODE_tb = 7'bxxx1111 ;
 
 // Enable Clocks of needed registers
CEA2_tb='b1;  CEB2_tb='b1; CEC_tb='b1; CEA1_tb = 'b1;CEB1_tb = 'b1;
CEP_tb='b1; 
CEALUMODE_tb='b1; 
CECARRYIN_tb='b1; 
CEINMODE_tb='b1;
CECTRL_tb='b1;


 
  end
endtask

///////////////////////// Multiplication Configurations /////////////////////////
task Multiplication_Configurations();
  begin

 ALUMODE_tb = 4'b0000;
 OPMODE_tb = 7'bxxx0101 ;
 
 // Enable Clocks of needed registers
CEA2_tb='b1;  CEB2_tb='b1; CEC_tb='b0; 
CEM_tb='b1;
CEP_tb='b1; CEALUMODE_tb='b1; CECTRL_tb='b1; CECARRYIN_tb='b1; CEINMODE_tb='b1;
CEA1_tb = 'b1;CEB1_tb = 'b1;

 
  end
endtask


///////////////////////// Logic Configurations /////////////////////////
task Logic_Configurations();
  begin
ALUMODE_tb = 4'b0100;
 OPMODE_tb = 7'b0110011;
 
 // Enable Clocks of needed registers
 // task multiplication configurations
CEA2_tb='b1;  CEB2_tb='b1; CEC_tb='b1; 
CEM_tb='b1;
CEP_tb='b1; CEALUMODE_tb='b1; CECTRL_tb='b1; CECARRYIN_tb='b1; CEINMODE_tb='b1;
CEA1_tb = 'b1;CEB1_tb = 'b1;

 

 
  end
endtask

//////////////////////////////////////////////////////// 
///////////////// Design Instaniation //////////////////
////////////////////////////////////////////////////////

DSP_TOP U0 (

.CLK(CLK_tb),      //////////////////  CLK   ///////////////////    

.RSTA(RSTA_tb),
.RSTB(RSTB_tb),
.RSTD(RSTD_tb),
.RSTC(RSTC_tb),
.RSTM(RSTM_tb),
.RSTP(RSTP_tb),
.RSTCTRL(RSTCTRL_tb),
.RSTALLCARRYIN(RSTCTRL_tb),
.RSTALUMODE(RSTALUMODE_tb),
.RSTINMODE(RSTINMODE_tb),         //////////////////  RST  /////////////////////   

.CEA1(CEA1_tb),
.CEA2(CEA2_tb),
.CEB1(CEB1_tb),
.CEB2(CEB2_tb),
.CEC(CEC_tb),
.CED(CED_tb),
.CEM(CEM_tb),
.CEP(CEP_tb),
.CEAD(CEAD_tb),      //////////////////  CLKENABLE  /////////////////////
.CEALUMODE(CEALUMODE_tb),
.CECTRL(CECTRL_tb),
.CECARRYIN(CECARRYIN_tb),
.CEINMODE(CEINMODE_tb),
  
//////////////////input ports////////////////////
.A(A_tb),
.B(B_tb),
.C(C_tb),
.D(D_tb),

.INMODE(INMODE_tb),
.OPMODE(OPMODE_tb),
.ALUMODE(ALUMODE_tb),

.CARRYINSEL(CARRYINSEL_tb),
.CARRYIN(CARRYIN_tb),

.ACIN(ACIN_tb),
.BCIN(BCIN_tb),
.PIN(PIN_tb),
.CARRYCASCIN(CARRYCASCIN_tb),
.MULTSIGNIN(MULTSIGNIN_tb),
  
//////////////////output ports////////////////////
.ACOUT(ACOUT_tb), 
.BCOUT(BCOUT_tb),
.PCOUT(PCOUT_tb),
.P(P_tb),
  

.CARRYOUT(CARRYOUT_tb),
.CARRYCASCOUT(CARRYCASCOUT_tb),
.MULTSIGNOUT(MULTSIGNOUT_tb),
.PATTERN_DETECT(PATTERN_DETECT_tb),
.PATTERNB_DETECT(PATTERNB_DETECT_tb)  
);
endmodule