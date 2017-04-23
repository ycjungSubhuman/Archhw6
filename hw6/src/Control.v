`include "opcodes.v" 	   

module Control(inst, BranchProperty, IsJump, IsBranch, OutputPortWrite, IsJumpReg, ALUOp, ALUSrc, IsLHI, MemRead, MemWrite, RegWriteSrc, RegWrite, RegDest, IsHLT);
	input [`WORD_SIZE-1:0] inst;
	output reg [1:0] BranchProperty;
	output reg IsJump;
	output reg IsBranch;
	output reg OutputPortWrite;
	output reg IsJumpReg;
	output reg [1:0] ALUOp;
	output reg ALUSrc;
	output reg IsLHI;
	output reg MemRead;
	output reg MemWrite;
	output reg [1:0] RegWriteSrc;
	output reg  RegWrite;
	output reg [2:0] RegDest;
	output reg IsHLT;
					 
	wire [3:0] opcode = inst[`WORD_SIZE-1: `WORD_SIZE-4];
	wire [5:0] func = (opcode==`ALU_OP) ? inst[5:0] : 0;
								 					  
	always @(*) begin
		if(opcode == 0) BranchProperty = 0;
		else if(opcode == 1) BranchProperty = 1;
		else if(opcode == 2) BranchProperty = 2;
		else if(opcode == 3) BranchProperty = 3;
		if(opcode==9 || opcode==10 || (opcode == 15 && (func == 25 || func == 26))) IsJump = 1;
		else IsJump = 0;
		if(opcode==0 || opcode==1 || opcode == 2 || opcode == 3) IsBranch = 1;
		else IsBranch = 0;
		if(opcode == 15 && func == 28) OutputPortWrite = 1;
		else OutputPortWrite = 0;
		if(opcode == 15 && (func == 25 || func == 26)) IsJumpReg = 1;
		else IsJumpReg = 0;
		if(opcode == 15) ALUOp = 0;
		else if(opcode == 4 || opcode == 7 || opcode == 8) ALUOp = 1;
		else if(opcode == 5)  ALUOp = 2;
		if(opcode == 15) ALUSrc = 0;
		else ALUSrc = 1;
		if(opcode == 6) IsLHI = 1;
		else IsLHI = 0;
		if(opcode == 7) MemRead = 1;
		else MemRead = 0;
		if(opcode == 8) MemWrite = 1;
		else MemWrite = 0;
		if(opcode == 7) RegWriteSrc = 1;
		else if(opcode == 10 || (opcode == 15 && func == 26)) RegWriteSrc = 2;
		else RegWriteSrc = 0;
		if(opcode == 4 || opcode == 5 || opcode == 6 || opcode == 7 || opcode == 10 || (opcode == 15 && (func <= 7 || func == 26))) RegWrite = 1;
		else RegWrite = 0;
		if(opcode == 0) RegDest = 0;
		else if(opcode == 10 || (opcode == 15 && func == 26)) RegDest = 2;
		else RegDest = 1;
		if(opcode == 15 && func == 29) IsHLT = 1;
		else IsHLT = 0;
	end
endmodule