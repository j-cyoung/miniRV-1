module execute(
    input   wire            rst_i,      // 复位信号
    input   wire            alub_sel_i,   // 选择 ALU B 端口的输入
    input   wire    [5:0]   alu_op_i,     // 选择 ALU 的运算模式，规则见 ALU
    input   wire    [31:0]  A_i,          // ALU A 端口输入
    input   wire    [31:0]  rD2_i,        // 寄存器堆 rD2 的输出
    input   wire    [31:0]  ext_i,        // 立即数的扩展信号
    output  wire    [31:0]  C_o,          // ALU C 端口输出
    output  wire            eq_o,         // ALU 的两个输入相等（前提为计算 A-B）
    output  wire            lt_o          // ALU 的输入端口 A < B（前提为计算 A-B）
    );
    
alu execute_alu (
    .rst_i      (rst_i),
    .alu_op_i   (alu_op_i),
    .A_i        (A_i),
    .B_i        (alub_sel_i ? ext_i : rD2_i),
    .C_o        (C_o),
    .eq_o       (eq_o),
    .lt_o       (lt_o)
);
    
endmodule
