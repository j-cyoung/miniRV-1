module alu(
input   wire            rst_n_i,
input   wire    [4:0]   alu_op_i,
input   wire    [31:0]  alu_a_i,
input   wire    [31:0]  alu_b_i,
output  reg     [31:0]  alu_c_o
);

wire    [31:0]  adder_c;
wire            adder_lt;
wire    [1 :0]  adder_op;
wire    [31:0]  shift_c;
wire    [31:0]  muller_c;
wire    [31:0]  divver_c;
wire    [31:0]  remmer_c;

assign adder_op = {alu_op_i[0] | alu_op_i[3], alu_op_i[0] ^ alu_op_i[3]};

adder alu_a_idder(
.op(adder_op),
.a(alu_a_i),
.b(alu_b_i),
.c(adder_c),
.lt(adder_lt)
);

shift alu_shift(
.dir(alu_op_i[1]),
.al(&alu_op_i[1:0]),
.a(alu_a_i),
.b(alu_b_i[4:0]),
.c(shift_c)
);

always@(*) begin
    if (~rst_n_i) alu_c_o = 32'b0;
    else
        case (alu_op_i)
            5'd0: alu_c_o = adder_c;
            5'd1: alu_c_o = adder_c;
            5'd2: alu_c_o = alu_a_i & alu_b_i;
            5'd3: alu_c_o = alu_a_i | alu_b_i;
            5'd4: alu_c_o = alu_a_i ^ alu_b_i;
            5'd5: alu_c_o = shift_c;
            5'd6: alu_c_o = shift_c;
            5'd7: alu_c_o = shift_c;
            5'd8: alu_c_o = {31'b0, adder_lt};
            5'd9: alu_c_o = {31'b0, adder_lt};
            default:alu_c_o = 32'b0;
        endcase
end

endmodule