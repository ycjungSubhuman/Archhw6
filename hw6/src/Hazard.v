module Hazard(PcWrite, IF_ID_Write, InsertBubble, ID_EX_MemRead, clk);
	
	output reg PcWrite;
	output reg IF_ID_Write;
	output reg InsertBubble;
	input ID_EX_MemRead;
	input clk;
	
	//Stage 1 Add input PcWrite,
	//Stage 2 Add Input IF_ID_Write, input InsertBubble
	//Stage 3 Add output ID_EX_MemRead
	initial begin
		PcWrite = 1;
		IF_ID_Write = 1;
		InsertBubble = 0;
	end
	
	
	always @(*) begin
		$display("Hazard: MemRead: %x", ID_EX_MemRead);
		if(ID_EX_MemRead) begin
			PcWrite = 0;
			IF_ID_Write = 0;
			InsertBubble = 1;
		end
		else begin
			PcWrite = 1;
			IF_ID_Write = 1;
			InsertBubble = 0;
		end
	end
	
endmodule