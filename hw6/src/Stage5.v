`include "opcodes.v" 

module Stage5(Pc,
	ALUOut, RegWriteTarget, MemData, 
	WriteData, RegWriteTarget_OUT,
	RegWriteSrc, RegWrite,
	RegWrite_OUT
	);
	//Data inout
	input [`WORD_SIZE-1:0] Pc;
	input [`WORD_SIZE-1:0] ALUOut;
	input [1:0] RegWriteTarget;
	input [`WORD_SIZE-1:0] MemData;
	output [`WORD_SIZE-1:0] WriteData;
	output [`WORD_SIZE-1:0] RegWriteTarget_OUT;
	
	//WB Control Signals
	input [1:0] RegWriteSrc;
	input RegWrite;
	
	//Control transfer
	output RegWrite_OUT;
	assign RegWrite_OUT = RegWrite_REG;
	assign ALUOut_OUT = ALUOut_REG;
	assign RegWriteTarget_OUT = RegWriteTarget_REG;
	
	//internal Register(EX/MEM)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] ALUOut_REG;
	reg [1:0] RegWriteTarget_REG;
	reg [`WORD_SIZE-1:0] MemData_REG;
	//WB Control Signals
	reg [1:0] RegWriteSrc_REG;
	reg RegWrite_REG;
	
	
endmodule