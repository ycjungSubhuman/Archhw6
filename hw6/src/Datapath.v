`include "opcodes.v"
`include "ALU.v"
`include "Stage1.v"
`include "Stage2.v"
`include "Stage3.v"
`include "Stage4.v"
`include "Stage5.v"

module Datapath ( 
	readM1, address1, data1,
	readM2, writeM2, address2, data2, 
	reset_n, clk, output_port, is_halted, num_inst); 
	
	output readM1;
	output address1;
	input [`WORD_SIZE-1:0] data1;
	
	output readM2;
	output writeM2;
	output address2;
	inout [`WORD_SIZE-1:0] data2;

	input reset_n;	  
	input clk;
	output reg [15:0] output_port;
	output reg is_halted;
	output reg [`WORD_SIZE-1:0] num_inst;
	
	Stage1 st1(PcUpdateTarget, Pc, inst);
	
	Stage2 st2(PcUpdateTarget, Pc, inst,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, PcVal,
	ALUOp, ALUSrc, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite
	);
	
	Stage3 st3(Pc,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, 
	PcVal, ALUOut, RegWriteTarget,
	ALUOp, ALUSrc, IsLHI, RegDest,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	MemRead_OUT, MemWrite_OUT,
	RegWriteSrc_OUT, RegWrite_OUT
	);
	
	Stage4 st4(Pc,
	ALUOut, RegWriteTarget, 
	PcVal, MemData, ALUOut_OUT, RegWriteTarget_OUT,
	MemRead, MemWrite,
	RegWriteSrc, RegWrite,
	RegWriteSrc_OUT, RegWrite_OUT
	);
	
	Stage5 st5(Pc,
	ALUOut, RegWriteTarget, MemData, 
	WriteData, RegWriteTarget_OUT,
	RegWriteSrc, RegWrite,
	RegWriteSrc_OUT, RegWrite_OUT
	);

endmodule