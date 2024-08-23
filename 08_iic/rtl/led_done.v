module led_done (
    input   rst_n   ,
    input   clk     ,
    input   done    ,
    input   flag    ,
    output  reg led
);

parameter CNT_MAX = 20'd125_000;
reg [19:0]  led_cnt;
reg         led_blink;
reg         done_reg;
reg         flag_reg;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        led_cnt   <= 20'd0;
        led_blink <= 1'b0;
        done_reg  <= 1'b0;
        flag_reg  <= 1'b0;
        led       <= 1'b0;
    end
    else begin
        //计时
        if(led_cnt < CNT_MAX - 1'b1)
            led_cnt <= led_cnt + 1'b1;
        else begin
            led_cnt <= 20'd0;
            led_blink <= ~led_blink;
        end
        //锁存
        if(done) begin
            done_reg <= 1'b1;
            flag_reg <= flag;
        end
        //显示
        if(done_reg) begin
            if(flag_reg)
                led <= led_blink;
            else
                led <= 1'b1;
        end
    end
end


endmodule