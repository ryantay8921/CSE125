module counter
  #(parameter width_p = 4,
    // Students: Using lint_off/lint_on commands to avoid lint checks,
    // will result in 0 points for the lint grade.
    /* verilator lint_off WIDTHTRUNC */
    parameter [width_p-1:0] reset_val_p = '0)
    /* verilator lint_on WIDTHTRUNC */
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   logic [width_p-1:0] count_next;
   logic [width_p-1:0] count_temp;
   always_ff @(posedge clk_i) begin
     if (reset_i) begin
       count_temp <= reset_val_p; 
     end else begin
       count_temp <= count_next;
     end
   end

  always_comb begin
     count_next = count_temp; 
     if (up_i && !down_i) begin
       count_next = count_temp + 1;
     end else if (down_i && !up_i) begin
       count_next = count_temp - 1; 
   end  
  end     

  assign count_o = count_temp;
endmodule
