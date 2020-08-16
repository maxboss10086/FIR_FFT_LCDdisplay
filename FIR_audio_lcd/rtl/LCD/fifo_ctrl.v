//****************************************Copyright (c)***********************************//
// 网站博客: NC 
// 版权所有, 盗版必究 
// Copyright (c) 2020
// ALL right reserved
//----------------------------------------------------------------------------------------//
// File name: 		xxx.v
// Descriptions: 	识别FIR协议中的一帧数据，截取一帧的一半，写入fifo用于后续显示
// Author: 		Max
// Creation Date:	Tue Jan 14 2020 13:59:40 GMT+0800
//----------------------------------------------------------------------------------------//
// Note:
//		1由于FFT之后的数据具有对称性，因此，截取一半的数据用于显示
//----------------------------------------------------------------------------------------//
//****************************************************************************************//



//fifo_ctrl把输入的数据截取一半存如FIFO
module fifo_ctrl(
    input             		clk_50m,
    input             		lcd_clk,
    input             		rst_n,
    
    input      	[15:0] 	fft_data,
    input             		fft_sop,
    input             		fft_eop,
    input             		fft_valid,
    
    input             		data_req,     //外部读取数据请求信号
    input             		wr_over,      //LCD一帧数据完成信号，用于开启下次一帧数据读取
    output 	reg 	[6:0]  	rd_cnt,      //读取数据标记信号
    
    output     	[15:0] 	fifo_wr_data,
    output            		fifo_wr_req,//写请求信号是fft_valid信号的一半
    output 	reg        	fifo_rd_req
);
//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================/
//parameter define
parameter 	Transform_Length = 128;

//reg define
reg 			[1:0]  	wr_state;
reg 			[1:0]  	rd_state;
reg 			[6:0]  	wr_cnt;
reg        			wr_en;
reg        			fft_valid_r;
reg 			[15:0] 	fft_data_r;


//=============================================================================
//**************    Main Code   **************
//=============================================================================


//产生fifo写请求信号
assign fifo_wr_req  = fft_valid_r && wr_en;//将128点的数据标识信号减半，wr_en在64点会拉低
assign fifo_wr_data = fft_data_r;

//将数据与有效信号延时一个时钟周期
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        fft_data_r  <= 16'd0;
        fft_valid_r <= 1'b0;
    end
    else begin
        fft_data_r  <= fft_data;
        fft_valid_r <= fft_valid;
    end     
end

//控制FIFO写端口，每次向FIFO中写入前半帧（64个）数据
always @ (posedge clk_50m or negedge rst_n) begin
    if(!rst_n) begin
        wr_state <= 2'd0;
        wr_en    <= 1'b0;
        wr_cnt   <= 7'd0;
    end
    else begin
        case(wr_state)
            2'd0: begin             //等待一帧数据的开始信号
                if(fft_sop) begin//达到条件进入下一个状态，否则维持原状态
                    wr_state <= 2'd1;//进入下一个工作状态
                    wr_en    <= 1'b1;//数据传输开始，拉高使能信号标记有效数据
                end
                else begin          //进入写数据过程，拉高写使能wr_en
                    wr_state <= 2'd0;
                    wr_en    <= 1'b0;
                end
            end
            2'd1: begin             
                if(fifo_wr_req)     //FFT数据标记信号和写使能信号相与，写入FIFO数据的标记信号
                    wr_cnt   <= wr_cnt + 1'b1; //对写入FIFO中的数据计数
                else
                    wr_cnt   <= wr_cnt;
                                    //由于FFT得到的数据具有对称性，因此只取一帧数据的一半
                if(wr_cnt < Transform_Length/2 - 1'b1) begin
                    wr_en    <= 1'b1;
                    wr_state <= 2'd1;
                end
                else begin
                    wr_en    <= 1'b0;
                    wr_state <= 2'd2;
                end
            end
            2'd2: begin             //当FIFO中的数据被读出一半的时候，进入下一帧数据写过程
                if((rd_cnt == Transform_Length/4)&& wr_over) begin
                    wr_cnt   <= 7'd0;
                    wr_state <= 2'd0;
                end
                else 
                    wr_state <= 2'd2;
            end
            default: 
                    wr_state <= 2'd0;
        endcase
    end     
end
    
//控制FIFO读端口，每次输出一个数据用于绘制频谱
always @ (posedge lcd_clk or negedge rst_n) begin
    if(!rst_n) begin
        rd_state    <= 2'd0;
        rd_cnt      <= 7'd0;
        fifo_rd_req <= 1'b0;
    end
    else begin
        case(rd_state)
            2'd0: begin             //外部请求频谱数据时，拉高读FIFO请求信号
                if(data_req) begin
                    fifo_rd_req <= 1'b1;
                    rd_state    <= 2'd1;
                end
                else begin
                    fifo_rd_req <= 1'b0;
                    rd_state    <= 2'd0;
                end
            end
            2'd1: begin             //读FIFO请求仅拉高一个时钟周期
                    fifo_rd_req <= 1'b0;
                    rd_state    <= 2'd2;
            end
            2'd2: begin             //等待输出的频谱数据绘制结束
                if(wr_over) begin 
                    rd_state    <= 2'd0;
                    if( rd_cnt== Transform_Length/2 -1 ) 
                        rd_cnt <= 7'd0;//每点的数据绘制完毕就+1，加到63点又清零
                    else 
                        rd_cnt <= rd_cnt + 1'b1;//一点（一帧）数据绘制完毕，+1输出第二点，绘制第二点数据
                end 
                else 
                    rd_state    <= 2'd2;
            end 
            default: 
                    rd_state    <= 2'd0;
        endcase
    end     
end

endmodule 