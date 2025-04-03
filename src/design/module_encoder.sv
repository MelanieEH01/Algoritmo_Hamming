// Este módulo implementa un codificador que genera bits de paridad para detección de errores
module module_encoder(

    input logic [3:0] switch_input,         // Entrada de 4 bits desde interruptores
    output logic [2:0] parity_original     // Salida de 3 bits con información de paridad

    );

    logic i0, i1, i2, i3;
    assign {i3, i2, i1, i0} = switch_input;

    // Cálculo de los bits de paridad usando operación XOR
    // Declaración de los bits de paridad según la nomenclatura vista en clase

    logic c0, c1, c2;
    assign c0 = i3 ^ i1 ^ i0; // c0 = i3 ⊕ i1 ⊕ i0
    assign c1 = i3 ^ i2 ^ i0; // c1 = i3 ⊕ i2 ⊕ i0
    assign c2 = i3 ^ i2 ^ i1; // c2 = i3 ⊕ i2 ⊕ i1
   
    // Construcción de la palabra codificada de 7 bits con datos y paridad
    logic [6:0] encoded_word;
    assign encoded_word = {i3,i2,i1,c2,i0,c1,c0};

    // Verificación de paridad: XOR entre los bits de datos y sus bits de paridad
    logic c0_calc, c1_calc, c2_calc;

    assign c0_calc = i3 ^ i1 ^ i0 ^ c0;
    assign c1_calc = i3 ^ i2 ^ i0 ^ c1;
    assign c2_calc = i3 ^ i2 ^ i1 ^ c2;
   
    assign parity_original = {c2_calc, c1_calc, c0_calc};

endmodule