module driver
#( parameter integer WIDTH=8)
	(
	input wire [WIDTH-1:0] data_in,  data_en, 
	output reg [WIDTH-1:0] data_out);

	always @(data_en, data_in)
		if (data_en)
			data_out = data_in; 
		else
			data_out = 'hz;
								 
endmodule