`timescale 1ns/1ns

module tb_touch_led ();
reg sys_clk;
reg sys_rst_n;
reg touch;
wire led;
initial begin
    sys_clk <= 1'b0;
    sys_rst_n <= 1'b0;
    touch <= 1'b0;
    #100
    sys_rst_n <= 1'b1;
    #200
    touch <= 1'b1;
    #200
    touch <= 1'b0;
    #200
    touch <= 1'b1;
    #200
    touch <= 1'b0;
end
always #1 sys_clk = ~sys_clk;

touch_led u_touch_led(
    .sys_clk   (sys_clk)  ,
    .sys_rst_n (sys_rst_n),
    .touch     (touch)    ,
    .led       (led)
);
endmodule