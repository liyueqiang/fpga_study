`timescale 1ns/1ns

module tb_eeprom_loop ();
    
reg sys_clk,sys_rst_n;
initial begin
    sys_clk <= 1'b0;
    sys_rst_n <= 1'b0;
    #200
    sys_rst_n <= 1'b1;
end
always #10 sys_clk = ~sys_clk;

wire led;
wire sda,scl;

defparam eeprom_loop_u.eeprom_wr_u.AD_MAX = 256;

eeprom_loop eeprom_loop_u(
    .sys_clk  (sys_clk),
    .sys_rst_n(sys_rst_n),
    .sda      (sda),
    .scl      (scl),
    .led      (led )
);

EEPROM_AT24C64 EEPROM_AT24C64_u(
    .scl   (scl),
    .sda   (sda)
);

endmodule