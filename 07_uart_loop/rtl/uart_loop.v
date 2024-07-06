module uarr_loop (
    input sys_clk,
    input sys_rst_n,

    input uart_rxd,
    output uart_txd
);

parameter CLK_FREQ = 50_000_000;
parameter BPS_UART = 115200;
localparam CNT_UART = CLK_FREQ /BPS_UART;


wire uart_rx_done;
wire uart_rx_busy;
wire uart_tx_busy;
wire [7:0] uart_data;

uart_rx uart_rx_u(
    .clk         (sys_clk),
    .rst_n       (sys_rst_n),
    .uart_cnt    (CNT_UART),
    .uart_rxd    (uart_rxd),
    .uart_done   (uart_rx_done),
    .uart_busy   (uart_rx_busy),
    .uart_data   (uart_data)
);

uart_tx uart_tx_u(
    .clk         (sys_clk),
    .rst_n       (sys_rst_n),
    .uart_cnt    (CNT_UART),
    .uart_flag   (uart_rx_done),
    .uart_data   (uart_data),
    .uart_busy   (uart_tx_busy),
    .uart_txd    (uart_txd)
);

    
endmodule