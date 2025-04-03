
module display_mux(
    input  logic       clk,      // Señal de reloj (no usado en esta versión combinacional)
    input  logic       btn,      // Botón para seleccionar display
    input  logic [3:0] bin,      // Valor binario (palabra corregida)
    input  logic [2:0] sin,      // Síndrome
    output logic [6:0] seg,      // Segmentos (compartidos entre displays)
    output logic [1:0] an        // Ánodos (selección de display)
);
    
    // Señales temporales para los segmentos
    logic [6:0] seg_bin;  // 7 segmentos para valor binario
    logic [6:0] seg_sin;  // 7 segmentos para síndrome
    
    // Instanciar convertidores de 7 segmentos
    sindrome_to_7seg sindrome_to_7seg_inst(
        .sin(sin),
        .seg(seg_sin)
    );
    
    bin4_to_7seg_sec bin4_to_7seg_sec_inst(
        .bin(bin),
        .seg(seg_bin)
    );
    
    // Lógica combinacional basada en el estado del botón
    always_comb begin
        if (btn) begin
            // Botón presionado: mostrar síndrome
            seg = seg_bin;
            an = 2'b10;     // Activar segundo display
        end else begin
            // Botón no presionado: mostrar valor binario
            seg = seg_sin;
            an = 2'b01;     // Activar primer display
        end

    end
endmodule