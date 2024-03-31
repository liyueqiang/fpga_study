`timescale 1ns/1ns //仿真刻度

module tb_flow_led ();

reg  sys_clk;
reg  sys_rst_n;
wire led;

always #1 sys_clk <= ~sys_clk;

initial begin
    sys_clk <= 0;
    sys_rst_n <= 0;
    # 100
    sys_rst_n <= 1;
end

flow_led #(
    .COUNTER (32'd25_00)
) u_flow_led(
    .sys_clk   (sys_clk),
    .sys_rst_n (sys_rst_n),
    .led       (led)
);

endmodule