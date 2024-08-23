module lcd_colorbar (
    input           sys_clk  ,  //system clock
    input           sys_rst_n,//system reset low valid

    inout   [23:0]  lcd_rgb  ,  //lcd out data
    output          lcd_clk  ,
    output          lcd_rst  ,
    output          lcd_bl   ,
    output          lcd_de   ,
    output          lcd_hs   ,
    output          lcd_vs
);
//lcd three state
wire [23:0] lcd_rgb_o;
wire [23:0] lcd_rgb_i;
assign lcd_rgb = lcd_de?lcd_rgb_o:24'bz;
assign lcd_rgb_i = lcd_rgb;

wire        clk_dri ;
wire [15:0] lcd_id  ;
wire [23:0] lcd_data;
wire        data_req;
wire [10:0] lcd_xpos;
wire [10:0] lcd_ypos;

//lcd id&clock
lcd_id lcd_id_u(
    .sys_rst_n   (sys_rst_n),
    .sys_clk     (sys_clk)  ,
    .lcd_rgb     (lcd_rgb_i),
    .clk_dri     (clk_dri)  ,
    .lcd_id      (lcd_id) 
);

//lcd driver
lcd_dri lcd_dri_u(
    .sys_rst_n (sys_rst_n ),
    .clk_dri   (clk_dri   ),
    .lcd_id    (lcd_id    ),
    .lcd_data  (lcd_data  ),
    .lcd_clk   (lcd_clk   ),
    .data_req  (data_req  ),
    .lcd_rgb   (lcd_rgb_o ),
    .lcd_xpos  (lcd_xpos  ),
    .lcd_ypos  (lcd_ypos  ),
    .lcd_de    (lcd_de    ),
    .lcd_hs    (lcd_hs    ),
    .lcd_vs    (lcd_vs    ),
    .lcd_bl    (lcd_bl    ),
    .lcd_rst   (lcd_rst   )
);

lcd_disp lcd_disp_u(
    .sys_rst_n (sys_rst_n),
    .clk_dri   (clk_dri  ),
    .lcd_id    (lcd_id   ),
    .data_req  (data_req ),
    .lcd_xpos  (lcd_xpos ),
    .lcd_ypos  (lcd_ypos ),
    .lcd_data  (lcd_data)
);
endmodule