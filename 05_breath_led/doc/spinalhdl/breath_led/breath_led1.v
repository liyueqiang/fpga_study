// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : breath_led1
// Git hash  : 93dc6b6c480148fa9ba8666e621faa8274c0342e

module breath_led1 (
  input               sys_clk,
  input               sys_rst_n,
  output              led
);
  reg        [27:0]   clkArea_counter;
  reg                 clkArea_pwmOutput;
  wire                when_BreathLED_l28;

  assign when_BreathLED_l28 = (clkArea_counter[26 : 17] <= clkArea_counter[16 : 7]);
  assign led = clkArea_pwmOutput;
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
      clkArea_counter <= 28'h0;
      clkArea_pwmOutput <= 1'b0;
    end else begin
      clkArea_counter <= (clkArea_counter + 28'h0000001);
      if(when_BreathLED_l28) begin
        clkArea_pwmOutput <= (! clkArea_counter[27]);
      end else begin
        clkArea_pwmOutput <= clkArea_counter[27];
      end
    end
  end


endmodule
