module divider(
    input clk_100m,
    input [31:0] target,
    output reg clk_target='b0
    );
    
    reg [31:0]maxn;
    reg [31:0]cnt;
    
    always @( posedge clk_100m )
    begin
    	maxn<='d10000_0000/target/2;
    	cnt=cnt+'b1;
    	if(cnt>maxn)
    	begin
    		cnt='b0;
    		clk_target=~clk_target;
    	end
    	else begin end
    end
endmodule