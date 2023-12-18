module PATTER_DETECT_TB #(parameter pattern_input = 48'd2) ();
  
  reg [47:0]      P_tb;
  reg [47:0]      C_tb;
  reg             SEL_PATTERN_tb,SEL_MASK_tb;
  wire       PATTERN_DETECT_tb; //PATTERNDETECT output goes High if P matches a set pattern
  wire       PATTERNB_DETECT_tb; // PATTERNB_DETECT goes high if P matches the complement of the set pattern.



initial 
begin
  SEL_PATTERN_tb = 1'b1; //choose the input pattern
  SEL_MASK_tb = 1'b1; // choose default mask is all zeros
  
  P_tb = 48'd2;
  #10
  if(PATTERN_DETECT_tb == 1)
    $display("Pattern Detected");
  else
    $display("Pattern Not Detected");
    
  #10
  $stop;  
end

PATTERN_DETECT #(.pattern_input(pattern_input)) DUT
(
.P(P_tb),
.C(C_tb),
.SEL_PATTERN(SEL_PATTERN_tb),
.SEL_MASK(SEL_MASK_tb),
.PATTERN_DETECT(PATTERN_DETECT_tb), 
.PATTERNB_DETECT(PATTERNB_DETECT_tb)
);
endmodule