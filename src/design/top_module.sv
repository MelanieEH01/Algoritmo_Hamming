module top_module(

    input  logic [3:0] swi_word_tx,  // 4 conmutadores para palabra de referencia
    input  logic [6:0] swi_word_rx,  // 7 conmutadores para palabra con posible error
    input  logic       btn,          // Botón para cambiar el display
    output logic [3:0] led,          // LEDs para mostrar palabra corregida
    output logic [6:0] seg,          // Segmentos del display (activo en bajo para ánodo común)
    output logic [1:0] anodo         // Ánodos para seleccionar display (activo en alto para ánodo común) 

    );

    logic [2:0] parity_original;
    logic [2:0] parity_error;          
    logic [2:0] sindrome;                                       
    logic [3:0] data_corrected;
         

    // Subsistema de lectura y codificación de la palabra transmitida
    module_encoder encoder_inst(
        .switch_input(swi_word_tx),    
        .parity_original(parity_original)      
    );

    // Subsistema de lectura y codificación de la palabra transmitida
    module_decoder decoder_inst(
        .switch_error(swi_word_rx),    
        .parity_error(parity_error)      
    );

    // Subsistema verificador de paridad y detector de error
    module_error_detection error_detection_inst(
        .parity_original(parity_original),  
        .parity_error(parity_error), 
        .sindrome(sindrome)                          
    );

    // Subsistema de corrección de error sobre la palabra recibida
    module_error_correction error_correction_inst(
        .word_error(swi_word_rx),
        .sindrome(sindrome),        
        .data_corrected(data_corrected)      
    );


    // Subsistema de despliegue de palabra corregida en LEDs
    module_led_display led_display_inst(
        .data_corrected(data_corrected),   
        .led(led)              // Salida a los LEDs negada para que enciendan en la FPGA
    );
  
    //Módulo de despliegue de síndrome en 7 segmentos
    display_mux display_mux_inst(
        .btn(btn),              // Botón para alternar entre displays
        .bin(data_corrected),   // Palabra corregida a mostrar
        .sin(sindrome),         // Síndrome a mostrar
        .seg(seg),              // Segmentos del display
        .an(anodo)              // Selección de display
    );

endmodule