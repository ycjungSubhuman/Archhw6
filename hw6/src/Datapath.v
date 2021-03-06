`include "opcodes.v"
`include "ALU.v"
`include "Stage1.v"
`include "Stage2.v"
`include "Stage3.v"
`include "Stage4.v"
`include "Stage5.v"
`include "Forward.v"
`include "Hazard.v"

module Datapath ( 
	readM1, address1, data1,
	readM2, writeM2, address2, data2, 
	reset_n, clk, output_port, is_halted, stalled); 
	
	output wire readM1;
	output [`WORD_SIZE-1:0] address1;
	inout [`WORD_SIZE-1:0] data1;
	assign data1 = 16'bz;
	output stalled;
	
	output readM2;
	output writeM2;
	output [`WORD_SIZE-1:0] address2;
	inout [`WORD_SIZE-1:0] data2;

	input reset_n;	  
	input clk;
	output reg [15:0] output_port;
	output reg is_halted;
	
	always @(posedge clk) begin
		$display("inst: %x, RegWrite_2_3: %x, RegWrite_3_4: %x, RegWrite_4_5: %x, WB_RegWrite: %x", inst, RegWrite_2_3, RegWrite_3_4, RegWrite_4_5, WB_RegWrite);
		//$display("stage 1 of %x finished : Rs:%x Rt:%x Exmemdest:%x Wbdest: %x, wb1: %x, w2, %x", inst, Rs_3_F, Rt_3_F, RegWriteTarget_4_5, WB_RegWriteTarget, RegWrite_4_5, WB_RegWrite);
	end
	
	
	//Stage1 ~ Stage2
	wire [`WORD_SIZE-1:0] PcUpdateTarget;
	wire [`WORD_SIZE-1:0] Pc_1_2;
	wire [`WORD_SIZE-1:0] inst;
	
		
	//Stage2 ~ Stage3
	wire [`WORD_SIZE-1:0] ReadData1;
	wire [`WORD_SIZE-1:0] ReadData2;
	wire [`WORD_SIZE-1:0] ImmediateExtended;
	wire [1:0] Rs;
	wire [1:0] Rt;
	wire [1:0] Rd;
	wire [`WORD_SIZE-1:0] Pc_2_3;
	wire [2:0] ALUOp_2_3;
	wire ALUSrc_2_3;
	wire IsLHI_2_3;
	wire [1:0] RegDest_2_3;
	wire MemRead_2_3;
	wire MemWrite_2_3;
	wire [1:0] RegWriteSrc_2_3;
	wire RegWrite_2_3;
	wire OutputPortWrite_2_3;
	assign stalled = InsertBubble;

	
	//Stage 5 ~ Stage2
	wire [`WORD_SIZE-1:0] WB_RegWriteData;
	wire WB_RegWrite;
	
	
		//Forward ~ Stage3
	wire [1:0] ControlA;
	wire [1:0] ControlB;
	wire [1:0] Rs_3_F;
	wire [1:0] Rt_3_F;
	
	//Stage4 ~ Stage3
	wire [`WORD_SIZE-1:0] MEM_RegWriteData;
	
	//Stage3 ~ Stage4
	wire [`WORD_SIZE-1:0] Pc_3_4;
	wire [`WORD_SIZE-1:0] ALUOut_3_4;
	wire [1:0] RegWriteTarget_3_4;
	wire MemRead_3_4;
	wire MemWrite_3_4;
	wire [1:0] RegWriteSrc_3_4;
	wire RegWrite_3_4;
	wire [`WORD_SIZE-1:0] MemWriteData_3_4;
	
	wire [1:0] WB_RegWriteSrc;
	
		
	//Stage4 ~ Stage5
	wire [`WORD_SIZE-1:0] Pc_4_5;
	wire [`WORD_SIZE-1:0] MemData_4_5;	
	wire [`WORD_SIZE-1:0] ALUOut_4_5;
	wire [1:0] RegWriteTarget_4_5;
	wire [1:0] RegWriteSrc_4_5;
	wire RegWrite_4_5;	
	
	//Stage5 ~ Forward
	wire [1:0] WB_RegWriteTarget;
	
	//Hazard Detection
	wire PcWrite;
	wire IF_ID_Write;
	wire InsertBubble;
	
	Stage1 st1(PcUpdateTarget, Pc_1_2, PcWrite, inst, readM1, address1, data1, clk, reset_n);
	
	Hazard hzd(PcWrite, IF_ID_Write, InsertBubble, MemRead_3_4, clk);
	
	Stage2 st2(PcUpdateTarget, Pc_1_2, inst,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, Pc_2_3,
	ALUOp_2_3, ALUSrc_2_3, OutputPortWrite_2_3, IsLHI_2_3, RegDest_2_3,
	MemRead_2_3, MemWrite_2_3,
	RegWriteSrc_2_3, RegWrite_2_3,
	WB_RegWriteData, WB_RegWriteTarget, WB_RegWrite,
	IF_ID_Write, InsertBubble,
	 is_halted, clk, reset_n
	);
	
	Forward fwd(ControlA, ControlB, Rs_3_F, Rt_3_F, RegWriteTarget_4_5, WB_RegWriteTarget,
	RegWrite_4_5, WB_RegWrite);
	
	Stage3 st3(Pc_2_3,
	ReadData1, ReadData2, ImmediateExtended, Rs, Rt, Rd, 
	Pc_3_4, ALUOut_3_4, RegWriteTarget_3_4,
	ALUOp_2_3, ALUSrc_2_3, OutputPortWrite_2_3, IsLHI_2_3, RegDest_2_3,
	MemRead_2_3, MemWrite_2_3,
	RegWriteSrc_2_3, RegWrite_2_3,
	MemRead_3_4, MemWrite_3_4,
	RegWriteSrc_3_4, RegWrite_3_4, MemWriteData_3_4,
	Rs_3_F, Rt_3_F,
	ControlA, ControlB, WB_RegWriteData, MEM_RegWriteData, output_port,
	clk, reset_n
	);		 

	
	Stage4 st4(Pc_3_4,
	ALUOut_3_4, RegWriteTarget_3_4, MemWriteData_3_4,
	Pc_4_5, MemData_4_5, ALUOut_4_5, RegWriteTarget_4_5,
	MemRead_3_4, MemWrite_3_4,
	RegWriteSrc_3_4, RegWrite_3_4,
	RegWriteSrc_4_5, RegWrite_4_5, MEM_RegWriteData,
	readM2, writeM2, address2, data2,
	clk, reset_n
	);
	
	Stage5 st5(Pc_4_5,
	ALUOut_4_5, RegWriteTarget_4_5, MemData_4_5, 
	WB_RegWriteData, WB_RegWriteTarget,
	RegWriteSrc_4_5, RegWrite_4_5,
	WB_RegWrite,
	clk, reset_n
	);

endmodule