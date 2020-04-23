module check(rst_n,key_rst,key_rst_en,clk,key_ps,key_ps_en);
   input   clk,rst_n;
   
   input   key_rst;
   output  key_rst_en;
   reg     [3:0]stcur_keyrst,stnext_keyrst,ms10_cnt_keyrst;
   wire    key_rst_en,ms10_en_keyrst;
   localparam
           IDLERST = 4'b0001,
		   KEYRST_1ST = 4'b0010,
		   KEYRST_2ND = 4'b0011;
		   
   input   key_ps;
   output  key_ps_en;
   reg     [3:0]stcur_keyps,stnext_keyps,ms10_cnt_keyps;
   wire    key_ps_en,ms10_en_keyps;
   localparam
           IDLEPS = 4'b0001,
		   KEYPS_1ST = 4'b0010,
		   KEYPS_2ND = 4'b0011;
   
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
endmodule