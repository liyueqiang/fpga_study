module uart_tx #(
    parameter DATA_WIDTH     = 8
)(
    input                       clk         ,
    input                       rst_n       ,

    input  [15:0]               uart_cnt    ,
    input                       uart_flag   ,
    input [DATA_WIDTH-1:0]      uart_data   ,
    output reg                  uart_busy   ,
    output reg                  uart_txd
);

reg [DATA_WIDTH-1:0] uart_data_reg;
reg [15:0]  bps_cnt;
reg [3:0]   bit_cnt;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        bps_cnt       <= 16'b0;
        bit_cnt       <= 4'b0;
        uart_busy     <= 1'b0;
        uart_txd      <= 1'b1;
        uart_data_reg <= 'b0;
    end else begin
        if(bps_cnt > 0)
            bps_cnt <= bps_cnt -1'b1;
        else if(bit_cnt > 4'b1) begin
                {uart_data_reg,uart_txd} <= {1'b0,uart_data_reg};
                bps_cnt                  <= uart_cnt - 1'b1;
                bit_cnt                  <= bit_cnt -1'b1;
        end else if(bit_cnt == 4'b1) begin
                uart_txd <= 1'b1;
                bps_cnt  <= uart_cnt - (uart_cnt >> 4)  - 1'b1;
                bit_cnt  <= bit_cnt -1'b1;
        end else begin
            uart_busy <= 1'b0;
            if(uart_flag == 1'b1)begin     
                uart_data_reg <= uart_data;
                uart_busy     <= 1'b1;
                bps_cnt       <= uart_cnt - 1'b1;
                bit_cnt       <= DATA_WIDTH + 4'd1;
                uart_txd      <= 1'b0;
            end
        end  
    end
end


    
endmodule