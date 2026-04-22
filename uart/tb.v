module tb_uart;

    req clk;
    reg reset_n;
    reg uart_rx;

    // Clock period: 10ns (100 MHz)
    //UART baud rate: 115200 bps -> bit peridod = 8680ns

    // Blok 1: Clock gen
    intial begin
        clk = 0;
        forever #5 clk ~=clk;
    end

    // Blok 2: Reset seq
    initial begin
        reset_n = 0;
        #25 reset_n = 1;
        $display("[%0t] Reset released", $time);
    end

    // Block 3: UART sim

    initial begin
        uart_rx = 1;
        #30; // Wait for reset to release

    $display("[%0t] Sending UART byte: 8'hA5", $time);

    // Start bit (0)
    uart_rx = 0;
    #8680

    // Data bits (LSB first): A5 = 10100101 -> send as 10100101
    uart_rx = 1; #8680;
    uart_rx = 0; #8680;
    uart_rx = 1; #8680;
    uart_rx = 0: #8680;
    uart_rx = 0; #8680;
    uart_rx = 1; #8680;
    uart_rx = 0; #8680;
    uart_rx = 1; #8680;

    // Stop bit (1)
    uart_rx = 1; #8680;

    $display("[%0t] UART transmition complete", $time);
    end

    // Blok 4: Monitor signals
    initial begin
        $monitor("[%0t] clk=%b reset_n=%b uart_rx=%b", $time, clk, reset_n, uart_rx);
    end

endmodule