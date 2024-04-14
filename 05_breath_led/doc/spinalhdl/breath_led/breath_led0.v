// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : breath_led0
// Git hash  : 93dc6b6c480148fa9ba8666e621faa8274c0342e



module breath_led0 (
  input               sys_clk,
  input               sys_rst_n,
  output              led
);
  wire       [9:0]    _zz_clockarea_clk_2ms_cnt;
  wire       [0:0]    _zz_clockarea_clk_2ms_cnt_1;
  wire       [9:0]    _zz_clockarea_clk_2s_cnt;
  wire       [0:0]    _zz_clockarea_clk_2s_cnt_1;
  reg        [7:0]    clockarea_clk_2us_cnt;
  reg                 clockarea_clk_2us_flg;
  wire                when_breath_led_l25;
  reg        [9:0]    clockarea_clk_2ms_cnt;
  reg                 clockarea_clk_2ms_flg;
  wire                when_breath_led_l32;
  reg        [9:0]    clockarea_clk_2s_cnt;
  reg                 clockarea_clk_2s_flag;
  wire                when_breath_led_l39;
  reg                 clockarea_led_state;
  wire                when_breath_led_l45;

  assign _zz_clockarea_clk_2ms_cnt_1 = clockarea_clk_2us_flg;
  assign _zz_clockarea_clk_2ms_cnt = {9'd0, _zz_clockarea_clk_2ms_cnt_1};
  assign _zz_clockarea_clk_2s_cnt_1 = clockarea_clk_2ms_flg;
  assign _zz_clockarea_clk_2s_cnt = {9'd0, _zz_clockarea_clk_2s_cnt_1};
  assign when_breath_led_l25 = (clockarea_clk_2us_cnt == 8'h63);
  assign when_breath_led_l32 = (clockarea_clk_2ms_cnt == 10'h3e7);
  assign when_breath_led_l39 = (clockarea_clk_2s_cnt == 10'h3e7);
  assign when_breath_led_l45 = (! clockarea_clk_2s_flag);
  assign led = clockarea_led_state;
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
      clockarea_clk_2us_cnt <= 8'h0;
      clockarea_clk_2us_flg <= 1'b0;
      clockarea_clk_2ms_cnt <= 10'h0;
      clockarea_clk_2ms_flg <= 1'b0;
      clockarea_clk_2s_cnt <= 10'h0;
      clockarea_clk_2s_flag <= 1'b0;
      clockarea_led_state <= 1'b0;
    end else begin
      clockarea_clk_2us_flg <= (clockarea_clk_2us_cnt == 8'h63);
      clockarea_clk_2us_cnt <= (clockarea_clk_2us_cnt + 8'h01);
      if(when_breath_led_l25) begin
        clockarea_clk_2us_cnt <= 8'h0;
      end
      clockarea_clk_2ms_flg <= (clockarea_clk_2ms_cnt == 10'h3e7);
      clockarea_clk_2ms_cnt <= (clockarea_clk_2ms_cnt + _zz_clockarea_clk_2ms_cnt);
      if(when_breath_led_l32) begin
        clockarea_clk_2ms_cnt <= 10'h0;
      end
      clockarea_clk_2s_cnt <= (clockarea_clk_2s_cnt + _zz_clockarea_clk_2s_cnt);
      if(when_breath_led_l39) begin
        clockarea_clk_2s_cnt <= 10'h0;
        clockarea_clk_2s_flag <= (! clockarea_clk_2s_flag);
      end
      if(when_breath_led_l45) begin
        clockarea_led_state <= (clockarea_clk_2ms_cnt <= clockarea_clk_2s_cnt);
      end else begin
        clockarea_led_state <= (clockarea_clk_2s_cnt < clockarea_clk_2ms_cnt);
      end
    end
  end


endmodule
