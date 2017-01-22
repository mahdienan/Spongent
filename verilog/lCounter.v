`ifndef LCOUNTER
`define LCOUNTER

module lCounter (input   [15:0] lfsr,
                 output  [15:0] out);

    assign out =    ((lfsr << 1) |
                    (((16'h80 & lfsr) >> 7) ^
                     ((16'h08 & lfsr) >> 3) ^
                     ((16'h04 & lfsr) >> 2) ^
                     ((16'h02 & lfsr) >> 1) )
                    )
                    & 16'hff;
endmodule

`endif
