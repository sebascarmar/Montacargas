`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnológica Nacional - Facutlad Regional Córdoba
// Engineer: Carreño Marin, Sebastian
// 
// Create Date:    17:32:49 11/25/2021 
// Design Name: 
// Module Name:    Montacargas 
// Project Name: 	 MontacargasProyectoFinal
// Target Devices: 
// Tool versions: 
// Description: 	 Este es el módulo de mayor jerarquía del proyecto. En este se encuentran las instanciaciones
//					de todos los módulos creados bajo el principio de "divide y vencerás", haciendo así más legible
//					la descripción. 
//						 Cada módulo posee su descripción correspondiente que explica su función y/o cómo fueron 
//					ideados.
//						 El montacargas es de 3 pisos y posee tres displays (uno por piso) que muestra el piso actual
//					en el cual se encuentra el montacargas. Además de poseer los pulsadores y finales de carrera co-
//					rrespondientes (tres y tres), también cuenta con un sensor que detecta si la puerta del monta-
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
	 
	 wire [2:0] numeroDePiso; // Señal que toma el número de piso que sale de U1 (montacargas_SM), 
									  //y lo conecta a U2 para que sea decodificado a los 7 segmentos de 	
									  //los diplays.
	 wire clock150Hz;	// Señal que toma el reloj que sale de U3 (divisor de freq.) y lo envía a
							//U4 (contador anillo) y a U1 (montacargas_SM)
	
	// Instanciación del módulo de montacargas que posee la transición de los estados (entre otras)
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

	// Instanciación del módulo decodificar del número de piso a 7 segmentos.
	decoderDe3bitsA7segmentos	U2(
	 	 .pisoEnBinario(numeroDePiso), 
		 .display(SieteSegmentos) 
		 );
		 
	//	 Instanciación del módulo divisor de frencuencia. De aquí sale el relok interno de 150MHz.
	divisorDeFrecuenciaDe4MHzA150Hz	U3(
		 .clockBase_4MHz(clockBase_4MHz),
		 .clockInt_150Hz(clock150Hz)
		 );
	 
	 // Instanciación del módulo que habilita de a un display por vez (multiplexado).
	contadorAnillo3bits	U4(	 
		 .clockInt_150Hz(clock150Hz),   
		 .reset(reset),
		 .cuentaAnillo(HabilitaDisplay)
		 );
	 

endmodule
