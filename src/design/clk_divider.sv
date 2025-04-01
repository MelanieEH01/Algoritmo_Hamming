module clk_div_27kHz(
    input  logic clk,     // 27 MHz
    input  logic rst,
    output logic clk_27k  // ~27 kHz
);
    logic [9:0] counter;  // Contador de 10 bits para dividir la frecuencia

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_27k <= 0;
        end else begin
            if (counter == 499) begin // Cambia cada 499 ciclos de clk (27MHz)
                // Cambia el estado del clk_27k cada 500 ciclos de clk (27MHz)
                clk_27k <= ~clk_27k;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule