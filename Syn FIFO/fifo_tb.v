module tb;
    reg         clk;
    reg [15:0]  din;
    wire [15:0] dout;
    reg [15:0]  rdata;
    reg         empty;
    reg         rd_en;
    reg         wr_en;
    wire        full;
    reg         rstn;
    reg         stop;

    //sync_fifo u_sync_fifo (*); can be implemented this way
    sync_fifo u_sync_fifo (.rstn(rstn),
                            .wr_en(wr_en),
                            .rd_en(rd_en),
                            .clk(clk),
                            .din(din),
                            .dout(dout),
                            .empty(empty),
                            .full(full)
                            );
    
    always #10 clk ~= clk;

    initial begin
        clk      <= 0;
        rstn     <= 0;
        wr_en    <= 0;
        rd_en    <= 0;
        stop     <= 0;

        #50 rstn <= 1;
    end

    initial begin
        @(posedge clk);

        for (int i = 0; i < 20; i = i + 1) begin
        
        while (full) begin
            @(posedge clk);
            $display("[%0t] FIFO is full, wait for reads to happen", $time);
        end;

        wr_en <= $random;
        din   <= $random;
        $display("[%0t] clk i=%0d wr_en=%0d din=0x%0h ", $time, i, wr_en, din);

        @(posedge clk);
        end

        stop = 1;
    end

    initial begin
        @(posedge clk);

        while (!stop) begin
            // Wait until there is data in fifo
            while (empty) begin
                rd_en <= 0;
                $display("[%0t] FIFO is empty, wait for writes to happend", $time);
                @(posedge clk);
            end;

            // Sample new value from FIFO at random pace
            rd_en <= $random;
            @(posedge clk);
            rdata <= dout;
            $display("[%0t] clk rd_en=%0d rdata=0x%0h", $time, rd_en, rdata);
        end

        #500 $finish;
    end
endmodule