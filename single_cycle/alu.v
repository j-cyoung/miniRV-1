/*
 *  alu_op[2:0] = 000
 *      - alu_op[5] = 1 减法（比较）
 *          - alu_op[4] = 1 减法
 *          - alu_op[4] = 0 比较
 *              - alu_op[3] = 0 无符号比较
 *              - alu_op[3] = 1 带符号比较
 *      - alu_op[5] = 0 加法
 *  alu_op[2:0] = 001
 *      与运算
 *  alu_op[2:0] = 010
 *      或运算
 *  alu_op[2:0] = 011
 *      异或运算
 *  alu_op[2:0]  = 100
 *      - alu_op[4:3] = 0x 左移
 *      - alu_op[4:3] = 10  逻辑右移
 *      - alu_op[4:3] = 11  算数右移
 */
module alu(
    input   wire            rst_i,
    input   wire    [5:0]   alu_op_i,
    input   wire    [31:0]  A_i,
    input   wire    [31:0]  B_i,
    output  reg     [31:0]  C_o,
    output  reg             eq_o,
    output  reg             lt_o
);

wire    [32:0]  A_wire_ext;
wire    [32:0]  B_wire_ext;
wire    [32:0]  C_wire_add;
wire    [31:0]  C_wire_shift;

assign  A_wire_ext = {alu_op_i[3]&A_i[31], A_i};
assign  B_wire_ext = {alu_op_i[3]&B_i[31], B_i};

add ALU_add (
    .A(A_wire_ext),
    .B(alu_op_i[5] ? ~B_wire_ext + 1 : B_wire_ext),
    .C(C_wire_add)
);

shift ALU_shift (
    .dir(alu_op_i[4]),
    .al (alu_op_i[3]),
    .a  (A_i),
    .b  (B_i[4:0]),
    .c  (C_wire_shift)
);
    
always@(*) begin
    if (rst_i)
        C_o  = 32'b0;
    else begin
        case(alu_op_i[2:0])
        3'd0: C_o  = alu_op_i[4] ? C_wire_add[31:0] : {30'b0, C_wire_add[32]};
        3'd1: C_o = A_i & B_i;
        3'd2: C_o = A_i | B_i;
        3'd3: C_o = A_i ^ B_i;
        3'd4: C_o = C_wire_shift;
        default: C_o = A_i & B_i;
        endcase
    end
end

always@(*) begin
    if (rst_i) begin
        eq_o = 1'b0;
        lt_o = 1'b0;
    end
    else begin
        eq_o = ~|C_wire_add;
        lt_o = C_wire_add[32];
    end
end
    
endmodule

module add(
    input   wire    [32:0]  A,
    input   wire    [32:0]  B,
    output  wire    [32:0]  C
);
assign  C = {A + B};
endmodule  
