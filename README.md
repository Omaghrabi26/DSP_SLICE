# DSP_SLICE
Implementation of DSP Slice

-Design

In this design we covered most of the features of the 7 series FPGA DSP48E1 slice.

FPGAs are efficient for digital signal processing (DSP) applications because they can implement custom, fully parallel algorithms. DSP applications use many binary multipliers and accumulators that are best implemented in dedicated DSP slices. All 7 series FPGAs have many dedicated, full-custom, low-power DSP slices, combining high speed with small size while retaining system design flexibility. 
Some highlights of the DSP functionality include:

• 25 × 18 two’s-complement multiplier

• 48-bit accumulator

• Power saving pre-adder

• Optimizes symmetrical filter applications and reduces DSP slice requirements

• Single-instruction-multiple-data (SIMD) arithmetic unit

• Optional logic unit

• Pattern detector

• Advanced features:  Optional pipelining and dedicated buses for cascading

 -Test Plan
 
  In the testbench we used the default attributes values specified by the user guide.
  All inputs pass by one register only (default value is 1 register)
  The Testbench covers the following cases:
  A.    Addition

  B.    Multiplication

  C.    Signed Multiplication
 
  D.    Logic Operations

  E.    Pattern Detection

  Each Operation in the DSP Slice is controlled by the following input control signals. 

   - OPMODE: specifies output of the 3 muxes (X,Y and Z)

   - ALUMODE: specifies the ALU operations (Arithmetic or Logic)

  In each test case we call a task that configures the required control signals according to the tested mode (Add/Subtract, Logic Operation)
