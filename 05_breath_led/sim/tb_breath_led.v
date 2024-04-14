`timescale 10ns/10ns
module tb_breath_led ();
reg sys_clk;
reg sys_rst_n;
wire led;


initial begin
    sys_clk <= 1'b0;
    sys_rst_n <= 1'b0;
    #10
    sys_rst_n <= 1'b1;
end
always #1 sys_clk <= ~sys_clk;
breath_led u_breath_led(
    .sys_clk    (sys_clk)   ,
    .sys_rst_n  (sys_rst_n) ,
    .led        (led)
);

endmodule
