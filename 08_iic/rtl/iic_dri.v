module iic_dri (
    input               sys_clk     ,// system clock
    input               sys_rst_n   ,// system reset low is valid

    output  reg         scl         ,// IIC clock
    inout               sda         ,// IIC data   

    input               iic_exec    ,
    input               iic_bit_ctrl,
    input               iic_rh_wl   ,
    input       [15:0]  iic_addr    ,
    input       [7:0]   iic_data_w  ,
    output  reg [7:0]   iic_data_r  ,
    output  reg         iic_done    ,
    output  reg         iic_ack     ,
    output  reg         iic_4_clk    
);

parameter CLK_FREQ = 50_000_000;
parameter IIC_FREQ =    250_000;
parameter DEV_ADDR = 7'b1010000;
//器件地址
wire [6:0] device_addr;
assign device_addr = DEV_ADDR;


// sda三态
reg     sda_dir;
reg     sda_out;
wire    sda_in;
assign sda = sda_dir ? sda_out : 1'bz;
assign sda_in = sda;

//输出IIC时钟4分频
wire [8:0] iic_4_max;
reg  [7:0] iic_4_cnt;
assign iic_4_max = (CLK_FREQ/IIC_FREQ) >> 2;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        iic_4_cnt <= 8'b0;
        iic_4_clk <= 1'b0;
    end
    else if(iic_4_cnt == iic_4_max[8:1] - 1'b1) begin
        iic_4_cnt <= 8'b0;
        iic_4_clk <= ~iic_4_clk;
    end
    else
        iic_4_cnt <= iic_4_cnt + 1'b1;  
end

//输出IIC
localparam ST_IDLE   = 8'b0000_0001;//空闲状态
localparam ST_DEV_W  = 8'b0000_0010;//器件地址写
localparam ST_DEV_R  = 8'b0000_0100;//器件地址读
localparam ST_ADDR_H = 8'b0000_1000;//地址高8bit
localparam ST_ADDR_L = 8'b0001_0000;//地址低8bit
localparam ST_WRITE  = 8'b0010_0000;//写数据
localparam ST_READ   = 8'b0100_0000;//读数据
localparam ST_STOP   = 8'b1000_0000;//停止状态


reg     [7:0]   state_next  ;//下一状态
reg     [7:0]   state_curr  ;//当前状态
reg             state_done  ;//状态跳转
reg             iic_rh_wl_t ;
reg     [7:0]   iic_data_rt ;
reg     [7:0]   iic_data_wt ;
reg     [15:0]  iic_addr_t  ;
reg     [7:0]   state_cnt   ;

always @(posedge iic_4_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        state_next <= ST_IDLE;
        state_curr <= ST_IDLE;
    end
    else
        state_curr <= state_next;
end

always @(*) begin
    state_next <= ST_IDLE;
    case (state_curr)
        ST_IDLE   : state_next <= iic_exec   ? ST_DEV_W : state_curr;
        ST_DEV_W  : state_next <= state_done ? (iic_bit_ctrl ? ST_ADDR_H : ST_ADDR_L): state_curr;
        ST_ADDR_H : state_next <= state_done ? ST_ADDR_L : state_curr;
        ST_ADDR_L : state_next <= state_done ? (iic_rh_wl_t ? ST_DEV_R : ST_WRITE) : state_curr;
        ST_WRITE  : state_next <= state_done ? ST_STOP : state_curr;
        ST_DEV_R  : state_next <= state_done ? ST_READ : state_curr;
        ST_READ   : state_next <= state_done ? ST_STOP : state_curr;
        ST_STOP   : state_next <= state_done ? ST_IDLE : state_curr;
        default   : state_next <= ST_IDLE;
    endcase
end

always @(posedge iic_4_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin        
        iic_data_r  <= 8'b0;
        iic_done    <= 1'b0;
        iic_ack     <= 1'b0;

        iic_addr_t  <= 15'b0;
        iic_data_wt <= 8'b0;
        iic_data_rt <= 8'b0;
        iic_rh_wl_t <= 1'b0;
        scl         <= 1'b1;
        sda_dir     <= 1'b1;
        sda_out     <= 1'b1;
        state_done  <= 1'b0;
        state_cnt   <= 8'b0;
    end
    else begin
        state_done  <= 1'b0;
        state_cnt   <= state_cnt + 1'b1;
        case (state_curr)
            ST_IDLE  :begin
                iic_done    <= 1'b0; 
                scl         <= 1'b1;
                sda_dir     <= 1'b1;
                sda_out     <= 1'b1;
                state_cnt   <= 8'b0;
                if(iic_exec)begin
                    iic_rh_wl_t <= iic_rh_wl;
                    iic_addr_t  <= iic_addr;
                    iic_data_wt <= iic_data_w;
                    iic_data_r  <= 8'b0;
                    iic_ack     <= 1'b0; 
                end
            end
            ST_DEV_W :begin
                if (state_cnt[1:0] == 2'b01)
                    scl <= 1'b0;
                else if (state_cnt[1:0] == 2'b11)
                    scl <= 1'b1;
                else
                    scl <= scl;

                case (state_cnt)
                    8'd0:  sda_out <= 1'b0;
                    8'd2:  sda_out <= device_addr[6];
                    8'd6:  sda_out <= device_addr[5];
                    8'd10: sda_out <= device_addr[4];
                    8'd14: sda_out <= device_addr[3];
                    8'd18: sda_out <= device_addr[2];
                    8'd22: sda_out <= device_addr[1];
                    8'd26: sda_out <= device_addr[0];
                    8'd30: sda_out <= 1'b0;
                    8'd34: sda_dir <= 1'b0;
                    8'd36: begin
                        state_done <= 1'b1;
                        if(sda_in)
                            iic_ack <= 1'b1;
                    end
                    8'd37: state_cnt <= 8'b0;
                    default: ;
                endcase
            end
            ST_ADDR_H:begin
                if(state_cnt==8'b0)
                    sda_dir <= 1'b1;
                if (state_cnt[1:0] == 2'b01)
                    scl <= 1'b1;
                else if (state_cnt[1:0] == 2'b11)
                    scl <= 1'b0;
                else
                    scl <= scl;

                case (state_cnt)
                    8'd0: sda_out <= iic_addr_t[15];
                    8'd4: sda_out <= iic_addr_t[14];
                    8'd8: sda_out <= iic_addr_t[13]; 
                    8'd12:sda_out <= iic_addr_t[12]; 
                    8'd16:sda_out <= iic_addr_t[11]; 
                    8'd20:sda_out <= iic_addr_t[10]; 
                    8'd24:sda_out <= iic_addr_t[9] ; 
                    8'd28:sda_out <= iic_addr_t[8] ; 
                    8'd32:sda_dir <= 1'b0; 
                    8'd34:begin
                        state_done <= 1'b1;
                        if(sda_in)
                            iic_ack <= 1'b1;
                    end 
                    8'd35:begin
                        state_cnt <= 8'b0; 
                    end
                    default: ;
                endcase
            end
            ST_ADDR_L:begin
                if(state_cnt==8'b0)
                    sda_dir <= 1'b1;
                if (state_cnt[1:0] == 2'b01)
                    scl <= 1'b1;
                else if (state_cnt[1:0] == 2'b11)
                    scl <= 1'b0;
                else
                    scl <= scl;
                case (state_cnt)
                    8'd0: sda_out <= iic_addr_t[7];
                    8'd4: sda_out <= iic_addr_t[6];
                    8'd8: sda_out <= iic_addr_t[5]; 
                    8'd12:sda_out <= iic_addr_t[4]; 
                    8'd16:sda_out <= iic_addr_t[3]; 
                    8'd20:sda_out <= iic_addr_t[2]; 
                    8'd24:sda_out <= iic_addr_t[1] ; 
                    8'd28:sda_out <= iic_addr_t[0] ; 
                    8'd32:sda_dir <= 1'b0; 
                    8'd34:begin
                        state_done <= 1'b1;
                        if(sda_in)
                            iic_ack <= 1'b1;
                    end 
                    8'd35:state_cnt <= 8'b0; 
                    default: ;
                endcase
            end
            ST_WRITE :begin
                if(state_cnt==8'b0)
                    sda_dir <= 1'b1;
                if (state_cnt[1:0] == 2'b01)
                    scl <= 1'b1;
                else if (state_cnt[1:0] == 2'b11)
                    scl <= 1'b0;                
                else
                    scl <= scl;
                case (state_cnt)
                    8'd0: sda_out <= iic_data_wt[7];
                    8'd4: sda_out <= iic_data_wt[6];
                    8'd8: sda_out <= iic_data_wt[5]; 
                    8'd12:sda_out <= iic_data_wt[4]; 
                    8'd16:sda_out <= iic_data_wt[3]; 
                    8'd20:sda_out <= iic_data_wt[2]; 
                    8'd24:sda_out <= iic_data_wt[1] ; 
                    8'd28:sda_out <= iic_data_wt[0] ; 
                    8'd32:sda_dir <= 1'b0; 
                    8'd34:begin
                        state_done <= 1'b1;
                        if(sda_in)
                            iic_ack <= 1'b1;
                    end 
                    8'd35:state_cnt <= 8'b0; 
                    default: ;
                endcase
            end
            ST_DEV_R :begin
                if (state_cnt == 8'b0)begin
                    sda_dir <= 1'b1;
                    sda_out <= 1'b1;
                end
                if (state_cnt[1:0] == 2'b01)
                    scl <= 1'b1;
                else if (state_cnt[1:0] == 2'b11)
                    scl <= 1'b0;
                else
                    scl <= scl;

                case (state_cnt)
                    8'd0: begin
                    end
                    8'd2:  sda_out <= 1'b0;
                    8'd4:  sda_out <= device_addr[6];
                    8'd8:  sda_out <= device_addr[5];
                    8'd12: sda_out <= device_addr[4];
                    8'd16: sda_out <= device_addr[3];
                    8'd20: sda_out <= device_addr[2];
                    8'd24: sda_out <= device_addr[1];
                    8'd28: sda_out <= device_addr[0];
                    8'd32: sda_out <= 1'b1;
                    8'd36: sda_dir <= 1'b0;
                    8'd38: begin
                        state_done <= 1'b1;
                        if(sda_in)
                            iic_ack <= 1'b1;
                    end
                    8'd39: state_cnt <= 1'b0;
                    default: ;
                endcase
            end
            ST_READ  :begin
                if (state_cnt[1:0] == 2'b01)
                    scl <= 1'b1;
                else if (state_cnt[1:0] == 2'b11)
                    scl <= 1'b0;
                else
                    scl <= scl;
                case (state_cnt)
                    8'd2:  iic_data_rt[7] <= sda_in;
                    8'd6:  iic_data_rt[6] <= sda_in;
                    8'd10: iic_data_rt[5] <= sda_in; 
                    8'd14: iic_data_rt[4] <= sda_in; 
                    8'd18: iic_data_rt[3] <= sda_in; 
                    8'd22: iic_data_rt[2] <= sda_in; 
                    8'd26: iic_data_rt[1] <= sda_in; 
                    8'd30: iic_data_rt[0] <= sda_in; 
                    8'd32:begin
                        sda_dir <= 1'b1;
                        sda_out <= 1'b1;
                    end
                    8'd33:;
                    8'd34:state_done <= 1'b1;
                    8'd35:begin
                        state_cnt  <= 8'b0;
                        iic_data_r <= iic_data_rt;
                    end
                    default: ;
                endcase
            end
            ST_STOP  :begin
                case (state_cnt)
                    8'd0: begin
                        sda_dir    <= 1'b1;
                        sda_out    <= 1'b0;
                    end
                    8'd1: scl        <= 1'b1;
                    8'd2: sda_out    <= 1'b1;
                    8'd4: state_done <= 1'b1;
                    8'd5: begin
                        state_cnt  <= 8'b0;
                        iic_done   <= 1'b1;
                    end
                    default: ;
                endcase
            end
            default  : ;
        endcase
    end
end


endmodule