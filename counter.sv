module counter #(parameter N = 8)
					 (input  logic clk,
					  input  logic reset_n,
					  input  logic en,
					  input  logic [N - 1:0] d,
					  input  logic cin,
					  output logic [N - 1:0] q);

	always_ff @(posedge clk, negedge reset_n)
		begin
			if (!reset_n) q <= 0;
			else if (en)  q <= q + d + cin;
			else			  q <= q;
		end

endmodule
