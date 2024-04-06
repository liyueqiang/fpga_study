// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : FlowLED
// Git hash  : 4914c12dbc65e6a57ef70cf7d9001c4d65f899c9



module FlowLED (
  input               io_sys_clk,
  input               io_sys_rst_n,
  output reg [1:0]    io_led,
  input               clk,
  input               reset
);
  reg        [31:0]   flow_led_cnt;
  wire                when_flow_led_l17;
  wire                when_flow_led_l19;
  reg        [2:0]    flow_led_flag;
  wire                when_flow_led_l27;
  wire                when_flow_led_l29;
  wire                when_flow_led_l31;

  assign when_flow_led_l17 = (! io_sys_rst_n);
  assign when_flow_led_l19 = (flow_led_cnt == 32'h017d783f);
  assign when_flow_led_l27 = (! io_sys_rst_n);
  assign when_flow_led_l29 = ((flow_led_cnt == 32'h017d783f) && (flow_led_flag == 3'b011));
  assign when_flow_led_l31 = ((flow_led_cnt == 32'h017d783f) && (flow_led_flag != 3'b011));
  always @(*) begin
    case(flow_led_flag)
      3'b000 : begin
        io_led = 2'b01;
      end
      3'b001 : begin
        io_led = 2'b01;
      end
      3'b010 : begin
        io_led = 2'b01;
      end
      3'b011 : begin
        io_led = 2'b10;
      end
      default : begin
        io_led = 2'b00;
      end
    endcase
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      flow_led_cnt <= 32'h0;
      flow_led_flag <= 3'b000;
    end else begin
      if(when_flow_led_l17) begin
        flow_led_cnt <= 32'h0;
      end else begin
        if(when_flow_led_l19) begin
          flow_led_cnt <= 32'h0;
        end else begin
          flow_led_cnt <= (flow_led_cnt + 32'h00000001);
        end
      end
      if(when_flow_led_l27) begin
        flow_led_flag <= 3'b000;
      end else begin
        if(when_flow_led_l29) begin
          flow_led_flag <= 3'b000;
        end else begin
          if(when_flow_led_l31) begin
            flow_led_flag <= (flow_led_flag + 3'b001);
          end
        end
      end
    end
  end


endmodule
