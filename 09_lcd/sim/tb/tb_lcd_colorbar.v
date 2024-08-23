`timescale 1ns/1ns

module tb_lcd_colorbar ();

reg sys_clk,sys_rst_n;
wire [23:0] lcd_rgb;
assign lcd_rgb = 24'b0;

initial begin
    sys_clk    <= 1'b0;
    sys_rst_n  <= 1'b0;
    #200
    sys_rst_n  <= 1'b1;
end

always #1 sys_clk <= ~sys_clk;


wire lcd_clk;
wire lcd_rst;
wire lcd_bl;
wire lcd_de;
wire lcd_hs;
wire lcd_vs;
lcd_colorbar lcd_colorbar_u(
    .sys_clk   (sys_clk  ),
    .sys_rst_n (sys_rst_n),
    .lcd_rgb   (lcd_rgb  ),
    .lcd_clk   (lcd_clk  ),
    .lcd_rst   (lcd_rst  ),
    .lcd_bl    (lcd_bl   ),
    .lcd_de    (lcd_de   ),
    .lcd_hs    (lcd_hs   ),
    .lcd_vs    (lcd_vs   )
);

    
endmodule