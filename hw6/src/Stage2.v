`include "opcodes.v"
`include "Control.v"

module Stage2(PcUpdateTarget, Pc, inst,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, PcVal,
	ALUOp, ALUSrc, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite
	);
	//Data inout
	output [`WORD_SIZE-1:0] PcUpdateTarget;
	input [`WORD_SIZE-1:0] Pc;
	input [`WORD_SIZE-1:0] inst;
	output [`WORD_SIZE-1:0] ReadData1;
	output [`WORD_SIZE-1:0] ReadData2;
	output [`WORD_SIZE-1:0] ImmediateExtended;
	output [1:0] Rs;
	output [1:0] Rt;
	output [1:0] Rd;
	output [`WORD_SIZE-1:0] PcVal;
	assign PcVal = Pc_REG;
	
	//EX Control Signals
	output [1:0] ALUOp;
	output ALUSrc;
	output IsLHI;
	output [1:0] RegDest;
	
	//MEM Control Signals
	output MemRead;
	output MemWrite;
	
	//WB Control Signals
	output [1:0] RegWriteSrc;
	output RegWrite;
	
	//internal ID Control Signals
	reg [1:0] BranchProperty;
	reg IsJump;
	reg IsBranch;
	reg OutputPortWrite;
	reg IsJumpReg;
	
	//internal Register(IF/ID)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] inst_REG;
	
	Control ctrl(inst_REG, 
	BranchProperty, IsJump, IsBranch, OutputPortWrite, IsJumpReg, ALUOp, ALUSrc, 
	IsLHI, MemRead, MemWrite, RegWriteSrc, RegWrite, RegDest);
	
endmodule