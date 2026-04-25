module dff (
    input clk,
    input d,
    input rstn,
    output reg q,
    output qn
);
    always @(posedge clk or negedge rstn)
        if (!rstn) q <= 0;
        else       q <= d;
    
    assign qn = ~q;
endmodule

module ripple (
    input clk,
    input rstn,
    output [3:0] out
);

    wire q0;
    wire qn0;
    wire q1;
    wire qn1;
    wire q2;
    wire qn2;
    wire q3;
    wire qn3;

    dff dff0 (
        .d(qn0),
        .clk(clk),
        .rstn(rstn),
        .q(q0),
        .qn(qn0)
    );

    dff dff1 (
        .d(qn1),
        .clk(qn0),
        .rstn(rstn),
        .q(q2),
        .qn(qn1)
    );

    dff dff2 (
        .d(qn2),
        .clk(qn1),
        .rstn(rstn),
        .q(q2),
        .qn(qn2)
    );

    dff dff3 (
        .d(qn3),
        .clk(qn2),
        .rstn(rstn)
        .q(q3),
        .qn3(q3)
    );

    assign out = {qn3, qn2, qn1, qn0};
endmodule