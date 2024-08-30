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
// Changelog:

module pipeline_reg #(
  parameter type T      = logic,
  parameter bit  Bypass = 1'b0,
  parameter bit  NoLat  = 1'b1
) (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic vld_i,
  output logic rdy_o,
  input  T     data_i,
  output logic vld_o,
  input  logic rdy_i,
  output T     data_o
);

  if (NoLat) begin: gen_no_lat_reg
    spill_register_flushable #(
      .T     (T     ),
      .Bypass(Bypass),
    ) i_reg (
      .clk_i  (clk_i ),
      .rst_ni (rst_ni),
      .valid_i(vld_i ),
      .flush_i(1'b0  ),
      .ready_o(rdy_o ),
      .data_i (data_i),
      .valid_o(vld_o ),
      .ready_i(rdy_i ),
      .data_o (data_o)
    );
  end else begin: gen_lat_reg
    logic full, empty, push, pop;
    assign push = vld_i && ~full && !flush_i;
    assign pop  = ~empty && vld_o;
    assign rdy_o = ~full;
    assign vld_o = ~empty;

    fifo_v3 # (
      .DATA_WIDTH   ($size(T)),
      .FALL_THROUGH (Bypass  ),
      .DEPTH        (1       ),
    ) i_reg (
      .clk_i      (clk_i   ),
      .rst_ni     (rst_ni  ),
      .flush_i    (flush_i ),
      .test_mode_i(1'b0    ),
      .full_o     (full    ),
      .empty_o    (empty   ),
      .data_i     (data_i  ),
      .push_i     (push    ),
      .data_o     (data_o  ),
      .pop_i      (pop     )
    );
  end

endmodule
