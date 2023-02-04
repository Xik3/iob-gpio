`timescale 1ns/1ps

`include "iob_lib.vh"
`include "iob_gpio_swreg_def.vh"


module iob_gpio_core
  (
   
   input      clk,
   input      sensor, // Data input
   input      enable,
   input      [32-1:0] rst,
   output reg  Q
   );

   wire       OUT_OR;   
   wire       OUT_NOT;   
   wire       D;   
   

   assign OUT_OR = sensor | Q;   
   assign OUT_NOT = rst;
   assign D = OUT_OR & OUT_NOT;

  `IOB_REG_E(clk, enable, Q, D) 
  //`IOB_REG_RE(clk, r,0 ,enable,Q, D) 
     
endmodule // iob_gpio_core

   
