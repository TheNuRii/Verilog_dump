module memory_controler (
    input wire       clk,
    input wire       we,
    input wire       oe,
    input wire [7:0] addr,
    input wire [7:0] write_data.
    inout      [7:0] data,
    output reg [7:0] read_data
);

    assign data = (we && oe) ? write_data : 8'bz // (if not - tri-state (high-impedance))

    always @(posedge clk) begin
        if (!we) begin
            read_data <= data;
        end
    end
endmodule

// Testbench
module tb_memory_controler 
    reg clk, we, oe;
    reg  [7:0] addr, write_data;
    wire [7:0] data;
    wire [7:0] read_data;

    // Testbench dirver for data bus (simulates external memory)
    reg [7:0] external_data;
    reg       external_driver;

    assign data = external_driver ? external_data : 8'bz;

    memory_controler dut (
        .clk(clk),
        .we(we),
        .oe(oe),
        .addr(addr),
        .write_data(write_data);
        .data(data);
        .read_data(read_data);
    );

    initial begin
        clk = 0;
    end

    always #5 clk ~= clk;

// Test sequence
  initial begin
    $display("Time\tWE\tOE\tWrite\tData Bus\tRead");
    $display("====\t==\t==\t=====\t=========\t====");

 
    we = 0; oe = 0; addr = 0; write_data = 0;
    external_drive = 0; external_data = 0;
    #10;

    // Test 1: Write operation
    $display("\nTest 1: Write 0xAB to data bus");
    @(posedge clk);
    we = 1; oe = 1; write_data = 8'hAB; external_drive = 0;
    #1 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, we, oe, write_data, data, read_data);
    @(posedge clk);
    #1 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, we, oe, write_data, data, read_data);

    // Test 2: Tri-state (oe=0 during write)
    $display("\nTest 2: Write with OE=0 (bus should be tri-stated)");
    @(posedge clk);
    we = 1; oe = 0; write_data = 8'hCD;
    #1 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, we, oe, write_data, data, read_data);

    // Test 3: Read operation (external device drives bus)
    $display("\nTest 3: Read 0x55 from external device");
    @(posedge clk);
    we = 0; oe = 0; external_drive = 1; external_data = 8'h55;
    #1 $display("%0t\t%b\t%b\t%h\t%h\t%h (before clock)", $time, we, oe, write_data, data, read_data);
    @(posedge clk);
    #1 $display("%0t\t%b\t%b\t%h\t%h\t%h (after clock - captured)", $time, we, oe, write_data, data, read_data);

    // Test 4: Another read
    $display("\nTest 4: Read 0x3C from external device");
    external_data = 8'h3C;
    @(posedge clk);
    #1 $display("%0t\t%b\t%b\t%h\t%h\t%h", $time, we, oe, write_data, data, read_data);

    $display("\nAll tests completed!");
    $finish;
  end
endmodule