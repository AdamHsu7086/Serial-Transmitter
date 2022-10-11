module STI(clk,reset,load,pi_data,pi_msb,pi_low,
           so_data,so_valid);

input clk,reset;// input and output
input load,pi_msb,pi_low; 
input [15:0]pi_data;
reg [3:0]counter;
output reg so_data,so_valid;


always@(posedge clk or posedge reset)begin
if(reset)
	counter <= 0; 
else if(load == 1)begin //if load = 1 then reset all counters depending on pi_msb or pi_low
	case({pi_low,pi_msb})
		2'b00://output from pi_data[0] to pi_data[7]
			counter <= 0;
		2'b01://outpur from pi_data[7] to pi_data[0]
			counter <= 7;
		2'b10://output from pi_data[0] to pi_data[15]
			counter <= 0;
		2'b11://output from pi_data[15] to pi_data[0]
			counter <= 15;
		default:
			counter <= 0;
	endcase
	end
else begin
	case({pi_low,pi_msb})
		2'b00://output from pi_data[0] to pi_data[7]
			counter <= counter + 1;
		2'b01://output from pi_data[7] to pi_data[0]
			counter <= counter - 1;
		2'b10://output from pi_data[0] to pi_data[15]
			counter <= counter + 1;
		2'b11://output from pi_data[15] to pi_data[0]
			counter <= counter - 1;
		default:
			counter <= 0;
	endcase
end
end


always@(posedge clk or posedge reset)begin// when should valid become high or low
if(reset)
	so_valid <= 0;
else if(load == 1)
	so_valid <= 1;
else if(({pi_low,pi_msb} == 2'b00 && counter == 7) || ({pi_low,pi_msb} == 2'b01 && counter == 0 ) || ({pi_low,pi_msb} == 2'b10 && counter == 15) || ({pi_low,pi_msb} == 2'b11 && counter == 0))
	so_valid <= 0;
else
	so_valid <= 1;
end


always@(*)begin// if so_valid = 1 then so_data get number
if(so_valid == 1)
	so_data = pi_data[counter];
else
	so_data = 0;
end

endmodule
