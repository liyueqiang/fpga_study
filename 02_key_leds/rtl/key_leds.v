module key_leds (
    input               sys_clk     ,
    input               sys_rst_n   ,
    input       [1:0]   key         ,
    output  reg [1:0]   led
);

parameter COUNTER = 32'd25_000_000;
reg [31:0] timer_cnt;
reg        timer_flg;
//0.5s计时器
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        timer_cnt <= 'b0;
    else if(timer_cnt == COUNTER - 1'b1)
        timer_cnt <= 'b0;
    else
        timer_cnt <= timer_cnt + 1'b1;
end
//0.5s标识
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        timer_flg <= 1'b0;
    else if(timer_cnt == COUNTER - 1'b1)
        timer_flg <= ~timer_flg;
    else
        timer_flg <= timer_flg;
end

//
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 2'b11;
    else begin
        case (key)
            2'b00: led <= 2'b11;
            2'b01: led <= {timer_flg,timer_flg};
            2'b10: led <= {timer_flg,~timer_flg};
            2'b11: led <= 2'b00;
            default: led <= 2'b11;
        endcase
    end  
end

    
endmodule