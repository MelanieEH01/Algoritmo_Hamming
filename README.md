# Introducción a diseño digital en HDL
### Estudiantes:
-Yohel Alas Gómez

-Melanie Espinoza Hernández

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **MSB**: Most Significant Bit
- **LSB**: Least Significant Bit
- **btn**: Botón

## 2. Referencias
[1] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema
El sistema implementado consiste una detección y corrección de errores basado en el código Hamming(7,4), diseñado para proteger transmisiones de datos de 4 bits. El sistema consta de varios módulos que trabajan en conjunto para codificar, detectar y corregir errores de un solo bit, así como para visualizar el resultado. El flujo de trabajo comienza con la codificación de la palabra original de 4 bits, añadiendo 3 bits de paridad. Luego, se simula la transmisión y posible corrupción de datos mediante interruptores. El sistema detecta cualquier discrepancia calculando el síndrome del error, localiza y corrige el bit afectado, y finalmente muestra tanto la palabra corregida en LEDs de la FPGA como el síndrome y la palabra corregida en displays de 7 segmentos.

### 3.1 Módulo 1
#### 3.1.1. module_encoder
```SystemVerilog
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
```
#### 3.1.2. Parámetros

No se definen parámetros para este módulo.

#### 3.1.3. Entradas y salidas

###### Entradas:
- `switch_input[3:0]`: Se configura la entrada desde interruptores (dip switch), donde switch_input[0] corresponde al LSB y switch_input[3] al MSB.
###### Salidas:
- `parity_original[2:0]`: Contiene los bits de paridad calculados, donde parity_original[0] corresponde al bit c0, parity_original[1] al bit c1 y parity_original[2] al bit c2.

#### 3.1.4. Descripción del módulo
 El módulo `module_encoder` implementa un codificador que genera bits de paridad para detección de errores. Extrae los 4 bits de datos de entrada, calcula tres bits de paridad mediante XOR entre bits específicos, construye la palabra codificada de 7 bits y verifica la paridad mediante XOR entre datos y bits de paridad, produciendo como salida los bits de paridad original.

