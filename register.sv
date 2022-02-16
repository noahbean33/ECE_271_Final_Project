module register #(parameter N = 8)
					  (input  logic clk, reset_n, en,
					   input  logic [N - 1:0] d,
						output logic [N - 1:0] q);
	
	always_ff @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			q <= 0;
		else if (en)
			q <= d;
		else
			q <= q;
	end
	
endmodule
