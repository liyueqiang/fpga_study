// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : FlowLED
// Git hash  : 702f67ba8ceb94fd98403ab47232e55cadb24577



module FlowLED (
  input               sys_clk,
  input               sys_rst_n,
  output reg [1:0]    led
);
  wire                _zz_1;
  reg        [31:0]   clkCtrl_flow_led_cnt;
  wire                when_flow_led_l21;
  wire                when_flow_led_l23;
  reg        [2:0]    clkCtrl_flow_led_flag;
  wire                when_flow_led_l31;
  wire                when_flow_led_l33;
  wire                when_flow_led_l35;

  assign _zz_1 = (! sys_rst_n);
  assign when_flow_led_l21 = (! sys_rst_n);
  assign when_flow_led_l23 = (clkCtrl_flow_led_cnt == 32'h017d783f);
  assign when_flow_led_l31 = (! sys_rst_n);
  assign when_flow_led_l33 = ((clkCtrl_flow_led_cnt == 32'h017d783f) && (clkCtrl_flow_led_flag == 3'b011));
  assign when_flow_led_l35 = ((clkCtrl_flow_led_cnt == 32'h017d783f) && (clkCtrl_flow_led_flag != 3'b011));
  always @(*) begin
    case(clkCtrl_flow_led_flag)
      3'b000 : begin
        led = 2'b01;
      end
      3'b001 : begin
        led = 2'b01;
      end
      3'b010 : begin
        led = 2'b01;
      end
      3'b011 : begin
        led = 2'b10;
      end
      default : begin
        led = 2'b00;
      end
    endcase
  end

  always @(posedge sys_clk or posedge _zz_1) begin
    if(_zz_1) begin
      clkCtrl_flow_led_cnt <= 32'h0;
      clkCtrl_flow_led_flag <= 3'b000;
    end else begin
      if(when_flow_led_l21) begin
        clkCtrl_flow_led_cnt <= 32'h0;
      end else begin
        if(when_flow_led_l23) begin
          clkCtrl_flow_led_cnt <= 32'h0;
        end else begin
          clkCtrl_flow_led_cnt <= (clkCtrl_flow_led_cnt + 32'h00000001);
        end
      end
      if(when_flow_led_l31) begin
        clkCtrl_flow_led_flag <= 3'b000;
      end else begin
        if(when_flow_led_l33) begin
          clkCtrl_flow_led_flag <= 3'b000;
        end else begin
          if(when_flow_led_l35) begin
            clkCtrl_flow_led_flag <= (clkCtrl_flow_led_flag + 3'b001);
          end
        end
      end
    end
  end


endmodule
