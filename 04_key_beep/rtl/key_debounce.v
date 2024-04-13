module key_debounce (
    input       sys_clk     ,
    input       sys_rst_n   ,
    input       key         ,
    output reg  key_flt
);
parameter COUNT_DLY = 20'd1_000_000;

// 检测上升沿
reg key_d0;
reg key_d1;
wire key_change;
assign key_change = (key_d0 != key_d1);
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        key_d0 <= 1'b1;
        key_d1 <= 1'b1;
    end
    else begin
        key_d0 <= key;
        key_d1 <= key_d0;
    end
end

// 消抖
reg [19:0] counter;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) 
        counter <= 'b0;
    else if(key_change)
        counter <= COUNT_DLY;
    else if(counter > 20'd0)
        counter <= counter - 1'b1;
    else
        counter <= counter;
end

// 输出
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        key_flt <= 1'b1;
    else if(counter == 20'd1)
        key_flt <= key_d1;
    else
        key_flt <= key_flt;
end


endmodule