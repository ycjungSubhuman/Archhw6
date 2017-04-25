`include "opcodes.v"
`include "Control.v"
`include "register_files.v"

module Stage2(PcUpdateTarget, Pc, inst,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, PcVal,
	ALUOp, ALUSrc, OutputPortWrite, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	WB_RegWriteData, WB_WriteReg, WB_RegWrite,
	IsHalted, clk, reset_n
	);
	//Data inout
	output reg [`WORD_SIZE-1:0] PcUpdateTarget;
	input [`WORD_SIZE-1:0] Pc;
	input [`WORD_SIZE-1:0] inst;
	output [`WORD_SIZE-1:0] ReadData1;
	output [`WORD_SIZE-1:0] ReadData2;
	output reg [`WORD_SIZE-1:0] ImmediateExtended;
	output reg [1:0] Rs;
	output reg [1:0] Rt;
	output reg [1:0] Rd;
	output [`WORD_SIZE-1:0] PcVal;				  
	output reg IsHalted;
	assign PcVal = Pc_REG;
	input clk;
	input reset_n;
	
	//EX Control Signals
	output [2:0] ALUOp;
	output ALUSrc;
	output IsLHI;
	output [1:0] RegDest;
	output OutputPortWrite;
	
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
	reg IsJumpReg;
	reg IsHLT;
	
	//internal Register(IF/ID)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] inst_REG;
	
	//Write Back
	input [`WORD_SIZE-1:0] WB_RegWriteData;
	input [1:0] WB_WriteReg;
	input WB_RegWrite;							
	
	always @(*) begin
		$display("Stage2 Rs: %x, Rt: %x, ReadData1: %x, ReadData2: %x", Rs, Rt, ReadData1, ReadData2);
		if(IsBranch) begin
			if(BranchProperty == 0 && ReadData1 == ReadData2
				|| BranchProperty == 1 && ReadData1 != ReadData2
				|| BranchProperty == 2 && ReadData1 > 0
				|| BranchProperty == 3 && ReadData1 < 0)
				PcUpdateTarget = Pc_REG + ImmediateExtended;
		end

		Rs = inst_REG[11:10];
		Rt = inst_REG[9:8];
		Rd = inst_REG[7:6];
		if(IsJump) PcUpdateTarget = {Pc_REG[15:12], inst_REG[11:0]};
 		else PcUpdateTarget = Pc;
		if(IsHLT) IsHalted = 1;
		else IsHalted = 0;
		ImmediateExtended = {8'b00000000, inst_REG[7:0]};
		if(WB_RegWrite == 1) begin
			//$display("WB_RegWrite: %d, WB_WriteReg: %d, WB_RegWriteData: %d", WB_RegWrite, WB_WriteReg, WB_RegWriteData);
		end
	end
	
	always @(posedge clk) begin

		
		Pc_REG = Pc;
		inst_REG = inst;  
	end
	
	RegisterFiles regfile(WB_RegWrite, Rs, Rt, WB_WriteReg, WB_RegWriteData, clk, reset_n, ReadData1, ReadData2);
	
	Control ctrl(inst_REG, 
	BranchProperty, IsJump, IsBranch, OutputPortWrite, IsJumpReg, ALUOp, ALUSrc, 
	IsLHI, MemRead, MemWrite, RegWriteSrc, RegWrite, RegDest, IsHLT);
	
endmodule