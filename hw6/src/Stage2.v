`include "opcodes.v"
`include "Control.v"
`include "register_files.v"

module Stage2(PcUpdateTarget, Pc, inst,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, PcVal,
	ALUOp, ALUSrc, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	WB_RegWriteTarget, WB_WriteReg, WB_RegWrite, OutputData, IsHalted
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
	output [`WORD_SIZE-1:0] OutputData;
	output IsHalted;
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
	reg IsHLT;
	
	//internal Register(IF/ID)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] inst_REG;
	
	//Write Back
	input [`WORD_SIZE-1:0] WB_RegWriteTarget;
	input [1:0] WB_WriteReg;
	input WB_RegWrite;							
	
	always @(*) begin
		Rs = inst_REG[11:10];
		Rt = inst_REG[9:8];
		Rd = inst_REG[7:6];
		immediateExtended = {8'b00000000, inst[7:0]};
		if(IsBranch) begin
			if(BranchProperty == 0 && ReadData1 == ReadData2
				|| BranchProperty == 1 && ReadData1 != ReadData2
				|| BranchProperty == 2 && ReadData1 > 0
				|| BranchProperty == 3 && ReadData1 < 0)
				PcUpdateTarget = Pc_REG + immediateExtended;
		end
		else if(IsJump) PcUpdateTarget = {Pc_REG[15:12], inst_REG[11:0]};
		else PcUpdateTarget = Pc;
		if(OutputPortWrite) OutputData = ReadData1;
		if(IsHLT) IsHalted = 1;
		else IsHalted = 0;
	end
	
	always @(posedge clk) begin
		Pc_REG = Pc;
		inst_REG = inst;
	end
	
	RegisterFiles regfile(WB_RegWrite, inst_REG[11:10], inst_REG[9:8], WB_WriteReg, WB_RegWriteTarget, clk, reset_n, readData1, readData2);
	
	Control ctrl(inst_REG, 
	BranchProperty, IsJump, IsBranch, OutputPortWrite, IsJumpReg, ALUOp, ALUSrc, 
	IsLHI, MemRead, MemWrite, RegWriteSrc, RegWrite, RegDest, IsHLT);
	
endmodule