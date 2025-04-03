module refresh_button (
    input  logic clk,          // Clock signal
    input  logic rst_n,        // Active-low reset
    input  logic button,       // Button input
    input  logic [3:0] hex1,   // 4-bit input for display 1
    input  logic [2:0] hex2,   // 3-bit input for display 2
    output logic [6:0] seg1,   // Seven-segment display 1
    output logic [6:0] seg2    // Seven-segment display 2
);

    // Debounce logic for the button
    logic button_sync, button_prev, button_pressed;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            button_sync   <= 1'b0;
            button_prev   <= 1'b0;
            button_pressed <= 1'b0;
        end else begin
            button_sync   <= button;
            button_prev   <= button_sync;
            button_pressed <= button_sync & ~button_prev; // Detect rising edge
        end
    end

    // State to toggle between refresh states
    logic refresh_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            refresh_state <= 1'b0;
        end else if (button_pressed) begin
            refresh_state <= ~refresh_state; // Toggle state on button press
        end
    end

    // Seven-segment decoder for hexadecimal digits
    function logic [6:0] hex_to_7seg(input logic [3:0] hex);
        case (hex)
            4'h0: hex_to_7seg = 7'b1000000;
            4'h1: hex_to_7seg = 7'b1111001;
            4'h2: hex_to_7seg = 7'b0100100;
            4'h3: hex_to_7seg = 7'b0110000;
            4'h4: hex_to_7seg = 7'b0011001;
            4'h5: hex_to_7seg = 7'b0010010;
            4'h6: hex_to_7seg = 7'b0000010;
            4'h7: hex_to_7seg = 7'b1111000;
            4'h8: hex_to_7seg = 7'b0000000;
            4'h9: hex_to_7seg = 7'b0010000;
            4'hA: hex_to_7seg = 7'b0001000;
            4'hB: hex_to_7seg = 7'b0000011;
            4'hC: hex_to_7seg = 7'b1000110;
            4'hD: hex_to_7seg = 7'b0100001;
            4'hE: hex_to_7seg = 7'b0000110;
            4'hF: hex_to_7seg = 7'b0001110;
            default: hex_to_7seg = 7'b1111111; // Turn off display for invalid input
        endcase
    endfunction

    // Assign outputs based on refresh state
    always_comb begin
        if (refresh_state) begin
            seg1 = 7'b1111111; // Turn off display 1
            seg2 = ~hex_to_7seg({1'b0, hex2}); // Decode 3-bit binary input as hexadecimal for display 2
        end else begin
            seg1 = ~hex_to_7seg(hex1); // Decode 4-bit binary input as hexadecimal for display 1
            seg2 = 7'b1111111; // Turn off display 2
        end
    end

endmodule
