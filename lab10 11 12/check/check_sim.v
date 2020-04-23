`timescale 1 us/1 us
module check_sim();
   reg     clk,rst_n,key_rst,key_ps;
   wire    key_rst_en,key_ps_en;
   
   
check u1 (
     .clk(clk),
	 .rst_n(rst_n),
	 .key_rst(key_rst),
	 .key_rst_en(key_rst_en),
	 .key_ps(key_ps),
	 .key_ps_en(key_ps_en)

);

initial
begin
 
  rst_n =      1'b0;
  rst_n = #500 1'b1;
end 

always
begin
  clk =      1'b0;
  clk = #500 1'b1;
        #500;
       
end

initial
begin
  key_rst =        1'b0;
  key_rst = #1000 1'b1;
  key_rst = #5000  1'b0;
  key_rst = #5000 1'b1;
  key_rst = #11000 1'b0;
  
end 
initial
begin
  key_ps =        1'b0;
  key_ps = #2000 1'b1;
  key_ps = #5000  1'b0;
  key_ps = #5000 1'b1;
  key_ps = #11000 1'b0;
  
end 
endmodule