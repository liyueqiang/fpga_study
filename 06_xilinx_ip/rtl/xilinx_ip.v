module xilinx_ip (
    input sys_clk  ,
    input sys_rst_n
);

//时钟
wire clk_50M;
wire clk_100M;
wire locked;
clk_wiz_0 clk_wiz_u
(
    .clk_sys    (sys_clk)  ,// input clk_in1
    .resetn     (sys_rst_n),// input resetn
    .clk_50M    (clk_50M)  ,// output clk_50M
    .clk_100M   (clk_100M) ,// output clk_100M
    .locked     (locked)    // output locked
); 

//复位
wire rst;
assign rst = (!sys_rst_n | !locked);
//rom
reg     [5:0]   rom_addra;
wire    [15:0]  rom_douta;
//fifo
wire            full,almost_full;
wire            empty,almost_empty;
wire            wr_rst_busy;
wire            rd_rst_busy;

wire    [7:0]   fifo_dout;
reg     [7:0]   fifo_dout_d0;
reg     [7:0]   fifo_dout_d1;
reg     [7:0]   fifo_dout_d2;
wire            fifo_rst;
assign fifo_rst = (!wr_rst_busy & !rd_rst_busy);
//FIFO
fifo_generator_0 fifo_generator_u (
  .rst          (rst)           ,   // input wire rst
  .wr_clk       (clk_50M)       ,   // input wire wr_clk
  .rd_clk       (clk_100M)      ,   // input wire rd_clk
  .wr_rst_busy  (wr_rst_busy)   ,   // output wire wr_rst_busy
  .rd_rst_busy  (rd_rst_busy)   ,   // output wire rd_rst_busy

  .wr_en        (fifo_rst)      ,   // input wire wr_en
  .din          (rom_douta)     ,   // input wire [15 : 0] din
  .full         (full)          ,   // output wire full
  .almost_full  (almost_full)   ,   // output wire almost_full

  .rd_en        (fifo_rst)      ,   // input wire rd_en
  .dout         (fifo_dout)     ,   // output wire [7 : 0] dout
  .empty        (empty)         ,   // output wire empty
  .almost_empty (almost_empty)      // output wire almost_empty
);

//ROM
blk_mem_gen_0 blk_mem_gen_u (
  .clka     (clk_50M)   ,  // input wire clka
  .addra    (rom_addra) ,  // input wire [5 : 0] addra
  .douta    (rom_douta)    // output wire [15 : 0] douta
);
always @(posedge clk_50M or posedge rst) begin
    if (rst)
       rom_addra <= 6'b0;
    else if (fifo_rst == 1'b1 && rom_addra == 6'd63)
        rom_addra <= 6'b0;
    else if (fifo_rst == 1'b1)
        rom_addra <= rom_addra + 6'b1;
    else
        rom_addra <= 6'b0;
end


always @(posedge clk_100M or posedge rst) begin
    if (rst) begin
        fifo_dout_d0 <= 8'b0;
        fifo_dout_d1 <= 8'b0;
        fifo_dout_d2 <= 8'b0;
    end
    else if (fifo_rst)begin
        fifo_dout_d0 <= fifo_dout;
        fifo_dout_d1 <= fifo_dout_d0;
        fifo_dout_d2 <= fifo_dout_d1;
    end
end

//DSP
wire [16:0] dsp_out;
xbip_dsp48_macro_0 xbip_dsp48_macro_u (
  .CLK  (clk_100M)  ,   // input wire CLK
  .A    (fifo_dout_d0)         ,   // input wire [7 : 0] A
  .B    (fifo_dout_d1)         ,   // input wire [7 : 0] B
  .C    ({8'b0,fifo_dout_d2})         ,   // input wire [15 : 0] C
  .P    (dsp_out)             // output wire [16 : 0] P
);

endmodule