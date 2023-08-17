module	controller
	(
		input wire [2:0] phase, opcode, 
		input wire zero, 
		output reg sel, rd, ld_ir, halt, inc_pc, ld_pc, ld_ac, wr,  data_e
	);

localparam integer HLT=0, SKZ=1, ADD=2, AND=3, XOR=4, LDA=5, STO=6, JMP=7;
reg temp_halt, temp_aluop, temp_skzzero, temp_jmp, temp_sto;

	always @*
		begin
			temp_halt    = (opcode == HLT);
			temp_aluop   = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
			temp_skzzero = (opcode == SKZ && zero);
			temp_jmp     = (opcode == JMP);
			temp_sto     = (opcode == STO);
			case (phase)
				0 : begin sel=1; rd=0         ; ld_ir=0; halt=0        ; inc_pc=0           ; ld_ac=0         ; ld_pc=0       ; wr=0       ; data_e=0       ; end
				1 : begin sel=1; rd=1         ; ld_ir=0; halt=0        ; inc_pc=0           ; ld_ac=0         ; ld_pc=0       ; wr=0       ; data_e=0       ; end
				2 : begin sel=1; rd=1         ; ld_ir=1; halt=0        ; inc_pc=0           ; ld_ac=0         ; ld_pc=0       ; wr=0       ; data_e=0       ; end
				3 : begin sel=1; rd=1         ; ld_ir=1; halt=0        ; inc_pc=0           ; ld_ac=0         ; ld_pc=0       ; wr=0       ; data_e=0       ; end
				4 : begin sel=0; rd=0         ; ld_ir=0; halt=temp_halt; inc_pc=1           ; ld_ac=0         ; ld_pc=0       ; wr=0       ; data_e=0       ; end
				5 : begin sel=0; rd=temp_aluop; ld_ir=0; halt=0        ; inc_pc=0           ; ld_ac=0         ; ld_pc=0       ; wr=0       ; data_e=0       ; end
				6 : begin sel=0; rd=temp_aluop; ld_ir=0; halt=0        ; inc_pc=temp_skzzero; ld_ac=0         ; ld_pc=temp_jmp; wr=0       ; data_e=temp_sto; end
				7 : begin sel=0; rd=temp_aluop; ld_ir=0; halt=0        ; inc_pc=0           ; ld_ac=temp_aluop; ld_pc=temp_jmp; wr=temp_sto; data_e=temp_sto; end
			endcase
		end

endmodule