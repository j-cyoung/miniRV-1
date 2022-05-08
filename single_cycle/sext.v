module sext(
    input   wire            rst_i,
    input   wire    [2:0]   sext_op_i,    // 立即数扩展信号
    input   wire    [31:0]  din,
    output  reg     [31:0]  ext_o
);

always@(*) begin
    if (rst_i) ext_o = 32'b0;
    else begin
        case(sext_op_i)
            3'd0:   begin
                if ((din[14:12] == 3'b001 || din[14:12] == 3'b101) && din[4]) ext_o = {27'b0, din[24:20]};
                else ext_o = {{20{din[31]}}, din[31:20]};
            end
            3'd1:   ext_o = {{20{din[31]}}, din[31:25], din[11:7]};
            3'd2:   ext_o = {{19{din[31]}}, din[31], din[7], din[30:25], din[11:8], 1'b0};   // B 型指令末尾补零
            3'd3:   ext_o = {{11{din[31]}}, din[31], din[19:12], din[20], din[30:21], 1'b0}; // J 型指令末尾补零
            3'd4:   ext_o = {din[31:12], 12'b0};
            default:ext_o = 32'b0;
        endcase
    end
end

endmodule