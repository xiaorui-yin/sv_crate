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

module dw_converter #(
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

  if (DW_IN >= DW_OUT) begin: gen_downsizer
    dw_downsizer # (
      .DW_IN  (DW_IN),
      .DW_OUT (DW_OUT)
    ) i_dw_downsizer (
      .clk_i,
      .rst_ni,
      .din_i,
      .vld_i,
      .rdy_o,
      .dout_o,
      .vld_o,
      .rdy_i
    );
  end else begin: gen_upsizer
    dw_upsizer # (
      .DW_IN  (DW_IN),
      .DW_OUT (DW_OUT)
    ) i_dw_upsizer (
      .clk_i,
      .rst_ni,
      .din_i,
      .vld_i,
      .rdy_o,
      .dout_o,
      .vld_o,
      .rdy_i
    );
  end

endmodule // dw_converter

