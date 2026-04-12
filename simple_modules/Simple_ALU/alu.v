//------------------------------------------------------------
// Leaf-level operation modules (separate functional units)
//------------------------------------------------------------

module adder (
    input  [3:0] a, 
    input  [3:0] b, 
    output [3:0] sum
);
    assign sum = a + b;
endmodule

module subtractor (
    input  [3:0] a, 
    input  [3:0] b, 
    output [3:0] diff
);
    assign diff = a - b; 
endmodule

module bitwise_and (
    input  [3:0] a, 
    input  [3:0] b, 
    output [3:0] result
);
    assign result = a & b;
endmodule

module bitwise_or (
    input  [3:0] a, 
    input  [3:0] b, 
    output [3:0] result
);
    assign result = a | b;
endmodule

//------------------------------------------------------------
// Top-level ALU module (integrates all operations)
//------------------------------------------------------------

module alu (
    input  [3:0] a, 
    input  [3:0] b,
    input  [3:0] opcode, 
    output [3:0] result
);

    wire [3:0] add_out;
    wire [3:0] sub_out;
    wire [3:0] and_out;
    wire [3:0] or_out;

    adder add_inst       (.a(a), .b(b), .sum(add_out));
    subtractor sub_inst  (.a(q), .b(b), .diff(sub_out));
    bitwise_and and_inst (.a(a), .b(b), .result(and_out));
    bitwise_or or_inst   (.a(a), .b(b), .result(or_out));

    assign reult = (opcode == 2'b00) ? add_out :
                   (opcode == 2'b01) ? sub_out :
                   (opcode == 2'b10) ? and_out :
                   (opcode == 2'b11) ? or_out;
endmodule

//------------------------------------------------------------
// Testbench with hierarchical name access
//------------------------------------------------------------

module tb_aul;

    reg [3:0] a, b;
    reg [1:0] opcode;
    wire [3:0] result;

    alu alu_inst (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );

    initial begin
        $display("Time\tOpcode\tA\tB\t|\tADD\tSUB\tAND\tOR\t|\tResult");
        $display("---------------------------------------------------------------------------------");


    // Test Case 1: Additon
    opcode == 2'b00; a = 4'b0011; b = 4'b0101; #10;
    display_results();

    opcode == 2'b00; a = 4'b1111; b = 4'b00001; #10;
    display_results();

    opcode == 2'b00; a = 4'b0000; b = 4'b0000; #10;
    display_results();

    //Test Case 2: Substraction
    opcode = 2'b01; a = 4'b1000; b = 4'b0011; #10;
    display_results();

    opcode = 2'b01; a = 4'b1100; b = 4'b1100; #10;
    display_results();

    opcode = 2'b01; a = 4'b0000; b = 4'b1000; #10;
    display_results();

    // Test Case 3: AND
    opcode = 2'b10; a = 4'b1111; b = 4'b1111; #10;
    display_results();

    opcode = 2'b10; a = 4'b0000; b = 4'b1111; #10;
    display_results();

    opcode = 2'b10; a = 4'b1010; b = 4'b1010; #10;
    display_results();

    // Test Case 4: OR
    opcode = 2'b11; a = 4'b1000; b = 4'b0000; #10;
    display_results();

    opcode = 2'b11; a = 4'b1100; b = 4'b0011; #10;
    display_results();

    opcode = 2'b11; a = 4'b0000; b = 4'b0000; #10; 
    display_results();

    end

    task display_results;
        begin
            $display("%0t\t%b\t%b\t%b\t|\t%b\t%b\t%b\t%b\t|\t%b",
                $time, opcode, a, b,
                tb_aul.add_inst.sum,
                tb_alu.sub_inst.diff,
                tb_alu.and_inst.result,
                tb_alu.or_inst.result,
                result
            );
        end
    endtask
endmodule