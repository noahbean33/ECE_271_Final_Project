module shiftregister #(parameter N = 8)
							 (input  logic serial_in, load, shift, reset_n,
							  input  logic [N - 1:0] parallel_in,
							  output logic serial_out,
							  output logic [N - 1:0] parallel_out);
	
	reg [N - 1:0] q;
	always_ff @(posedge shift, negedge reset_n, posedge load)
	begin
		if (!reset_n)
			q <= 0;
		else if (load)
			q <= parallel_in;
		else
			q <= {q[N - 2:0], serial_in};
	end
	
	assign serial_out = q[N - 1];
	assign parallel_out = q;
	
endmodule