#### 3.1.5. Criterios de diseño
![module_encoder](https://github.com/MelanieEH01/Images_README/blob/db9f83d1e0962d2d328390ba1755ff41acee7fe2/Proyecto_1/module_encoder.png)


### 3.2 Módulo 2
#### 3.2.1. module_decoder
```SystemVerilog
module module_decoder(
    
    input logic [6:0] switch_error,       // 7 bits con posible error
    output logic [2:0] parity_error     // 3 bits de paridad recalculados

    );

    logic c0_err, c1_err, c2_err;	//Cálculo de paridades

    // Calcular los bits de paridad del código recibido
    assign c0_err = switch_error[6] ^ switch_error[4] ^ switch_error[2] ^ switch_error[0];
    assign c1_err = switch_error[6] ^ switch_error[5] ^ switch_error[2] ^ switch_error[1];
    assign c2_err = switch_error[6] ^ switch_error[5] ^ switch_error[4] ^ switch_error[3];

    // Extracción de los bits de paridad de la palabra recibida
    assign parity_error = {c2_err, c1_err, c0_err};  // c2, c1, c0

    
endmodule
```
#### 3.2.2. Parámetros

No se definen parámetros para este módulo.

#### 3.2.3. Entradas y salidas
###### Entradas:
- `switch_error[6:0]`: Entrada de la palabra recibida con posible error, donde switch_error[0] corresponde al LSB (c0) y switch_error[6] MSB (i3).
###### Salidas:
- `parity_error[2:0]`: Contiene los bits de paridad recalculados a partir de la palabra recibida, siguiendo el mismo orden que parity_original.

#### 3.2.4. Descripción del módulo
El módulo `module_decoder` recalcula los bits de paridad a partir de una palabra de 7 bits ingresada potencialmente con error. Calcula tres bits de paridad mediante operaciones XOR de ciertos bits de la palabra recibida, siguiendo el patrón de código Hamming para verificación de paridad.

#### 3.2.5. Criterios de diseño
![module_decoder](https://github.com/MelanieEH01/Images_README/blob/69ec1be5492ee66390c3db05843f07aff60c5606/Proyecto_1/module_decoder.png)


### 3.3 Módulo 3
#### 3.3.1. module_error_detection
```SystemVerilog
module module_error_detection(
  
    input  logic [2:0] parity_original,  // Bits de paridad originales
    input  logic [2:0] parity_error,     // Bits de paridad recibidos
    output logic [2:0] sindrome         // Síndrome de error (posición del bit erróneo)
);

    // Cálculo del síndrome de error
    assign sindrome = parity_original ^ parity_error;
    
endmodule
```
#### 3.3.2. Parámetros

No se definen parámetros para este módulo.

#### 3.3.3 Entradas y salidas:
###### Entradas:
- `parity_original[2:0]`: Recibe los bits de paridad originales recalculados por el codificador.
- `parity_error[2:0]`: Recibe los bits de paridad recalculados por el decodificador.
###### Salidas:
- `sindrome[2:0]`: Proporciona el síndrome del error, donde un valor de 000 indica ausencia de error y cualquier otro valor indica la posición del bit erróneo.

#### 3.3.4. Descripción del módulo
El módulo `module_error_detection` detecta errores comparando los bits recalculados de paridad original codificada con los bits recalculados de la palabra recibida mediante XOR, generando un síndrome que indica la presencia y posición del bit erróneo.

#### 3.3.5. Criterios de diseño
![module_error_detection](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/module_error_detection.png)


### 3.4 Módulo 4
#### 3.4.1. module_error_correction
```SystemVerilog
module module_error_correction(
    input  logic [6:0] word_error,        // Palabra recibida (posiblemente con error)
    input  logic [2:0] sindrome,          // Síndrome de error
    output logic [3:0] data_corrected     // Datos de la palabra corregida
);
    // Extraer los bits de datos sin corregir
    logic i0, i1, i2, i3;
    assign i0 = word_error[2];  // Bit i0
    assign i1 = word_error[4];  // Bit i1
    assign i2 = word_error[5];  // Bit i2
    assign i3 = word_error[6];  // Bit i3
    
    // Generación de señales para detectar cada síndrome específico
    // Usando compuertas AND y NOT para las comparaciones
    
    // Detección de síndrome 011 (i0 error)
    logic sindrome_i0;
    assign sindrome_i0 = ~sindrome[2] & sindrome[1] & sindrome[0];
    
    // Detección de síndrome 101 (i1 error)
    logic sindrome_i1;
    assign sindrome_i1 = sindrome[2] & ~sindrome[1] & sindrome[0];
    
    // Detección de síndrome 110 (i2 error)
    logic sindrome_i2;
    assign sindrome_i2 = sindrome[2] & sindrome[1] & ~sindrome[0];
    
    // Detección de síndrome 111 (i3 error)
    logic sindrome_i3;
    assign sindrome_i3 = sindrome[2] & sindrome[1] & sindrome[0];
    
    // Corrección de cada bit usando compuertas XOR
    // Si sindrome_ix es 1, el bit se invierte; si es 0, queda igual
    
    // Corrección de i0
    logic i0_corrected;
    assign i0_corrected = i0 ^ sindrome_i0;
    
    // Corrección de i1
    logic i1_corrected;
    assign i1_corrected = i1 ^ sindrome_i1;
    
    // Corrección de i2
    logic i2_corrected;
    assign i2_corrected = i2 ^ sindrome_i2;
    
    // Corrección de i3
    logic i3_corrected;
    assign i3_corrected = i3 ^ sindrome_i3;
    
    // Combinar los bits corregidos en la salida
    assign data_corrected = {i3_corrected, i2_corrected, i1_corrected, i0_corrected};
    
endmodule
```
#### 3.4.2. Parámetros

No se definen parámetros para este módulo.

#### 3.4.3. Entradas y salidas:
###### Entradas:
- `word_error[6:0]`: Recibe la palabra completa con el posible error.
- `sindrome[2:0]`: Recibe el síndrome del error calculado por el detector.
###### Salidas:
- `data_corrected[3:0]`: Proporciona los 4 bits de datos corregidos, donde data_corrected[0] es el LSB y data_corrected[3] el MSB.

#### 3.4.4. Descripción del módulo
El módulo `module_error_correction` primero extrae los cuatro bits de datos (i3, i2, i1, i0) de la palabra recibida con posible error, ubicados en posiciones específicas de la palabra de 7 bits. Luego realiza un análisis del síndrome de 3 bits para identificar con precisión qué bit contiene el error. Para esto, utiliza operaciones lógicas AND y NOT que decodifican el síndrome en cuatro señales binarias (sindrome_i0 a sindrome_i3), donde cada una se activa únicamente cuando el síndrome indica error en su bit correspondiente. Una vez identificado el bit erróneo, el módulo aplica operaciones XOR entre cada bit de datos y su señal de síndrome correspondiente: si la señal del síndrome está activa (1), el bit se invierte para corregirlo; si está inactiva (0), el bit permanece sin cambios. Finalmente, combina los cuatro bits ya corregidos en una salida de 4 bits.

#### 3.4.5. Criterios de diseño
![module_error_correction](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/module_error_correction.png)


### 3.5 Módulo 5
#### 3.5.1. module_led_display
```SystemVerilog
module module_led_display(
    
    input  logic [3:0] data_corrected,         // Palabra corregida del subsistema de corrección
    output logic [3:0] led               // Salidas a los LEDs de la FPGA

    );
    
    assign led = ~data_corrected;

endmodule
```
#### 3.5.2. Parámetros

No se definen parámetros para este módulo.

#### 3.5.3. Entradas y salidas:
###### Entradas:
- `data_corrected[3:0]`: Recibe la palabra de 4 bits ya corregida.
###### Salidas:
- `led[3:0]`: Se establece la salida invertida hacia los LEDs, donde led[0] corresponde al LSB y led[3] al MSB.

#### 3.5.4. Descripción del módulo
El módulo `module_led_display` muestra la palabra corregida en los LEDs de la FPGA, invirtiendo los bits de datos corregidos ya que los LEDs típicamente se encienden con nivel bajo.

#### 3.5.5. Criterios de diseño
![leds](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/module_led_display.png)


### 3.6 Módulo 6
#### 3.6.1. bin4_to_7seg_sec
```SystemVerilog
module bin4_to_7seg_sec(
    input  logic [3:0] data_corrected,   // 4 bits de datos corregidos
    output logic [6:0] seg              // Segmentos (activo en bajo)
);
    
    // Mapeo de 4 bits a 7 segmentos (común cátod - 0 activa el segmento)
    assign seg = (data_corrected == 4'b0000) ? 7'b1000000 : // 0
                 (data_corrected == 4'b0001) ? 7'b1111001 : // 1
                 (data_corrected == 4'b0010) ? 7'b0100100 : // 2
                 (data_corrected == 4'b0011) ? 7'b0110000 : // 3
                 (data_corrected == 4'b0100) ? 7'b0011001 : // 4
                 (data_corrected == 4'b0101) ? 7'b0010010 : // 5
                 (data_corrected == 4'b0110) ? 7'b0000010 : // 6
                 (data_corrected == 4'b0111) ? 7'b1111000 : // 7
                 (data_corrected == 4'b1000) ? 7'b0000000 : // 8
                 (data_corrected == 4'b1001) ? 7'b0010000 : // 9
                 (data_corrected == 4'b1010) ? 7'b0001000 : // A
                 (data_corrected == 4'b1011) ? 7'b0000011 : // b
                 (data_corrected == 4'b1100) ? 7'b1000110 : // C
                 (data_corrected == 4'b1101) ? 7'b0100001 : // d
                 (data_corrected == 4'b1110) ? 7'b0000110 : // E
                 (data_corrected == 4'b1111) ? 7'b0001110 : // F
                 7'b1111111;  // default: Todos apagados

endmodule
```
#### 3.6.2. Parámetros

No se definen parámetros para este módulo.

#### 3.6.3. Entradas y salidas:
###### Entradas:
- `data_corrected[3:0]`: Recibe el valor binario de 4 bits a mostrar en el display.
###### Salidas:
- `seg[6:0]`: Configura los segmentos del display, donde cada bit controla un segmento específico (activo en bajo).

#### 3.6.4. Descripción del módulo
El módulo `bin4_to_7seg_sec` implementa un decodificador de 4 bits a 7 segmentos, donde un 0 en la salida activa el segmento correspondiente. Utiliza una serie de operadores condicionales ternarios anidados para mapear cada valor binario de 4 bits a su representación específica en un display de 7 segmentos. El módulo soporta la representación de todos los dígitos hexadecimales (0-9 y A-F). Cada bit de salida controla un segmento específico del display, y la combinación de estos bits encendidos o apagados forma el patrón visual del número o letra. Si se recibe un valor no definido, todos los segmentos se apagan por defecto.

#### 3.6.5. Criterios de diseño
![bin_7seg](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/bin4_to_7seg_sec.png)


### 3.7 Módulo 7
#### 3.7.1. sindrome_to_7seg
```SystemVerilog
module sindrome_to_7seg(
    input  logic [2:0] sindrome,   // Síndrome de 3 bits
    output logic [6:0] seg    // Segmentos (activo en bajo)
);
    
    // Mapeo de síndrome a 7 segmentos (común cát - 0 activa el segmento)
    assign seg = (sindrome == 3'b000) ? 7'b1000000 : // 0
                 (sindrome == 3'b001) ? 7'b1111001 : // 1
                 (sindrome == 3'b010) ? 7'b0100100 : // 2
                 (sindrome == 3'b011) ? 7'b0110000 : // 3
                 (sindrome == 3'b100) ? 7'b0011001 : // 4
                 (sindrome == 3'b101) ? 7'b0010010 : // 5
                 (sindrome == 3'b110) ? 7'b0000010 : // 6
                 (sindrome == 3'b111) ? 7'b1111000 : // 7
                7'b1111111;  // default: segmentos apagados

endmodule
```
#### 3.7.2. Parámetros

No se definen parámetros para este módulo.

#### 3.7.3. Entradas y salidas:
###### Entradas:
- `sindrome[2:0]`: Recibe el síndrome de 3 bits a mostrar en el display.
###### Salidas:
- `seg[6:0]`: Configura los segmentos del display para representar el valor del síndrome (activo en bajo).

#### 3.7.4. Descripción del módulo
El módulo `sindrome_to_7seg` funciona como un decodificador específico para convertir un valor de síndrome de 3 bits en una representación de 7 segmentos para displays de cátodo común. Utiliza una estructura de operadores condicionales ternarios anidados para mapear cada uno de los ocho posibles valores del síndrome (000 a 111) a su correspondiente configuración de segmentos. Al igual que en el módulo `bin4_to_7seg_sec`, un 0 en cada bit de la salida activa el segmento respectivo del display.

#### 3.7.5. Criterios de diseño
![sin_7seg](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/sindrome_to_7seg.png)


### 3.8 Módulo 8
#### 3.8.1. display_mux
```SystemVerilog

module display_mux(
    input  logic       btn,      // Botón para seleccionar display
    input  logic [3:0] data_corrected,      // Valor binario (palabra corregida)
    input  logic [2:0] sindrome,      // Síndrome
    output logic [6:0] seg,      // Segmentos (compartidos entre displays)
    output logic [1:0] an        // Ánodos (selección de display)
);
    
    // Señales temporales para los segmentos
    logic [6:0] seg_data;  // 7 segmentos para valor binario
    logic [6:0] seg_sin;  // 7 segmentos para síndrome
    
    // Instanciar convertidores de 7 segmentos
    sindrome_to_7seg sindrome_to_7seg_inst(
        .sindrome(sindrome),
        .seg(seg_sin)
    );
    
    bin4_to_7seg_sec bin4_to_7seg_sec_inst(
        .data_corrected(data_corrected),
        .seg(seg_data)
    );
    
    // Lógica combinacional basada en el estado del botón usando multiplexores 2:1
    
    assign seg = btn ? seg_sin : seg_data;       // Para los segmentos: si btn=1 selecciona seg_sin, si btn=0 selecciona seg_bin
    
    assign an = btn ? 2'b10 : 2'b01;        // Para los ánodos: si btn=1 selecciona 2'b10, si btn=0 selecciona 2'b01


endmodule
```
#### 3.8.2. Parámetros

No se definen parámetros para este módulo.

#### 3.8.3. Entradas y salidas:
###### Entradas:
- `btn`: Recibe la señal del botón para alternar entre mostrar el síndrome o la palabra corregida.
- `data_corrected[3:0]`: Recibe el valor binario de la palabra corregida.
- `sindrome[2:0]`: Recibe el valor del síndrome.
###### Salidas:
- `seg[6:0]`: Configura los segmentos del display según la información seleccionada.
- `an[1:0]`: Controla qué display se activa, donde an[0] corresponde al primer display y an[1] al segundo.

#### 3.8.4. Descripción del módulo
El módulo `display_mux` implementa un sistema de multiplexado para controlar dos displays de 7 segmentos usando una sola salida física. Primero instancia dos convertidores: sindrome_to_7seg para generar los patrones de segmentos del síndrome de 3 bits, y bin4_to_7seg_sec para convertir la palabra binaria corregida de 4 bits a su representación en 7 segmentos. Luego, utiliza multiplexores 2:1 controlados por la entrada de botón (btn) para seleccionar qué señales enviar a las salidas. Para los segmentos (seg), selecciona seg_sin cuando el botón está presionado (btn=1) o seg_bin cuando no lo está (btn=0). Simultáneamente, para los ánodos (an), selecciona activar el segundo display (an=10) cuando el botón está presionado o el primer display (an=01) cuando no lo está. Esta implementación permite al usuario alternar la visualización entre el valor del síndrome y la palabra corregida con solo presionar un botón.

#### 3.8.5. Criterios de diseño
![7seg](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/display_mux.png)


### 3.9 Módulo 9
#### 3.9.1. top_module
```SystemVerilog
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
```
#### 3.9.2. Parámetros

No se definen parámetros para este módulo.

#### 3.9.3. Entradas y salidas:
###### Entradas:
- `swi_word_tx[3:0]`: Se configura mediante interruptores para la palabra original a transmitir.
- `swi_word_rx[6:0]`: Se configura mediante interruptores para simular la palabra recibida con posible error.
- `btn`: Controla qué información se muestra en los displays (síndrome o palabra corregida).
###### Salidas:
- `led[3:0]`: Muestra la palabra corregida en los LEDs de la FPGA.
- `seg[6:0]`: Controla los segmentos del display seleccionado.
- `anodo[1:0]`: Selecciona cuál de los displays se activa para mostrar información.


#### 3.9.4. Descripción del módulo
Integra todos los módulos anteriores para formar el sistema completo de detección y corrección de errores, conectando el codificador, decodificador, detector de errores, corrector de errores, controlador de LEDs y multiplexor de displays para implementar un código Hamming (7,4) que puede detectar y corregir un solo error de bit en una palabra de 7 bits.

#### 3.9.5. Criterios de diseño
![top](https://github.com/MelanieEH01/Images_README/blob/bbd6eae6a9600ed92a021bd227f549a55c4cf417/Proyecto_1/top_module.png)

#### 3.9.6. Testbench
```SystemVerilog
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
```
##### 3.9.6.1 Descripción
Este testbench es utilizado para validar el funcionamiento del sistema completo de código Hamming. Comienza inicializando las señales de entrada con valores por defecto y declarando las señales de salida que serán monitoreadas. Instancia el módulo top_module bajo prueba, conectando todas las señales necesarias. El testbench ejecuta cuatro casos de prueba específicos que simulan diferentes escenarios de error: un error en la posición 5, un error en la posición 6, un error en la posición 7 y un error en la posición 2. Para cada caso, establece los valores de palabra de entrada y palabra con error, simula la pulsación del botón para cambiar entre displays, y muestra los resultados formateados en tablas que incluyen la palabra transmitida, la palabra con error, el síndrome calculado y la palabra corregida. El testbench también genera un archivo VCD para visualización de formas de onda y finaliza la simulación después de completar todas las pruebas. Esta estructura permite verificar sistemáticamente la capacidad del sistema para detectar y corregir errores en diferentes posiciones de bit, validando que los síndromes generados y las correcciones aplicadas sean correctos en cada caso.

##### 3.9.6.2 Resultados
###### Consola
![consola](https://github.com/MelanieEH01/Images_README/blob/a1d6a3e67e6efc2735f0b7363bf65a42678b4916/Proyecto_1/Consola.png)

###### GTKWave (Simulación)
![gtkwave](https://github.com/MelanieEH01/Images_README/blob/a1d6a3e67e6efc2735f0b7363bf65a42678b4916/Proyecto_1/gtkwave.png)

A partir de la imagen de GTKWave, se puede rastrear el flujo de señales a través del sistema. 
Se explicará el primer ejemplo, la entrada original es `switch_input[3:0]` = 1101 (13 en decimal), que se codifica como `encoded_word[6:0]` = 1100110 con bits de paridad originales `parity_original[2:0]` = 000. En la simulación, se introduce un error, resultando en `switch_error[6:0] = 1110110`, con una diferencia en el bit 5. Los bits de paridad recalculados `parity_error[2:0]` = 101 generan el síndrome `sindrome[2:0]` = 101, que correctamente identifica la posición del error.
El subsistema de corrección funciona adecuadamente, recuperando los datos originales como `data_corrected[3:0]` = 1101, que se muestra invertido en los LEDs como `led[3:0]` = 0010. El sistema de visualización alterna entre mostrar el síndrome y el dato corregido a través de los segmentos `seg[6:0]`, que cambian entre 0100001 y 0000010 según el estado del botón.
La simulación confirma que el codificador genera correctamente los bits de paridad para la palabra de entrada, el subsistema de detección de errores identifica adecuadamente el síndrome (101 = 5), el módulo de corrección de errores repara con éxito el error en la palabra recibida, y el sistema de display de 7 segmentos muestra correctamente el síndrome o los datos corregidos según la entrada del botón.

## 4. Consumo de recursos
Sobre el archivo synthesis_tangnano9k.log se obtuvieron las siguientes características:
![recursos](https://github.com/MelanieEH01/Images_README/blob/8b9b8ad17e5045fb8d3993f3d5fcc7a86c7c3dcd/Proyecto_1/recursos.png)

El informe de síntesis para el top_module revela un consumo de 303 células lógicas distribuidas entre diferentes tipos de look-up tables (LUTs). La mayor parte del consumo corresponde a LUT4 con 137 unidades, seguido por MUX2_LUT5 con 72 unidades. El resto de recursos se distribuye entre otros tipos de LUTs, incluidos MUX2_LUT6 (36 unidades), MUX2_LUT7 (18 unidades) y MUX2_LUT8 (7 unidades). Adicionalmente, el diseño utiliza elementos de interfaz: 12 buffers de entrada (IBUF) para manejar las señales provenientes de los interruptores y botones, y 13 buffers de salida (OBUF) para controlar los LEDs y displays de 7 segmentos.
La conectividad del diseño muestra un total de 288 cables con 338 bits de cables, todos ellos clasificados como públicos. Estos recursos representan las interconexiones necesarias para comunicar los diferentes módulos del sistema, como el codificador, decodificador, detector de errores y corrector de errores. El número relativamente alto de conexiones refleja la naturaleza modular del diseño, donde cada componente realiza una función específica en el proceso de detección y corrección.
Un aspecto destacable del diseño es la ausencia total de elementos de memoria, con cero memorias y cero bits de memoria utilizados. Esto confirma que la implementación es completamente combinacional, procesando las entradas y generando las salidas sin necesidad de almacenar estados intermedios. Esta característica es coherente con la naturaleza del código Hamming implementado, que permite la detección y corrección de errores mediante operaciones lógicas directas sin requerir elementos secuenciales.
La concentración de recursos en LUT4 y MUX2_LUT5 sugiere que las funciones más complejas del diseño están relacionadas con la decodificación para los displays de 7 segmentos y los circuitos de corrección de errores.

## 5. Problemas encontrados durante el proyecto


# Oscilador en anillo

