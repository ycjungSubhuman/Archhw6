`include "opcodes.v"

module Stage1(PcUpdateTarget, Pc, inst, readM, address, data, clk, reset_n);
	input [`WORD_SIZE-1:0] PcUpdateTarget;
	output [`WORD_SIZE-1:0] Pc;
	output reg [`WORD_SIZE-1:0] inst;
	output reg readM;
	output reg [`WORD_SIZE-1:0] address;
	inout [`WORD_SIZE-1:0] data;
	assign data = 16'bz;
	input clk;
	input reset_n;
	
	reg [`WORD_SIZE-1:0] internalPc;
	
	initial begin
		internalPc = -1;
		readM = 0;
	end
	
	assign Pc = internalPc + 1;
	
	always @(data) begin
		if(readM==1) begin
			inst = data;
			$display("inst: %x, address: %x", inst, address);
		end
	end
	
	always @(posedge clk) begin
		internalPc = PcUpdateTarget;

		readM = 1;
		address = internalPc;
		
		if(!reset_n) begin
			internalPc = -1;
			readM = 0;
		end
	end
	
endmodule