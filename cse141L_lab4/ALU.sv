module ALU(
  input [ 7:0] INPUTA,      	  // data inputs
               INPUTB,
  input [ 2:0] opcode,				  // ALU opcode
  input func,
  output logic [7:0] ALU_out,		  // ALU output
  output logic branch_taken,
  output logic branch_skip
    );
  logic [10:0] dm64;
  logic [6:0] dm73;
  LFSR_prog2_LUT lut9(.DM64(dm64),.DM73(dm73));
  always_comb begin
    {branch_skip, branch_taken, ALU_out} = 0;   // default -- reset ALU_out and not branching
    case(opcode)
      3'b000: begin
	if (func==1)
        	ALU_out = INPUTA + INPUTB;
	else
		ALU_out = INPUTA - INPUTB;
        branch_skip = 0;
        branch_taken = 0;
      end
      3'b001: begin
        ALU_out = INPUTB;
        branch_skip = 0;
        branch_taken = 0;
      end
      3'b010: begin
        branch_skip = 0;
        branch_taken = 0;
        if(INPUTB) begin              // halt otherwise
          case(func)
            1'b0: begin                // left shift
              case(INPUTB[1:0])
                2'b01: begin
                  ALU_out = {INPUTA[6:0], 1'b0};
                end
                2'b10: begin
                  ALU_out = {INPUTA[5:0], 2'b00};
                end
                2'b11: begin
                  ALU_out = {INPUTA[4:0], 3'b000};
                end
              endcase
            end
            1'b1: begin                // right shift
              case(INPUTB[1:0])
                2'b01: begin
                  ALU_out = {1'b0, INPUTA[7:1]};
                end
                2'b10: begin
                  ALU_out = {2'b00, INPUTA[7:2]};
                end
                2'b11: begin
                  ALU_out = {3'b000, INPUTA[7:3]};
                end
              endcase
            end
          endcase
        end
      end
      3'b011: begin                   // LW
        branch_skip = 0;
        branch_taken = 0;
      end
      3'b100: begin                   // look up
        if(func==1) begin
		case(INPUTA)
    		0: ALU_out = 8'h60;	
    		1: ALU_out = 8'h48;
    		2: ALU_out = 8'h78;
    		3: ALU_out = 8'h72;
    		4: ALU_out = 8'h6A;
    		5: ALU_out = 8'h69;
    		6: ALU_out = 8'h5C;
    		7: ALU_out = 8'h7E;
    		8: ALU_out = 8'h7B;
  		endcase
	end else begin
		dm64= {INPUTA,INPUTB[3:0]};
		$display(dm64);
		$display(ALU_out);
		ALU_out = lut9.core[dm64];
	end
        branch_skip = 0;
        branch_taken = 0;
      end
      3'b101: begin                   // XOR
	if (func==1)
        	ALU_out = {^(INPUTA[6:0]),INPUTA[6:0]};
	else
		ALU_out = INPUTA ^ INPUTB;
        branch_skip = 0;
        branch_taken = 0;
      end
      3'b110: begin                   // lfsr
        ALU_out[6:0]=(INPUTA<<1)|(^(INPUTA & INPUTB));
	ALU_out[7]=0;
        branch_skip = 0;
        branch_taken = 0;
      end
      3'b111: begin                   // BNE
        if (INPUTA == INPUTB) begin
          branch_skip = 1;
          branch_taken = 0;
        end
        else begin
          branch_skip = 0;
          branch_taken = 1;
        end
      end
    endcase
  end
endmodule
