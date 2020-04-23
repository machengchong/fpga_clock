`timescale 1 us/1 us
module ledsim();
   reg  clk;
   reg  [3:0]numcount4_out,numcount3_out,numcount2_out,numcount1_out;
   wire a,b,c,d,e,f,g,h,led1,led2,led3,led4;
led u1(
     .clk(clk),
	 .numcount1_out(numcount1_out),
	 .numcount2_out(numcount2_out),
	 .numcount3_out(numcount3_out),
	 .numcount4_out(numcount4_out),
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

always
begin
  clk =      1'b0;
  clk = #500 1'b1;
        #500;
       
end

initial
begin
 
  numcount4_out =        4'd3;
  numcount4_out = #10000 4'd4;
  numcount4_out = #10000 4'd5;
end 
initial
begin
 
  numcount3_out =        4'd6;

end 
initial
begin
 
  numcount2_out =        4'd5;

end
initial
begin
 
  numcount1_out =        4'd2;

end
endmodule