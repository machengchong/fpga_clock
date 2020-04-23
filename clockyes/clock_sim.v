`timescale 1 us/1 us
module clock_sim();
   reg     clk,rst_n,key_rst,key_ps;
   wire    a,b,c,d,e,f,g,h,led1,led2,led3,led4;
   
   
clock u1 (
     .clk(clk),
	 .rst_n(rst_n),
	 .key_rst(key_rst),
	 .key_ps(key_ps),
	 .a(a),
	 .b(b),
	 .c(c),
	 .d(d),
	 .e(e),
	 .f(f),
	 .g(g),
	 .h(h),
	 .led1(led1),
	 .led2(led2),
	 .led3(led3),
	 .led4(led4)

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
  key_rst = #90000000 1'b1;
  key_rst = #11000 1'b0;
  
end 
initial
begin
  key_ps =        1'b0;
  key_ps = #2000 1'b1;
  key_ps = #15000  1'b0;
  key_ps = #70000000 1'b1;
  key_ps = #11000 1'b0;
  key_ps = #110000 1'b1;
  key_ps = #11000 1'b0;
end 
endmodule