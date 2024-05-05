// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : xilinx_ip
// Git hash  : ba4ca3596c004fdd6cab5e1d922908055dc33d7c



module xilinx_ip (
  input               sys_clk,
  input               sys_rst_n
);
  wire                clk_wiz_u_clk_50m;
  wire                clk_wiz_u_clk_100m;
  wire                clk_wiz_u_locked;
  wire                fifo_generator_u_wr_rst_busy;
  wire                fifo_generator_u_rd_rst_busy;
  wire                fifo_generator_u_full;
  wire                fifo_generator_u_almost_full;
  wire       [7:0]    fifo_generator_u_dout;
  wire                fifo_generator_u_empty;
  wire                fifo_generator_u_almost_empty;
  wire       [15:0]   blk_mem_gen_u_douta;
  wire       [16:0]   clockingarea1_xbip_dsp48_macro_u_P;
  wire                clk_50m;
  wire                clk_100m;
  wire                locked;
  wire                rst;
  wire                wr_rst_busy;
  wire                rd_rst_busy;
  wire                fifo_is_ok;
  wire       [15:0]   fifo_in;
  wire       [7:0]    fifo_out;
  wire                full;
  wire                almost_full;
  wire                empty;
  wire                almost_empty;
  wire       [5:0]    rom_addra;
  reg        [5:0]    clockingarea0_rom_addr_count;
  wire                when_xilinx_ip_l122;
  wire       [16:0]   dsp_out;
  reg        [7:0]    clockingarea1_fifo_dout_d0;
  reg        [7:0]    clockingarea1_fifo_dout_d1;
  reg        [15:0]   clockingarea1_fifo_dout_d2;

  clk_wiz_0 clk_wiz_u (
    .sys_clk     (sys_clk             ), //i
    .resetn      (sys_rst_n           ), //i
    .clk_50m     (clk_wiz_u_clk_50m   ), //o
    .clk_100m    (clk_wiz_u_clk_100m  ), //o
    .locked      (clk_wiz_u_locked    )  //o
  );
  fifo_generator_0 fifo_generator_u (
    .rst             (rst                            ), //i
    .wr_clk          (clk_50m                        ), //i
    .rd_clk          (clk_100m                       ), //i
    .wr_rst_busy     (fifo_generator_u_wr_rst_busy   ), //o
    .rd_rst_busy     (fifo_generator_u_rd_rst_busy   ), //o
    .wr_en           (fifo_is_ok                     ), //i
    .din             (fifo_in                        ), //i
    .full            (fifo_generator_u_full          ), //o
    .almost_full     (fifo_generator_u_almost_full   ), //o
    .rd_en           (fifo_is_ok                     ), //i
    .dout            (fifo_generator_u_dout          ), //o
    .empty           (fifo_generator_u_empty         ), //o
    .almost_empty    (fifo_generator_u_almost_empty  )  //o
  );
  blk_mem_gen_0 blk_mem_gen_u (
    .clka     (clk_50m              ), //i
    .addra    (rom_addra            ), //i
    .douta    (blk_mem_gen_u_douta  )  //o
  );
  xbip_dsp48_macro_0 clockingarea1_xbip_dsp48_macro_u (
    .CLK    (clk_100m                            ), //i
    .A      (clockingarea1_fifo_dout_d0          ), //i
    .B      (clockingarea1_fifo_dout_d1          ), //i
    .C      (clockingarea1_fifo_dout_d2          ), //i
    .P      (clockingarea1_xbip_dsp48_macro_u_P  )  //o
  );
  assign clk_50m = clk_wiz_u_clk_50m;
  assign clk_100m = clk_wiz_u_clk_100m;
  assign locked = clk_wiz_u_locked;
  assign rst = ((! sys_rst_n) || (! locked));
  assign fifo_is_ok = (wr_rst_busy && rd_rst_busy);
  assign wr_rst_busy = fifo_generator_u_wr_rst_busy;
  assign rd_rst_busy = fifo_generator_u_rd_rst_busy;
  assign full = fifo_generator_u_full;
  assign almost_full = fifo_generator_u_almost_full;
  assign fifo_out = fifo_generator_u_dout;
  assign empty = fifo_generator_u_empty;
  assign almost_empty = fifo_generator_u_almost_empty;
  assign fifo_in = blk_mem_gen_u_douta;
  assign when_xilinx_ip_l122 = (clockingarea0_rom_addr_count == 6'h3f);
  assign rom_addra = clockingarea0_rom_addr_count;
  assign dsp_out = clockingarea1_xbip_dsp48_macro_u_P;
  always @(posedge clk_50m or posedge rst) begin
    if(rst) begin
      clockingarea0_rom_addr_count <= 6'h0;
    end else begin
      if(fifo_is_ok) begin
        if(when_xilinx_ip_l122) begin
          clockingarea0_rom_addr_count <= 6'h0;
        end else begin
          clockingarea0_rom_addr_count <= (clockingarea0_rom_addr_count + 6'h01);
        end
      end
    end
  end

  always @(posedge clk_100m or posedge rst) begin
    if(rst) begin
      clockingarea1_fifo_dout_d0 <= 8'h0;
      clockingarea1_fifo_dout_d1 <= 8'h0;
      clockingarea1_fifo_dout_d2 <= 16'h0;
    end else begin
      if(fifo_is_ok) begin
        clockingarea1_fifo_dout_d0 <= fifo_out;
        clockingarea1_fifo_dout_d1 <= clockingarea1_fifo_dout_d0;
        clockingarea1_fifo_dout_d2 <= {8'd0, clockingarea1_fifo_dout_d1};
      end
    end
  end


endmodule
