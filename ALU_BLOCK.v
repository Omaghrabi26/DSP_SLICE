module ALU_BLOCK (
	input  wire signed [47:0]     X,
	input  wire signed [47:0]     Y,
	input  wire signed [47:0]     Z,

	input  wire            CARRYIN,

	input  wire [3:0]      ALUMODE_SEL,
	input  wire [3:0]      OPMODE,           //opmode 3,2 bit

	input  wire            MULTSIGNIN,

     output wire            MULTSIGOUT,


	output reg [47:0]       P_OUT,
	output wire             CARRYCASCOUT,
  output wire              CARRYOUT 
     );

//reg [48:0] P;    //{CARRY_OUT,P}
assign MULTSIGOUT = (OPMODE==4'b0101)? P_OUT[47]:1'bx;
//reg [47:0] P_OUT;

reg  [3:0]      CARRY_OUT;

assign CARRYOUT =     CARRY_OUT[3];
assign CARRYCASCOUT = CARRY_OUT[3];

always@(*)
begin
      CARRY_OUT=0;
      P_OUT=0;
	case(ALUMODE_SEL)
     4'b0000: begin
                    {CARRY_OUT,P_OUT}=  (Z+X+Y+CARRYIN);
  
               end     
  
     4'b0011: begin
                    {CARRY_OUT,P_OUT}=  (Z-(X+Y+CARRYIN));
  
               end     
  
     4'b0001: begin 
                    {CARRY_OUT,P_OUT}= ~(Z)+(X+Y+CARRYIN);
  
               end     
  
     4'b0010: begin
                    {CARRY_OUT,P_OUT}= ~(Z+X+Y+CARRYIN);
  
               end     
  


     4'b0100:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT=   X^Z; 
                else if (OPMODE[3:2]==2'b10)     P_OUT= ~(X^Z);
                else                        P_OUT='D0;
             end 
     			
     4'b0101:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT= ~(X^Z);
                else if (OPMODE[3:2]==2'b10)     P_OUT=   X^Z; 
                else                        P_OUT='D0;
             end  

     4'b0110:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT= ~(X^Z);
                else if (OPMODE[3:2]==2'b10)     P_OUT=   X^Z; 
                else                        P_OUT='D0;
             end  

     4'b0111:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT=   X^Z; 
                else if (OPMODE[3:2]==2'b10)     P_OUT= ~(X^Z);
                else                        P_OUT='D0;
             end 
     4'b1100:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT=   X&Z;
                else if (OPMODE[3:2]==2'b10)     P_OUT=   X|Z;
                else                        P_OUT='D0;
             end  

     4'b1101:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT=   X& ~(Z);
                else if (OPMODE[3:2]==2'b10)     P_OUT=   X| ~(Z);
                else                        P_OUT='D0;
             end  
     4'b1110:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT=  ~ (X&Z);
                else if (OPMODE[3:2]==2'b10)     P_OUT=  ~ (X|Z);
                else                             P_OUT='D0;
             end  
     4'b1111:begin
     	      if      (OPMODE[3:2]==2'b00)     P_OUT=  ~ (X)|Z;
                else if (OPMODE[3:2]==2'b10)     P_OUT=  ~ (X)&Z;
                else                        P_OUT='D0;
             end 
     default:begin
             CARRY_OUT=0;
             P_OUT=0;
             end
	endcase

end




endmodule