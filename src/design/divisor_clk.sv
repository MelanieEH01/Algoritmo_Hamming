module divisor_clk #(
    parameter DIV_FACTOR = 1000 // Division factor (27 MHz to 27 kHz)
)(
    input  logic clk_in,     // Input clock
    input  logic reset,      // Active-high reset
    output logic clk_out     // Divided clock output
);

    // Counter to keep track of clock cycles, width determined by $clog2(DIV_FACTOR)
    logic [$clog2(DIV_FACTOR)-1:0] counter;

    // Sequential logic triggered on the rising edge of clk_in or reset
    always_ff @(posedge clk_in or posedge reset) begin
        if (reset) begin
            // Reset counter and output clock to initial state
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (DIV_FACTOR/2 - 1)) begin
                // When half the division factor is reached, toggle clk_out and reset counter
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                // Increment counter otherwise
                counter <= counter + 1;
            end
        end
    end

endmodule


  