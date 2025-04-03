module module_led_display(
    
    input  logic [3:0] data_corrected,         // Palabra corregida del subsistema de corrección
    output logic [3:0] led               // Salidas a los LEDs de la FPGA

    );
    
    assign led = ~data_corrected;

endmodule