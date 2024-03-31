module flow_led (
    input               sys_clk     ,//系统时钟
    input               sys_rst_n   ,//系统复位
    output reg  [1:0]   led
);
// 时间间隔
parameter COUNTER = 32'd25_000_000;

reg [31:0] flow_led_cnt;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        flow_led_cnt <= 'd0;
    else if(flow_led_cnt == COUNTER - 1'b1)
        flow_led_cnt <= 'd0;
    else
        flow_led_cnt <= flow_led_cnt + 1'b1;
end

reg [2:0] flow_led_flag;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        flow_led_flag <= 'd0;
    else if (flow_led_cnt == COUNTER - 1'b1 & flow_led_flag == 3'd3)
        flow_led_flag <= 'd0;
    else if (flow_led_cnt == COUNTER - 1'b1 & flow_led_flag != 3'd3)
         flow_led_flag <= flow_led_flag + 1'b1;
    else
        flow_led_flag <= flow_led_flag;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        led <= 2'b00;
    else begin
        case(flow_led_flag)
            3'd0,3'd1,3'd2: 
                led <= 2'b01;
            3'd3:
                led <= 2'b10;
            default:
                led <= 2'b00;
        endcase
    end
end

 
endmodule