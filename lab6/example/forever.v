module Gen_Clk_D(Clk_D);
	output ClkD ;
	reg ClkD ;
	parameter START_DELAY = 5, LOW_TIME = 2, HIGH_TIME = 3;

	initial
	begin
		Clk_D = 0;
		#STARTDELAY ;
		forever
		begin
			#LOW_TIME ;
			Clk_D = 1;
			#HIGHTIME;
			Clk_D = 0;
		end
	end
endmodule