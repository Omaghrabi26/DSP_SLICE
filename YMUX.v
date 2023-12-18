module Y_MUX (

  input  signed [47:0]    C, // Data output from C
  input  signed [42:0]    M, // Must select with OPMODE[3:2] = 01
  input         [3:0]     OP_MODE, // selector
  output reg    [47:0]    Y_MUX_OUT
  );

always@(*)
  begin
    casex(OP_MODE)
    
    4'b00xx: Y_MUX_OUT='b0;
    4'b0101: Y_MUX_OUT=M;
    4'b10xx: Y_MUX_OUT=48'hFFFFFFFFFFFF;
    4'b11xx: Y_MUX_OUT=C;

    default: Y_MUX_OUT='b0;

      endcase
  end
endmodule