`ifndef RETNUOCL
`define RETNUOCL

module retnuoCl (input  [15:0] lfsr,
                 output [15:0] out);

    assign out =    ((((lfsr & 16'h01) << 7) |
                      ((lfsr & 16'h02) << 5) |
                      ((lfsr & 16'h04) << 3) |
                      ((lfsr & 16'h08) << 1) |
                      ((lfsr & 16'h10) >> 1) |
                      ((lfsr & 16'h20) >> 3) |
                      ((lfsr & 16'h40) >> 5) |
                      ((lfsr & 16'h80) >> 7) )
                    << 8);
endmodule

`endif