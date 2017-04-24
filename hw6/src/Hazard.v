module Hazard(PcWrite, IF_ID_Write, InsertBubble
	ID_EX_MemRead);
	
	output PcWrite;
	output IF_ID_Write;
	output InsertBubble;
	input ID_EX_MemRead;
	
	//Stage 1 Add input PcWrite,
	//Stage 2 Add Input IF_ID_Write, input InsertBubble
	//Stage 3 Add output ID_EX_MemRead
	
	always @(*) begin
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