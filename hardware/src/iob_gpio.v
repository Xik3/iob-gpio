 `timescale 1ns/1ps

`include "iob_lib.vh"
`include "iob_gpio_swreg_def.vh"

module iob_gpio 
  # (
     parameter GPIO_W = 32, //PARAM Number of GPIO (can be up to DATA_W)
     parameter DATA_W = 32, //PARAM CPU data width
     parameter ADDR_W = `iob_gpio_swreg_ADDR_W //MACRO CPU address section width
     )
   (

   //CPU interface
`include "iob_s_if.vh" 

    // inputs and outputs have dedicated interface
    input [GPIO_W-1:0] gpio_input, 
 
    output [GPIO_W-1:0] gpio_output,
    // output enable can be used to tristate outputs on external module
    output [GPIO_W-1:0] gpio_output_enable,

    input [1:0] SENSOR_IN,
    //input GPIO_OUTPUT_SENSOR_READ,
    output GPIO_SENSOR_OUTPUT_I,
    output GPIO_SENSOR_OUTPUT_O,
   // output OUT_FF,
    

`include "iob_gen_if.vh"
    );

//BLOCK Register File & Configuration control and status register file.
`include "iob_gpio_swreg_gen.vh"

   //`IOB_REG_AR(CLK, RST, RST_VAL, NAME, (NAME==(MOD-1)? 1'b0: NAME+1'b1))

    // SWRegs
    `IOB_WIRE(GPIO_OUTPUT_ENABLE, DATA_W)
    iob_reg #(.DATA_W(DATA_W))
    gpio_output_enable_reg (
        .clk        (clk),
        .arst       (rst),
        .rst        (rst),
        .en         (GPIO_OUTPUT_ENABLE_en),
        .data_in    (GPIO_OUTPUT_ENABLE_wdata),
        .data_out   (GPIO_OUTPUT_ENABLE)
    );

    `IOB_WIRE(GPIO_OUTPUT, DATA_W)
    iob_reg #(.DATA_W(DATA_W))
    gpio_output_reg      (
        .clk        (clk),
        .arst       (rst),
        .rst        (rst),
        .en         (GPIO_OUTPUT_en),
        .data_in    (GPIO_OUTPUT_wdata),
        .data_out   (GPIO_OUTPUT)
    );
   `IOB_VAR(RST_SENSOR, DATA_W)
   `IOB_VAR(COUNTER_OUT, DATA_W)
   `IOB_WIRE(SENSOR_OUTPUT_I, 1)
   `IOB_WIRE(SENSOR_OUTPUT_O, 1)
   iob_gpio_core iob_gpio_core0 (
      .clk         (clk),
      .sensor      (SENSOR_IN[0]),
      .enable      (gpio_input[0]),
      .rst         (RST_SENSOR),
      .Q           (SENSOR_OUTPUT_I)
      );

   iob_gpio_core iob_gpio_core1 (
      .clk         (clk),
      .sensor      (SENSOR_IN[1]),
      .enable      (gpio_input[0]),
      .rst         (RST_SENSOR),
      .Q           (SENSOR_OUTPUT_O)
      );


   `IOB_MODCNT_AR(clk, rst, 0, COUNTER_OUT, 500000)
   
   
   assign RST_SENSOR = COUNTER_OUT == 0 ? 0:1;
   // GPIO_COUNTER_PER_wdata

   // Add GPIO function
 
   // Read GPIO
   assign GPIO_INPUT_rdata = gpio_input;
   assign GPIO_INPUT_SENSOR_GENERAL_rdata = SENSOR_IN;
   assign GPIO_INPUT_SENSOR_I_rdata = SENSOR_IN[0];
   assign GPIO_INPUT_SENSOR_O_rdata = SENSOR_IN[1];
    
   // Write GPIO
   assign GPIO_SENSOR_OUTPUT_I = SENSOR_OUTPUT_I;
   assign GPIO_SENSOR_OUTPUT_O = SENSOR_OUTPUT_O;
   
   //assign GPIO_OUTPUT_SENSOR_READ = SENSOR_OUTPUT;
 
   assign gpio_output = GPIO_OUTPUT;
   assign gpio_output_enable = GPIO_OUTPUT_ENABLE;

   

endmodule
