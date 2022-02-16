// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Fri Dec 03 14:57:23 2021"

module finalproject(
	ir,
	clk_50MHz,
	reset_n,
	m12_en,
	m34_en,
	a1,
	a2,
	a3,
	a4,
	leds
);


input wire	ir;
input wire	clk_50MHz;
input wire	reset_n;
output wire	m12_en;
output wire	m34_en;
output wire	a1;
output wire	a2;
output wire	a3;
output wire	a4;
output wire	[9:4] leds;

wire	clear_n;
wire	clr_register_n;
wire	[31:0] data;
wire	ir_n;
wire	[31:0] q;
wire	send;
wire	serial;
wire	shift;




assign	clr_register_n = clear_n & reset_n;


instructiondecoder	b2v_instdecoder0(
	.reset_n(reset_n),
	.instruction(q[7:0]),
	.a1(leds[9]),
	.a2(leds[8]),
	.a3(leds[7]),
	.a4(leds[6]),
	.m12_en(leds[5]),
	.m34_en(leds[4]));


IRdecoderFSM	b2v_irdecoder0(
	.ir(ir_n),
	.clk(clk_50MHz),
	.reset_n(reset_n),
	.data(serial),
	.shift(shift),
	.clear_n(clear_n),
	.send(send));

assign	ir_n =  ~ir;


register	b2v_register0(
	.clk(clk_50MHz),
	.reset_n(clr_register_n),
	.en(send),
	.d(data),
	.q(q));
	defparam	b2v_register0.N = 32;


shiftregister	b2v_shiftreg0(
	.serial_in(serial),
	
	.shift(shift),
	.reset_n(reset_n),
	
	
	.parallel_out(data));
	defparam	b2v_shiftreg0.N = 32;


endmodule
