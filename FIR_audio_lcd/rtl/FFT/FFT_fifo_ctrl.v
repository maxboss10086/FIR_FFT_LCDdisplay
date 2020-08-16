//****************************************Copyright (c)***********************************//
// 网站博客: NC 
// 版权所有, 盗版必究 
// Copyright (c) 2020
// ALL right reserved
//----------------------------------------------------------------------------------------//
// File name: 		xxx.v
// Descriptions: 	对FFT模块的FIFO IP核进行读数据控制
// Author: 		Max
// Creation Date:	Tue Jan 14 2020 13:35:37 GMT+0800
//----------------------------------------------------------------------------------------//
// Note: 1有数据的时候读出数据，对读出的数据进行128循环计数生成标记信号
//
//----------------------------------------------------------------------------------------//
//****************************************************************************************//








//读取FIFO中的数据，每128点标记为1帧，输入给FFT
//fft_valid信号是标记进入FFT IP核的有效信号，因为本实验中请求信号只有一个时钟，所以fft_valid应当也只有一个时钟，而不是在sop和eop之间都是高电平
module FFT_fifo_ctrl(
    input      			clk_50m,
    input      			rst_n,
  
    input      			fifo_rd_empty,
    output     			fifo_rdreq,
      
    input         			fft_ready,
    output 	reg    		fft_rst_n,
    output 	reg			fft_valid,
    output        			fft_sop,
    output        			fft_eop
);

//reg define
reg         state;
reg  [4:0]  delay_cnt;
reg  [9:0]  fft_cnt;   
reg         rd_en;
//*****************************************************
//**                    main code
//***************************************************** 

//状态机状态控制,输出不同的状态
always @(posedge clk_50m or negedge rst_n)begin
	if(!rst_n)begin
		state<=1'b0;
	end
	else begin
		case(state)
			1'b0:state<=(delay_cnt==5'd31)&&(fft_ready)?1:0;//初始化结束进入读数据状态
			1'b1:state<=1'b1;//将读数据状态稳定，否则状态机不能稳定
			default:state<=1'b0;
		endcase
	end
end
//状态机状态执行
//初始化FFT，初始化完成后拉高读请求信号，请求FIFO向FFT输入数据
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        rd_en     <= 1'b0;
        fft_rst_n <= 1'b0;
        delay_cnt <= 5'd0;
    end
    else begin
        case(state)
		      1'b0: begin//初始化状态,延迟32个周期后用复位端打开FFT            
                if(delay_cnt < 5'd31) begin 
                    delay_cnt <= delay_cnt + 1'b1;
                    fft_rst_n <= 1'b0;
                end
                else begin
						  delay_cnt <= delay_cnt;//计数到31时维持为31不置0等待FFT反馈ready信号
                    fft_rst_n <= 1'b1;
                end
            end
            1'b1: begin//读取数据
                if(!fifo_rd_empty)//如果FIFO没有读空，拉高读使能读取数据一直读空为止
                    rd_en <= 1'b1;
                else
                    rd_en <= 1'b0;
            end
        endcase
    end
end

//
assign 	fifo_rdreq = rd_en && (~fifo_rd_empty);             //读使能一般要在FIFO中有数据才能产生读请求，否则有可能读出空数据

//数据将在请求信号的后面一个时钟达到，所以将fifo_rdreq延迟一个时钟得到数据标记信号fft_valid输入FFT IP核
always 	@(posedge clk_50m or negedge rst_n)begin
		if(!rst_n)begin
			fft_valid<=0;
		end
		else 
			fft_valid<=fifo_rdreq;
end

//对FIFO输出的数据进行128循环计数，因为变换点数是128
always 	@(posedge clk_50m or negedge rst_n)begin
		if(!rst_n)begin
	        fft_cnt<=0;
		end
		else if(fifo_rdreq)begin//每次有读请求就计数一次
			if(fft_cnt<127)
	           	fft_cnt<=fft_cnt+1'b1;
            	else
	           	fft_cnt<=0;
		end
	else
		fft_cnt<=fft_cnt;//没有读请求的时候计数器保持！！！因为数据时非空即读出来，所以写时钟和读时钟只有一个时钟
	
end

reg		[10:0]	fft_sop_cnt;
reg		[10:0]	fft_eop_cnt;
always	@(posedge clk_50m or negedge rst_n)begin
		if(!rst_n)begin
			fft_sop_cnt<=0;
			fft_eop_cnt<=0;
		end
		else if(fft_cnt == 0)begin
				fft_sop_cnt<=fft_sop_cnt+1'b1;//cnt不是1时要置0，否则不是1时会锁定计数器，在1时在计数170的基础上又计数
		end
		else if(fft_cnt == 127)begin
				fft_eop_cnt<=fft_eop_cnt+1'b1;
		end
		else begin
			fft_sop_cnt<='d0;
			fft_eop_cnt<='d0;
		end	
end

	
//用计数器计数128生成开始、结束信号和标志信号,sop和eop信号只要一个时钟
assign 	fft_sop    = (fft_cnt==10'd0 &&fft_sop_cnt==0 )   ? 1'b1 : 1'b0; //在第一个数据为，生成sop信号，
assign 	fft_eop    = (fft_cnt==10'd127&&fft_eop_cnt==0)   ? 1'b1 : 1'b0; //在最后一个数据位，生成eop信号


endmodule 
