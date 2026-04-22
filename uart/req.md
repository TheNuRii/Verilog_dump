<h1>Challenge: Build a Complete UART Testbench Initialization</h1>

Create a testbench for a UART receiver with the following requirements using multiple initial blocks:

Block 1: Generate a 100 MHz clock (10ns period)
Block 2: Apply reset for 25ns, then release it
Block 3: Send a UART byte (8'hA5) at 115200 baud rate (8.68 µs per bit) starting after reset
Block 4: End simulation after 200ns using $finish
Add a $monitor statement to observe clock, reset, and UART serial input signals
