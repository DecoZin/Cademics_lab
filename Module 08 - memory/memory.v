module memory 
#(
  parameter AWIDTH = 5,
  parameter DWIDTH = 8
) (
  input wire       clk, wr, rd,
  input wire [AWIDTH-1:0] addr,
  inout wire [DWIDTH-1:0] data
);

  reg [DWIDTH-1:0] mem_array [0:2**(AWIDTH-1)];

  always @* mem_array[addr] = wr ? data : mem_array[addr];

  assign    data = rd ? mem_array[addr] : data;
  
endmodule