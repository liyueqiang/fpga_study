`timescale 1ns/1ns

module tb_iic_dri ();

reg sys_clk;
reg sys_rst_n;
wire scl;
wire sda;
pullup(scl);
pullup(sda);


reg iic_exec;
reg iic_rh_wl;
reg [15:0] iic_addr;
reg [7:0] iic_data_w;
wire [7:0] iic_data_r;
wire iic_done;
wire iic_ack;
wire iic_4_clk;
initial begin
    sys_clk    <= 1'b0;
    sys_rst_n  <= 1'b0;
    iic_exec   <= 1'b0;
    iic_addr   <= 'b0;
    iic_data_w <= 'b0;
    iic_rh_wl  <= 1'b0;
    #200
    sys_rst_n <= 1'b1;
    #500
    iic_exec <= 1'b1;
    iic_rh_wl<= 1'b0;
    iic_addr <= 15'b1010_1010_0011_1100;
    iic_data_w <= 8'b0101_1010;
    #1000
    iic_exec <= 1'b0;

    #500000
    iic_exec  <= 1'b1;
    iic_rh_wl <= 1'b1;
    iic_addr  <= 15'b1010_1010_1111_0000;
    #1000
    iic_exec <= 1'b0;
end
always #10 sys_clk<= ~sys_clk;




iic_dri iic_dri_u(
     .sys_clk      (sys_clk  ),
     .sys_rst_n    (sys_rst_n),
     .scl          (scl),
     .sda          (sda),
     .iic_exec     (iic_exec),
     .iic_bit_ctrl (1'b1),
     .iic_rh_wl    (iic_rh_wl),
     .iic_addr     (iic_addr),
     .iic_data_w   (iic_data_w),
     .iic_data_r   (iic_data_r),
     .iic_done     (iic_done),
     .iic_ack      (iic_ack),
     .iic_4_clk    (iic_4_clk) 
);

endmodule