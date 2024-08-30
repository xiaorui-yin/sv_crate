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
// Generic upsizer module for data width expansion.
//
// Changelog:

`include "registers.svh"
module dw_upsizer # (
  parameter int unsigned DW_IN  = 8,
  parameter int unsigned DW_OUT = 16
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

  if (DW_OUT % DW_IN == 0) begin: gen_divisable_upsizer
    localparam int unsigned NumSlots = DW_OUT / DW_IN;

    // Internal Signals
    `REG(dbuf, logic[DW_OUT-1:0])
    `REG(wr_ptr, logic[$clog2(NumSlots)-1:0])
    `REG(out_vld)
    assign dout_o = dbuf_q;
    assign vld_o  = out_vld_q;
    assign rdy_o  = ~out_vld_q;

    always_comb begin
      dbuf_d    = dbuf_q;
      wr_ptr_d  = wr_ptr_q;
      out_vld_d = out_vld_q;

      // Read data
      if (out_vld_q && rdy_i)
        out_vld_d = 1'b0;

      // Write data
      if (vld_i && (rdy_o || ~out_vld_d)) begin
        dbuf_d[wr_ptr_q * DW_IN +: DW_IN] = din_i;
        wr_ptr_d = wr_ptr_q + 1;

        // Slots are full, output valid
        if (wr_ptr_q == NumSlots - 1) begin
          wr_ptr_d  = '0;
          out_vld_d = 1'b1;
        end
      end
    end
  end else begin: gen_non_divisable_upsizer
    // Internal Signals
    `REG(dbuf, logic[DW_OUT-1:0])
    `REG(rem, logic[DW_IN-1:0])
    `REG(dbuf_wr_ptr, logic[$clog2(NumSlots)-1:0])
    `REG(out_vld)
    assign dout_o = dbuf_q;
    assign vld_o  = out_vld_q;
    assign rdy_o  = ~out_vld_q;
  end

  // ==============================================================
  // Assertions
  // ==============================================================

  initial begin
    if (DW_IN > DW_OUT)
      $fatal("Error: DW_IN must be less than DW_OUT.");

    if (DW_IN == 0 || DW_OUT == 0)
      $fatal("Error: DW_IN and DW_OUT must be greater than 0.");
  end

endmodule // dw_upsizer #

