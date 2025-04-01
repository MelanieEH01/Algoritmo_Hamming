module display_mux(
    input  logic clk,                   // 27 MHz
    input  logic rst,                   // Reset
    input  logic [3:0] bin,          // Número binario a mostrar (display 0)
    input  logic [2:0] sin,        // Síndrome (display 1)
    output logic [6:0] seg,             // Segmentos compartidos {a,b,c,d,e,f,g}
    output logic [1:0] an               // Ánodos activos bajos
);

    // Señal del reloj a 27 kHz
    logic clk_27k;

    // Instancia del divisor de reloj: 27MHz -> 27kHz
    clk_div_27kHz div27 (
        .clk(clk),
        .rst(rst),
        .clk_27k(clk_27k)
    );

    // Decodificadores a 7 segmentos
    logic [6:0] seg_bin;
    logic [6:0] seg_sin;

    // Para mostrar el síndrome en 7 segmentos lo pasamos a 4 bits con cero extendido
    logic [3:0] sindrome_ext = {1'b0, sindrome};

    bin4_to_7seg_anodo dec_bin (
        .bin(bin),
        .seg(seg_bin)
    );

    sindrome_to_7seg dec_sin (
        .sin(sin),
        .seg(seg_sin)
    );

    // Multiplexor entre los dos displays
    logic sel;

    always_ff @(posedge clk_27k or posedge rst) begin
        if (rst)
            sel <= 0;
        else
            sel <= ~sel;
    end

    always_comb begin
        case (sel)
            1'b0: begin
                seg = seg_numero;
                an  = 2'b10; // Display 0 activo (numero)
            end
            1'b1: begin
                seg = seg_sindrome;
                an  = 2'b01; // Display 1 activo (sindrome)
            end
        endcase
    end

endmodule