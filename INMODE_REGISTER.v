module INMODE_REGISTER #(parameter INMODEREG=1) 

( 
  input   wire        CEINMODE,CLK,
  input   wire        RSTINMODE,
  input   wire  [4:0]  INMODE,
  output  wire  [3:0]  INMODE_PRE_ADDER,
  output  wire         INMODE_B_REGISTER
  );
  

  reg  [3:0]  INMODE_PRE_ADDER_REG;
  reg         INMODE_B_REGISTER_REG;
  wire  CLK_INMODE;





  CLK_GATE R1 (.CLK_EN(CEINMODE),
             .CLK(CLK),
             .GATED_CLK(CLK_INMODE));
             
 

  always@(posedge CLK_INMODE)
    begin
      if(RSTINMODE)
        begin
          INMODE_PRE_ADDER_REG <= 'b0;
          INMODE_B_REGISTER_REG <= 'b0;
        end
      else
        begin
          INMODE_PRE_ADDER_REG <= INMODE[3:0];
          INMODE_B_REGISTER_REG <= INMODE[4];
        end    
    end

assign INMODE_PRE_ADDER  =(INMODEREG)?  INMODE_PRE_ADDER_REG :INMODE[3:0];
assign INMODE_B_REGISTER =(INMODEREG)?  INMODE_B_REGISTER_REG:INMODE[4];


endmodule