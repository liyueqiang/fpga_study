module key_beep (
    input       sys_clk     ,
    input       sys_rst_n   ,
    input       key         ,
    output  reg beep
);

wire key_flt;
key_debounce u_key_debounce(
    .sys_clk   (sys_clk),
    .sys_rst_n (sys_rst_n),
    .key       (key)  ,
    .key_flt   (key_flt)
);

//消抖
reg key_flt_d0;
reg key_flt_d1;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        key_flt_d0 <= 1'b1;
        key_flt_d1 <= 1'b1;
    end
    else begin
        key_flt_d0 <= key_flt;
        key_flt_d1 <= key_flt_d0;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        beep <= 1'b0;
    else if(key_flt_d1 & !key_flt_d0)
        beep <= ~beep;
    else
        beep <= beep;
end
    
endmodule