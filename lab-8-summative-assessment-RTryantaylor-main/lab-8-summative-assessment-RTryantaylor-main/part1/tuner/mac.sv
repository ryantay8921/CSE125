/*verilator lint_off DECLFILENAME*/
/*verilator lint_off WIDTHEXPAND*/
/*verilator lint_off UNUSEDSIGNAL*/
/*verilator lint_off SYNCASYNCNET*/
`timescale 1ns/1ps
module mac
 #(parameter int_in_lp = 1
  ,parameter frac_in_lp = 11
  ,parameter int_out_lp = 10
  ,parameter frac_out_lp = 22
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [int_in_lp - 1 : -frac_in_lp] a_i
  ,input [int_in_lp - 1 : -frac_in_lp] b_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,input [0:0] ready_i
  ,output [0:0] valid_o 
  ,output [int_out_lp - 1 : -frac_out_lp] data_o
  );

  logic signed [int_out_lp - 1 : -frac_out_lp] data_prev;
  logic signed [int_out_lp - 1 : -frac_out_lp] total;

  always_ff @(posedge clk_i ) begin : mutltiply
    if(reset_i) begin
      total <= '0;
      data_prev <= '0;
    end else if(ready_o  && valid_i) begin
      total <= ($signed(a_i) * $signed(b_i)) + data_prev;
      data_prev    <= ($signed(a_i) * $signed(b_i)) + data_prev;
    end
  end
  assign data_o = total;



  logic valid_temp;
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      valid_temp <= '0;
    end else if (ready_o) begin
      valid_temp <= valid_i && ready_o;
    end
  end

  assign ready_o = ~valid_o | ready_i;
  assign valid_o = valid_temp;
   
endmodule
