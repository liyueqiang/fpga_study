module lcd_id (
    input               sys_clk     ,//系统时钟
    input               sys_rst_n   ,//系统复位
    input       [23:0]  lcd_rgb     ,//LCD引脚

    output  reg         clk_dri     ,//LCD时钟
    output  reg [15:0]  lcd_id       //LCD标识
);

//lcd识别
reg lcd_id_done;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        lcd_id_done <= 1'b0;
        lcd_id      <= 16'b0;
    end else begin
        if(!lcd_id_done) begin
            case ({lcd_rgb[7],lcd_rgb[15],lcd_rgb[23]})
                3'b000: lcd_id <= 16'h4342;
                3'b001: lcd_id <= 16'h7084;
                3'b010: lcd_id <= 16'h7016;
                3'b100: lcd_id <= 16'h4384;
                3'b101: lcd_id <= 16'h1018;
                default:lcd_id <= 16'h1018; 
            endcase
            lcd_id_done <= 1'b1;
        end
    end
end


reg clk_div2    ;//25M时钟
reg clk_div4  ;//12.5M时钟
reg clk_div4_f;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        clk_div2   <= 1'b0;
        clk_div4   <= 1'b0;
        clk_div4_f <= 1'b0;
    end else begin
        clk_div2   <= ~clk_div2; 
        clk_div4_f <= clk_div4_f + 1'b1;
        if(clk_div4_f)
            clk_div4 <= ~clk_div4;
    end  
end


always @(*) begin
    case (lcd_id)
        16'h4342: clk_dri = clk_div4;
        16'h7084: clk_dri = clk_div2;
        16'h7016: clk_dri = sys_clk;
        16'h4384: clk_dri = clk_div2;
        16'h1018: clk_dri = sys_clk;
        default:  clk_dri = 1'b0;
    endcase
end    
endmodule