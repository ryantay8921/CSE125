module tuner
 #(parameter int_in_lp = 1
  ,parameter frac_in_lp = 11
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [int_in_lp - 1 : -frac_in_lp] audio_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [7 : 0] ssd_o
  );

  logic mac_reset, count_reset;
  localparam int_out_lp = 17; localparam frac_out_lp = 15;
  
  logic signed [11:0] sine_wave_c, sine_wave_d, sine_wave_e, sine_wave_f, sine_wave_g, sine_wave_a, sine_wave_b;
  logic [int_out_lp - 1 : -frac_out_lp] data_c, data_d, data_e, data_f, data_g, data_a, data_b;
  logic ready_lo_c, ready_lo_d, ready_lo_e, ready_lo_f, ready_lo_g, ready_lo_a, ready_lo_b;

  localparam freq_c = 523;
  localparam freq_d = 590;
  localparam freq_e = 660;
  localparam freq_f = 701;
  localparam freq_g = 784;
  localparam freq_b = 988;
  localparam freq_a = 880;   

  // localparam freq_c = 523.3;  //these give conflict error: ERROR: Conflicting init values for signal 1'0 ($flatten\sin_f.$verific$n1$3225 = 1'1 != 1'0).
  // localparam freq_d = 587.3;
  // localparam freq_e = 659.3;
  // localparam freq_f = 698.5;
  // localparam freq_g = 784.0;
  // localparam freq_a = 880.0;
  // localparam freq_b = 987.8;
 

  sinusoid #(.note_freq_p(freq_c)) 
  sin_c (.data_o(sine_wave_c), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_c && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_c (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_c), .b_i(audio_i), .data_o(data_c),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_c),
        .ready_i(1'b1), .valid_o());

  sinusoid #(.note_freq_p(freq_d)) 
  sin_d (.data_o(sine_wave_d), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_d && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_d (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_d), .b_i(audio_i), .data_o(data_d),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_d),
        .ready_i(1'b1), .valid_o());

  sinusoid #(.note_freq_p(freq_e)) 
  sine_e (.data_o(sine_wave_e), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_e && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_e (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_e), .b_i(audio_i), .data_o(data_e),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_e),
        .ready_i(1'b1), .valid_o());

  sinusoid #(.note_freq_p(freq_f)) 
  sin_f (.data_o(sine_wave_f), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_f && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_f (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_f), .b_i(audio_i), .data_o(data_f),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_f),
        .ready_i(1'b1), .valid_o());

  sinusoid #(.note_freq_p(freq_g)) 
  sin_g (.data_o(sine_wave_g), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_g && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_g (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_g), .b_i(audio_i), .data_o(data_g),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_g),
        .ready_i(1'b1), .valid_o());

  sinusoid #(.note_freq_p(freq_a)) 
  sin_a (.data_o(sine_wave_a), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_a && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_a (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_a), .b_i(audio_i), .data_o(data_a),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_a),
        .ready_i(1'b1), .valid_o());

  sinusoid #(.note_freq_p(freq_b)) 
  sin_b (.data_o(sine_wave_b), .clk_i(clk_i), .reset_i(reset_i),  .ready_i(ready_lo_b && valid_i), .valid_o());
  mac #(.int_in_lp(int_in_lp), .frac_in_lp(frac_in_lp), .int_out_lp(int_out_lp), .frac_out_lp(frac_out_lp))
  mac_b (.clk_i(clk_i), .reset_i(reset_i || mac_reset),
        .a_i(sine_wave_b), .b_i(audio_i), .data_o(data_b),
        .valid_i(valid_i && ready_o), .ready_o(ready_lo_b),
        .ready_i(1'b1), .valid_o());


  logic [31:0] count_o;
  counter #(.width_p(32))
  counter (.clk_i(clk_i), .reset_i(reset_i || count_reset), .up_i(valid_i && ready_lo_c), .down_i('0), .count_o(count_o));
  assign count_reset = count_o == 'd66538;
  assign mac_reset = count_o == 'd66537;
  assign hold = count_o == 'd66536;

  logic [7:0] data_c_squared, data_d_squared, data_e_squared, data_f_squared, data_g_squared, data_a_squared, data_b_squared;
  always_comb begin : square_mac_o
    data_c_squared = data_c[int_out_lp-2:int_out_lp-9] * data_c[int_out_lp-2:int_out_lp-9];
    data_d_squared = data_d[int_out_lp-2:int_out_lp-9] * data_d[int_out_lp-2:int_out_lp-9];
    data_e_squared = data_e[int_out_lp-2:int_out_lp-9] * data_e[int_out_lp-2:int_out_lp-9];
    data_f_squared = data_f[int_out_lp-2:int_out_lp-9] * data_f[int_out_lp-2:int_out_lp-9];
    data_g_squared = data_g[int_out_lp-2:int_out_lp-9] * data_g[int_out_lp-2:int_out_lp-9];
    data_a_squared = data_a[int_out_lp-2:int_out_lp-9] * data_a[int_out_lp-2:int_out_lp-9];
    data_b_squared = data_b[int_out_lp-2:int_out_lp-9] * data_b[int_out_lp-2:int_out_lp-9];
  end

logic [11:0] data_a_b, data_c_d, data_e_f;
always_ff @(posedge clk_i) begin : first_row_turn
  data_a_b <= (data_a_squared > data_b_squared) ? {4'hA, data_a_squared} : {4'hB, data_b_squared};
  data_c_d <= (data_c_squared > data_d_squared) ? {4'hC, data_c_squared} : {4'hD, data_d_squared};
  data_e_f <= (data_e_squared > data_f_squared) ? {4'hE, data_e_squared} : {4'hD, data_f_squared};
end

logic [11:0] data_a_b_c_d, data_e_f_g;
always_ff @(posedge clk_i) begin : second_row_turn
  data_a_b_c_d <= (data_a_b[7:0] > data_c_d[7:0]) ? (data_a_b[11:8] == 4'hA ? {4'hA,data_a_squared} : {4'hB,data_b_squared}) : (data_c_d[11:8] == 4'hC ? {4'hC,data_c_squared} : {4'hD,data_d_squared});
  data_e_f_g <= (data_e_f[7:0] > data_g_squared) ? (data_e_f[11:8] == 4'hE ? {4'hE,data_e_squared} : {4'hF,data_f_squared}) : {4'h6,data_g_squared};
end

logic [3:0] data_out;
always_ff @(posedge clk_i) begin  : third_row
  if(data_a_b_c_d[7:0] > data_e_f_g[7:0]) begin
    if(data_a_b_c_d[11:8] == 4'hA) begin data_out <= 4'hA; end
    else if(data_a_b_c_d[11:8] == 4'hB) begin data_out <= 4'hB; end
    else if(data_a_b_c_d[11:8] == 4'hC) begin data_out <= 4'hC; end
    else if(data_a_b_c_d[11:8] == 4'hD) begin data_out <= 4'hD; end
  end else if (data_a_b_c_d[7:0] < data_e_f_g[7:0]) begin
    if(data_e_f_g[11:8] == 4'hE) begin data_out <= 4'hE; end
    else if(data_e_f_g[11:8] == 4'hF) begin data_out <= 4'hF; end
    else if(data_e_f_g[11:8] == 4'h6) begin data_out <= 4'h6; end
  end
end


  logic [3:0] data_hold;
   always_ff @(posedge clk_i) begin : hold_reg
     if (reset_i) begin
       data_hold <= '0;
     end else if(hold) begin
        data_hold <= data_out;
     end
   end

  /*
  logic [3:0] data_hold;
    always_ff @(posedge clk_i) begin : hold_reg
     if (reset_i) begin
       data_hold <= '0;
     end else if(hold) begin
        if((data_a_squared>data_b_squared)&&(data_a_squared> data_c_squared)&&(data_a_squared > data_d_squared)&&(data_a_squared>data_e_squared)&&(data_a_squared>data_f_squared)&&data_a_squared> data_g_squared) begin data_hold <= 4'hA; end
        else if((data_b_squared>data_a_squared)&&(data_b_squared> data_c_squared)&&(data_b_squared > data_d_squared)&&(data_b_squared>data_e_squared)&&(data_b_squared>data_f_squared)&&data_b_squared> data_g_squared) begin data_hold <= 4'hB; end
        else if((data_c_squared>data_b_squared)&&(data_c_squared> data_a_squared)&&(data_c_squared > data_d_squared)&&(data_c_squared>data_e_squared)&&(data_c_squared>data_f_squared)&&data_c_squared> data_g_squared) begin data_hold <= 4'hC; end
        else if((data_d_squared>data_b_squared)&&(data_d_squared> data_c_squared)&&(data_d_squared > data_a_squared)&&(data_d_squared>data_e_squared)&&(data_d_squared>data_f_squared)&&data_d_squared> data_g_squared) begin data_hold <= 4'hD; end
        else if((data_e_squared>data_b_squared)&&(data_e_squared> data_c_squared)&&(data_e_squared > data_d_squared)&&(data_e_squared>data_a_squared)&&(data_e_squared>data_f_squared)&&data_e_squared> data_g_squared) begin data_hold <= 4'hE; end
        else if((data_f_squared>data_b_squared)&&(data_f_squared> data_c_squared)&&(data_f_squared > data_d_squared)&&(data_f_squared>data_e_squared)&&(data_f_squared>data_a_squared)&&data_f_squared> data_g_squared) begin data_hold <= 4'hF; end
        else if((data_g_squared>data_b_squared)&&(data_g_squared> data_c_squared)&&(data_g_squared > data_d_squared)&&(data_g_squared>data_e_squared)&&(data_g_squared>data_f_squared)&&data_g_squared> data_a_squared) begin data_hold <= 4'h6; end
     end
   end
   */


  logic [6:0] display;
  hex2ssd #() hex1 (.hex_i(data_hold), .ssd_o(display));
  assign ssd_o = {1'b1,  display};


   assign ready_o = 1;
endmodule
