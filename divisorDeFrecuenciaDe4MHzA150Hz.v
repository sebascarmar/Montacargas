`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnológica Nacional - Facutlad Regional Córdoba
// Engineer: Carreño Marin, Sebastian
// 
// Create Date:    17:02:17 11/25/2021 
// Design Name: 
// Module Name:    divisorDeFrecuenciaDe4MHzA150Hz 
// Project Name:   MontacargasProyectoFinal
// Target Devices: 
// Tool versions: 
// Description:    Este módulo realiza la división de frencuencia del reloj de entrada,
//    obteniendo así, un reloj interno de una frecuencia de 150Hz. Este frecuencia es la
//    elegida debido a que la máquina trabaja con 3 displays (uno por piso). Entonces,
//    con el uso de un contador anillo, se multiplexan los displays, resultando así una
//    frecuencia de 50Hz de refresco por cada display.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module divisorDeFrecuenciaDe4MHzA150Hz(
  input      clockBase_4MHz,
  output reg clockInt_150Hz
  );

  reg[14:0] cuenta  = 15'd0;     // Se sabe que el clock de base es de 4MHz, y que cada 
  parameter DIVISOR = 15'd26667; //display se quiere refrescar a 50Hz. Como son 3 displays,
                                 //entonces el clock debe ser de 150Hz. Para dividir de 4MHz
                                 //a 150Hz, se necesita un contador que llegue hasta
                                 //4MHz/150Hz=26667. Entonces, se usan 15 bits (2^15=32768).

  always@( posedge clockBase_4MHz )
  begin
    if( cuenta == (DIVISOR-1) )	// Si la cuenta es == a 26666, resetea la cuenta.
      cuenta <= 15'd0;
    else
      cuenta <= cuenta + 15'd1;	// El contador se aumenta en 1 por cada pulso de clockBase_4MHz.
    
    if( cuenta < (DIVISOR/2) )		// En este bloque if-else se genera el nuevo clock, dependiendo
      clockInt_150Hz <= 1'b1;		//del contador del bloque if-else anterior.
    else
      clockInt_150Hz <= 1'b0;
    
  end                           

endmodule

