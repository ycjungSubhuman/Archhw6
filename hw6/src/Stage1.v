`include "opcodes.v"

module Stage1(PcUpdateTarget, Pc, inst, readM, address, data);
	input [`WORD_SIZE-1:0] PcUpdateTarget;
	output [`WORD_SIZE-1:0] Pc;
	output [`WORD_SIZE-1:0] inst;
	output readM;
	output [`WORD_SIZE-1:0] address;
	input [`WORD_SIZE-1:0] data;
	
endmodule