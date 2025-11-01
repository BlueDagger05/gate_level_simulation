module sample_tb();

`ifdef DELAY 3
	initial begin
		$display(" three");
	end
`elsif DELAY 4
	initial begin
		$display( "four" );
	end
`else 
	initial begin
		$display (" uno ");
	end
`endif
endmodule 
