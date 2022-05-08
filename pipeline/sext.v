module sext(
    input   wire            rst_n_i,
    input   wire    [2:0]   sext_op_i,    // 立即数扩展信号
    input   wire    [31:0]  inst_i,
    output  reg     [31:0]  ext_o
);

always@(*) begin
    if (~rst_n_i) ext_o = 32'b0;
    else begin
        case(sext_op_i)
            3'd0:   begin
                if ((inst_i[14:12] == 3'b001 || inst_i[14:12] == 3'b101) && inst_i[4]) ext_o = {27'b0, inst_i[24:20]};
                else ext_o = {{20{inst_i[31]}}, inst_i[31:20]};
            end
            3'd1:   ext_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
            3'd2:   ext_o = {{19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};   // B 型指令末尾补零
            3'd3:   ext_o = {{11{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0}; // J 型指令末尾补零
            3'd4:   ext_o = {inst_i[31:12], 12'b0};
            default:ext_o = 32'b0;
        endcase
    end
end

endmodule