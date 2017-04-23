`include "opcodes.v"

module Stage1(PcUpdateTarget, Pc, inst, readM, address, data, clk, reset_n);
	input [`WORD_SIZE-1:0] PcUpdateTarget;
	output [`WORD_SIZE-1:0] Pc;
	output reg [`WORD_SIZE-1:0] inst;
	output reg readM;
	output reg [`WORD_SIZE-1:0] address;
	input [`WORD_SIZE-1:0] data;
	input clk;
	input reset_n;
	
	reg [`WORD_SIZE-1:0] internalPc;
	
	initial begin
		internalPc = 0;
		readM = 0;
	end
	
	assign Pc = internalPc + 4;
	
	always @(*) begin
		if(readM==1) begin
			inst = data;
			readM = 0;
		end
	end
	
	always @(posedge clk) begin
		internalPc = PcUpdateTarget;
		readM = 1;
		address = internalPc;
		
		if(!reset_n) begin
			internalPc = 0;
			readM = 0;
		end
	end
	
endmodule