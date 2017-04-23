`include "opcodes.v"

module Stage3(Pc,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, 
	PcVal, ALUOut, RegWriteTarget,
	ALUOp, ALUSrc, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	MemRead_OUT, MemWrite_OUT,
	RegWriteSrc_OUT, RegWrite_OUT,
	Rs_OUT, Rt_OUT,
	ControlA, ControlB, WB_RegWriteData, MEM_RegWriteData,
	clk, reset_n
	);
	//Data inout
	input [`WORD_SIZE-1:0] Pc;
	input [`WORD_SIZE-1:0] ReadData1;
	input [`WORD_SIZE-1:0] ReadData2;
	input [`WORD_SIZE-1:0] ImmediateExtended;
	input [1:0] Rs;
	input [1:0] Rt;
	input [1:0] Rd;
	output [`WORD_SIZE-1:0] PcVal;
	assign PcVal = Pc_REG;
	output [`WORD_SIZE-1:0] ALUOut;
	output [1:0] RegWriteTarget;
	output [1:0] Rs_OUT;
	output [1:0] Rt_OUT;
		input clk;
	input reset_n;
	
	//EX Control Signals
	input [1:0] ALUOp;
	input ALUSrc;
	input IsLHI;
	input [1:0] RegDest;
	
	//MEM Control Signals
	input MemRead;
	input MemWrite;
	
	//WB Control Signals
	input [1:0] RegWriteSrc;
	input RegWrite;
	
	//Forwarding
	input [1:0] ControlA;
	input [1:0] ControlB;
	input [`WORD_SIZE-1:0] WB_RegWriteData;
	input [`WORD_SIZE-1:0] MEM_RegWriteData;
	
	//Control transfer
	output MemRead_OUT;
	output MemWrite_OUT;
	output [1:0] RegWriteSrc_OUT;
	output RegWrite_OUT;
	assign MemRead_OUT = MemRead_REG;
	assign MemWrite_OUT = MemWrite_REG;
	assign RegWriteSrc_OUT = RegWriteSrc_REG;
	assign RegWrite_OUT = RegWrite_REG;
	
	//internal Register(ID/EX)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] ReadData1_REG;
	reg [`WORD_SIZE-1:0] ReadData2_REG;
	reg [`WORD_SIZE-1:0] ImmediateExtended_REG;
	reg [1:0] Rs_REG;
	reg [1:0] Rt_REG;
	reg [1:0] Rd_REG;
	//EX Control Signals
	reg [1:0] ALUOp_REG;
	reg ALUSrc_REG;
	reg IsLHI_REG;
	reg [1:0] RegDest_REG;	
	//MEM Control Signals
	reg MemRead_REG;
	reg MemWrite_REG;
	//WB Control Signals
	reg [1:0] RegWriteSrc_REG;
	reg RegWrite_REG;
	
	
endmodule