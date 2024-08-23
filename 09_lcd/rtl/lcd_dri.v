module lcd_dri (
    input               sys_rst_n,
    input               clk_dri  ,
    input       [15:0]  lcd_id   ,
    input       [23:0]  lcd_data ,

    output              lcd_clk,
    output  reg         data_req,
    output      [23:0]  lcd_rgb,
    output  reg [10:0]  lcd_xpos,
    output  reg [10:0]  lcd_ypos,
    output  reg         lcd_de,
    output              lcd_hs,
    output              lcd_vs,
    output              lcd_bl,
    output              lcd_rst
);
//lcd输出
assign lcd_clk = clk_dri;
assign lcd_hs  = 1'b1;
assign lcd_vs  = 1'b1;
assign lcd_bl  = 1'b1;
assign lcd_rst = 1'b1;
assign lcd_rgb = lcd_de ? lcd_data : 24'b0;

reg [10:0] VS,VBP,VD,VFP,VSUM;//帧
reg [10:0] HS,HBP,HD,HFP,HSUM;//行
always @(*) begin
    case (lcd_id)
        16'h4342:begin
            VS   <= 11'd10;
            VBP  <= 11'd2;
            VD   <= 11'd272;
            VFP  <= 11'd2;
            VSUM <= 11'd286;
            HS   <= 11'd41; 
            HBP  <= 11'd2; 
            HD   <= 11'd480;
            HFP  <= 11'd2;
            HSUM <= 11'd525;
        end 
        16'h4384:begin
            VS   <= 11'd10;
            VBP  <= 11'd2;
            VD   <= 11'd272;
            VFP  <= 11'd2;
            VSUM <= 11'd286;
            HS   <= 11'd41; 
            HBP  <= 11'd2; 
            HD   <= 11'd480;
            HFP  <= 11'd2;
            HSUM <= 11'd525;        
        end
        16'h7084:begin
            VS   <= 11'd2;
            VBP  <= 11'd33;
            VD   <= 11'd480;
            VFP  <= 11'd10;
            VSUM <= 11'd525;
            HS   <= 11'd128; 
            HBP  <= 11'd88; 
            HD   <= 11'd800;
            HFP  <= 11'd40;
            HSUM <= 11'd1056;        
        end
        16'h7016:begin
            VS   <= 11'd3;
            VBP  <= 11'd20;
            VD   <= 11'd600;
            VFP  <= 11'd12;
            VSUM <= 11'd635;
            HS   <= 11'd20; 
            HBP  <= 11'd140; 
            HD   <= 11'd1024;
            HFP  <= 11'd160;
            HSUM <= 11'd1344;        
        end
        16'h1018:begin
            VS   <= 11'd3;
            VBP  <= 11'd10;
            VD   <= 11'd800;
            VFP  <= 11'd10;
            VSUM <= 11'd823;
            HS   <= 11'd10; 
            HBP  <= 11'd80; 
            HD   <= 11'd1028;
            HFP  <= 11'd70;
            HSUM <= 11'd1440;         
        end
        default: begin
            VS   = 11'd3;
            VBP  = 11'd10;
            VD   = 11'd800;
            VFP  = 11'd10;
            VSUM = 11'd823;
            HS   = 11'd10; 
            HBP  = 11'd80; 
            HD   = 11'd1028;
            HFP  = 11'd70;
            HSUM = 11'd1440;         
        end
    endcase
end

always @(posedge clk_dri or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        lcd_xpos    <= 'b0;
        lcd_ypos    <= 'b0;
    end else begin
        if(lcd_xpos == HSUM - 1'b1)begin
            lcd_xpos <= 'b0;
            if(lcd_ypos == VSUM - 1'b1)
                lcd_ypos <= 'b0;
            else
                lcd_ypos <= lcd_ypos + 1'b1;
        end else 
            lcd_xpos <= lcd_xpos + 1'b1;
    end
end

always @(posedge clk_dri or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        lcd_de   <= 1'b0;
        data_req <= 1'b0;
    end else begin
        //lcd有效
        if(lcd_ypos >= VS+VBP && lcd_ypos <= VS+VBP+VD && 
           lcd_xpos >= HS+HBP-11'd1 && lcd_xpos <= HS+HBP+HD-11'd1)
            lcd_de  <= 1'b1;
        else
            lcd_de  <= 1'b0;
        //数据请求/提前1拍
        if(lcd_ypos >= VS+VBP && lcd_ypos <= VS+VBP+VD && 
           lcd_xpos >= HS+HBP-11'd2 && lcd_xpos <= HS+HBP+HD-11'd2)
           data_req <= 1'b1;
        else
           data_req <= 1'b0;
    end
end

    
endmodule