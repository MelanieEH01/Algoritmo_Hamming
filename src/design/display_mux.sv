module display_mux (
    input  logic        clk,         // reloj de 27 MHz
    input  logic [3:0]  bin,        // palabra de 4 bits 
    input  logic [2:0]  sin,    // síndrome de 3 bits
    output logic [6:0]  seg,         // salidas del display (a-g)
    output logic [1:0]  an           // ánodos activos bajos (display enable)
);
    logic contador 1'b0; // contador de 1 bit para alternar entre displays
    logic       refresh_clk; // reloj de refresco para el display
    logic [3:0] current_digit; // dígito actual a mostrar

    // === Divisor de frecuencia para 1 kHz refresco ===
    parameter COUNT = 500; // divisor de frecuencia para 1 kHz (27 MHz / 27000 = 1 kHz)
    localparam integer WIDTH_COUNT = $clog(COUNT); // ancho del contador
    logic [WIDTH_COUNT - 1:0] counter = 0; // contador para el divisor de frecuencia

    always_ff @(posedge clk) begin
        if (counter == COUNT)  begin 
            counter <= 0;
            contador <= contador + 1; // alternar entre 0 y 1
        end else if (count == COUNT - 1) begin
            counter <= 0;
            contador <= 1'b0; // reiniciar el contador
        end else begin
        contador <= contador + 1; // incrementar el contador
        end
    end

   always_comb begin
        case (contador)
            1'b0: begin
                an = 2'b01; // habilitar el primer display
                current_digit = bin; // mostrar el valor binario
            end
            1'b1: begin
                an = 2'b10; // habilitar el segundo display
                current_digit = {1'b0,sin}; // mostrar el síndrome
            end
// === Instanciación del decodificador externo ===
     bin4_to_7seg_sec dec_inst (
        .bin(current_digit),
        .seg(seg)
    );
        endcase
    end
endmodule