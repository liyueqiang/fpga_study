`timescale 1ns/1ns
module tb_eeprom_wr ();
reg rstn;
reg clk;
initial begin
    clk  <= 1'b0;
    rstn <= 1'b0;
    #200
    rstn <= 1'b1;
end
always #5 clk <= ~clk;

wire result_done,result_flag;
wire [7:0] iic_data_r;
wire iic_exec,iic_rh_wl,iic_bit_ctrl;
wire [15:0] iic_addr;
wire [7:0]iic_data_w;
assign iic_data_r = iic_addr[7:0];

eeprom_wr #(
    .WR_WAIT (16'd10)
)  eeprom_wr_u(
    .rstn         (rstn        ),
    .iic_4_clk    (clk         ),
    .iic_done     (1'b1        ),
    .iic_ack      (1'b0        ),
    .iic_data_r   (iic_data_r  ),
    .iic_bit_ctrl (iic_bit_ctrl),
    .iic_exec     (iic_exec    ),
    .iic_rh_wl    (iic_rh_wl   ),
    .iic_addr     (iic_addr    ),
    .iic_data_w   (iic_data_w  ),
    .result_done  (result_done ),
    .result_flag  (result_flag)
    );

    
endmodule