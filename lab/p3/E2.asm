processor 16f877 ; Indica la versión de procesador 
include <p16f877.inc> ; Incluye la librería de la versión del procesador 

valor1 equ h'21' ; primer valor para el retardo
valor2 equ h'22' ; segundo valor para el retardo
valor3 equ h'23' ; tercer valor para el retardo
cte1 equ 20h ; primer constante para el retardo
cte2 equ 50h ; segunda constante para el retardo
cte3 equ 60h ; tercera constante para el retardo

org 0H ; Carga al vector de RESET la dirección de inicio 
goto inicio ; Saltamos a la etiqueta inicio

inicio: ; Definir rutina inicio
org 5H ; Dirección de inicio del programa del usuario 
bsf STATUS, RP0 ; Cambiar a bloque de memoria 1
bcf STATUS, RP1 ; Cambiar a bloque de memoria 1
movlw h'06' 
movwf ADCON1 ; Configurar los puertos A y E como digitales
movlw h'ff'
movwf TRISA ; Configurar puerto A como entrada
clrf TRISB ; Configar puerto B como salida
bcf STATUS, RP0 ; Cambiar a bloque de memoria 0

; Rutinas para validar el estado de los switches
switch: ; Definir rutina switch
	btfsc PORTA,2 ; Verificar el estado del 3 switch
	goto a10x ; si el 3 switch está en 1, ir a a10x
	goto a0xx ; si el 3 switch está en 0, ir a a0xx
	
a10x: ; Definir rutina a10x
	btfsc PORTA,0 ; Verificar el estado del 1 switch
	goto encenderApagar ; Ir a la rutina del caso 101
	goto ambosCorr ; Ir a la rutina del caso 100
	
a0xx: ; Definir rutina a0xx 
	btfsc PORTA,1 ; Verificar el estado del 2 switch
	goto a01x ; si el 2 switch está en 1, ir a a01x
	goto a00x ; si el 2 switch está en 0, ir a a00x
	
a01x: ; Definir rutina a01x
	btfsc PORTA,0 ; Verificar el estado del 1 switch
	goto corrIzq ; ir a la rutina del caso 011
	goto corrDer ; ir a la rutina del caso 010
	
a00x: , Definir rutina a00x
	btfsc PORTA,0 ; Verificar el estado del 1 switch
	goto encender ; ir a la rutina del caso 001
	goto apagar ; ir a la rutina del caso 000

; Rutinas para los casos de los switches	
apagar: ; definir rutina del caso 000
	call apagarFunc ; llamar a la función para apagar todos los leds
	goto switch ; regresar a la rutina switch
	
encender: ; definir rutina del caso 001
	call encenderFunc ; llamar a la función encender todos los leds
	goto switch ; regresar a la rutina switch

corrDer: ; definir rutina del caso 010
	call corrDerFunc ; llamar a la función para correr los leds a la derecha
	goto switch ; regresar a la rutina switch

corrIzq: ; definir rutina del caso 011
	call corrIzqFunc ; llamar a la función para correr los leds a la izquierda
	goto switch ; regresar a la rutina switch

ambosCorr: ; definir rutina del caso 100
	call corrDerFunc ; llamar a la función para correr los leds a la derecha
	call corrIzqFunc ; llamar a la función para correr los leds a la izquierda
	goto switch ; regresar a la rutina switch

encenderApagar: ; definir rutina del caso 101
	call encenderFunc ; llamar a la función encender todos los leds
	call retardo ; llamar a la función retardo
	call apagarFunc ; llamar a la función para apagar todos los leds
	call retardo ; llamar a la función retardo
	goto switch ; regresar a la rutina switch

; funciones basicas para cada secuencia
apagarFunc: ; definir funcion para apagar todos los leds
	clrf PORTB ; apagar todos los leds
	return ; regresar

encenderFunc: ; definir funcion para encender todos los leds
	movlw h'ff' 
	movwf PORTB ; encender todos los leds
	return ; regresar
	
corrDerFunc: ; definir funcion para correr los leds a la derecha
	clrf PORTB ; apagar todos los leds
	bsf PORTB,0 ; encender el led 0
	cicloDer: ; ciclo interno
		call retardo ; llamar a la función retardo
		rlf PORTB,1 ; rotar a la izquierda usando el carry
		btfss PORTB,7 ; verificar si el led 7 está encendido
		goto cicloDer ; si el led 7 esta apagado, regresar al ciclo interno
	call retardo ; llamar a la función retardo
	return ; regresar
	
corrIzqFunc: ; definir funcion para correr los leds a la izquierda
	clrf PORTB ; apagar todos los leds
	bsf PORTB, 7 ; encender el led 7
	cicloIzq: ; ciclo interno
		call retardo ; llamar a la función retardo
		rrf PORTB, 1 ; rotar a la derecha usando el carry
		btfss PORTB, 0 ; verificar si el led 0 está encendido
		goto cicloIzq ; si el led 0 esta apagado, regresar al ciclo interno
	call retardo ; llamar a la función retardo
	return ; regresar

; Función para el retardo
retardo: movlw cte1
	movwf valor1

tres: movlw cte2
	movwf valor2
	
dos: movlw cte3
	movwf valor3

uno: decfsz valor3
	goto uno
	decfsz valor2
	goto dos
	decfsz valor1
	goto tres
	return

	
END ; Fin del programa