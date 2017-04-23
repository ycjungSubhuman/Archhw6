`include "opcodes.v"

module Stage1(PcUpdateTarget, Pc, inst);
	input [`WORD_SIZE-1:0] PcUpdateTarget;
	output [`WORD_SIZE-1:0] Pc;
	output [`WORD_SIZE-1:0] inst;
	
endmodule