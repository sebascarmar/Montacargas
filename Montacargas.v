`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnol�gica Nacional - Facutlad Regional C�rdoba
// Engineer: Carre�o Marin, Sebastian
// 
// Create Date:    17:32:49 11/25/2021 
// Design Name: 
// Module Name:    Montacargas 
// Project Name: 	 MontacargasProyectoFinal
// Target Devices: 
// Tool versions: 
// Description: 	 Este es el m�dulo de mayor jerarqu�a del proyecto. En este se encuentran las instanciaciones
//					de todos los m�dulos creados bajo el principio de "divide y vencer�s", haciendo as� m�s legible
//					la descripci�n. 
//						 Cada m�dulo posee su descripci�n correspondiente que explica su funci�n y/o c�mo fueron 
//					ideados.
//						 El montacargas es de 3 pisos y posee tres displays (uno por piso) que muestra el piso actual
//					en el cual se encuentra el montacargas. Adem�s de poseer los pulsadores y finales de carrera co-
//					rrespondientes (tres y tres), tambi�n cuenta con un sensor que detecta si la puerta del monta-
//					cargas se encuentra cerrada. Y, finalmente, si el montacargas se encuentra en el piso 2 o 3, y
//					durante un minuto se encuentra en desuso, procede a bajar al piso 1. 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Montacargas(
    input  clockBase_4MHz,
    input  reset,
    input  BotonPiso1,
    input  BotonPiso2,
    input  BotonPiso3,
	 input  SensorPuertaCerrada,
    input  FinalCarreraPiso1,
    input  FinalCarreraPiso2,
    input  FinalCarreraPiso3,
    output [1:0] DriverMotor,
	 output [6:0] SieteSegmentos,
	 output [2:0] HabilitaDisplay
    );
	 
	 wire [2:0] numeroDePiso; // Se�al que toma el n�mero de piso que sale de U1 (montacargas_SM), 
									  //y lo conecta a U2 para que sea decodificado a los 7 segmentos de 	
									  //los diplays.
	 wire clock150Hz;	// Se�al que toma el reloj que sale de U3 (divisor de freq.) y lo env�a a
							//U4 (contador anillo) y a U1 (montacargas_SM)
	
	// Instanciaci�n del m�dulo de montacargas que posee la transici�n de los estados (entre otras)
	montacargas_StateMachine	U1(
		 .clockBase_4MHz(clockBase_4MHz),
		 .reset(reset),
		 .P1(BotonPiso1),
		 .P2(BotonPiso2),
		 .P3(BotonPiso3),
		 .SPC(SensorPuertaCerrada),
		 .FC1(FinalCarreraPiso1),
		 .FC2(FinalCarreraPiso2),
		 .FC3(FinalCarreraPiso3),
		 .clockInt_150Hz(clock150Hz),
		 .driverMotor(DriverMotor),
		 .pisoEnBinario(numeroDePiso)
		 );

	// Instanciaci�n del m�dulo decodificar del n�mero de piso a 7 segmentos.
	decoderDe3bitsA7segmentos	U2(
	 	 .pisoEnBinario(numeroDePiso), 
		 .display(SieteSegmentos) 
		 );
		 
	//	 Instanciaci�n del m�dulo divisor de frencuencia. De aqu� sale el relok interno de 150MHz.
	divisorDeFrecuenciaDe4MHzA150Hz	U3(
		 .clockBase_4MHz(clockBase_4MHz),
		 .clockInt_150Hz(clock150Hz)
		 );
	 
	 // Instanciaci�n del m�dulo que habilita de a un display por vez (multiplexado).
	contadorAnillo3bits	U4(	 
		 .clockInt_150Hz(clock150Hz),   
		 .reset(reset),
		 .cuentaAnillo(HabilitaDisplay)
		 );
	 

endmodule
