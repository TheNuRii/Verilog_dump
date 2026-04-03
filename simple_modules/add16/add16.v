module add16 (
    input [15:0] a, 
    input [15:0] b, 
    input cin, 
    output [15:0] sum;
);

module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire carry;
    wire [15:0] sum_low, sum_high;

    add16 adder1 (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(carry)
    );

    add16 adder2 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(carry),
        .sum(sum_high),
        .cout()
    );

    assign sum = {sum_high, sum_low};
endmodule