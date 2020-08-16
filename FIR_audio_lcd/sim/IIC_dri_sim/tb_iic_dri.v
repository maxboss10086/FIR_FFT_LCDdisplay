`timescale 1ns/1ns
module spi_dri_tb;

	// Inputs
	reg [7:0] in_data;
	reg clk;
	reg [1:0] addr;
	reg wr;
	reg rd;
	wire cs_n;
	reg miso;
    reg rst_n;
	// Outputs
	wire [7:0] out_data;

	// Bidirs
	wire mosi;
	wire sclk;

	// Instantiate the Unit Under Test (UUT)
	i2c_dri i2c_dri_inst (
        .clk                (clk),
		.rst_n              (rst_n),
         //input         
        .i2c_exec           (1'b1),
		.bit_ctrl           (1'b1),
		.i2c_rh_wl          (1'b0),
		.i2c_addr           (16'b1010_1010),   
		.i2c_data_w         (in_data),
        //output
		.i2c_data_r         (i2c_data_r),
		.i2c_done           (i2c_done),
        //芯片接口
        .scl                (scl),
		.sda                (sda),
		
	    .dri_clk            (dri_clk)
        
       
);         
         
	initial        begin
		// Initialize Inputs
		in_data = 0;
		clk = 0;
        rst_n = 0;
		// set clk_div , and out by out_data
		#40;
        in_data = 8'haa;
        rst_n = 1;
		
		// write data 
		
		

		
	end


	// define clock
	always #10 clk = ~clk;

      
endmodule

