/*
Design an 8-bit ALU (Arithmetic Logic Unit) that supports the following operations based on a 3-bit opcode:

3'b000: Addition (a + b)
3'b001: Subtraction (a - b)
3'b010: Bitwise AND (a & b)
3'b011: Bitwise OR (a | b)
3'b100: Bitwise XOR (a ^ b)
3'b101: Left shift a by 1 (a << 1)
3'b110: Right shift a by 1 (a >> 1)
3'b111: Comparison (a > b) -> returns 8'h01 if true, 8'h00 if false
The module should have: 8-bit inputs a and b, 3-bit opcode, and 8-bit result output.

*/
module alu_8bit (
    input   logic [7:0] a,
    input   logic [7:0] b,
    input   logic [2:0] opcode,
    output  logic [7:0] result
);

always (*) begin
case (opcode) 
    3'b000: result = a + b;
    3'b001: result = a - b;
    3'b010: result = a & b;
    3'b011: result = a | b;
    3'b100: result = a ^ b;
    3'b101: result = a << 1;
    3'b110: result = a >> 1;
    3'b111: result = {7'b0, (a > b)}; // Comparison returns 0x01 or 0x00
    default: result = 8'b0; 
endcase
end
endmodule

module tb_alu;
    logic [7:0] a, b, result;
    logic [2:0] opcode;

    alu_8bit dut(.*); // init module (same port)

    initial begin
        $display("=== ALU 8-bit Test ===\n");

        // Test addition
        a = 50; b = 25; opcode = 3'b000;
        #1 $display("ADD: %0d + %0d = %0d", a, b, result);

        // Test subtraction
        a = 100; b = 35; opcode = 3'b001;
        #1 $display("SUB: %0d - %0d = %0d", a, b, result);

        // Test bitwise AND
        a = 8'b11110000; b = 8'b10101010; opcode = 3'b010;
        #1 $display("AND: 8'b%b & 8'b%b = 8'b%b", a, b, result);

        // Test bitwise OR
        a = 8'b11110000; b = 8'b10101010; opcode = 3'b011;
        #1 $display("OR: 8'b%b | 8'b%b = 8'b%b", a, b, result);

        // Test bitwise XOR
        a = 8'b11110000; b = 8'b10101010; opcode = 3'b100;
        #1 $display("XOR: 8'b%b ^ 8'b%b = 8'b%b", a, b, result);

        // Test left shift
        a = 8'b00000101; opcode = 3'b101;
        #1 $display("SHL: 8'b%b << 1 = 8'b%b (%0d * 2 = %0d)", a, result, a, result);

        // Test right shift
        a = 8'b00010100; opcode = 3'b110;
        #1 $display("SHR: 8'b%b >> 1 = 8'b%b (%0d / 2 = %0d)", a, result, a, result);

        // Test comparison (greater than)
        a = 150; b = 100; opcode = 3'b111;
        #1 $display("CMP: %0d > %0d = 0x%h", a, b, result);

        a = 50; b = 100; opcode = 3'b111;
        #1 $display("CMP: %0d > %0d = 0x%h", a, b, result);

        $finish;
    end
endmodule