`timescale 1 us/1 us
module counter_sim();
    reg    key_rst_en,key_ps_en,clk,rst_n;
	wire     [3:0]numcount4_out,numcount3_out,numcount2_out,numcount1_out;
counter u1 (
     .rst_n(rst_n),
     .clk(clk),
	 .numcount4_out(numcount4_out),
	 .numcount3_out(numcount3_out),
	 .numcount2_out(numcount2_out),
	 .numcount1_out(numcount1_out),
	 .key_rst_en(key_rst_en),
	 .key_ps_en(key_ps_en)

);

always
begin
  clk =      1'b0;
  clk = #500 1'b1;
        #500;
       
end

initial
begin
 
  rst_n =      1'b0;
  rst_n = #500 1'b1;
end 



initial
begin
  key_ps_en =       1'b0;
  key_ps_en = #3000 1'b1;
  key_ps_en = #1000 1'b0;
  key_ps_en = #100500 1'b1;
  key_ps_en = #1000 1'b0;
  key_ps_en = #20000 1'b1;
  key_ps_en = #1000 1'b0;
end 

initial
begin
  key_rst_en = 1'b0;
  key_rst_en = #25000000 1'b1;
  key_rst_en = #1000 1'b0;
end 

endmodule