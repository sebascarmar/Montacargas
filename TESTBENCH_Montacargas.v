`timescale 1 ms / 1 ns

////////////////////////////////////////////////////////////////////////////////
// Company:  Universidad Tecnológica Nacional - Facutlad Regional Córdoba
// Engineer: Carreño Marin, Sebastian
//
// Create Date:   12:12:00 11/26/2021
// Design Name:   Montacargas
// Module Name:   Z:/Simulaciones/Verilog/Montacargas_ProyectoFinalTDI/TESTBENCH_Montacargas.v
// Project Name:  Montacargas_ProyectoFinalTDI
// Target Device:  XC9575XL - VQ44
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Montacargas
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TESTBENCH_Montacargas;

  // Inputs
  reg clockBase_4MHz;
  reg reset;
  reg BotonPiso1;
  reg BotonPiso2;
  reg BotonPiso3;
  reg SensorPuertaCerrada;
  reg FinalCarreraPiso1;
  reg FinalCarreraPiso2;
  reg FinalCarreraPiso3;
  
  // Outputs
  wire [1:0] DriverMotor;
  wire [6:0] SieteSegmentos;
  wire [2:0] HabilitaDisplay;
  
  // Instantiate the Unit Under Test (UUT)
  Montacargas uut (
    .clockBase_4MHz(clockBase_4MHz), 
    .reset(reset), 
    .BotonPiso1(BotonPiso1), 
    .BotonPiso2(BotonPiso2), 
    .BotonPiso3(BotonPiso3), 
    .SensorPuertaCerrada(SensorPuertaCerrada), 
    .FinalCarreraPiso1(FinalCarreraPiso1), 
    .FinalCarreraPiso2(FinalCarreraPiso2), 
    .FinalCarreraPiso3(FinalCarreraPiso3), 
    .DriverMotor(DriverMotor), 
    .SieteSegmentos(SieteSegmentos), 
    .HabilitaDisplay(HabilitaDisplay)
  );

  // Simulación del clock.
  parameter PERIOD = 0.000250; //T=250ns , f=4MHz.
  always
  begin
    clockBase_4MHz = 1'b0;
    #(PERIOD/2) clockBase_4MHz = 1'b1;
    #(PERIOD/2);
  end
  
  initial
  begin
    // Initialize Inputs
    reset = 1;
    BotonPiso1 = 0;
    BotonPiso2 = 0;
    BotonPiso3 = 0;
    SensorPuertaCerrada = 1;
    FinalCarreraPiso1 = 0;
    FinalCarreraPiso2 = 0;
    FinalCarreraPiso3 = 0;
    #4000; //4s
    reset = 0;
    
    // Se activa el sensor FC1, ya que el estado inicial es BajarPiso1. Entonces, con esto, queda en 
    //Piso1.
    #10000; //10segundos
    FinalCarreraPiso1 = 1;
    
    
    
    // Se activa P3 para que proceda a subir.
    #4000; //4s
    BotonPiso3 = 1;
    FinalCarreraPiso1 = 0;
    #500; //500ms
    BotonPiso3 = 0;
    
    // Se activa el sensor FC2 para ver posibles errores. Dicho estímulo no debería obtener respuesta de la 
    //máquina. Luego, se activa el sensor FC3 para que quede en Piso3.
    #10000; //10segundos
    FinalCarreraPiso2 = 1;
    #1000; //1s
    FinalCarreraPiso2 = 0;
    #10000; //10segundos
    FinalCarreraPiso3 = 1;
    
    
    
    // Se espera 1 minuto en desuso estando en Piso3. Como la puerta permanece cerrada, 
    //pasará a bajar al Piso1. Luego se activa FC1 y queda quieto en Piso1.
    #60000;
    FinalCarreraPiso3 = 0;
    #10000; //10segundos
    FinalCarreraPiso1 = 1;
    
    
    
    // Se activa P2 para que suba a Piso2.
    #4000; //4s
    BotonPiso2 = 1;
    FinalCarreraPiso1 = 0;
    #500; //500ms
    BotonPiso2 = 0;
    
     // Se activa el sensor FC2 para que quede en P2, y se deja la puerta abierta (SPC=0).
    #10000; //10segundos
    FinalCarreraPiso2 = 1;//-------------------------->ta=124seg
    SensorPuertaCerrada = 0;  //SE ABRE LA PUERTA
    
    
    
    // Se espera 1 min en desuso para que proceda a ir al piso 1 CUANDO se cierra la puerta. Es decir, 
    //recién 10 seg después del minuto en desuso es que procede a bajar a Piso1, debido a que ahí es 
    //donde se cierra la puerta (SPC=1).
    #60000; //1minuto--------------------------------->ta=184seg
    #10000; //10segundos
    SensorPuertaCerrada = 1;  //SE CIERRA LA PUERTA--->ta=194
    FinalCarreraPiso2 = 0;
    
    // Se activa FC1 para que quede en Piso1. También se abre la puerta (SPC=0).
    #10000; //10segundos
    FinalCarreraPiso1 = 1;//-------------------------->ta=184seg
    SensorPuertaCerrada = 0; //SE ABRE LA PUERTA
    
    
    
    // Se activa P3, pero no responde porque la puerta está abierta. Luego, se cierra la puerta (SPC=1) y 
    //se presiona de nuevo P3, con lo cual, esta vez sí subirá a Piso3.
    #4000; //4s
    BotonPiso3 = 1;
    #500; //500ms
    BotonPiso3 = 0;
    #2000; //2s
    SensorPuertaCerrada = 1;  //SE CIERRA LA PUERTA
    #2000; //2s
    BotonPiso3 = 1;//--------------------------------->ta=212.5seg
    FinalCarreraPiso1 = 0;
    #500; //500ms
    BotonPiso3 = 0;
    
    // Se activa el FC2, ya que pasa por ahí el montacargas. No debe responder a dicho estimulo.
    //Luego se activa FC3 indicando que ya llegó a Piso3, y se abre la puerta (SPC=0).
    #10000; //10segundos
    FinalCarreraPiso2 = 1;
    #1000; //1s
    FinalCarreraPiso2 = 0;
    #10000; //10segundos
    FinalCarreraPiso3 = 1;//-------------------------->ta=234seg
    SensorPuertaCerrada = 0;  //SE ABRE LA PUERTA
    
    
    
    // Se hace permanecer 30 seg en total detenido en Piso3. En ese tramo se prueba presionar P2 con la puerta
    //abierta y no debe de responder a dicho estímulo. Luego, se cierra la puerta y se presiona P2 de nuevo.
    #4000; //4s
    BotonPiso2 = 1;
    #500; //500ms
    BotonPiso2 = 0;
    #21500; //21.5s
    SensorPuertaCerrada = 1;  //SE CIERRA LA PUERTA
    #4000; //4s
    BotonPiso2 = 1;//--------------------------------->ta=264seg
    FinalCarreraPiso3 = 0;
    #500; //500ms
    BotonPiso2 = 0;
    
    // Se activa FC2 indicando que ya llegó a Piso2, y se abre la puerta (SPC=0).
    #10000; //10segundos
    FinalCarreraPiso2 = 1;//-------------------------->ta=274.5seg
    SensorPuertaCerrada = 0;  //SE ABRE LA PUERTA
    
    
    
    // La idea es que permanezca un total de 30seg en Piso2. Se presiona P1 pero no responde porque la puerta 
    //está abierta. Luego, se cierra la puerta y nuevamentese se activa P1, con lo cual, procederá a BajarPiso1.
    #4000; //4s
    BotonPiso1 = 1;
    #500; //500ms
    BotonPiso1 = 0;
    #21500; //21.5s
    SensorPuertaCerrada = 1;  //SE CIERRA LA PUERTA
    #4000; //4s
    BotonPiso1 = 1;//--------------------------------->ta=304.5seg
    FinalCarreraPiso2 = 0;
    #500; //500ms
    BotonPiso1 = 0;
    
    // Finalmente, se activa FC1 para que quede en Piso1.
    #10000; //10segundos
    FinalCarreraPiso1 = 1;//-------------------------->ta=315seg
  
  	
  	
  	
  end

endmodule

