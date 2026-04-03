module xor_4_bit (
    input a,
    input b,
    input c,
    input d,
    output res
)

wire sum_ab, sum_cd;

xor_2_bit s0 (.a(a), .b(b), .res(sum_ab));
xor_2_bit s1 (.a(a), .b(d), .res(sum_cd));
xor_2_bit s3 (.a(sum_ab), .b(sum_cd), .res(res));

endmodule