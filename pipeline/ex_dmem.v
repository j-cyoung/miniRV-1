module  ex_dmem(
// 数据信号
input               rst_n_i,
input               clk_i,
input       [31:0]  alu_c_i,
input       [31:0]  rD2_i,
input       [31:0]  pc4_i,
input       [31:0]  pcimm_i,
input       [31:0]  imm_i,
input       [4 :0]  wR_i,
output  reg [4 :0]  wR_o,
output  reg [31:0]  alu_c_o,
output  reg [31:0]  rD2_o,
output  reg [31:0]  pc4_o,
output  reg [31:0]  pcimm_o,
output  reg [31:0]  imm_o,
// 控制信号
input       [1:0]   mask_op_i,
input               mask_sign_i,
input               dram_we_i,
input       [2:0]   wb_sel_i,
input               rf_we_i,
output  reg [1:0]   mask_op_o,
output  reg         mask_sign_o,
output  reg         dram_we_o,
output  reg [2:0]   wb_sel_o,
output  reg         rf_we_o,
input               null_i,
output  reg         null_o
);

always@(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
        alu_c_o  <= 32'b0;
        rD2_o    <= 32'b0;
        pc4_o    <= 32'b0;
        pcimm_o  <= 32'b0;
        imm_o    <= 32'b0;
        mask_op_o<=  2'b0;
        mask_sign_o<=  1'b0;
        dram_we_o<=  1'b0;
        wb_sel_o <=  3'b0;
        rf_we_o  <=  1'b0;
        wR_o     <=  5'b0;
        null_o   <=  1'b1;
    end
    else begin
        alu_c_o  <= alu_c_i;
        rD2_o    <= rD2_i;  
        pc4_o    <= pc4_i;  
        pcimm_o  <= pcimm_i;
        imm_o    <= imm_i;  
        mask_op_o<= mask_op_i;
        mask_sign_o<=mask_sign_i;   
        dram_we_o<= dram_we_i;
        wb_sel_o <= wb_sel_i; 
        rf_we_o  <= rf_we_i;  
        wR_o     <= wR_i;
        null_o   <= null_i;
    end
end

endmodule