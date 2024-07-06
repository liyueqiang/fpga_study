`timescale 1ns/1ns

module tb_uart_tx ();
reg clk;
reg rst_n;
reg uart_flag;
reg [7:0] uart_data;
wire uart_busy;
wire uart_txd;
initial begin
    clk <= 1'b0;
    rst_n <= 1'b0;
    uart_flag <= 1'b0;
    uart_data <= 8'b0;
    #100 rst_n <= 1'b1;
    #200
    uart_flag <= 1'b1;
    uart_data <= 8'b1010_1111;
    #2
    uart_flag <= 1'b0;
    uart_data <= 8'b0;

end

always #1 clk <= ~clk;

uart_tx uart_tx_u(
    .clk         (clk),
    .rst_n       (rst_n),
    .uart_cnt    (16'd100),
    .uart_flag   (uart_flag),
    .uart_data   (uart_data),
    .uart_busy   (uart_busy),
    .uart_txd    (uart_txd)
);

    
endmodule