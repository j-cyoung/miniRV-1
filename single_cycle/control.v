module control(
    input   wire            rst_i,  // 复位信号
    input   wire    [31:0]  inst_i,   // 指令
    input   wire            lt_i,     // ALU 的 lt_i 信号
    input   wire            eq_i,     // ALU 的 eq_i 信号
    output  reg     [1:0]   npc_op_o, // 控制生成的下一条指令
    output  reg             rf_we_o,  // 寄存器堆写使能
    output  reg     [2:0]   sext_op_o,// 立即数扩展方式
    output  reg     [2:0]   wd_sel_o, // 写入寄存器堆的写数据
    output  reg             alub_sel_o,// ALU B 端口的输入数据
    output  reg     [5:0]   alu_op_o, // 选择 ALU 的运算模式
    output  reg             dram_we_o,// 数据存储器的写使能
    output  reg     [1:0]   mask_op_o,// 用于字节、半字读取
    output  reg             sign_o
    );
// npc_op_o = 00 pc = pc + 4
//  - R 型指令、I 型指令（除 jalr）、S 型指令、U 型指令
// npc_op_o = 01 pc = pc + imm
//  - B 型指令（beq_i & eq_i，bne & !eq_i，blt_i & !eq_i & lt_i，bge & !lt_i
//  - J 型指令
// npc_op_o = 10 pc = ra + imm
//  - jalr
always@(*) begin
    if (rst_i) npc_op_o = 2'b00;
    else begin
        case(inst_i[6:0])
            // beq_i [14:12] 000
            // bne [14:12] 001
            // blt_i [14:12] 100
            // blt_i [14:12] 101
            7'b1100011: npc_op_o = ({inst_i[14], inst_i[12], eq_i} == 3'b001 || {inst_i[14], inst_i[12], eq_i} == 3'b010
                                    || {inst_i[14], inst_i[12], eq_i, lt_i} == 4'b1001 || {inst_i[14], inst_i[12], lt_i} == 3'b110);
            7'b1101111: npc_op_o = 2'b01;
            7'b1100111: npc_op_o = 2'b10;
            default: npc_op_o = 2'b00;
        endcase
    end
end

// rf_we_o = 1 寄存器堆写使能
//  - R、I、U
always@(*) begin
    if (rst_i) rf_we_o = 1'b0;
    else rf_we_o = (inst_i[6:0] != 7'b0100011 && inst_i[6:0] !=7'b1100011);
end

// sext_op_o = 0 I
// sext_op_o = 1 S
// sext_op_o = 2 B
// sext_op_o = 3 J
// sext_op_o = 4 U
always@(*) begin
    if (rst_i) sext_op_o = 3'b000;
    else begin
        case(inst_i[6:0])
           // I 型指令
           7'b0010011: sext_op_o = 3'd0;
           // l
           7'b0000011: sext_op_o = 3'd0;
           // jal
           7'b1100111: sext_op_o = 3'd0;
           // S 型指
           7'b0100011: sext_op_o = 3'd1;
           // B 型指
           7'b1100011: sext_op_o = 3'd2;
           // J 型指
           7'b1101111: sext_op_o = 3'd3;
           // U 型指
           7'b0110111: sext_op_o = 3'd4;
           7'b0010111: sext_op_o = 3'd4;
           default: sext_op_o = 3'd0;
        endcase
    end
end

// wd_sel_o = 00 寄存器堆写入 alu_c
//  - R、I（除 lw、jalr）
// wd_sel_o = 01 写入 pc4
//  - jal 和 jalr
// wd_sel_o = 10 写入 dram_rd
//  - lw
// wd_sel_o = 11 写入 ext
//  - U 型指令 lui
always@(*) begin
    if (rst_i) wd_sel_o = 3'b000;
    else begin
        case(inst_i[6:0])
            7'b0000011: wd_sel_o = 3'b010;
            7'b1100111: wd_sel_o = 3'b001;
            7'b1101111: wd_sel_o = 3'b001;
            7'b0110111: wd_sel_o = 3'b011;
            7'b0010111: wd_sel_o = 3'b100;
            default: wd_sel_o = 3'b000;
        endcase
    end
end

// alub_sel_o = 1 ALU B 端输入 ext
//  - I、S
// alub_sel_o = 0 ALU B 端输入 RF_rD2
//  - R、B、U、J
always@(*) begin
    if (rst_i) alub_sel_o = 1'b0;
    else begin
        case(inst_i[6:0])
            7'b0010011: alub_sel_o = 1'b1;
            7'b0100011: alub_sel_o = 1'b1;
            7'b0000011: alub_sel_o = 1'b1;
            default: alub_sel_o = 1'b0;
        endcase
    end
end

// alu_op_o = 0 1x 000 加法
// alu_op_o = 1 1x 000 减法
// alu_op_o = 1 00 000 无符号比较
// alu_op_o = 1 01 000 有符号比较
// alu_op_o = x xx 001 与运算
// alu_op_o = x xx 010 或运算
// alu_op_o = x xx 011 异或运算
// alu_op_o = x 0x 100 左移运算
// alu_op_o = x 10 100 无符号右移
// alu_op_o = x 11 100 算数右移
always@(*) begin
    if (rst_i) alu_op_o = 6'b000000;
    else if (inst_i[6:0] == 7'b1100011) alu_op_o = {2'b10, ~inst_i[13], 3'b000};
    else if (~inst_i[4]) alu_op_o = 6'b010000;
    else begin
        case(inst_i[14:12])
            3'b000: alu_op_o = {inst_i[30] & inst_i[5], 5'b10000};  // 需要是 R 型指令，不能是 I 型指令
            3'b111: alu_op_o = 6'b000001;
            3'b110: alu_op_o = 6'b000010;
            3'b100: alu_op_o = 6'b000011;
            3'b001: alu_op_o = 6'b000100;
            3'b101: alu_op_o = {2'b01, inst_i[30], 3'b100}; 
            3'b010: alu_op_o = 6'b101000;
            3'b011: alu_op_o = 6'b100000;
            default: alu_op_o = {inst_i[30] & inst_i[5], 5'b00000};
        endcase
    end
end

// dram_we_o = 1 sw 操作
always@(*) begin
    if (rst_i) dram_we_o = 1'b0;
    else if (inst_i[6:0] == 7'b0100011) dram_we_o = 1'b1;
    else dram_we_o = 1'b0;
end

// mask_op_o = 10 xw
// mask_op_o = 01 xh
// mask_op_o = 00 xb
always@(*) begin
    if (rst_i) mask_op_o = 2'b0;
    else mask_op_o = inst_i[13:12];
end

always@(*) begin
    if (rst_i) sign_o = 0;
    else sign_o = (inst_i[14:12] != 3'b100 && inst_i[14:12] != 3'b101);
end

endmodule