module breath_led (
    input       sys_clk,
    input       sys_rst_n,

    output reg  led
);

//产生2us时钟
reg       clk_2us;
reg [7:0] clk_2us_cnt;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        clk_2us <= 1'b0;
        clk_2us_cnt <= 8'b0;
    end
    else if(clk_2us_cnt == 8'd100 - 1'b1) begin
        clk_2us <= 1'b1;
        clk_2us_cnt <= 8'b0;
    end
    else begin
        clk_2us <= 1'b0;
        clk_2us_cnt <= clk_2us_cnt + 8'b1;
    end  
end

//2ms计数
reg [9:0] clk_2ms_cnt;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        clk_2ms_cnt <= 10'b0;
    else if(clk_2us == 1'b1 && clk_2ms_cnt == 10'd1000-1'b1)
        clk_2ms_cnt <= 10'b0;
    else if(clk_2us == 1'b1)
        clk_2ms_cnt <= clk_2ms_cnt + 1'b1;
    else
        clk_2ms_cnt <= clk_2ms_cnt;
end

//2s计数
reg [9:0] clk_2s_cnt;
reg       clk_2s_flg;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        clk_2s_cnt <= 10'b0;
        clk_2s_flg <= 1'b0;
    end
    else if(clk_2us == 1'b1 && clk_2ms_cnt == 10'd1000-1'b1 && clk_2s_cnt == 10'd1000-1'b1)begin
        clk_2s_cnt <= 10'b0;
        clk_2s_flg <= ~clk_2s_flg;
    end
    else if(clk_2us == 1'b1 && clk_2ms_cnt == 10'd1000-1'b1)begin
        clk_2s_cnt <= clk_2s_cnt + 1'b1;
        clk_2s_flg <= clk_2s_flg;
    end
    else begin
        clk_2s_cnt <= clk_2s_cnt;
        clk_2s_flg <= clk_2s_flg;
    end
end

//PWM输出
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 1'b0;
    else if(clk_2us == 1'b1 && clk_2ms_cnt <= clk_2s_cnt)
        led <= ~clk_2s_flg;
    else if(clk_2us == 1'b1 && clk_2ms_cnt > clk_2s_cnt)
        led <= clk_2s_flg;
    else
        led <= led;
end
    
endmodule