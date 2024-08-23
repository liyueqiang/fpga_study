module eeprom_loop (
    input  sys_clk  ,
    input  sys_rst_n,
    inout  sda  ,
    output scl  ,
    output led
);

wire        iic_4_clk   ;
wire        iic_exec    ;
wire        iic_bit_ctrl;
wire        iic_rh_wl   ;
wire        iic_ack     ;
wire        iic_done    ;
wire [15:0] iic_addr    ;
wire [7:0]  iic_data_w  ;
wire [7:0]  iic_data_r  ;

wire result_done        ;
wire result_flag        ;


iic_dri iic_dri_u(
    .sys_clk     (sys_clk),
    .sys_rst_n   (sys_rst_n),
    .scl         (scl),
    .sda         (sda),
    .iic_exec    (iic_exec),
    .iic_bit_ctrl(iic_bit_ctrl),
    .iic_rh_wl   (iic_rh_wl),
    .iic_addr    (iic_addr),
    .iic_data_w  (iic_data_w),
    .iic_data_r  (iic_data_r),
    .iic_done    (iic_done),
    .iic_ack     (iic_ack),
    .iic_4_clk   (iic_4_clk) 
);


eeprom_wr #(.WR_WAIT(16'd5_000))
    eeprom_wr_u(
    .rstn         (sys_rst_n),
    .iic_4_clk    (iic_4_clk),
    .iic_done     (iic_done),
    .iic_ack      (iic_ack),
    .iic_data_r   (iic_data_r),
    .iic_bit_ctrl (iic_bit_ctrl),
    .iic_exec     (iic_exec),
    .iic_rh_wl    (iic_rh_wl),
    .iic_addr     (iic_addr),
    .iic_data_w   (iic_data_w),
    .result_done  (result_done),
    .result_flag  (result_flag)
    );

led_done #(.CNT_MAX(20'd125_000))
    led_done_u(
    .rst_n   (sys_rst_n),
    .clk     (iic_4_clk),
    .done    (result_done),
    .flag    (result_flag),
    .led     (led)
);

    
endmodule