module Z_MUX (

  input       signed  [47:0]    C, // Data output from C
  input       signed  [47:0]    PCIN,
  input       signed  [47:0]    P,
  
  input               [6:0]     OP_MODE, // selector
  output reg  signed  [47:0]    Z_MUX_OUT
  );

always@(*)
  begin
    casex(OP_MODE)
    
    7'b000_xx_xx: Z_MUX_OUT='b0;
    7'b001_xx_xx: Z_MUX_OUT=PCIN;
    7'b010_xx_xx: Z_MUX_OUT=P;
    7'b011_xx_xx: Z_MUX_OUT=C;
    7'b100_10_00: Z_MUX_OUT=P;
    7'b101_xx_xx: Z_MUX_OUT=PCIN>>17;
    7'b110_xx_xx: Z_MUX_OUT=P>>17;

    default:      Z_MUX_OUT='b0;

      endcase
  end
endmodule