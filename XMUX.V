module X_MUX (
  input                [29:0]    A, // A and B are concatanted to form 48-bit input 
  input                [17:0]    B,
  input                [47:0]    P, // Data output from second stage adder/subtracter or logic function ,Must select with PREG = 1
  input      signed    [42:0]    M, // Must select with OPMODE[3:2] = 01
  input                [3:0]     OP_MODE, // selector
  output reg signed    [47:0]    X_MUX_OUT
  );

always@(*)
  begin
    casex(OP_MODE)


    4'bxx00: X_MUX_OUT='b0;
    4'b0101: X_MUX_OUT=/*$signed*/M;
    4'bxx10: X_MUX_OUT=P;
    4'bxx11: X_MUX_OUT={A,B};
    default: X_MUX_OUT='b0;
      endcase
  end
endmodule