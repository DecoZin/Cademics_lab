module multiplexor 
#(
  parameter integer WIDTH = 5
  )
  (
    input wire sel,
    input wire [WIDTH-1:0] in0, in1,
    output reg [WIDTH-1:0] mux_out
  );

  always @(sel, in0, in1)
    mux_out = sel ? in1 : in0;
  
endmodule