module lifo_tb;

    parameter WIDTH = 16;
    parameter DEPTH = 4;

    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;
    wire empty;
    wire full;

    lifo #(
        .WIDTH(WIDTH);
        .DEPTH(DEPTH);
    ) uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        rst <= 1;
        push <= 0;
        pop <= 0;
        data_in <= 0;

        // Wait for few clok cycles
        #10;

        // Release reset
        rst <= 0;

    for (integer i = 0; i < 20; i = i + 1) begin
        @(posedge clk);
        if ($random % 2) begin
            push <= $random;
            pop  <= 0;
            data_in <= $random;

        end else begin
            pop <= $random;
            push <= 0;
        end

        $display("[%0t] Operation push=%0d pop=%0d data_in=%0h empty=%0b full=%0b", $time, push, pop, data_in, empty, full);

        end

        #100;
        $finish;
    end
endmodule