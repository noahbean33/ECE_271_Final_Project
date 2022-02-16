module IRdecoderFSM (input  logic ir, clk, reset_n,
							output logic data, shift, clear_n, send);
	
	enum {IDLE, ANTI_NOISE, HEADER_START, HEADER_END, REPEAT, CLEAR,
			BIT_START, READ_BIT, ZERO, SHIFT_ZERO, ONE, SHIFT_ONE, SEND} state, next_state, old_state;
	logic [23:0] count;
	logic clrn;
	counter #(24) c(clk, clrn, 1, 0, 1, count); // to keep track of time elapsed
	
	logic timer_0560us, timer_1125us, timer_3000us, timer_4000us, timer_6045us, timer_200ms;
	
	always_ff @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			begin
				state <= IDLE;
				old_state <= IDLE;
			end
		else
			begin
				old_state <= state;
				state <= next_state;
			end
	end
	
	always_comb
	begin
		case (state)
			IDLE:				if (ir)
									next_state <= ANTI_NOISE;
								else if (timer_200ms)
									next_state <= CLEAR;
								else
									next_state <= IDLE;
								
			ANTI_NOISE:		if (!ir)
									next_state <= IDLE;
								else if (timer_0560us)
									next_state <= HEADER_START;
								else
									next_state <= ANTI_NOISE;
								
			HEADER_START:	if (!ir)
									next_state <= REPEAT;
								else if (timer_3000us)
									next_state <= HEADER_END;
								else
									next_state <= HEADER_START;
								
			HEADER_END:		next_state <= timer_6045us ? BIT_START : HEADER_END;
			REPEAT:			next_state <= timer_4000us ? IDLE : REPEAT;
			CLEAR:			next_state <= IDLE;
			BIT_START:		next_state <= timer_1125us ? READ_BIT : BIT_START;
			READ_BIT:		next_state <= ir ? ZERO : ONE;
			ZERO:				next_state <= SHIFT_ZERO;
			SHIFT_ZERO:		next_state <= BIT_START;
			ONE:				if (ir)
									next_state <= SHIFT_ONE;
								else if (timer_4000us)
									next_state <= SEND;
								else
									next_state <= ONE;
								
			SHIFT_ONE:		next_state <= timer_0560us ? BIT_START : SHIFT_ONE;
			SEND:				next_state <= IDLE;
			default:			next_state <= IDLE;
		endcase
	end
	
	assign clrn = (state == old_state) & reset_n;
	
	assign timer_0560us = count >= 28000;		//    28000 clock cycles
	assign timer_1125us = count >= 56250;		//    56250
	assign timer_3000us = count >= 150000;		//   150000
	assign timer_4000us = count >= 200000;		//   200000
	assign timer_6045us = count >= 302250;		//   302250
	assign timer_200ms  = count >= 10000000;	// 10000000
	
	assign data    = (state == ONE) | (state == SHIFT_ONE);
	assign shift   = (state == SHIFT_ZERO) | (state == SHIFT_ONE);
	assign clear_n = state != CLEAR;
	assign send    = state == SEND;
	
endmodule
