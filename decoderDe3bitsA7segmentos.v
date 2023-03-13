`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnológica Nacional - Facutlad Regional Córdoba
// Engineer: Carreño Marin, Sebastian
//
// Create Date:    10:51:07 11/26/2021
// Design Name:
// Module Name:    decoderDe3bitsA7segmentos
// Project Name:   MontacargasProyectoFinal
// Target Devices:
// Tool versions:
// Description:    La función de este módulo es la de decodificar el número binario que
//    representa el piso en el cual se encuentra el montacargas. Este módulo decodifica a 
//    los 7 segmentos que poseen los displays utilizados.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module decoderDe3bitsA7segmentos(
  input      [2:0] pisoEnBinario, 
  output reg [6:0] display 
  );
		
  always @( pisoEnBinario )
  begin 
    case ( pisoEnBinario )
      3'b000 : display <= 7'b0000000; // Display apagado.
      3'b001 : display <= 7'b0110000; // Número 1 para 7 segmentos. 
      3'b010 : display <= 7'b1101101; // Número 2 para 7 segmentos.
      3'b011 : display <= 7'b1111001; // Número 2 para 7 segmentos.
      3'b111 : display <= 7'b1110111; // Letra A para 7 segmentos.
      default: display <= 7'b0000000; // Display apagado.
    endcase 
    
  end
endmodule

