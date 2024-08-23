module lcd_disp (
    input               sys_rst_n ,
    input               clk_dri   ,
    input       [15:0]  lcd_id    ,
    input               data_req  ,
    input       [10:0]  lcd_xpos  ,
    input       [10:0]  lcd_ypos  ,

    output  reg [23:0]  lcd_data

);

localparam WHITE = 24'hAAAAAA; //白色
localparam BLACK = 24'h444444; //黑色
localparam RED   = 24'hFF1111; //红色
localparam GREEN = 24'h11FF11; //绿色
localparam BLUE  = 24'h1111FF; //蓝色

localparam CHAR_X = 11'd10;
localparam CHAR_Y = 11'd10;
localparam CHAR_W = 11'd128;
localparam CHAR_H = 11'd32;

localparam PIC_X = 11'd10;
localparam PIC_Y = 11'd50;
localparam PIC_W = 11'd200;
localparam PIC_H = 11'd200;


reg [15:0] rom_addr;
wire [23:0] rom_data;

reg [10:0] VS,VBP,VD,VFP,VSUM;//帧
reg [10:0] HS,HBP,HD,HFP,HSUM;//行
always @(*) begin
    case (lcd_id)
        16'h4342:begin
            VS   = 11'd10;
            VBP  = 11'd2;
            VD   = 11'd272;
            VFP  = 11'd2;
            VSUM = 11'd286;
            HS   = 11'd41; 
            HBP  = 11'd2; 
            HD   = 11'd480;
            HFP  = 11'd2;
            HSUM = 11'd525;
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
    endcase
end

//字符数组
reg   [127:0] char[31:0];  
always @(*) begin
    char[0]  <= 128'h00000000000000000000000000000000;
    char[1]  <= 128'h00000000000000000000000000000000;
    char[2]  <= 128'h00030000000000000000000000006000;
    char[3]  <= 128'h000180000000C0000007000000003000;
    char[4]  <= 128'h000180000001E0000007000000003000;
    char[5]  <= 128'h00018C00000780000006000000C02000;
    char[6]  <= 128'h00008700001C1C000006020000602F80;
    char[7]  <= 128'h0000830000061C00000603000007F180;
    char[8]  <= 128'h00088100004330000006270000022300;
    char[9]  <= 128'h001EC000007320000007F60003022000;
    char[10] <= 128'h0018C000003143C0007F0C0001823C00;
    char[11] <= 128'h0060400000107FE0000618000083EE00;
    char[12] <= 128'h00B04E00021F81F00006187000220C00;
    char[13] <= 128'h00107C0003E6018000063FFC00664800;
    char[14] <= 128'h0017E000060702000007FF0000443800;
    char[15] <= 128'h001E210006060C0000FFC00000C43C00;
    char[16] <= 128'h07F821800C04FE003FC18000018467E0;
    char[17] <= 128'h0718338005FFE00000030000018A03C0;
    char[18] <= 128'h001E130000EC0000000E0C0001830000;
    char[19] <= 128'h00181E0000080000000C1E0000030010;
    char[20] <= 128'h00780C000018F000001C3C0000027FFC;
    char[21] <= 128'h03D80C0000173000006CE00003FFFC00;
    char[22] <= 128'h1F181E000030300000CF00001F842000;
    char[23] <= 128'h0C187600006E6000018C010000086000;
    char[24] <= 128'h0018C30800C1E000060C0100000E4000;
    char[25] <= 128'h001301880180E000180C01000003C000;
    char[26] <= 128'h00F000C80301F000000403800001F800;
    char[27] <= 128'h0070007806071E000007FF8000031E00;
    char[28] <= 128'h0020003C080C0FC00001FE00000E0F00;
    char[29] <= 128'h0000001C007003FC0000000000700380;
    char[30] <= 128'h00000000000000800000000000000180;
    char[31] <= 128'h00000000000000000000000000000000;
end

reg [10:0] xpos;
reg [10:0] ypos;
always @(posedge clk_dri or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        xpos <= 'b0;
        ypos <= 'b0;
    end else begin
        if(lcd_ypos >= VS+VBP && lcd_ypos <= VS+VBP+VD)
            ypos <= lcd_ypos - (VS+VBP);
        else
            ypos <= 'b0;

        if(lcd_xpos >= HS+HBP-1'b1 && lcd_xpos <= HS+HBP+HD-1'b1)
            xpos <= lcd_xpos - (HS+HBP-1'b1);
        else 
            xpos <= 'b0;
    end
end

always @(posedge clk_dri or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        lcd_data <= 24'b0;
        rom_addr <= 16'b0;
    end else if(data_req) begin
        if(xpos >= CHAR_X && xpos <= CHAR_X + CHAR_W - 1'b1 && ypos >= CHAR_Y && ypos <= CHAR_Y + CHAR_H - 1'b1)begin//字符
            if(char[ypos-CHAR_Y][7'd127-(xpos-CHAR_X)])
                lcd_data <= 24'h000000;
            else
                lcd_data <= 24'hffffff;
        end else if(xpos >= PIC_X && xpos <= PIC_X + PIC_W - 1'b1 &&  ypos >= PIC_Y && ypos <= PIC_Y + PIC_H - 1'b1) begin//图片
            lcd_data <= rom_data;
            if(rom_addr == 16'd40000 - 1'b1)
                rom_addr <= 16'b0;
            else
                rom_addr <= rom_addr + 1'b1; 
        end else if(xpos >= HD / 5 * 0 && xpos < HD / 5 * 1)
            lcd_data <= WHITE;
        else if(xpos >= HD / 5 * 1 && xpos < HD / 5 * 2)
            lcd_data <= BLACK;
        else if(xpos >= HD / 5 * 2 && xpos < HD / 5 * 3)
            lcd_data <= RED;
        else if(xpos >= HD / 5 * 3 && xpos < HD / 5 * 4)
            lcd_data <= GREEN;
        else if(xpos >= HD / 5 * 4 && xpos < HD / 5 * 5)
            lcd_data <= BLUE;
        else
            lcd_data <= 24'b0;
    end else 
        lcd_data <= 24'b0;
end


blk_mem_gen_0 blk_mem_gen_0_u (
  .clka  (clk_dri) ,  // input wire clka
  .ena   (1'b1)    ,  // input wire ena
  .addra (rom_addr),  // input wire [15 : 0] addra
  .douta (rom_data)   // output wire [23 : 0] douta
);

endmodule