`include "opcodes.v"

module Forward(SelectA, SelectB, ID_EX_Rs, ID_EX_Rt, EX_MEM_Dest, MEM_WB_Dest,
	EX_MEM_RegWrite, MEM_WB_RegWrite);
	
	output [1:0] SelectA;
	output [1:0] SelectB;
	input [1:0] ID_EX_Rs;
	input [1:0] ID_EX_Rt;
	input [1:0] EX_MEM_Dest;
	input [1:0] MEM_WB_Dest;
	input EX_MEM_RegWrite;
	input MEM_WB_RegWrite;
	
endmodule