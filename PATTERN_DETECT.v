// detects if the P bus matches a
//specified pattern or if it exactly matches the complement of the pattern
module PATTERN_DETECT #(parameter mask_input = 48'b0, pattern_input = 48'b0)
  (
  input signed [47:0]      P,
  //input [47:0] MASK, //1 in mask = ignore  //A mask field can be used to hide certain bit locations in the pattern detector. 
  //input [47:0] PATTERN,
  input signed [47:0]      C,
  input             SEL_PATTERN,SEL_MASK,
  output wire       PATTERN_DETECT, //PATTERNDETECT output goes High if P matches a set pattern
  output wire       PATTERNB_DETECT // PATTERNB_DETECT goes high if P matches the complement of the set pattern.
  );

wire [47:0] PATTERN;
wire [47:0] MASK;


//PATTERNDETECT computes ((P == pattern)||mask) on a bitwise basis and then ANDs the
//results to a single output bit.

assign PATTERN_DETECT = &(P == PATTERN || MASK);



assign PATTERNB_DETECT= &((P == ~PATTERN)||MASK);



// Pattern can be C input or specific input pattern

assign PATTERN = (SEL_PATTERN)? pattern_input: C ; //SEL PATTERN = 1 >> pattern, SEL PATTERN = 0 >> C


// mux to select the mask (mask or c)
assign MASK = (SEL_MASK)? mask_input: C; //SEL MASK = 1 >> Mask, SEL MASK = 0 >> C


endmodule
