module clock(rst_n,key_rst,clk,key_ps,a,b,c,d,e,f,g,h,led1,led2,led3,led4);
   input   clk,rst_n;
   
   input   key_rst;
   reg     [3:0]stcur_keyrst,stnext_keyrst,ms10_cnt_keyrst;
   wire    key_rst_en,ms10_en_keyrst;
   localparam
           IDLERST = 4'b0001,
		   KEYRST_1ST = 4'b0010,
		   KEYRST_2ND = 4'b0011;
		   
   input   key_ps;
   reg     [3:0]stcur_keyps,stnext_keyps,ms10_cnt_keyps;
   wire    key_ps_en,ms10_en_keyps;
   localparam
           IDLEPS = 4'b0001,
		   KEYPS_1ST = 4'b0010,
		   KEYPS_2ND = 4'b0011;
   
   reg      [3:0]stcur_counter,stnext_counter,k;
   reg      [3:0]numcount4,numcount3,numcount2,numcount1;
   localparam
            TORST = 4'b0001,
		    COUNT = 4'b0010,
		    PAUSE = 4'b0011;
			
	output  a,b,c,d,e,f,g,h,led1,led2,led3,led4;		
	reg     [3:0]stcur_led,stnext_led,inpnum;
    reg     a,b,c,d,e,f,g,h,led1,led2,led3,led4;
	  
    localparam
            bit1 = 4'b0001,
		    bit2 = 4'b0010,
		    bit3 = 4'b0011,
			bit4 = 4'b0100;
			
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    stcur_keyrst <= IDLERST;
    else
    stcur_keyrst <= stnext_keyrst;
end

always @(stcur_keyrst or key_rst or ms10_en_keyrst)
begin
  case (stcur_keyrst)
  IDLERST: if (key_rst) stnext_keyrst <= KEYRST_1ST;
           else stnext_keyrst<= IDLERST;
  KEYRST_1ST: 
           if (!key_rst) stnext_keyrst<=IDLERST;
           else
             begin
               if (ms10_en_keyrst)
               stnext_keyrst<=KEYRST_2ND;
               else stnext_keyrst<=KEYRST_1ST;
             end
  KEYRST_2ND: 
           if (!key_rst) stnext_keyrst<=IDLERST;
           else stnext_keyrst<=KEYRST_2ND;
  default: stnext_keyrst <= IDLERST;
  endcase
end

// 对应各状态下的输出
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
  ms10_cnt_keyrst <= 4'h0;
  else
    begin
      case(stnext_keyrst)
      IDLERST: 
	    ms10_cnt_keyrst <= 4'h0;
      KEYRST_1ST:
        ms10_cnt_keyrst <= ms10_cnt_keyrst+1;
      KEYRST_2ND:
        ms10_cnt_keyrst <= 4'h0;
      default:
        ms10_cnt_keyrst <= 4'h0;
      endcase
    end
end

assign ms10_en_keyrst= (ms10_cnt_keyrst == 4'ha)?1:0;
assign key_rst_en= (ms10_cnt_keyrst == 4'ha)?1:0; 

 always @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
   stcur_keyps <= IDLEPS;
  else
   stcur_keyps <= stnext_keyps;
end

   always @(stcur_keyps or key_ps or ms10_en_keyps)
begin
   case (stcur_keyps)
   IDLEPS: 
      if (key_ps) stnext_keyps <= KEYPS_1ST;
      else stnext_keyps<= IDLEPS;
   KEYPS_1ST: 
      if (!key_ps) stnext_keyps<=IDLEPS;
      else
        begin
          if (ms10_en_keyps)
          stnext_keyps<=KEYPS_2ND;
          else stnext_keyps<=KEYPS_1ST;
        end
   KEYPS_2ND: 
      if (!key_ps) stnext_keyps<=IDLEPS;
      else stnext_keyps<=KEYPS_2ND;
   default: stnext_keyps <= IDLEPS;
   endcase
end

// 对应各状态下的输出
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n)
  ms10_cnt_keyps <= 4'h0;
  else
    begin
      case(stnext_keyps)
        IDLEPS: 
		ms10_cnt_keyps <= 4'h0;
        KEYPS_1ST:
        ms10_cnt_keyps <= ms10_cnt_keyps+1;
        KEYPS_2ND:
        ms10_cnt_keyps <= 4'h0;
        default:
        ms10_cnt_keyps <= 4'h0;
      endcase
    end
end

assign ms10_en_keyps= (ms10_cnt_keyps == 4'ha)?1:0;
assign key_ps_en= (ms10_cnt_keyps == 4'ha)?1:0;



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
numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;k<=0;
end
else
  begin 
    if(key_rst_en) 
	begin 
	numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;
	k<=0;
	end
    else 
      begin
	    case(stnext_counter)
	    TORST:
		begin 
		numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;
		k <= 0;
		end
	    COUNT:
		begin 
		 k <= k+1;
		 if(k==4'h9)
		  begin 
		   numcount4 <= numcount4 + 1; k <=0;
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
		numcount4 <= numcount4; numcount3 <= numcount3;numcount2 <= numcount2;numcount1 <= numcount1;k <= 0;
		end
	    default:
		begin  
		numcount4 <= 4'D0; numcount3 <= 4'D0;numcount2 <= 4'D0;numcount1 <= 4'D0;k <= 0;
		end
	    endcase
	  end
  end
  


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
		inpnum <= numcount1;
		h = 0;
		led1 = 1;
		led2 = 0;
		led3 = 0;
		led4 = 0;
		end
		bit2 :
		begin
		inpnum <= numcount2;
		h = 1;
		led1 = 0;
		led2 = 1;
		led3 = 0;
		led4 = 0;
		end
		bit3 :
		begin 
		inpnum <= numcount3;
		h = 0;
		led1 = 0;
		led2 = 0;
		led3 = 1;
		led4 = 0;
		end
		bit4 :
		begin 
		inpnum <= numcount4;
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