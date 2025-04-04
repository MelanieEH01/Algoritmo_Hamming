`timescale 1ns/1ps

module tb_top_module;
    // Definición de señales de prueba
    logic [3:0] swi_word_tx = 4'b0000;
    logic [6:0] swi_word_rx = 7'b0000000;
    logic       btn = 0;           // Botón para cambiar el display
    logic       clk = 0;           // Reloj del sistema
    logic [3:0] led;               // LEDs para mostrar palabra corregida
    logic [6:0] seg;               // Segmentos del display
    logic [1:0] anodo;             // Ánodos para seleccionar display

    // Instancia del módulo bajo prueba (UUT: Unit Under Test)
    top_module uut (
        .swi_word_tx(swi_word_tx),
        .swi_word_rx(swi_word_rx),
        .btn(btn),
        .led(led),
        .seg(seg),
        .anodo(anodo)
    );

    // Generación de reloj (periodo de 10ns = 100MHz)
    always #5 clk = ~clk;

    initial begin
        // Display para resultados
        
        // Probar valores (error en posicion 5 - i2)
        swi_word_tx = 4'b1101;
        swi_word_rx = 7'b1110110;
        #20
        
        // Simular pulsación de botón
        btn = 1;
        #10
        btn = 0;
        #10

        $display("---------------------|------------------------|------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   |     Sindrome     | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |    c2,c1,c0      |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------|------------------------------------------");
        $display("         %b                  %b                %b                        %b", swi_word_tx, swi_word_rx, uut.sindrome, led);

        // Probar valores (error en posicion 6 - i1)
        swi_word_tx = 4'b0110;
        swi_word_rx = 7'b0010011;
        #20
        
        // Simular pulsación de botón
        btn = 1;
        #10
        btn = 0;
        #10
        
        $display("---------------------|------------------------|------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   |     Sindrome     | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |    c2,c1,c0      |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------|------------------------------------------");
        $display("         %b                  %b                %b                        %b\n", swi_word_tx, swi_word_rx, uut.sindrome, led);
        
        // Probar valores (error en posicion 7 - i3)
        swi_word_tx = 4'b1010;
        swi_word_rx = 7'b0010010;
        #20
        
        // Simular pulsación de botón
        btn = 1;
        #10
        btn = 0;
        #10
        
         $display("---------------------|------------------------|------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   |     Sindrome     | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |    c2,c1,c0      |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------|------------------------------------------");
        $display("         %b                  %b                %b                        %b", swi_word_tx, swi_word_rx, uut.sindrome, led);

        // Probar valores (error en posicion 2 - i0)
        swi_word_tx = 4'b1010;
        swi_word_rx = 7'b1010000;
        #20
        
        // Simular pulsación de botón
        btn = 1;
        #10
        btn = 0;
        #10
        
         $display("---------------------|------------------------|------------------|------------------------------------------");
        $display(" Palabra Transmitida |    Palabra con Error   |     Sindrome     | Palabra Corregida (Negada para los LEDS) ");
        $display("     i3,i2,i1,i0     |  i3,i2,i1,c2,i0,c1,c0  |    c2,c1,c0      |                i3,i2,i1,i0               ");
        $display("---------------------|------------------------|------------------|------------------------------------------");
        $display("         %b                  %b                %b                        %b", swi_word_tx, swi_word_rx, uut.sindrome, led);

        // Agregar información sobre display de 7 segmentos y síndrome
        $display("\nEstado de los displays de 7 segmentos:");
        $display("Segmentos: %b, Anodos activos: %b", seg, anodo);

        $finish;
    end

    // Proceso de simulación
    initial begin
        $dumpfile("hamming_test.vcd");
        $dumpvars(0, tb_top_module);
    end

endmodule