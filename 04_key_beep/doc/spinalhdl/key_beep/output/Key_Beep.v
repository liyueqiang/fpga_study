// Generator : SpinalHDL v1.6.0    git head : 73c8d8e2b86b45646e9d0b2e729291f2b65e6be3
// Component : Key_Beep
// Git hash  : 34264b3bb2481bc0b4199da21c0a1f64270cbace



module Key_Beep (
  input               sys_clk,
  input               sys_rst_n,
  input               key,
  output              beep
);
  wire                keydebounce_key_out;
  wire                key_flter;
  reg                 sysctrl_key_flt_d0;
  reg                 sysctrl_key_flt_d1;
  reg                 sysctrl_beep;
  wire                when_key_beep_l78;

  Key_Debounce keydebounce (
    .sys_clk      (sys_clk              ), //i
    .sys_rst_n    (sys_rst_n            ), //i
    .key_in       (key                  ), //i
    .key_out      (keydebounce_key_out  )  //o
  );
  assign key_flter = keydebounce_key_out;
  assign when_key_beep_l78 = (sysctrl_key_flt_d1 && (! sysctrl_key_flt_d0));
  assign beep = sysctrl_beep;
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
      sysctrl_key_flt_d0 <= 1'b1;
      sysctrl_key_flt_d1 <= 1'b1;
      sysctrl_beep <= 1'b0;
    end else begin
      sysctrl_key_flt_d0 <= key_flter;
      sysctrl_key_flt_d1 <= sysctrl_key_flt_d0;
      if(when_key_beep_l78) begin
        sysctrl_beep <= (! sysctrl_beep);
      end
    end
  end


endmodule

module Key_Debounce (
  input               sys_clk,
  input               sys_rst_n,
  input               key_in,
  output              key_out
);
  reg                 clockingArea_key_fltReg;
  reg                 clockingArea_key_in_d0;
  reg                 clockingArea_key_in_d1;
  wire                clockingArea_key_in_chg;
  reg        [19:0]   clockingArea_counter;
  wire                when_key_beep_l33;
  wire                when_key_beep_l37;

  assign clockingArea_key_in_chg = (clockingArea_key_in_d0 != clockingArea_key_in_d1);
  assign when_key_beep_l33 = (clockingArea_counter != 20'h0);
  assign when_key_beep_l37 = (clockingArea_counter == 20'h00001);
  assign key_out = clockingArea_key_fltReg;
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
      clockingArea_key_fltReg <= 1'b1;
      clockingArea_key_in_d0 <= 1'b1;
      clockingArea_key_in_d1 <= 1'b1;
      clockingArea_counter <= 20'h0;
    end else begin
      clockingArea_key_in_d0 <= key_in;
      clockingArea_key_in_d1 <= clockingArea_key_in_d0;
      if(clockingArea_key_in_chg) begin
        clockingArea_counter <= 20'hf4240;
      end else begin
        if(when_key_beep_l33) begin
          clockingArea_counter <= (clockingArea_counter - 20'h00001);
        end
      end
      if(when_key_beep_l37) begin
        clockingArea_key_fltReg <= clockingArea_key_in_d1;
      end
    end
  end


endmodule
