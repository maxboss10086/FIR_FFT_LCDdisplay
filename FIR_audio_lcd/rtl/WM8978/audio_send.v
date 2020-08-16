//****************************************Copyright (c)***********************************//
// 网站博客: NC 
// 版权所有, 盗版必究 
// Copyright (c) 2020
// ALL right reserved
//----------------------------------------------------------------------------------------//
// File name: 		xxx.v
// Descriptions: 	将低通滤波后的音频发送出去播放
// Author: 		Max
// Creation Date:	Tue Jan 14 2018 13:11:45 GMT+0800
//----------------------------------------------------------------------------------------//
// Note:
//
//----------------------------------------------------------------------------------------//
//****************************************************************************************//



module audio_send #(parameter WL = 6'd32) (    // WL(word length音频采样精度定义)
    //system reset
    input                  rst_n     ,         // 复位信号

    //wm8978 interface
    input                  aud_bclk  ,         // WM8978位时钟
    input                  aud_lrc   ,         // 对齐信号
    output   reg           aud_dacdat,         // 音频数据输出
    //user interface
    input         [31:0]   dac_data  ,         // 预输出的音频数据
    output   reg           tx_done             // 发送一次音频位数完成
);

//reg define
reg              aud_lrc_d0;                   // 延迟一个时钟周期
reg    [ 5:0]    tx_cnt;                       // 发送数据计数
reg    [31:0]    dac_data_t;                   // 预输出的音频数据的暂存值

//wire define
wire             lrc_edge;                     // 边沿信号

//*****************************************************
//**                    main code
//*****************************************************



//为了在aud_lrc变化的第二个AUD_BCLK上升沿采集aud_adcdat,延迟打拍采集
always 	@(posedge aud_bclk or negedge rst_n) begin
    		if(!rst_n) begin
        		aud_lrc_d0 <= 1'b0;
   		end
    		else
        		aud_lrc_d0 <= aud_lrc;
end
assign  	lrc_edge = aud_lrc ^ aud_lrc_d0;     // LRC信号的边沿检测

//发送32位音频数据的计数
always 	@(posedge aud_bclk or negedge rst_n) begin
    		if(!rst_n) begin
        		tx_cnt     <=  6'd0;
        		dac_data_t <= 32'd0;
    		end
    		else if(lrc_edge == 1'b1) begin
        		tx_cnt     <= 6'd0;
        		dac_data_t <= dac_data;
    		end
    		else if(tx_cnt < 6'd35)
        		tx_cnt <= tx_cnt + 1'b1;
end

//发送完成信号
always @(posedge aud_bclk or negedge rst_n) begin
    		if(!rst_n) begin
        		tx_done <= 1'b0;
    		end
    		else if(tx_cnt == 6'd32)
        		tx_done <= 1'b1;
    		else
        		tx_done <= 1'b0;
end

//把预发送的音频数据串行发送出去
always 	@(negedge aud_bclk or negedge rst_n) begin
    		if(!rst_n) begin
        		aud_dacdat <= 1'b0;
    		end
    		else if(tx_cnt < WL)
        		aud_dacdat <= dac_data_t[WL - 1'd1 - tx_cnt];
    		else
        		aud_dacdat <= 1'b0;
end

endmodule