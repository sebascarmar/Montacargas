`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnológica Nacional - Facutlad Regional Córdoba
// Engineer: Carreño Marin, Sebastian
// 
// Create Date:    15:22:45 11/25/2021 
// Design Name: 
// Module Name:    contadorDetecta1minuto 
// Project Name:   MontacargasProyectoFinal
// Target Devices: 
// Tool versions: 
// Description:    Este contador trabaja con un reloj de 150Hz. La función que tiene es de contar hasta
//             1 minuto, acción necesaria para que el montacargas se vaya al piso 1 en caso de que se encuentre
//					dicho tiempo en desuso. 
//						 Si pensamos en un reloj de período 60 seg, entonces su frencuencia sería de 0.016Hz. Luego, 
//					dicha frecuencia se encuentra 150Hz/0.016Hz=9000 veces en el reloj de entrada. Entocnes, si el
//					contador inicia en 0, deberá contar hasta 8999, y con eso detectará el minuto en desuso.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module contadorDetecta1minuto(
    input  clockInt_150Hz,
	 input  iniciaCuenta,  // Esta señal también cumple la función de reset.
    output [13:0] cuenta
    );

												// Se parte sabiendo que el clock a usar es de 150Hz. Es necesario
	 reg[13:0] cuentaAux = 14'd0;		//detectar un periodo de 1 min, cuya frecuencia es f=0.016Hz. 
	 parameter DIVISOR = 14'd9000; 	// Para dividir el clock de 150Hz a 0.016Hz, se necesita un
												//contador que llegue hasta 150Hz/0.016Hz=9000. Entonces, se usan
												//14 bits (2^14=16384).
	
	always@( posedge clockInt_150Hz )begin	
		 
		if( iniciaCuenta == 1 ) begin	// Si iniciaCuenta==1, empieza a contar.
			cuentaAux <= cuentaAux + 14'd1;	// El contador se aumenta en 1 por cada pulso del clockInt_150Hz.
			if( cuentaAux == (DIVISOR-1) )	// Si la cuenta es == a 8999, resetea la cuenta.
				cuentaAux <= 14'd0;       
		end
		else begin							// Si iniciaCuenta==0, la cuenta no se inicia.
			cuentaAux <= 14'd0;
		end
	
	end // Fin de always. 
		
	assign cuenta = cuentaAux;	// Finalmente, la señal auxiliar que lleva la cuenta, se asigna a la señal de salida.

endmodule
