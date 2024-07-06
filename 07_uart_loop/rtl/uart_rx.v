module uart_rx#(
    parameter DATA_WIDTH     = 8
)(
    input                       clk         ,
    input                       rst_n       ,

    input  [15:0]               uart_cnt    ,
    input                       uart_rxd    ,
    output reg                  uart_done   ,
    output reg                  uart_busy   ,
    output reg [DATA_WIDTH-1:0] uart_data
);

reg     uart_rxd_d0;
reg     uart_rxd_d1;
reg     uart_rxd_d2;
wire    uart_rxd_fall;
assign uart_rxd_fall = (!uart_rxd_d1 && uart_rxd_d2);

reg [DATA_WIDTH-1:0] uart_data_reg;
reg [15:0]  bps_cnt;
reg [3:0]   bit_cnt;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        
        uart_busy <= 1'b0;
        uart_done <= 1'b0;
        uart_data <= 'b0;
        uart_rxd_d0 <= 1'b1;
        uart_rxd_d1 <= 1'b1;
        uart_rxd_d2 <= 1'b1;
        bps_cnt     <= 16'b0;
        bit_cnt     <= 4'b0;
        uart_data_reg <= 'b0;
    end else begin
        uart_rxd_d0 <= uart_rxd;
        uart_rxd_d1 <= uart_rxd_d0;
        uart_rxd_d2 <= uart_rxd_d1;

        if(bps_cnt > 0) begin
            bps_cnt <= bps_cnt - 16'b1;
        end else if(bit_cnt > DATA_WIDTH + 1'b1) begin
            bit_cnt <= bit_cnt - 1'b1;
            bps_cnt <= uart_cnt - 1'b1;
        end else if(bit_cnt > 4'b1) begin
            uart_data_reg <= {uart_rxd_d2,uart_data_reg[DATA_WIDTH-1:1]};
            bit_cnt <= bit_cnt - 1'b1;
            bps_cnt <= uart_cnt - 1'b1;
        end else if(bit_cnt == 4'b1) begin
            uart_done <= 1'b1;
            uart_data <= uart_data_reg;
            bit_cnt   <= bit_cnt - 1'b1;
        end else begin
            uart_busy <= 1'b0;
            uart_done <= 1'b0;
            if(uart_rxd_fall)begin
                uart_busy <= 1'b1;
                bit_cnt   <= DATA_WIDTH + 2'd2;
                bps_cnt   <= (uart_cnt >> 1) - 1'b1;
            end
        end
    end
end

endmodule