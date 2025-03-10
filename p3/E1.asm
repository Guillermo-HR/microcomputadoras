processor 16f877 ; Indica la versión de procesador 
include <p16f877.inc> ; Incluye la librería de la versión del procesador 
org 0H ; Carga al vector de RESET la dirección de inicio 
goto inicio ; Saltamos a la etiqueta inicio

inicio: ; Definir rutina inicio
org 5H ; Dirección de inicio del programa del usuario 
bsf STATUS, RP0 ; Cambiar a bloque de memoria 1
bcf STATUS, RP1 ; Cambiar a bloque de memoria 1
movlw h'06' ; Configurar puerto A y E como E/S digitales
movwf ADCON1
movlw h'ff'
movwf TRISA ; Configurar puerto A como entrada
clrf TRISB ; Configar puerto B como salida
bcf STATUS, RP0 ; Cambiar a bloque de memoria 0

switch: ; Definir rutina switch
	btfsc PORTA,0 ; Verificar posición del switch
	goto encender ; Si A = 1 ir a rutina encender
	clrf PORTB ; Si A = 0 apagar los leds
	goto switch ; Volver a la rutina switch
	
encender: ; Definir rutina encender
	movlw h'ff'
	movwf PORTB ; Encender los leds
	goto switch ; Volver a la rutina switch
	
END ; Fin del programa