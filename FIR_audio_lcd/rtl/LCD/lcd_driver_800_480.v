//****************************************Copyright (c)***********************************//
// 网站博客: NC 
// 版权所有, 盗版必究 
// Copyright (c) 2020
// ALL right reserved
//----------------------------------------------------------------------------------------//
// File name: 		xxx.v
// Descriptions: 	LCD800*480屏幕分辨率的像素驱动
// Author: 		Max
// Creation Date:	Tue Jan 14 2018 13:15:29 GMT+0800
//----------------------------------------------------------------------------------------//
// Note:
//
//----------------------------------------------------------------------------------------//
//****************************************************************************************//



//输出像素点坐标
//输入屏显示图案
//令图案在有效像素点期间显示
module lcd_driver_800_480(
    input           			lcd_clk,      //lcd模块驱动时钟
    input           			sys_rst_n,    //复位信号
    //RGB LCD接口   	   	   	                 
    output          			lcd_hs,       //LCD 行同步信号
    output          			lcd_vs,       //LCD 场同步信号
    output          			lcd_de,       //LCD 数据输入使能
    output  		[15:0]  		lcd_rgb,      //LCD RGB565颜色数据
    output  		        		lcd_bl,       //LCD 背光控制信号
    output  		        		lcd_rst,      //LCD 复位信号
    output  		        		lcd_pclk,     //LCD 采样时钟
            		        		
    input   		[15:0]  		pixel_data,   //像素点数据，屏幕显示什么
    output  		        		data_req  ,   //请求像素点颜色数据输入 
    output  		[10:0]  		pixel_xpos,   //像素点横坐标
    output  		[10:0]  		pixel_ypos    //像素点纵坐标
    );                             
                                                        
//parameter define  
parameter  H_SYNC   =  11'd128;   //行同步
parameter  H_BACK   =  11'd88;    //行显示后沿
parameter  H_DISP   =  11'd800;   //行有效数据
parameter  H_FRONT  =  11'd40;    //行显示前沿
parameter  H_TOTAL  =  11'd1056;  //行扫描周期

parameter  V_SYNC   =  11'd2;     //场同步
parameter  V_BACK   =  11'd33;    //场显示后沿
parameter  V_DISP   =  11'd480;   //场有效数据
parameter  V_FRONT  =  11'd10;    //场显示前沿
parameter  V_TOTAL  =  11'd525;   //场扫描周期
          
//reg define                                     
reg  	[10:0] cnt_h;
reg  	[10:0] cnt_v;

//wire define
wire       lcd_en;

//*****************************************************
//**                    main code
//*****************************************************
assign lcd_bl   = 1'b1;           //RGB LCD显示模块背光控制信号
assign lcd_rst  = 1'b1;           //RGB LCD显示模块系统复位信号
assign lcd_pclk = lcd_clk;        //RGB LCD显示模块采样时钟

//RGB LCD 采用数据输入使能信号同步时，行场同步信号需要拉高
assign lcd_de  = lcd_en;          //LCD输入的颜色数据采用数据输入使能信号同步
assign lcd_hs  = 1'b1;
assign lcd_vs  = 1'b1;

//像素点计算						
//行计数器对像素时钟计数
always 	@(posedge lcd_clk or negedge sys_rst_n) begin         
    		if (!sys_rst_n)
        		cnt_h <= 11'd0;                                  
    		else begin
        		if(cnt_h < H_TOTAL - 1'b1)                                               
            		cnt_h <= cnt_h + 1'b1;                               
        		else 
            		cnt_h <= 11'd0;  
    		end
end
//场计数器对行计数(列像素点计数)
always 	@(posedge lcd_clk or negedge sys_rst_n) begin         
    		if (!sys_rst_n)
        		cnt_v <= 11'd0;                                  
    		else if(cnt_h == H_TOTAL - 1'b1) begin
        		if(cnt_v < V_TOTAL - 1'b1)                                               
            		cnt_v <= cnt_v + 1'b1;                               
        		else 
           		 cnt_v <= 11'd0;  
   		end
end

//有效像素点前一点，输出显示数据请求信号
//在行信号有效期间都拉高                
assign 	data_req = (((cnt_h >= H_SYNC+H_BACK-1'b1) && (cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
                  && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                  ?  1'b1 : 1'b0;
//请求信号之后，读入数据，对输入数据进行标记，表示这段时间有数据
assign 	lcd_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                 &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                 ?  1'b1 : 1'b0;
//有数据的时候输出显示数据                
assign 	lcd_rgb = lcd_en ? pixel_data : 16'd0;
//经典数据处理：提前发出数据请求，对读入的数据进行标记，有数据的时候对接口引脚赋值输出

			
//如果输入的数据不是RGB数据可以直接显示 ，则输出坐标像素点进入display模块进行处理               
assign 	pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 11'd0;
assign 	pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 11'd0;







endmodule 