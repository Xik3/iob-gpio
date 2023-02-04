`timescale 1ns/1ps

`include "iob_lib.vh"
`include "iob_gpio_swreg_def.vh"

module iob_gpio_counter (input clk, input rstn, output reg[3:0] out);
	always @ (*) 
	begin
		if(!rstn)
			out <= 0;
		else
			out <= out + 1;
	end
endmodule
