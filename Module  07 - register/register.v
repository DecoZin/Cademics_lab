module register 
#(
  parameter WIDTH = 8
) (
  input wire      clk, rst, load,
  input wire [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out 
);

  always @(posedge clk)
  begin
    if (~rst)
      data_out <= load ? data_in : data_out;
    else
      data_out <= 0;
  end
  
endmodule