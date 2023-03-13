`timescale 1ms / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnológica Nacional - Facutlad Regional Córdoba
// Engineer: Carreño Marin, Sebastian
//
// Create Date:    09:27:22 11/26/2021
// Design Name:
// Module Name:    montacargas_StateMachine
// Project Name:
// Target Devices:
// Tool versions:
// Description:    En este módulo se encuentran las transiciones de la máquina de estados.
//    También se encuentra instanciado el contador que cuenta hasta 1 minuto, para así
//    detectar dicho tiempo en desuso y	proceder a descender a planta baja.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module montacargas_StateMachine(
  input            clockBase_4MHz,
  input            reset,
  input            P1,
  input            P2,
  input            P3,
  input            SPC,
  input            FC1,
  input            FC2,
  input            FC3,
  input            clockInt_150Hz,
  output reg [1:0] driverMotor,
  output reg [2:0] pisoEnBinario
);

  // Codificación de estados.
  parameter Piso1        = 3'b000;
  parameter SubirPiso2   = 3'b001;
  parameter Piso2        = 3'b010;
  parameter SubirPiso3   = 3'b011;
  parameter Piso3        = 3'b100;
  parameter BajarPiso2   = 3'b101;
  parameter BajarPiso1   = 3'b110;
  parameter CerrarPuerta = 3'b111;
  // Señal interna que aloja el estado actual
  reg [2:0] state = BajarPiso1;
	
	
/******* CONTADOR QUE CUENTA HASTA DETECTAR 1 MINUTO, CON EL USO DEL RELOJ DE 150MHz ********/
/*******************************************************************************************/ 
  wire [13:0] cuenta1Minuto;// Variable que aloja la cuenta (hasta 9000).
  reg iniciaCuenta1Minuto;  // Señal que habilita el inicio del contador.

  contadorDetecta1minuto  U0( // Instanciación del contador.
    .clockInt_150Hz(clockInt_150Hz),
    .iniciaCuenta(iniciaCuenta1Minuto),
    .cuenta(cuenta1Minuto)
  );
	
 
/**** PROCESO always EN EL CUAL SE ENCUENTRAN LAS TRANSICIONES DE ESTADOS DE LA MÁQUINA ****/
/*******************************************************************************************/ 
  always @( posedge clockBase_4MHz )
  begin
    if( reset )	// Si reset==1, se lleva la máquina a las condiciones iniciales.
    begin 
      if( SPC == 1 ) // Si la puerta está cerrada, procede a bajar al piso 1.
      begin 
        state <= BajarPiso1;
        // Asignación de salidas.
        iniciaCuenta1Minuto <= 0;		// Resetea el contador. 
        driverMotor   		  <= 2'b00;	// Motor en dirección de ascenso.
        pisoEnBinario		  <= 3'b000;// Todo apagado.
      end 
      else
      begin          // Si la puerta está abierta, transiciona al piso 1 (así no se mueve).
        
        state <= Piso1;
        // Asignación de salidas.
        iniciaCuenta1Minuto <= 0;		// Resetea el contador. 
        driverMotor   		  <= 2'b0;	// Motor en dirección de ascenso.
        pisoEnBinario		  <= 3'b000;// Todo apagado.
      end
    end
    else        // Si reset==0, la máquina de estado comienza su funcionamiento.
    begin
      case( state )// Sentencia case con todos los estados de la máquina.
        Piso1: //ESTADO 3'b000
        begin
          if( P2 & SPC )
            state <= SubirPiso2;
          else if( P3 & SPC )
            state <= SubirPiso3;
          else
            state <= Piso1;
          
          // Asignación de salidas.
          iniciaCuenta1Minuto <= 0; // No inicia la cuenta de 1 minuto porque está en P1.
          driverMotor         <= 2'b00;	// Motor apagado.
          pisoEnBinario       <= 3'b001;// Número 1 para decodificar en 7 segmentos.
         
        end				
        
        SubirPiso2: // ESTADO 3'b001.
        begin
          if( FC2 )
            state <= Piso2;
          else
            state <= SubirPiso2;
         
          //Asignación de salidas
          iniciaCuenta1Minuto <= 0; // No inicia la cuenta de 1 minuto porque está en mov. 
          driverMotor         <= 2'b01;	// Motor en dirección de ascenso.
          pisoEnBinario       <= 3'b000;// Display apagado.
         
        end				
        
        Piso2: // ESTADO 3'b010.
        begin
          if( cuenta1Minuto == 14'd8999 )
            state <= CerrarPuerta;
          else if( P3 & SPC )
            state <= SubirPiso3;
          else if( P1 & SPC )
            state <= BajarPiso1;
          else
            state <= Piso2;
          	
          //Asignación de salidas
          iniciaCuenta1Minuto <= 1; // Inicia la cuenta que detectará 1 minuto en desuso.
          driverMotor         <= 2'b00; // Motor apagado.
          pisoEnBinario       <= 3'b010;// Número 2 para decodificar en 7 segmentos.
          
        end
        
        SubirPiso3: // ESTADO 3'b011.
        begin
          if( FC3 )
            state <= Piso3;
          else
            state <= SubirPiso3;
          
          //Asignación de salidas
          iniciaCuenta1Minuto <= 0;// No inicia la cuenta de 1 minuto porque está en mov.
          driverMotor         <= 2'b01;	// Motor en dirección de ascenso.
          pisoEnBinario       <= 3'b000;// Display apagado.
          
        end
        
        Piso3: // ESTADO 3'b100.
        begin
          if( cuenta1Minuto == 14'd8999 )
            state <= CerrarPuerta;
          else if( P2 & SPC )
            state <= BajarPiso2;
          else if( P1 & SPC )
            state <= BajarPiso1;
          else
            state <= Piso3;
          		
          //Asignación de salidas
          iniciaCuenta1Minuto <= 1; // Inicia la cuenta que detectará 1 minuto en desuso.
          driverMotor         <= 2'b00;	// Motor apagado.
          pisoEnBinario       <= 3'b011;// Número 3 para decodificar en 7 segmentos.
          
        end
        
        BajarPiso2: // ESTADO 3'b101.
        begin
          if( FC2 )
            state <= Piso2;
          else
            state <= BajarPiso2;
          	
          //Asignación de salidas
          iniciaCuenta1Minuto <= 0;// No inicia la cuenta de 1 minuto porque está en mov.
          driverMotor         <= 2'b10;	 // Motor en dirección de descenso.
          pisoEnBinario       <= 3'b000; // Display apagado.
          
        end
        
        BajarPiso1: // ESTADO 3'b110.
        begin
          if( FC1 )
            state <= Piso1;
          else
            state <= BajarPiso1;
          	
          //Asignación de salidas
          iniciaCuenta1Minuto <= 0;// No inicia la cuenta de 1 minuto porque está en mov.
          driverMotor         <= 2'b10;	// Motor en dirección de descenso.
          pisoEnBinario       <= 3'b000;// Display apagado.
          
        end
        
        CerrarPuerta: // ESTADO 3'b111.
        begin
          if( SPC == 1 )
          begin
            state         <= BajarPiso1;
            pisoEnBinario <= 3'b000;// Display apagado.
          end
          else
          begin
            state         <= CerrarPuerta;
            pisoEnBinario <= 3'b111; // Combinación que representa la letra A en el deco.
          end
          
          //Asignación de salidas
          iniciaCuenta1Minuto <= 0;     // No inicia la cuenta de 1 minuto.
          driverMotor         <= 2'b00;	// Motor apagado.
          
        end
        
      endcase
     						
    end //Fin de else
    
  end //Fin de always



endmodule 

