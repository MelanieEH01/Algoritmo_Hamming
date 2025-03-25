`timescale 1ns/1ps

module tb_top_module;
    // Definición de señales de prueba
    logic [3:0] swi_word_tx = 4'b0000;
    logic [6:0] swi_word_rx = 7'b0000000;
    logic [3:0] final_word;

    // Instancia del módulo bajo prueba (UUT: Unit Under Test)
    top_module uut (
        .swi_word_tx(swi_word_tx),
        .swi_word_rx(swi_word_rx),
        .final_word(final_word)
    );

    initial begin

        // Display para resultados
        
        
        // Probar valores (error en posicion 5)
        swi_word_tx = 4'b1101;
        swi_word_rx    = 7'b1110110;
        #20

        $display("---------------------|------------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------------------------------");
        $display("         %b                  %b                             %b\n", swi_word_tx, swi_word_rx, final_word);

        // Probar valores (error en posicion 6)
        swi_word_tx = 4'b0110;
        swi_word_rx    = 7'b0010011;
        #20
        $display("---------------------|------------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------------------------------");
        $display("         %b                  %b                             %b\n", swi_word_tx, swi_word_rx, final_word);
        
        // Probar valores (error en posicion 7)
        swi_word_tx = 4'b1010;
        swi_word_rx    = 7'b0010010;
        #20
        $display("---------------------|------------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------------------------------");
        $display("         %b                  %b                             %b\n", swi_word_tx, swi_word_rx, final_word);

        // Probar valores (error en posicion 2)
        swi_word_tx = 4'b1010;
        swi_word_rx    = 7'b1010000;
        #20
        $display("---------------------|------------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------------------------------");
        $display("         %b                  %b                             %b\n", swi_word_tx, swi_word_rx, final_word);

        $finish;
    end


    // Proceso de simulación
    initial begin
        $dumpfile("hamming_test.vcd");
        $dumpvars(0, tb_top_module);
        
    end

endmodule