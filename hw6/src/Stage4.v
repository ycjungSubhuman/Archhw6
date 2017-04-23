`include "opcodes.v" 

module Stage4(Pc,
	ALUOut, RegWriteTarget, MemWriteData, 
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
	input [`WORD_SIZE-1:0] MemWriteData;
	output [`WORD_SIZE-1:0] PcVal;
	assign PcVal = Pc_REG;
	output reg [`WORD_SIZE-1:0] MemData;
	output [`WORD_SIZE-1:0] ALUOut_OUT;

	output [1:0] RegWriteTarget_OUT;	
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
	output reg readM;
	output reg writeM;
	output reg [`WORD_SIZE-1:0] address;
	inout [`WORD_SIZE-1:0] data;
	reg [`WORD_SIZE-1:0] writeBuf;
	assign data = (writeM) ? writeBuf : 16'bz;
	
	//internal Register(EX/MEM)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] ALUOut_REG;
	reg [1:0] RegWriteTarget_REG;
	reg [`WORD_SIZE-1:0] MemWriteData_REG;
	//MEM Control Signals
	reg MemRead_REG;
	reg MemWrite_REG;
	//WB Control Signals
	reg [1:0] RegWriteSrc_REG;
	reg RegWrite_REG;
	
	assign ALUOut_OUT = ALUOut_REG;
	assign MEM_RegWriteData = ALUOut_REG;
	assign RegWriteTarget_OUT = RegWriteTarget_REG;
	assign RegWriteSrc_OUT = RegWriteSrc_REG;
	assign RegWrite_OUT = RegWrite_REG;
	
	initial begin
	end
	
	always@(*) begin
		if(writeM) writeM = 0;
		else if(readM) begin
			MemData = data;
		end
	end
	
	always@(posedge clk) begin
		address = ALUOut_REG;
		if(MemRead_REG == 1) readM = 1;
		else if (MemWrite_REG == 1) begin
			writeM = 1;
			writeBuf = MemWriteData;
		end
		
		
		//Update Register values
		Pc_REG = Pc;
		ALUOut_REG = ALUOut;
		RegWriteTarget_REG = RegWriteTarget;
		MemWriteData_REG = MemWriteData;
		MemRead_REG = MemRead;
		MemWrite_REG = MemWrite;
		RegWriteSrc_REG = RegWriteSrc;
		RegWrite_REG = RegWrite;
	end
	
endmodule