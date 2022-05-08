module mask(
    input   wire            rst_i,
    input   wire    [1 :0]  mask_op_i,
    input   wire            sign_i,
    input   wire    [31:0]  addr_i,
    input   wire    [31:0]  data_i,
    output  reg     [31:0]  rd_o,
    input   wire    [31:0]  rd_i,
    output  reg     [31:0]  addr_o,
    output  reg     [31:0]  data_o
);

always@(*) begin
    if (rst_i)
        rd_o = 32'b0;
    else if (mask_op_i == 2'b01)
        rd_o = {{16{{addr_i[1] ? rd_i[31] : rd_i[15]}&sign_i}}, addr_i[1] ? rd_i[31:16] : rd_i[15:0]};
    else if (mask_op_i == 2'b00) begin
        case (addr_i[1:0])
            2'b00: rd_o =  {{24{rd_i[7 ]&sign_i}}, rd_i[7 :0 ]};
            2'b01: rd_o =  {{24{rd_i[15]&sign_i}}, rd_i[15:8 ]};
            2'b10: rd_o =  {{24{rd_i[23]&sign_i}}, rd_i[23:16]};
            default: rd_o ={{24{rd_i[31]&sign_i}}, rd_i[31:24]};
        endcase
    end
    else rd_o = rd_i;
end

always@(*) begin
    addr_o = addr_i;
end

always@(*) begin
    if (rst_i)
        data_o = 32'b0;
    else if (mask_op_i == 2'b01) begin
        data_o = addr_i[1] ? {data_i[15:0], rd_i[15:0]} : {rd_i[31:16], data_i[15:0]};
    end
    else if (mask_op_i == 2'b00) begin
        case (addr_i[1:0])
            2'b00: data_o = {rd_i[31:8], data_i[7:0]};
            2'b01: data_o = {rd_i[31:16], data_i[7:0], rd_i[ 7:0]};
            2'b10: data_o = {rd_i[31:24], data_i[7:0], rd_i[15:0]};
            default: data_o = {data_i[7:0], rd_i[23:0]};
        endcase
    end
    else data_o = data_i;
end

endmodule
