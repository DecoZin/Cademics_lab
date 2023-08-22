module alu
 #(
	parameter WIDTH=8
	)
	(
		input wire [WIDTH-1:0] in_a, in_b, 
		input wire [2:0] opcode, 
		output reg [WIDTH-1:0] alu_out,
		output reg a_is_zero
	);
	
	always @*
		begin
			a_is_zero = (in_a === 1'b0) ? 1'b1 : 1'b0;
			if ( opcode === 3'd0) alu_out = in_a;        else
			if ( opcode === 3'd1) alu_out = in_a;        else
			if ( opcode === 3'd2) alu_out = in_a + in_b; else
			if ( opcode === 3'd3) alu_out = in_a & in_b; else
			if ( opcode === 3'd4) alu_out = in_a ^ in_b; else
			if ( opcode === 3'd5) alu_out = in_b;        else
			if ( opcode === 3'd6) alu_out = in_a;        else
			if ( opcode === 3'd7) alu_out = in_a;
		end

endmodule