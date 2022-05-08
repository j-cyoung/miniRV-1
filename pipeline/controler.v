module controler(
input               rst_n_i,
input       [31:0]  inst_i,
input       [1:0]   cmp_i,      // 跳转指令的比较信号
output  reg         cmp_sign_o, // cmp 比较的带符号情况
output  reg [1:0]   jump_o,     // 跳转指令信号
output  reg [2:0]   sext_op_o,  // 扩展信号
output  reg         alub_sel_o, // 选择 alu B 端口的输入信号
output  reg [4:0]   alu_op_o,   // alu 运算选择信号
output  reg [1:0]   mask_op_o,  // 访存控制信号
output  reg         mask_sign_o,     // 访存符号控制信号
output  reg         dram_we_o,  // 数据存储器写使能信号
output  reg [2:0]   wb_sel_o,   // 写回选择信号
output  reg         rf_we_o     // 寄存器堆写使能信号
);

always@(*) begin
    if (~rst_n_i) cmp_sign_o = 1'b0;
    else if (inst_i[6:0] == 7'b1100011 && ~&inst_i[14:13]) cmp_sign_o = 1'b1;
    else cmp_sign_o = 1'b0;
end

always@(*) begin
    if (~rst_n_i) begin
        jump_o = 2'b0;
    end
    else if (inst_i[6:0] == 7'b1100011) begin
        case (inst_i[14:12])
        3'b000: jump_o = cmp_i[0] ? 2'b01 : 2'b00;
        3'b001: jump_o = cmp_i[0] ? 2'b00 : 2'b01;
        3'b100: jump_o = cmp_i[1] ? 2'b01 : 2'b00;
        3'b110: jump_o = cmp_i[1] ? 2'b01 : 2'b00;
        3'b101: jump_o = cmp_i[1] ? 2'b00 : 2'b01;
        default: jump_o = cmp_i[1] ? 2'b00 : 2'b01;
        endcase
    end
    else if (inst_i[6:0] == 7'b1101111)
        jump_o = 2'b01;
    else if (inst_i[6:0] == 7'b1100111 && inst_i[14:12] == 3'b000)
        jump_o = 2'b10;
    else jump_o = 2'b00;
end

always@(*) begin
    if (~rst_n_i) begin
        sext_op_o = 3'b0;
    end
    else begin
        case(inst_i[6:0])
        7'b0010011: sext_op_o = 3'b000;
        7'b0000011: sext_op_o = 3'b000;
        7'b1100111: sext_op_o = 3'b000;
        7'b0100011: sext_op_o = 3'b001;
        7'b1100011: sext_op_o = 3'b010;
        7'b1101111: sext_op_o = 3'b011;
        7'b0010111: sext_op_o = 3'b100;
        default: sext_op_o = 3'b100;
        endcase
    end
end

always@(*) begin
    if (~rst_n_i) begin
        alub_sel_o = 1'b0;
    end
    else if (inst_i[6:0] == 7'b0010011 || inst_i[6:0] == 7'b0000011 || inst_i[6:0] == 7'b1100111 || inst_i[6:0] == 7'b0100011)
        alub_sel_o = 1'b1;
    else alub_sel_o = 1'b0;
end

always@(*) begin
    if(~rst_n_i) begin
        mask_op_o = 2'b0;
    end
    else if (inst_i[6:0] == 7'b0000011) begin
        case(inst_i[14:12])
        3'b000: mask_op_o = 2'b00;
        3'b100: mask_op_o = 2'b00;
        3'b001: mask_op_o = 2'b01;
        3'b101: mask_op_o = 2'b01;
        default: mask_op_o = 2'b10;
        endcase
    end
    else if (inst_i[6:0] == 7'b0100011) begin
        case(inst_i[14:12])
        3'b000: mask_op_o = 2'b00;
        3'b001: mask_op_o = 2'b01;
        default: mask_op_o = 2'b10;
        endcase
    end
    else mask_op_o = 2'b0;
end

always@(*) begin
    if (~rst_n_i) mask_sign_o = 1'b0;
    else if (inst_i[6:0] == 7'b0000011) begin
        mask_sign_o = (~inst_i[14]) ? 1'b1 : 1'b0;
    end
    else mask_sign_o = 1'b0;
end

always@(*) begin
    if (~rst_n_i) dram_we_o = 1'b0;
    else if (inst_i[6:0] == 7'b0100011) dram_we_o = 1'b1;
    else dram_we_o = 1'b0;
end

always@(*) begin
    if (~rst_n_i) wb_sel_o = 3'b000;
    else begin
        case(inst_i[6:0])
        7'b0110011: wb_sel_o = 3'b100;
        7'b0010011: wb_sel_o = 3'b100;
        7'b0000011: wb_sel_o = 3'b011;
        7'b1100111: wb_sel_o = 3'b010;
        7'b1101111: wb_sel_o = 3'b010;
        7'b0110111: wb_sel_o = 3'b000;
        7'b0010111: wb_sel_o = 3'b001;
        default: wb_sel_o = 3'b000;
        endcase
    end
end

always@(*) begin
    if (~rst_n_i) rf_we_o = 1'b0;
    else if (inst_i[6:0] == 7'b0110011 || inst_i[6:0] == 7'b0010011 || inst_i[6:0] == 7'b0000011 || inst_i[6:0] == 7'b1100111 ||
             inst_i[6:0] == 7'b0110111 || inst_i[6:0] == 7'b0010111 || inst_i[6:0] == 7'b1101111)
        rf_we_o = 1'b1;
    else rf_we_o = 1'b0;
end

always@(*) begin
    if (~rst_n_i) alu_op_o = 5'b0;
    else if (inst_i[6:0] == 7'b0110011 || inst_i[6:0] == 7'b0010011) begin
        case(inst_i[14:12])
        3'b000: alu_op_o = {4'b0, inst_i[30]&inst_i[5]};
        3'b111: alu_op_o = 5'b00010;
        3'b110: alu_op_o = 5'b00011;
        3'b100: alu_op_o = 5'b00100;
        3'b001: alu_op_o = 5'b00101;
        3'b101: alu_op_o = {4'b0011, inst_i[30]};
        3'b010: alu_op_o = 5'b01000;
        3'b011: alu_op_o = 5'b01001;
        default: alu_op_o = 5'b00000;
        endcase
    end
    else if (inst_i[6:0] == 7'b0000011 || inst_i[6:0] == 7'b0100011) begin
        alu_op_o = 5'b00000;
    end
    else alu_op_o = 5'b0;
end

endmodule