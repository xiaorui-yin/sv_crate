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
// Generic Signed Adder Tree
//
// Changelog:
// 28.08.2024: Use compiler built-in style of adder tree

module adder_tree #(
    parameter int unsigned InWidth   = 16,
    parameter int unsigned NumIn     = 9,
    parameter bit          KeepWidth = 1,

    localparam int unsigned NumLevel = $clog2(NumIn),
    localparam int unsigned OutWidth = InWidth + (KeepWidth ?  NumLevel : 0)
) (
    // Clock and Reset
    input  logic                       clk_i,
    input  logic                       rst_ni,

    input  logic signed [InWidth -1:0] in_i[NumIn],
    output logic signed [OutWidth-1:0] sum_o
);

  // if (NumIn == 1) begin: gen_single_node
  //   assign sum_o = in_i;
  // end else if (NumIn == 2) begin: gen_leaf_node
  //   assign sum_o = in_i[0] + in_i[1];
  // end else begin: gen_no_leaf_node
  //   localparam int unsigned NumRightNodes = NumIn / 2;
  //   localparam int unsigned NumLeftNodes  = NumIn -  NumIn / 2;

  //   localparam int unsigned RightSumWidth = InWidth + KeepWidth ? $clog2(NumRightNodes) : 0;
  //   localparam int unsigned LeftSumWidth  = InWidth + KeepWidth ? $clog2(NumLeftNodes)  : 0;

  //   logic signed [RightSumWidth-1:0] right_child_sum;
  //   logic signed [LeftSumWidth -1:0] left_child_sum;

  //   adder_tree #(
  //     .InWidth (InWidth      ),
  //     .NumIn   (NumRightNodes)
  //   ) i_right_child (
  //     .in_i  (in_i[0:NumRightNodes-1]),
  //     .sum_o (right_child_sum        )
  //   );

  //   adder_tree #(
  //     .InWidth (InWidth     ),
  //     .NumIn   (NumLeftNodes)
  //   ) i_left_child (
  //     .in_i  (in_i[NumRightNodes+:NumLeftNodes]),
  //     .sum_o (left_child_sum                   )
  //   );

  //   assign sum_o = right_child_sum + left_child_sum;
  // end

  always_comb begin
    sum_o = '0;
    for (int unsigned i = 0; i < NumIn; i++) begin
      sum_o = sum_o + in_i[i];
    end
  end
endmodule // adder_tree

