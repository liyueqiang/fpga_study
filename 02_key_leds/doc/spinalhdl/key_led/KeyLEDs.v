// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : KeyLEDs
// Git hash  : 4914c12dbc65e6a57ef70cf7d9001c4d65f899c9



module KeyLEDs (
  input               io_sys_clk,
  input               io_sys_rst_n,
  input      [1:0]    io_key,
  output reg [1:0]    io_led,
  input               clk,
  input               reset
);
  reg        [30:0]   timer_cnt;
  reg                 timer_flg;
  wire                when_key_led_l18;
  wire                when_key_led_l21;
  wire                when_key_led_l29;
  wire                when_key_led_l32;
  wire                when_key_led_l38;

  assign when_key_led_l18 = (! io_sys_rst_n);
  assign when_key_led_l21 = (timer_cnt == 31'h017d783f);
  assign when_key_led_l29 = (! io_sys_rst_n);
  assign when_key_led_l32 = (timer_cnt == 31'h017d783f);
  assign when_key_led_l38 = (! io_sys_rst_n);
  always @(*) begin
    if(when_key_led_l38) begin
      io_led = 2'b11;
    end else begin
      case(io_key)
        2'b00 : begin
          io_led = 2'b11;
        end
        2'b01 : begin
          io_led = {timer_flg,timer_flg};
        end
        2'b10 : begin
          io_led = {timer_flg,(! timer_flg)};
        end
        default : begin
          io_led = 2'b00;
        end
      endcase
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      timer_cnt <= 31'h0;
      timer_flg <= 1'b0;
    end else begin
      if(when_key_led_l18) begin
        timer_cnt <= 31'h0;
      end else begin
        if(when_key_led_l21) begin
          timer_cnt <= 31'h0;
        end else begin
          timer_cnt <= (timer_cnt + 31'h00000001);
        end
      end
      if(when_key_led_l29) begin
        timer_flg <= 1'b0;
      end else begin
        if(when_key_led_l32) begin
          timer_flg <= (! timer_flg);
        end
      end
    end
  end


endmodule
