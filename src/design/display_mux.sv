module dual_7seg_mux (
    input  logic        clk,         // reloj de 27 MHz
    input  logic [3:0]  bin,        // palabra de 4 bits 
    input  logic [2:0]  sin,    // síndrome de 3 bits
    output logic [6:0]  seg,         // salidas del display (a-g)
    output logic [1:0]  an           // ánodos activos bajos (display enable)
);

    logic       refresh_clk; // reloj de refresco para el display
    logic       toggle; // variable para alternar entre displays
    logic [3:0] current_digit; // dígito actual a mostrar

    // === Divisor de frecuencia para 1 kHz refresco ===
    localparam integer MAX_COUNT = 27000;
    logic [14:0] counter = 0; // contador de 15 bits para el divisor de frecuencia

    always_ff @(posedge clk) begin
        if (counter == MAX_COUNT - 1) begin 
            counter <= 0;
            refresh_clk <= 1;
        end else begin
            counter <= counter + 1;
            refresh_clk <= 0;
        end
    end

    // === Toggle entre displays ===
    always_ff @(posedge clk) begin
        if (refresh_clk)
            toggle <= ~toggle; // alternar entre 0 y 1
    end

    // === MUX de entrada y control de ánodos ===
    always_comb begin
        if (toggle == 0) begin
            current_digit = bin; // mostrar la palabra de 4 bits
            an = 2'b10;
        end else begin
            current_digit = {1'b0, sin}; // mostrar el síndrome de 3 bits
            an = 2'b01;
        end
    end

    // === Instanciación del decodificador externo ===
    bin4_to_7seg_sec dec_inst (
        .bit(current_digit),
        .seg(seg)
    );

endmodule