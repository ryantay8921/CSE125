module hex2ssd
  (input [3:0] hex_i
  ,output [6:0] ssd_o
  );

  logic [6:0] ssd_temp;
  assign ssd_o = ssd_temp;
  
  always_comb begin
    case(hex_i) 
            //Segment A = header J1-1
            //Segment B = header J1-2
            //Segment C = header J1-3
            //Segment D = header J1-4
            //Segment E = header J2-1
            //Segment F = header J2-2
            //Segment G = header J2-3
            //                         GFEDCBA
            4'h0:  begin ssd_temp = 7'b1000000; end // 0
            4'h1:  begin ssd_temp = 7'b1111001; end // 1 
            4'h2:  begin ssd_temp = 7'b0100100; end // 2
            4'h3:  begin ssd_temp = 7'b0110000; end // 3
            4'h4:  begin ssd_temp = 7'b0011001; end // 4
            4'h5:  begin ssd_temp = 7'b0010010; end // 5
            4'h6:  begin ssd_temp = 7'b0000010; end // 6
            4'h7:  begin ssd_temp = 7'b1111000; end // 7
            4'h8:  begin ssd_temp = 7'b0000000; end // 8
            4'h9:  begin ssd_temp = 7'b0011000; end // 9
            4'hA:  begin ssd_temp = 7'b0001000; end // A
            4'hB:  begin ssd_temp = 7'b0000011; end // B
            4'hC:  begin ssd_temp = 7'b1000110; end // C
            4'hD:  begin ssd_temp = 7'b0100001; end // D
            4'hE:  begin ssd_temp = 7'b0000110; end // E
            4'hF:  begin ssd_temp = 7'b0001110; end // F
            default:  ssd_temp = 7'b1111111; 
    endcase 
  end 
endmodule 
