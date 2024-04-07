// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : TouchLED
// Git hash  : 702f67ba8ceb94fd98403ab47232e55cadb24577



module TouchLED (
  input               sys_clk,
  input               sys_rst_n,
  input               touch,
  output              led
);
  wire                _zz_1;
  reg                 area_touch_d0;
  reg                 area_touch_d1;
  reg                 area_touch_d2;
  wire                area_touch_rise;
  reg                 area_led_state;
  wire                when_touch_led_l31;

  assign _zz_1 = (! sys_rst_n);
  assign area_touch_rise = ((! area_touch_d2) && area_touch_d1);
  assign when_touch_led_l31 = (! sys_rst_n);
  assign led = area_led_state;
  always @(posedge sys_clk or posedge _zz_1) begin
    if(_zz_1) begin
      area_touch_d0 <= 1'b0;
      area_touch_d1 <= 1'b0;
      area_touch_d2 <= 1'b0;
      area_led_state <= 1'b0;
    end else begin
      if(when_touch_led_l31) begin
        area_touch_d0 <= 1'b0;
        area_touch_d1 <= 1'b0;
        area_touch_d2 <= 1'b0;
      end else begin
        area_touch_d0 <= touch;
        area_touch_d1 <= area_touch_d0;
        area_touch_d2 <= area_touch_d1;
      end
      if(area_touch_rise) begin
        area_led_state <= (! area_led_state);
      end
    end
  end


endmodule
