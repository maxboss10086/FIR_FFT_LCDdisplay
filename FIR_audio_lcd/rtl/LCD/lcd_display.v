//****************************************Copyright (c)***********************************//
// 网站博客: NC 
// 版权所有, 盗版必究 
// Copyright (c) 2020
// ALL right reserved
//----------------------------------------------------------------------------------------//
// File name: 		xxx.v
// Descriptions: 	LCD显示模块
// Author: 		Max
// Creation Date:	Tue Jan 14 2020 14:05:14 GMT+0800
//----------------------------------------------------------------------------------------//
// Note:
//		1LCD分辨率800*480,CMOS分辨率600*480,将CMOS像素数据在LCD中间位置显示
//		2在前一点发出数据请求信号，读入数据，根据坐标输出显示什么
//----------------------------------------------------------------------------------------//
//****************************************************************************************//

module lcd_display(
    input             lcd_clk,                  //lcd驱动时钟
    input             sys_rst_n,                //复位信号
    
    input      [10:0] pixel_xpos,               //像素点横坐标
    input      [10:0] pixel_ypos,               //像素点纵坐标
    
    input      [6:0]  line_cnt,                 //频点
    input      [15:0] line_length,              //频谱数据
    output            data_req,                 //请求频谱数据
    output            wr_over,                  //绘制频谱完成
    output     [15:0] lcd_data                  //LCD像素点数据
    );    

//parameter define  
parameter  	H_LCD_DISP = 11'd800;                //LCD分辨率——行
localparam 	BLACK  = 16'b00000_000000_00000;     //RGB565 黑色
localparam 	WHITE  = 16'b11111_111111_11111;     //RGB565 白色

//*****************************************************
//**                    main code
//*****************************************************




//请求像素数据信号（这里加8是为了图像居中显示）
//在前一刻输出读取数据信号，使得在当前时刻有数据
assign data_req = ((pixel_ypos == line_cnt * 4'd6 + 4'd8 - 4'd1)//刚开始改的是8，没有解决无法显示的问题
                    && (pixel_xpos == H_LCD_DISP - 1)) ? 1'b1 : 1'b0;

//对读到的数据上色
assign lcd_data = ((pixel_ypos == line_cnt * 4'd6 + 4'd8)
                    && (pixel_xpos <= line_length)) ? WHITE : BLACK;

//wr_over标志着一个频点上的频谱绘制完成,该信号会触发line_cnt加1
assign wr_over  = ((pixel_ypos == line_cnt * 4'd6 + 4'd8)
                    && (pixel_xpos == H_LCD_DISP - 1)) ? 1'b1 : 1'b0;

endmodule 