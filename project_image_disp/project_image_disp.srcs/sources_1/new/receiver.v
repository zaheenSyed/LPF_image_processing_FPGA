
module receiver(
	input clk,
	input ps2clk,
    input key_data,
    output reg [7:0] c_data
);

reg [10:0] store; 
reg [3:0] count;
wire parity;
always @(negedge ps2clk) begin
    if (count<10) begin
        store[count] <= key_data;
        count <= count+1;
    end
    else begin
        count <= 0;
    end
end

assign parity_check=~((store[1]^store[8])^(store[2]^store[3])^(store[4]^store[5])^(store[6]^store[7]));

always @(posedge clk) begin
    if ((store[0]==0) && (parity_check== store[9])) begin
        c_data <= store[8:1]; // every multi bit start with msb so flip the store
    end
end

endmodule