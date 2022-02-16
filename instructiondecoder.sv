module instructiondecoder (input  logic [7:0] instruction,
									input  logic reset_n,
									output logic a1, a2, a3, a4, m12_en, m34_en);
	
	enum {IDLE, FORWARD, BACKWARD, LEFT, STRAIGHT, RIGHT} cur_instruction, next_instruction, direction;
	
	logic [2:0] drive_bits;		// {a1, a2, m12_en}
	logic [2:0] steering_bits; // {a3, a4, m34_en}
	logic new_instruction;
	
	always_ff @(posedge new_instruction, negedge reset_n)
	begin
		if (!reset_n)
			begin
				cur_instruction <= IDLE;
				direction <= STRAIGHT;
			end
		else
			begin
				cur_instruction <= next_instruction;
				if ((next_instruction == LEFT) | (next_instruction == STRAIGHT) | (next_instruction == RIGHT))
					direction <= next_instruction;
			end
	end
	
	always_comb
	begin
		case (instruction)
			8'b11111001: next_instruction <= FORWARD;
			8'b01111001: next_instruction <= BACKWARD;
			8'b01011001: next_instruction <= LEFT;
			8'b11101001: next_instruction <= STRAIGHT;
			8'b10111001: next_instruction <= RIGHT;
			default:		 next_instruction <= IDLE;
		endcase
		
		case (cur_instruction)
			FORWARD:  drive_bits = 3'b101;
			BACKWARD: drive_bits = 3'b011;
			default:  drive_bits = 3'b000;
		endcase
		
		case (direction)
			LEFT:     steering_bits = 3'b101;
			RIGHT:    steering_bits = 3'b011;
			default:  steering_bits = 3'b000;
		endcase
	end
	
	assign new_instruction = cur_instruction != next_instruction;
	
	assign a1 = drive_bits[2];
	assign a2 = drive_bits[1];
	assign a3 = steering_bits[2];
	assign a4 = steering_bits[1];
	assign m12_en = drive_bits[0];
	assign m34_en = steering_bits[0];
	
endmodule
