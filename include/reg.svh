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

`ifndef REG_SVH_
`define REG_SVH_

`define REG_DFLT_CLK clk_i
`define REG_DFLT_RST rst_ni

// Generic Flip-Flop register with asynchronous active-low reset
// __name: name of the register
// __reset_value: value assigned upon reset
// (__clk: clock input)
// (__arst_n: asynchronous reset, active-low)
`define REG(__name, __type = logic, __reset_value = '0, __load_en = 1'b1, __clear_en = 1'b0, __clk = `REG_DFLT_CLK, __arst_n = `REG_DFLT_RST)   \
  __type __name``_d, __name``_q;                                                                                                                \
  always_ff @(posedge (__clk) or negedge (__arst_n)) begin                                                                                      \
    if (!__arst_n)                                                                                                                              \
      __name``_q <= (__reset_value);                                                                                                            \
    else if (__load_en)                                                                                                                         \
      __name``_q <= (__name``_d);                                                                                                               \
    else if (__clear_en)                                                                                                                        \
      __name``_q <= (__reset_value);                                                                                                            \
  end

`endif
