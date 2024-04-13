`timescale 1ns/1ns

module tb_key_debounce ();
reg sys_clk;
reg sys_rst_n;
reg key;
wire key_flt;
initial begin
    sys_clk   <= 1'b0;
    sys_rst_n <= 1'b0;
    key       <= 1'b1;
    #20
    sys_rst_n <= 1'b1;
    #100
    key       <= 1'b0;
    #10 key   <= 1'b1;#5  key       <= 1'b0;
    #10 key   <= 1'b1;#5  key       <= 1'b0;
    #200
    key       <= 1'b1;
    #200
    key       <= 1'b0;
    #10 key   <= 1'b1;#5  key       <= 1'b0;
    #10 key   <= 1'b1;#5  key       <= 1'b0;
    #200
    key       <= 1'b1;
end
always #1 sys_clk <= ~sys_clk;

key_debounce #(.COUNT_DLY (20'd50))
u_key_debounce(
    .sys_clk   (sys_clk),
    .sys_rst_n (sys_rst_n),
    .key       (key)  ,
    .key_flt   (key_flt)

);

    
endmodule