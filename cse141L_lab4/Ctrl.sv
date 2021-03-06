module Ctrl (
  input[8:0] instruction,	   // machine code
  input logic read_jump,
  output logic [2:0] opcode,
                     operand1,
                     operand2,
                     reg_write_addr,
  output logic [7:0] immediate,
  output logic func,
  output logic [5:0] lut_index,
  output logic imm_operand2,
               ALU_write_reg,
               write_to_reg,
               write_mem,
               read_mem,
               jump_en,
               Halt
  );
always_comb begin
  if (read_jump) begin                   // jp
    opcode = 3'b000;
    operand1 = instruction[5:3];
    operand2 = instruction[2:0];
    reg_write_addr = instruction[5:3];
    immediate = 8'b00000000;
    func = instruction[2];
    lut_index = instruction[5:0];
    imm_operand2 = 0;
    ALU_write_reg = 0;
    write_to_reg = 0;
    write_mem = 0;
    read_mem = 0;
    jump_en = 1;
    Halt = 0;
  end
  else begin
    case(instruction[8:6])
      3'b000: begin                         // add sub
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000+ instruction[1:0];
        func = instruction[2];
        lut_index = instruction[5:0];
        imm_operand2 = 1;
        ALU_write_reg = 1;
        write_to_reg = 1;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        Halt = 0;
      end
      3'b001: begin                         // MOV
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000 + instruction[2:0];
        func = instruction[2];
        lut_index = instruction[5:0];
	if(operand1==3'b111 || operand2==3'b111)begin
		imm_operand2 = 0;
	end else begin
		imm_operand2 = 1;
	end
        ALU_write_reg = 1;
        write_to_reg = 1;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        Halt = 0;
      end
      3'b010: begin                         // shift
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000 + instruction[1:0];
        func = instruction[2];
        lut_index = instruction[5:0];
        imm_operand2 = 1;
        ALU_write_reg = 1;
        write_to_reg = 1;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        if(instruction[5:0] == 6'b000000) begin
	  write_to_reg = 0;
          Halt = 1;
        end
        else begin
          Halt = 0;
        end
      end
      3'b011: begin                         // LW
        opcode = instruction[8:6];
        immediate = 8'b00000000;
	if (instruction[5:3]==3'b111)begin  // store
		operand1 = instruction[2:0];
                operand2 =instruction[5:3];
		reg_write_addr = instruction[2:0];
        	write_to_reg = 0;
        	write_mem = 1;
        	read_mem = 0;
	end else begin
		operand1 = instruction[5:3];
        	operand2 = instruction[2:0];
		reg_write_addr = instruction[5:3];
        	write_to_reg = 1;
        	write_mem = 0;
        	read_mem = 1;
	end
        func = instruction[2];
        lut_index = instruction[5:0];
        imm_operand2 = 0;
        ALU_write_reg = 0;
        jump_en = 0;
        Halt = 0;
      end
      3'b100: begin                         // look up
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000;
	if (operand2==3'b111)
		func = 1;
	else
        	func = 0;
        lut_index = instruction[5:0];
        imm_operand2 = 0;
        ALU_write_reg = 1;
        write_to_reg = 1;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        Halt = 0;
      end
      3'b101: begin                         // XOR
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000;
        if (operand2==3'b111)
		func = 1;
	else
        	func = 0;
        lut_index = instruction[5:0];
        imm_operand2 = 0;
        ALU_write_reg = 1;
        write_to_reg = 1;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        Halt = 0;
      end
      3'b110: begin                         // lfsr
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000;
        func = instruction[2];
        lut_index = instruction[5:0];
        imm_operand2 = 0;
        ALU_write_reg = 1;
        write_to_reg = 1;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        Halt = 0;
      end
      3'b111: begin                         // BNE
        opcode = instruction[8:6];
        operand1 = instruction[5:3];
        operand2 = instruction[2:0];
        reg_write_addr = instruction[5:3];
        immediate = 8'b00000000;
        func = instruction[2];
        lut_index = instruction[5:0];
        imm_operand2 = 0;
        ALU_write_reg = 0;
        write_to_reg = 0;
        write_mem = 0;
        read_mem = 0;
        jump_en = 0;
        Halt = 0;
      end
    endcase
  end
end

endmodule