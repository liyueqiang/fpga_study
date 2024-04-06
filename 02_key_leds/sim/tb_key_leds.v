`timescale 1ns/1ns

module tb_key_leds ();

reg             sys_clk;
reg             sys_rst_n;
reg  [1:0]      key;
wire [1:0]      led;

initial begin
    sys_clk <= 1'b0;
    sys_rst_n <= 1'b0;
    key <= 2'b11;
    #20
    sys_rst_n <= 1'b1;
    #100
    key <= 2'b01;
    #100
    key <= 2'b10;
    #100
    key <= 2'b00;
    #100
    key <= 2'b11;
end
always #1 sys_clk <= ~sys_clk;

key_leds #(.COUNTER (32'd25))
u_key_leds(
    .sys_clk  (sys_clk),
    .sys_rst_n(sys_rst_n),
    .key      (key),
    .led      (led)
);


endmodule