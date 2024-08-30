// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from XIAORUI YIN.
//
//            (C) COPYRIGHT 2023~2024 XIAORUI YIN.
//                     ALL RIGHTS RESERVED
//
// Author: Xiaorui Yin <xiaorui.yin@tutamail.com>
//
// Date: 28.08.2024
//
// Description:
//
// Changelog:

`include "registers.svh"

module dw_downsizer #(
  parameter int unsigned DW_IN  = 16,
  parameter int unsigned DW_OUT = 8
) (
  // Clock and Reset
  input  logic              clk_i,
  input  logic              rst_ni,

  // Input Interface
  input  logic [DW_IN-1:0]  din_i,
  input  logic              vld_i,
  output logic              rdy_o,

  // Output Interface
  output logic [DW_OUT-1:0] dout_o,
  output logic              vld_o,
  input  logic              rdy_i
);

  if (DW_IN % DW_OUT == 0) begin: gen_divisable_downsizer
    localparam int unsigned NumSlots = DW_IN / DW_OUT;
    `REG(dbuf, logic[DW_IN-1:0])
    `REG(rd_ptr, logic[$clog2(NumSlots)-1:0])
    `REG(out_vld)

    assign rdy_o = ~out_vld_q;
    assign vld_o = out_vld_q;

    always_comb begin
      out_vld_d    = out_vld_q;
      dbuf_d       = dbuf_q;
      rd_ptr_d     = rd_ptr_q;

      // Read data
      if (rdy_i && out_vld_q) begin
        dout_o    = dbuf_q[rd_ptr_q * DW_OUT +: DW_OUT];

        rd_ptr_d  = rd_ptr_q + 1;
        if (rd_ptr_q == NumSlots - 1)
          out_vld_d = 1'b0;
      end

      // Write data
      if (vld_i && (rdy_o || ~out_vld_d)) begin
        dbuf_d    = din_i;
        out_vld_d = 1'b1;
      end
    end

  end else begin: gen_non_divisable_downsizer
  end

  // ==============================================================
  // Assertion
  // ==============================================================

  initial begin
    if (DW_OUT > DW_IN)
      $fatal("Error: DW_OUT should be less than or equal to DW_IN");
  end

endmodule // dw_downsizer
