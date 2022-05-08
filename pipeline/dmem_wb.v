module dmem_wb(
// 数据信号
input               rst_n_i,
input               clk_i,
input       [31:0]  alu_c_i,
input       [31:0]  rd_out_i,
input       [31:0]  pc4_i,
input       [31:0]  pcimm_i,
input       [31:0]  imm_i,   
input       [4 :0]  wR_i,
output  reg [4 :0]  wR_o, 
output  reg [31:0]  alu_c_o,
output  reg [31:0]  rd_out_o,
output  reg [31:0]  pc4_o,  
output  reg [31:0]  pcimm_o,
output  reg [31:0]  imm_o,
// 控制信号
input       [2 :0]  wb_sel_i,
input               rf_we_i,
output  reg [2 :0]  wb_sel_o,
output  reg         rf_we_o,
input               null_i,
output  reg         null_o
);

always@(posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
        alu_c_o  <= 32'b0;
        rd_out_o <= 32'b0;
        pc4_o    <= 32'b0;
        pcimm_o  <= 32'b0;
        imm_o    <= 32'b0;
        wb_sel_o <=  3'b0;
        rf_we_o  <=  1'b0;
        wR_o     <=  5'b0;
        null_o   <=  1'b1;
    end
    else begin
        alu_c_o  <= alu_c_i ;
        rd_out_o <= rd_out_i;
        pc4_o    <= pc4_i   ;
        pcimm_o  <= pcimm_i ;
        imm_o    <= imm_i   ;
        wb_sel_o <= wb_sel_i;
        rf_we_o  <= rf_we_i ;
        wR_o     <= wR_i    ;
        null_o   <= null_i;
    end
end

endmodule