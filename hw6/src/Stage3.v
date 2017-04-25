`include "opcodes.v"

module Stage3(Pc,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, 
	PcVal, ALUOut, RegWriteTarget,
	ALUOp, ALUSrc, OutputPortWrite, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	MemRead_OUT, MemWrite_OUT,
	RegWriteSrc_OUT, RegWrite_OUT, MemWriteData_OUT,
	Rs_OUT, Rt_OUT,
	ControlA, ControlB, WB_RegWriteData, MEM_RegWriteData,	 OutputData,
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
	output reg [`WORD_SIZE-1:0] PcVal;
	assign PcVal = Pc_REG;
	output reg [`WORD_SIZE-1:0] ALUOut;
	output reg [1:0] RegWriteTarget;
	output [1:0] Rs_OUT;
	output [1:0] Rt_OUT;
	output reg [`WORD_SIZE-1:0] MemWriteData_OUT;
	output reg [`WORD_SIZE-1:0] OutputData;
		input clk;
	input reset_n;
	
	//EX Control Signals
	input [2:0] ALUOp;
	input ALUSrc;
	input IsLHI;
	input [1:0] RegDest;
	input OutputPortWrite;
	
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
	output reg MemRead_OUT;
	output reg MemWrite_OUT;
	output reg [1:0] RegWriteSrc_OUT;
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
	assign Rs_OUT = Rs_REG;
	assign Rt_OUT = Rt_REG;	 
	
	//EX Control Signals
	reg [2:0] ALUOp_REG;
	reg ALUSrc_REG;
	reg IsLHI_REG;
	reg [1:0] RegDest_REG;	
	//MEM Control Signals
	reg MemRead_REG;
	reg MemWrite_REG;
	//WB Control Signals
	reg [1:0] RegWriteSrc_REG;
	reg RegWrite_REG;
	
	reg OutputPortWrite_REG;
	
	reg overflow;  
	reg [`WORD_SIZE-1:0] operandA;
	reg [`WORD_SIZE-1:0] operandB;
	reg [`WORD_SIZE-1:0] ALUInterOut;
	
	always @(*) begin
		if(ControlA == 0) operandA = ReadData1_REG;
		else if(ControlA == 1) operandA = MEM_RegWriteData;
		else if(ControlA == 2) operandA = WB_RegWriteData;
		if(ALUSrc_REG == 1)	operandB = ImmediateExtended_REG;
		else begin
			if(ControlB == 0) operandB = ReadData2_REG;
			else if(ControlB == 1) operandB = MEM_RegWriteData;
			else if(ControlB == 2) operandB = WB_RegWriteData;
		end
		MemWriteData_OUT = operandB;
		if(RegDest_REG == 0) RegWriteTarget = Rd_REG;
		else if(RegDest_REG == 1) RegWriteTarget = Rt_REG;
		if(IsLHI_REG == 0) ALUOut = ALUInterOut;
		else if(IsLHI_REG == 1) ALUOut = ImmediateExtended_REG << 8;
		$display("OperandA: %x, OperandB: %x, IsLHI_REG: %x, OutputPortWrite_REG: %x, RegWrite_REG: %x, ALUOut: %x, ALUOp: %x, RegWriteTarget: %x, ControlA: %x, ControlB: %x", 
			operandA, operandB, IsLHI_REG, OutputPortWrite_REG, RegWrite_REG, ALUOut, ALUOp, RegWriteTarget, ControlA, ControlB);
		if(OutputPortWrite_REG) begin
			OutputData = operandA;
			$display("outputting: OutputData: %x, ControlA: %x", operandA, ControlA);
		end
	end
	
	always @(posedge clk) begin
		Pc_REG = Pc;
		ReadData1_REG = ReadData1;
		ReadData2_REG = ReadData2;
		ImmediateExtended_REG = ImmediateExtended;
		Rs_REG = Rs;
		Rt_REG = Rt;
		Rd_REG = Rd;
		ALUOp_REG = ALUOp;
		ALUSrc_REG = ALUSrc;
		IsLHI_REG = IsLHI;
		RegDest_REG = RegDest;
		MemRead_REG = MemRead;
		MemWrite_REG = MemWrite;
		RegWriteSrc_REG = RegWriteSrc;
		RegWrite_REG = RegWrite;
		OutputPortWrite_REG = OutputPortWrite;
	end
	
	ALU alu(overflow, ALUInterOut, operandA, operandB, ALUOp_REG);
	
endmodule