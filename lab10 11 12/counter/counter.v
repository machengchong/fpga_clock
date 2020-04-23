module counter(key_rst_en,key_ps_en,clk,numcount4_out,rst_n,numcount3_out,numcount2_out,numcount1_out);
    input    key_rst_en,key_ps_en,clk,rst_n;
	output   numcount4_out,numcount3_out,numcount2_out,numcount1_out;
	
	reg      [3:0]stcur_counter,stnext_counter,a;
	reg      [3:0]numcount4,numcount3,numcount2,numcount1;
	wire     [3:0]numcount4_out,numcount3_out,numcount2_out,numcount1_out;
	localparam
            TORST = 4'b0001,
		    COUNT = 4'b0010,
		    PAUSE = 4'b0011;


always @(stcur_counter or key_rst_en or key_ps_en)
begin
   case (stcur_counter)
TORST: 
     begin
       if(key_ps_en) stnext_counter<= COUNT;
         else stnext_counter<= TORST;
     end
COUNT: 
     if (key_rst_en) stnext_counter<=TORST;
         else
           begin
             if(key_ps_en) stnext_counter<=PAUSE;
             else stnext_counter<=COUNT;
		   end
PAUSE:
     if (key_rst_en) stnext_counter<=TORST;
         else
           begin
             if(key_ps_en) stnext_counter<=COUNT;
                else stnext_counter<=PAUSE;
           end
default: stnext_counter <= TORST;
   endcase
end

always @(posedge clk or posedge key_rst_en or negedge rst_n)
if (!rst_n) stcur_counter<=TORST;
else
 begin
     if(key_rst_en) stcur_counter <= TORST;
     else   stcur_counter <= stnext_counter;
 end

always @(posedge clk or posedge key_rst_en or negedge rst_n)
if (!rst_n) 
begin
numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;
end
else
  begin 
    if(key_rst_en) 
	begin 
	numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;
	a<=0;
	end
    else 
      begin
	    case(stnext_counter)
	    TORST:
		begin 
		numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;
		a <= 0;
		end
	    COUNT:
		begin 
		 a <= a+1;
		 if(a==4'h9)
		  begin 
		   numcount4 <= numcount4 + 1; a <=0;
		   if (numcount4 == 4'h9) 
		   begin 
		   numcount4 <= 4'h0;
		   numcount3 <= numcount3 + 1;
		   if(numcount3 == 4'h9)
		      begin 
		      numcount3 <= 4'h0;
		      numcount2 <= numcount2 + 1;
			  if(numcount2 == 4'h9)
			     begin 
		         numcount2 <= 4'h0;
		         numcount1 <= numcount1 + 1;
			     end
		      end
		   end 
		 end
		end
	    PAUSE:
		begin  
		numcount4 <= numcount4; numcount3 <= numcount3;numcount2 <= numcount2;numcount1 <= numcount1;a <= 0;
		end
	    default:
		begin  
		numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;a <= 0;
		end
	    endcase
	  end
  end
  assign numcount4_out = numcount4;
  assign numcount3_out = numcount3;
  assign numcount2_out = numcount2;
  assign numcount1_out = numcount1;

endmodule
