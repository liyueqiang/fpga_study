`timescale 1ns/1ns

module tb_uart_rx ();
reg  clk;
reg  rst_n;
reg  uart_rxd;
wire uart_done;
wire uart_busy;
wire [7:0] uart_data;
initial begin
    clk      <= 1'b0;
    rst_n    <= 1'b0;
    uart_rxd <= 1'b1;
    #100 
    rst_n <= 1'b1;
    #200    uart_rxd <= 1'b0;
    #200    uart_rxd <= 1'b0;
    #200    uart_rxd <= 1'b1;
    #200    uart_rxd <= 1'b1;
    #200    uart_rxd <= 1'b0;
    #200    uart_rxd <= 1'b1;
    #200    uart_rxd <= 1'b0;
    #200    uart_rxd <= 1'b0;
    #200    uart_rxd <= 1'b1;
end

always #1 clk <= ~clk;

uart_rx uart_rx_u(
    .clk         (clk),
    .rst_n       (rst_n),
    .uart_cnt    (16'd100),
    .uart_rxd    (uart_rxd),
    .uart_done   (uart_done),
    .uart_busy   (uart_busy),
    .uart_data   (uart_data)
);

    
endmodule