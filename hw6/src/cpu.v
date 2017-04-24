`timescale 1ns/1ns
`define WORD_SIZE 16    // data and address word size 
`include "Datapath.v"

module cpu(Clk, Reset_N, i_readM, i_writeM, i_address, i_data, d_readM, d_writeM, d_address, d_data, num_inst, output_port, is_halted);
	input Clk;
	wire Clk;
	input Reset_N;
	wire Reset_N;
	
	// Instruction memory interface
	output i_readM;
	wire i_readM;
	output i_writeM;
	wire i_writeM;
	assign i_writeM = 0;
	output [`WORD_SIZE-1:0] i_address;
	wire [`WORD_SIZE-1:0] i_address;

	inout [`WORD_SIZE-1:0] i_data;
	wire [`WORD_SIZE-1:0] i_data;
	
	//assign i_data = 16'bz;
	
	// Data memory interface
	output d_readM;
	wire d_readM;
	output d_writeM;
	wire d_writeM;
	output [`WORD_SIZE-1:0] d_address;
	wire [`WORD_SIZE-1:0] d_address;

	inout [`WORD_SIZE-1:0] d_data;
	wire [`WORD_SIZE-1:0] d_data;

	output [`WORD_SIZE-1:0] num_inst;
	reg [`WORD_SIZE-1:0] num_inst;
	output [`WORD_SIZE-1:0] output_port;
	wire [`WORD_SIZE-1:0] output_port;
	output is_halted;
	wire is_halted;
	
	initial num_inst = -4; 
	

    Datapath dpath (
		.readM1(i_readM), .address1(i_address), .data1(i_data),
		.readM2(d_readM), .writeM2(d_writeM), .address2(d_address), .data2(d_data), 
		.reset_n(Reset_N), .clk(Clk), .output_port(output_port), .is_halted(is_halted));
		
	always@(posedge Clk) begin
		num_inst += 1;
	end

endmodule