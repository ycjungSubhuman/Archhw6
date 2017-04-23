`include "opcodes.v" 

module Stage4(Pc,
	ALUOut, RegWriteTarget, 
	PcVal, MemData, ALUOut_OUT, RegWriteTarget_OUT,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	RegWriteSrc_OUT, RegWrite_OUT, MEM_RegWriteData,
	readM, writeM, address, data,
	clk, reset_n
	);
	//Data inout
	input [`WORD_SIZE-1:0] Pc;
	input [`WORD_SIZE-1:0] ALUOut;
	input [1:0] RegWriteTarget;
	output [`WORD_SIZE-1:0] PcVal;
	assign PcVal = Pc_REG;
	output [`WORD_SIZE-1:0] MemData;
	output [`WORD_SIZE-1:0] ALUOut_OUT;
	output [`WORD_SIZE-1:0] RegWriteTarget_OUT;	
	output [1:0] RegWriteSrc_OUT;
	output RegWrite_OUT;
	output [`WORD_SIZE-1:0] MEM_RegWriteData;
		input clk;
	input reset_n;
	
	//MEM Control Signals
	input MemRead;
	input MemWrite;
	
	//WB Control Signals
	input [1:0] RegWriteSrc;
	input RegWrite;
	
	//Control transfer

	assign RegWriteSrc_OUT = RegWriteSrc_REG;
	assign RegWrite_OUT = RegWrite_REG;
	assign ALUOut_OUT = ALUOut_REG;
	assign RegWriteTarget_OUT = RegWriteTarget_REG;
	
	//Memory Communication
	output readM;
	output writeM;
	output [`WORD_SIZE-1:0] address;
	inout [`WORD_SIZE-1:0] data;
	
	//internal Register(EX/MEM)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] ALUOut_REG;
	reg [1:0] RegWriteTarget_REG;
	//MEM Control Signals
	reg MemRead_REG;
	reg MemWrite_REG;
	//WB Control Signals
	reg [1:0] RegWriteSrc_REG;
	reg RegWrite_REG;
	
	
endmodule