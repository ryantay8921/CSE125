`timescale 1ns/1ps
`define START_TESTBENCH error_o = 0; pass_o = 0; #10;
`define FINISH_WITH_FAIL error_o = 1; pass_o = 0; #10; $finish();
`define FINISH_WITH_PASS pass_o = 1; error_o = 0; #10; $finish();
module testbench
  // You don't usually have ports in a testbench, but we need these to
  // signal to cocotb/gradescope that the testbench has passed, or failed.
  (output logic error_o = 0
  ,output logic pass_o = 0);

   // You can pick these
   parameter int_in_lp = 1;
   parameter frac_in_lp = 11;
   
   wire        clk_i;
   bit         reset_i;
   wire        _reset_i;

   // Use reset_il to set reset from procedural blocks.
   bit         reset_il;
   assign reset_i = _reset_i | reset_il;


   // I'm using bit here to get a 0/1 type
   logic signed [int_in_lp - 1 : - frac_in_lp] audio_il;
   bit                                valid_il;
   wire                               ready_o;

   logic [7 : 0]                      ssd_ol;

   nonsynth_clock_gen #(.cycle_time_p(10)) cg (.clk_o(clk_i));
   nonsynth_reset_gen #(.reset_cycles_lo_p(0)  ,.reset_cycles_hi_p(10)) rg (.clk_i(clk_i) ,.async_reset_o(_reset_i));
   tuner #(.int_in_lp(int_in_lp) ,.frac_in_lp(frac_in_lp) ) dut (.clk_i(clk_i) ,.reset_i(reset_i) ,.audio_i(audio_il) ,.valid_i(valid_il) ,.ready_o(ready_o) ,.ssd_o(ssd_ol) );

   // Track how many handshakes have occured at the input interface.
   int wr_count;

   always_ff @(posedge clk_i) begin
      // Only reset wr_count at the very start of simulation
      if(_reset_i)
        wr_count <= 0;
      else 
        wr_count <= wr_count + (valid_il & (ready_o === 1'b1));
   end

   // Use done to tell the "tracker" we're done.
   bit                                 input_done = 0;
   always @(posedge clk_i) begin
      // If the input generator is done and the write count is equal
      // to the read count, then terminate the simulator with a pass.
      if(input_done) begin
         `FINISH_WITH_PASS;
      end
   end

   // Input Generator
   // Since it's unsafe to read outputs of a module in an initial
   // block, sanitize the input/write handshake by capturing it in a
   // signal we control.
   bit wr_success;
   always_ff @(posedge clk_i) begin
      wr_success <= valid_il & (ready_o === 1'b1);
   end   

   // Input Interface Watchdog Timer
   int wr_timeout;
   always @(posedge clk_i) begin
      if(reset_i || (valid_il & (ready_o === 1))) begin
         wr_timeout <= 0;
      end else if(wr_timeout > 10) begin
         $error("Timeout on input interface. valid_i was high for 10 cycles with no response.");
         `FINISH_WITH_FAIL;
      end else if(valid_il & (ready_o !== 1)) begin
         wr_timeout <= wr_timeout + 1;
      end
   end


logic [7:0] data_c_squared, data_d_squared, data_e_squared, data_f_squared, data_g_squared, data_a_squared, data_b_squared;
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


   initial begin
      `START_TESTBENCH
      // Leave this code alone, it generates the waveforms
      // Set input signals to zeros to ensure that dut state is not
      // polluted by x's
      valid_il = 1'b0;
      reset_il = 1'b0;
      audio_il = '0;

      @(negedge reset_i);

      // Wait a few clock cycles
   repeat(2) @(negedge clk_i);


   data_a_squared = 8'b1; data_b_squared = 8'b0; data_c_squared = 8'b0; data_d_squared = 8'b0; data_e_squared = 8'b0; data_f_squared = 8'b0; data_g_squared = 8'b0;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'hA) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'hA) begin
      $display("A works");
   end

   data_a_squared = 8'b0; data_b_squared = 8'b1; data_c_squared = 8'b0; data_d_squared = 8'b0; data_e_squared = 8'b0; data_f_squared = 8'b0; data_g_squared = 8'b0;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'hB) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'hB) begin
      $display("B works");
   end

   data_a_squared = 8'b0; data_b_squared = 8'b0; data_c_squared = 8'b1; data_d_squared = 8'b0; data_e_squared = 8'b0; data_f_squared = 8'b0; data_g_squared = 8'b0;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'hC) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'hC) begin
      $display("C works");
   end


   data_a_squared = 8'b0; data_b_squared = 8'b0; data_c_squared = 8'b0; data_d_squared = 8'b1; data_e_squared = 8'b0; data_f_squared = 8'b0; data_g_squared = 8'b0;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'hD) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'hD) begin
      $display("D works");
   end

   data_a_squared = 8'b0; data_b_squared = 8'b0; data_c_squared = 8'b0; data_d_squared = 8'b0; data_e_squared = 8'b1; data_f_squared = 8'b0; data_g_squared = 8'b0;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'hE) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'hE) begin
      $display("E works");
   end

   data_a_squared = 8'b0; data_b_squared = 8'b0; data_c_squared = 8'b0; data_d_squared = 8'b0; data_e_squared = 8'b0; data_f_squared = 8'b1; data_g_squared = 8'b0;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'hF) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'hF) begin
      $display("F works");
   end

   data_a_squared = 8'b0; data_b_squared = 8'b0; data_c_squared = 8'b0; data_d_squared = 8'b0; data_e_squared = 8'b0; data_f_squared = 8'b0; data_g_squared = 8'b1;
   repeat(4) @(negedge clk_i);
   if(data_out !== 4'h6) begin
      `FINISH_WITH_FAIL
   end else if(data_out === 4'h6) begin
      $display("G works");
   end

      //------------------------------------------------------------------------------------

      $display();
      $display("Input Generator, Start.");

      // Input sinusoidal audio
      audio_il = '0;
      do begin
         // Randomly decide when to transmit data
         valid_il = ($urandom_range(0, 1) == 1);
         if(valid_il) begin
            // Approx 440 Hz wave.
            audio_il = $sin(440 * (wr_count * 2 * (2 * $asin(1))) /(44000)) * (1024);
            $display("%d: %d or %f", wr_count, audio_il, audio_il/1024.0 );
         end else begin
            audio_il = 0;
         end

         // If we decided to transmit data, iterate until it was read
         // into the DUT.

         // wr_success is set in an always_ff block and
         // indicates a successfull input handshake on the LAST
         // posedge.
         do begin
           @(negedge clk_i);
         end while((valid_il == 1'b1) && (wr_success == 1'b0));

         valid_il = 0;
         @(negedge clk_i);

         // Simulate approximately 1 second of time.
      end while(wr_count < 44000);

      // This will eventually terminate simulation.
      input_done = 1;
   end
   
   // This block executes after $finish() has been called.
   final begin
      $display("Simulation time is %t", $time);
      if(error_o === 1) begin
	 $display("\033[0;31m    ______                    \033[0m");
	 $display("\033[0;31m   / ____/_____________  _____\033[0m");
	 $display("\033[0;31m  / __/ / ___/ ___/ __ \\/ ___/\033[0m");
	 $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
	 $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
	 $display("Simulation Failed");
     end else if (pass_o === 1) begin
	 $display("\033[0;32m    ____  ___   __________\033[0m");
	 $display("\033[0;32m   / __ \\/   | / ___/ ___/\033[0m");
	 $display("\033[0;32m  / /_/ / /| | \\__ \\\__ \ \033[0m");
	 $display("\033[0;32m / ____/ ___ |___/ /__/ / \033[0m");
	 $display("\033[0;32m/_/   /_/  |_/____/____/  \033[0m");
	 $display();
	 $display("Simulation Succeeded!");
     end else begin
        $display("   __  ___   ____ __ _   ______ _       ___   __");
        $display("  / / / / | / / //_// | / / __ \\ |     / / | / /");
        $display(" / / / /  |/ / ,<  /  |/ / / / / | /| / /  |/ / ");
        $display("/ /_/ / /|  / /| |/ /|  / /_/ /| |/ |/ / /|  /  ");
        $display("\\____/_/ |_/_/ |_/_/ |_/\\____/ |__/|__/_/ |_/   ");
	$display("Please set error_o or pass_o!");
     end
   end

endmodule
