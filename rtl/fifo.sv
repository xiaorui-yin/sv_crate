// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from XIAORUI YIN.
//
//            (C) COPYRIGHT 2023~2024 XIAORUI YIN.
//                     ALL RIGHTS RESERVED
//
// Author: Xiaorui Yin <xiaorui.yin@tutamail.com>
//
// Date: 01.09.2024
//
// Description:
//
// Changelog:

module fifo #(
    parameter bit          FALL_THROUGH = 1'b0,
    parameter int unsigned DATA_WIDTH   = 32,
    parameter int unsigned DEPTH        = 8,
    parameter int unsigned AFULL_LEVEL  = DEPTH - 1,
    parameter int unsigned AEMPTY_LEVEL = 1,
    parameter type dtype                = logic [DATA_WIDTH-1:0],
    // DO NOT OVERWRITE THIS PARAMETER
    parameter int unsigned ADDR_DEPTH   = (DEPTH > 1) ? $clog2(DEPTH) : 1
) (
    input  logic  clk_i,
    input  logic  rst_ni,
    input  logic  flush_i,
    input  logic  testmode_i,
    // status flags
    output logic  full_o,
    output logic  empty_o,
    output logic  afull_o,
    output logic  aempty_o,
    // as long as the queue is not full we can push new data
    input  dtype  data_i,
    input  logic  push_i,
    // as long as the queue is not empty we can pop new elements
    output dtype  data_o,
    input  logic  pop_i
);

  logic [ADDR_DEPTH-1:0] usage;
  assign afull_o  = (usage >= AFULL_LEVEL) || full_o;
  assign aempty_o = (usage <= AEMPTY_LEVEL) || empty_o;

  fifo_v3 # (
    .DATA_WIDTH   (DATA_WIDTH    ),
    .dtype        (dtype         ),
    .FALL_THROUGH (FALL_THROUGH  ),
    .DEPTH        (DEPTH         ),
  ) i_fifo_v3 (
    .clk_i      (clk_i      ),
    .rst_ni     (rst_ni     ),
    .flush_i    (flush_i    ),
    .test_mode_i(test_mode_i),
    .usage_o    (usage      )
    .full_o     (full_o     ),
    .empty_o    (empty_o    ),
    .data_i     (data_i     ),
    .push_i     (push_i     ),
    .data_o     (data_o     ),
    .pop_i      (pop_i      )
  );

endmodule // fifo
