`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnol�gica Nacional - Facutlad Regional C�rdoba
// Engineer: Carre�o Marin, Sebastian
// 
// Create Date:    17:08:38 11/25/2021 
// Design Name: 
// Module Name:    contadorAnillo3bits 
// Project Name:   MontacargasProyectoFinal
// Target Devices: 
// Tool versions: 
// Description: 	Este contador anillo permite multiplexar los 3 displays que utiliza la m�quina (uno por piso).
//					Por cada pulso de reloj (de freq. 150Hz), se habilita uno de los tres displays. Esto genera
//					que cada display se refresque a una frecuencia de 50Hz.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module contadorAnillo3bits(		// Contador utilizado para el multiplexado de los displays.  
    input 		clockInt_150Hz,   // Al ser 3 displays, cada uno se refrescar� a 50Hz.
    input 		reset,
    output reg [2:0] cuentaAnillo
    );
	 
	 always@( posedge clockInt_150Hz ) begin
		if( reset == 1 )
			cuentaAnillo <= 3'b100;			// Habilita display del piso 1.
		else
			case( cuentaAnillo )
				3'b100: 
					cuentaAnillo <= 3'b010; // Habilita display del piso 2.
				3'b010:
					cuentaAnillo <= 3'b001; // Habilita display del piso 3.
				3'b001:
					cuentaAnillo <= 3'b100; // Vuelve a habilita display del piso 1.
				default:
					cuentaAnillo <= 3'b100; // En caso de caer en estado desconoido, habilita al display del piso 1.
			endcase
		
	 end


endmodule
