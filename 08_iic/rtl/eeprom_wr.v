module eeprom_wr(
    input               rstn        ,

    input               iic_4_clk   ,
    input               iic_done    ,
    input               iic_ack     ,
    input       [7:0]   iic_data_r  ,

    output              iic_bit_ctrl,
    output  reg         iic_exec    ,
    output  reg         iic_rh_wl   ,
    output  reg [15:0]  iic_addr    ,
    output  reg [7:0]   iic_data_w  ,
    output  reg         result_done ,
    output  reg         result_flag
);
//
assign iic_bit_ctrl = 1'b1;

parameter WR_WAIT = 16'd5_000;
parameter AD_MAX  = 16'd256;

reg [15:0] wait_cnt;
reg [15:0] addr_cnt;
reg [2:0]  st_curr ;
always @(posedge iic_4_clk or negedge rstn) begin
    if(!rstn)begin
        //output
        iic_exec    <= 'b0;
        iic_rh_wl   <= 'b0;
        iic_addr    <= 'b0;
        iic_data_w  <= 'b0;
        result_done <= 'b0;
        result_flag <= 'b0;
        //reg
        st_curr     <= 'b0;
        addr_cnt    <= 'b0;
        wait_cnt    <= 'b0;
    end else begin
        case (st_curr)
            3'd0:begin
                if(wait_cnt > 0)
                    wait_cnt <= wait_cnt - 1'b1;
                else begin                    
                    if(addr_cnt >= AD_MAX)begin
                        st_curr  <= 3'd2;
                        addr_cnt <=  'd0;
                    end
                    else begin
                        iic_exec     <= 1'b1 ; 
                        iic_rh_wl    <= 1'b0 ;
                        iic_addr     <= {8'b0,addr_cnt[7:0]};
                        iic_data_w   <= addr_cnt[7:0];
                        st_curr      <= 3'd1 ;
                    end
                end
            end 
            3'd1:begin
                iic_exec     <= 1'b0 ; 
                if(iic_done)begin
                    addr_cnt <= addr_cnt + 1'b1;
                    wait_cnt <= WR_WAIT - 1'b1;
                    st_curr  <= 3'd0;
                end
            end
            3'd2:begin
                iic_exec  <= 1'b1 ; 
                iic_rh_wl <= 1'b1 ;
                iic_addr  <= {8'b0,addr_cnt[7:0]};
                st_curr   <= 3'd3 ;
            end
            3'd3:begin//判断数据结果
                iic_exec  <= 1'b0 ;
                if(iic_done)begin
                    if (iic_data_r != addr_cnt[7:0] | iic_ack) begin
                        st_curr     <= 3'd4;
                        result_done <= 1'b1;
                        result_flag <= 1'b0;
                    end else if (addr_cnt >= AD_MAX - 1'b1) begin
                        st_curr     <= 3'd4;
                        result_done <= 1'b1;
                        result_flag <= 1'b1;
                    end else begin
                        st_curr     <= 3'd2;
                        addr_cnt    <= addr_cnt + 1'b1;
                    end
                end
            end
            3'd4:begin
                result_done <= 1'b0;
                st_curr     <= 3'd4;
            end
            default: ;
        endcase
    end

end    
endmodule