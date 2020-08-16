//****************************************Copyright (c)***********************************//
// 网站博客: NC 
// 版权所有, 盗版必究 
// Copyright (c) 2020
// ALL right reserved
//----------------------------------------------------------------------------------------//
// File name: 		xxx.v
// Descriptions: 	输出一帧数据内所有频率的取模信号
// Author: 		Max
// Creation Date:	Tue Jan 14 2020 13:51:00 GMT+0800
//----------------------------------------------------------------------------------------//
// Note:
//
//----------------------------------------------------------------------------------------//
//****************************************************************************************//



module  data_modulus(
    input             		clk_50m,
    input             		rst_n,
    
    input   		[15:0]    source_real,
    input   		[15:0]    source_imag,
    input   		          source_sop,
    input   		          source_eop,
    input   		          source_valid,
            		
    output  		[15:0]    data_modulus,  
    output  reg       		data_sop,
    output  reg       		data_eop,
    output  reg       		data_valid
);
//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/

//reg define
reg 		[31:0] 	source_data;
reg 		[15:0] 	data_real;
reg 		[15:0] 	data_imag;
reg 		       	data_sop1;
reg 		       	data_sop2;
reg 		       	data_eop1;
reg 		       	data_eop2;
reg 		       	data_valid1;
reg 		       	data_valid2;
    	
//=============================================================================
//**************    Main Code   **************
//=============================================================================


//取实部和虚部的平方和
//数据计算后比源数据延迟一个时钟
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        source_data <= 32'd0;
        data_real   <= 16'd0;
        data_imag   <= 16'd0;
    end
    else begin
        if(source_real[15]==1'b0)               //由FFT实部补码计算原码
            data_real <= source_real;
        else
            data_real <= ~source_real + 1'b1;
            
        if(source_imag[15]==1'b0)               //由FFT虚部补码计算原码
            data_imag <= source_imag;
        else
            data_imag <= ~source_imag + 1'b1;            
                                                //计算原码平方和
        source_data <= (data_real*data_real) + (data_imag*data_imag);
    end
end

//例化sqrt模块，开根号运算
sqrt sqrt_inst (
    .clk              (clk_50m),
    .radical          (source_data),
    
    .q                (data_modulus),
    .remainder        ()
    );
    
//数据取模运算共花费了三个时钟周期，此处延时三个时钟周期
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        data_sop    <= 1'b0;
        data_sop1   <= 1'b0;
        data_sop2   <= 1'b0;
        data_eop    <= 1'b0;
        data_eop1   <= 1'b0;
        data_eop2   <= 1'b0;
        data_valid  <= 1'b0;
        data_valid1 <= 1'b0;
        data_valid2 <= 1'b0;
    end
    else begin
        data_valid1 <= source_valid;
        data_valid2 <= data_valid1;
        data_valid  <= data_valid2;
        data_sop1   <= source_sop;
        data_sop2   <= data_sop1;
        data_sop    <= data_sop2;
        data_eop1   <= source_eop;
        data_eop2   <= data_eop1;
        data_eop    <= data_eop2;
    end
end
    
endmodule 