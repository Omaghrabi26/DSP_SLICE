module Dual_B_Register #(parameter BREG=1,BCASCREG=1,B_INPUT=0)(
    
    input wire                CLK,             
    input wire                RSTB,           
    input wire                CEB1,CEB2,
    input wire  signed [17:0] B, 
    input wire  signed [17:0] BCIN,
    input wire                INMODE,
    
    //input wire      B_INPUT,

    output wire signed  [17:0] BCOUT,
    output wire signed  [17:0] XMUX,
    output wire signed  [17:0] BMULT
  
  );


wire CLK_B1;
wire CLK_B2;


wire [17:0] MUX_B1_BYPASS;



reg SEL_B1,SEL_B2,SEL_BCOUT;
//wire [17:0] MUX_B2_BYPASS;
/////////////////
reg [17:0]  B1_REG;
reg [17:0]  B2_REG;


CLK_GATE B1 (.CLK_EN(CEB1),
             .CLK(CLK),
             .GATED_CLK(CLK_B1));

CLK_GATE B2 (.CLK_EN(CEB2),
             .CLK(CLK),
             .GATED_CLK(CLK_B2));




wire [17:0] MUX_OUT_B_IN;

assign MUX_OUT_B_IN = (B_INPUT)? BCIN:B  ;            //NOT SURE OF THE SELECTOR.. 
////////////B1/////////////
always @ (posedge CLK_B1)
begin
  if (RSTB)
  begin
  B1_REG<='b0;
  end
  else begin
  B1_REG<=MUX_OUT_B_IN;
  end
end

always@(*)
begin
case(BREG)
     0:begin
       SEL_B1='b0;
       SEL_B2='b0;
       end


     1:begin
       SEL_B1='b0;
       SEL_B2='b1;
       end


     2:begin
       SEL_B1='b1;
       SEL_B2='b1;
       end

     default:begin
       SEL_B1='b0;
       SEL_B2='b1;
       end
endcase
end


always@(*)
begin
if ((BCASCREG==1)&&(BREG==2))
  SEL_BCOUT=0;
else
    SEL_BCOUT=1;
/*
if((BCASCREG==1)&&(BREG==1))
  SEL_BCOUT=1;

else if ((BCASCREG==1)&&(BREG==2))
  SEL_BCOUT=0;
 
else if ((BCASCREG==1)or(BCASCREG==2))
  SEL_BCOUT=1;
*/
end
/*

case(BCASCREG)
     0:begin
       SEL_BCOUT='b1;
  
       end
 // BCASC=1 AND BREG =1 SEL=1

     1:begin
       SEL_BCOUT='b0;
       end
//SEL=0, BREG=2 AND BCASC=1;

     2:begin
       SEL_BCOUT='b1;
   

//SEL=1, BCASC=2 OR 0
       end

     default:SEL_BCOUT='b0;
   
endcase

end
*/
assign MUX_B1_BYPASS = (SEL_B1)?B1_REG:MUX_OUT_B_IN;
assign XMUX          = (SEL_B2)?B2_REG:MUX_B1_BYPASS;

assign BMULT         =(INMODE)? B1_REG:XMUX;
assign BCOUT         =(SEL_BCOUT)? XMUX:B1_REG;





///////////  B2////////////
always @ (posedge CLK_B2)
begin
  if (RSTB)
  begin
  B2_REG<='b0;
  end
  else begin
  B2_REG<=MUX_B1_BYPASS;
  end
end


endmodule
