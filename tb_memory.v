`timescale 1ns/1ps
// `ifdef SDF_TEST
//     supply1 VPWR;
//     supply0 VGND;
//     supply1 VPB ;
//     supply0 VNB ;
//     `endif
`ifdef SDF_TEST
	`include "/home/demon/regression/gls/memory.v"
`else
	`include "/home/demon/regression/rtl/memory.v"
`endif
module tb_memory;

reg clk;
reg reset_n;
reg [3:0] addr_in;
reg [15:0] data_in;
reg wr_en;
reg op_en;
reg cs;
wire [15:0] data_out;
wire [255:0] data_max;

memory memory_i (
	.clk     ( clk ),
	.reset_n ( reset_n ),
	.addr_in ( addr_in ),
	.data_in ( data_in ),
	.wr_en   ( wr_en   ),
	.op_en   ( op_en   ),
	.cs      ( cs      ),
	//.data_max ( data_max ),
	.data_out( data_out));

`ifdef SDF_TEST
initial begin
	$sdf_annotate("/home/demon/regression/gls/memory.sdf", // SDF FILE
		      memory_i,                     // INSTANCE_NAME
		      ,                             // CONFIG_FILE
		      "sdf.log",                    // LOG_FILE
		      "MINIMUM",                    // mtm_spec : "MINIMUM" | "TYPICAL" | "MAXIMUM"
	              );
	//$sdf_annotate("/home/demon/gls/memory.sdf", memory_i, , , "sdf.log","MAXIMUM");
end
`endif

initial begin
	clk = 0;
	reset_n = 0;
	addr_in = 0;
	data_in = 0;
	wr_en   = 0;
	op_en   = 0;
	cs      = 0;

	#1000 reset_n = 1'b1;
end

always #10 clk = ~clk;

initial begin
	wait ( reset_n );
		fork 
			#2 wr_en = 1'b1;
			#2 op_en = 1'b1;
			#2 cs    = 1'b1;
		join
	repeat ( 16 ) begin
		@ ( posedge clk ); 
		fork
			#2; addr_in = addr_in + 1'b1;
		        #2; data_in = $random();
		join 
	end
	wr_en = 1'b0;
	op_en = 1'b0;
	cs    = 1'b0;
	reset_n = 1'b0;
	#1000 reset_n = 1'b1;

	repeat ( 100 ) begin
		@ ( posedge clk );
        end

	// read opertaion 
	fork 
		#2 wr_en = 1'b0;
		#2 op_en = 1'b1;
		#2 cs    = 1'b1;
	join
	repeat ( 16 ) begin
		@ ( posedge clk ); #2 addr_in = addr_in + 1'b1;
		@ ( posedge clk );
	end
end

initial begin
	$monitor( "%0t :: READ DATA : ADDR %0h  : DATA %0h ", $time, addr_in, data_out);
end
endmodule // tb_memory
