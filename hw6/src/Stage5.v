`include "opcodes.v" 

module Stage5(Pc,
	ALUOut, RegWriteTarget, MemData, 
	WriteData, RegWriteTarget_OUT,
	RegWriteSrc, RegWrite,
	RegWrite_OUT,
	clk, reset_n
	);
	//Data inout
	input [`WORD_SIZE-1:0] Pc;
	input [`WORD_SIZE-1:0] ALUOut;
	input [1:0] RegWriteTarget;
	input [`WORD_SIZE-1:0] MemData;
	output reg [`WORD_SIZE-1:0] WriteData;
	output reg [1:0] RegWriteTarget_OUT;	
		input clk;
	input reset_n;
	
	//WB Control Signals
	input [1:0] RegWriteSrc;
	input RegWrite;
	
	//Control transfer
	output RegWrite_OUT;
	assign RegWrite_OUT = RegWrite_REG;
	assign RegWriteTarget_OUT = RegWriteTarget_REG;
	
	//internal Register(EX/MEM)
	reg [`WORD_SIZE-1:0] Pc_REG;
	reg [`WORD_SIZE-1:0] ALUOut_REG;
	reg [1:0] RegWriteTarget_REG;
	reg [`WORD_SIZE-1:0] MemData_REG;
	//WB Control Signals
	reg [1:0] RegWriteSrc_REG;
	reg RegWrite_REG;
	
	always @(*) begin
		if(RegWriteSrc_REG == 0) WriteData = ALUOut_REG;
		else if(RegWriteSrc_REG == 1) WriteData = MemData_REG;
		else if(RegWriteSrc_REG == 2) WriteData = Pc_REG;
	end
	
	always @(posedge clk) begin
		
		Pc_REG = Pc;
		ALUOut_REG = ALUOut;
		RegWriteTarget_REG = RegWriteTarget;
		MemData_REG = MemData;
		RegWriteSrc_REG = RegWriteSrc;
		RegWrite_REG = RegWrite;
	end
	
endmodule