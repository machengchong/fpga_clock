module led(clk,numcount4_out,numcount3_out,numcount2_out,numcount1_out,a,b,c,d,e,f,g,h,led1,led2,led3,led4);
      input   clk;
      input   [3:0]numcount4_out,numcount3_out,numcount2_out,numcount1_out;
	  output  a,b,c,d,e,f,g,h,led1,led2,led3,led4;
	  
	  reg     [3:0]stcur_led,stnext_led,inpnum;
	  reg     a,b,c,d,e,f,g,h,led1,led2,led3,led4;
	  
      localparam
            bit1 = 4'b0001,
		    bit2 = 4'b0010,
		    bit3 = 4'b0011,
			bit4 = 4'b0100;

always @(posedge clk)
      stcur_led <= stnext_led;

always @(clk)
begin
   case (stcur_led)
bit1: 
         stnext_led<= bit2;
    
bit2: 
     
         stnext_led<=bit3;
		  
bit3:
         stnext_led<=bit4;
		 
bit4:
         stnext_led<=bit1;
		 
default: stnext_led <= bit1;
   endcase
end

always @(posedge clk)
begin
	    case(stnext_led)
		bit1 : 
		begin
		inpnum <= numcount1_out;
		h = 0;
		led1 = 1;
		led2 = 0;
		led3 = 0;
		led4 = 0;
		end
		bit2 :
		begin
		inpnum <= numcount2_out;
		h = 1;
		led1 = 0;
		led2 = 1;
		led3 = 0;
		led4 = 0;
		end
		bit3 :
		begin 
		inpnum <= numcount3_out;
		h = 0;
		led1 = 0;
		led2 = 0;
		led3 = 1;
		led4 = 0;
		end
		bit4 :
		begin 
		inpnum <= numcount4_out;
		h = 0;
		led1 = 0;
		led2 = 0;
		led3 = 0;
		led4 = 1;
		end
		endcase
end

always@ (inpnum) 
begin
  case(inpnum)
    4'b0000:
	begin
      a <= 1;
      b <= 1;
      c <= 1;
      d <= 1;
      e <= 1;
      f <= 1;
      g <= 0;
    end 
	4'b0001:
	begin
      a <= 0;
      b <= 1;
      c <= 1;
      d <= 0;
      e <= 0;
      f <= 0;
      g <= 0;
    end 
	4'b0010:
	begin
      a <= 1;
      b <= 1;
      c <= 0;
      d <= 1;
      e <= 1;
      f <= 0;
      g <= 1;
    end 
	4'b0011:
	begin
      a <= 1;
      b <= 1;
      c <= 1;
      d <= 1;
      e <= 0;
      f <= 0;
      g <= 1;
    end 
	4'b0100:
	begin
      a <= 0;
      b <= 1;
      c <= 1;
      d <= 0;
      e <= 0;
      f <= 1;
      g <= 1;
    end 
	4'b0101:
	begin
      a <= 1;
      b <= 0;
      c <= 1;
      d <= 1;
      e <= 0;
      f <= 1;
      g <= 1;
    end 
	4'b0110:
	begin
      a <= 0;
      b <= 0;
      c <= 1;
      d <= 1;
      e <= 1;
      f <= 1;
      g <= 1;
    end 
	4'b0111:
	begin
      a <= 1;
      b <= 1;
      c <= 1;
      d <= 0;
      e <= 0;
      f <= 0;
      g <= 0;
    end 
	4'b1000:
	begin
      a <= 1;
      b <= 1;
      c <= 1;
      d <= 1;
      e <= 1;
      f <= 1;
      g <= 1;
    end 
	4'b1001:
	begin
      a <= 1;
      b <= 1;
      c <= 1;
      d <= 0;
      e <= 0;
      f <= 1;
      g <= 1;
    end 
  endcase
end
endmodule