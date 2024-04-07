module touch_led (
    input       sys_clk     ,
    input       sys_rst_n   ,
    input       touch       ,
    output reg  led
);

//
reg touch_d0;
reg touch_d1;
reg touch_d2;
wire touch_rise;
assign touch_rise = (!touch_d2) & touch_d1;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        touch_d0 <= 1'b0;
        touch_d1 <= 1'b0;
        touch_d2 <= 1'b0;
    end
    else begin
        touch_d0 <= touch;
        touch_d1 <= touch_d0;
        touch_d2 <= touch_d1;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        led <= 1'b0;
    else if(touch_rise)
        led <= ~led;
    else
        led <= led;
end
 
endmodule