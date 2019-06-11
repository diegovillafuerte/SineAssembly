TITLE *MASM Template	(primer1.asm)*

; Descripcion:
; Mi primer programa.
; 
; Fecha de ultima modificacion:
; 05-oct-2018

INCLUDE \masm32\Irvine\Irvine32.inc
INCLUDE \masm32\Irvine\macros.inc

INCLUDELIB \masm32\Irvine\Irvine32.lib
includelib \masm32\Irvine\User32.lib
includelib \masm32\Irvine\Kernel32.lib

.DATA
contador DWord 0 ; Se usa como contador en la función eleva
primera DWORD ? ; Primera mitad del denomindador
segunda DWORD ? ; Primera mitad del numerador
auxiliar DWORD ? ; Auxiliar en el metodo factorial 
numerador REAL8 ? ; Para guardar el numerador antes de dividir
x REAL8 5.83 ; Esto es temporal en lo que funciona Write
k DWORD ? ; Es la K de la formula

.CODE
; Procedimiento principal
main PROC
    call Clrscr
    ; =============================== Bienvenida e input de usuario =====================================
    mWrite "Hola, bienvenida al programa!  "
    call Crlf
    mWrite "Si quieres obtener el valor de la funcion seno ingresando grados, ingresa el numero 1 "
    call Crlf
    mWrite "Si quieres obtener el valor de la funcion seno ingresando radianes, ingresa el numero 2 "
    call Crlf
    mWrite "Si quieres obtener una tabla de valores de la funcion seno, ingresa el numero 3 "
    call Crlf

    ; ============================== Llamada a la función eleva ======================================
    ; Le pasa en el stack de operación la potencia a la que se eleva y el valor base y la respuesta se pasan por el stack de FPU
    mov ebx, 4 ; Esto es la K (iteracion)
    mov k, ebx
    fld x
    fld x
    push ebx
    call eleva
    push k
    call checaParidad
    pop eax
    .IF eax == 1
        FCHS
    .ENDIF
    fst numerador ; Con esto ya tienes el numerador completo en la variable numerador
    call Crlf

    ; ============================== Llamada a la función factorial ======================================
    ; La llama con el valor que se pushea y regresa en primera la mitad menos significativa y en segunda la mitad más significativa
    push 18
    call factorial
    pop segunda
    pop primera
    
    exit
main ENDP
; Termina el procedimiento principal

; =============================== Procedimiento para elevar un número flotante a una potencia entera ===================================================
eleva PROC
; Recibe un flotante REAL8 y regresa la respuesta en el mismo formato. Comunicación a través del stack de ejecución de ida y del FPU de regreso 
; Receives: REAL8
; Returns: REAL8
; Requires: contador DWORD
;---------------------------------------------------------
    
    pop ecx ; Registro para regresar
    pop ebx ; K de la iteración
    mov eax, ebx
    mov edx, 2
    mul edx
    inc eax
    mov esi, eax ;  2k+1
    mov contador, 1
    .WHILE contador < esi
        fmul ST(0), ST(1)
    inc contador
    .ENDW 

    push ecx
    RET
eleva ENDP

; =============================== Procedimiento para saber si n es par ===================================================
checaParidad PROC
; Recibe un entero de 1 WORD y regresa 1 si es non o 0 si es par. Comunicación a través del stack   
; Receives: An unsinged integer in AL
; Returns: WORD
; Requires: Nothing
;---------------------------------------------------------
    pop ecx ; Dirección de regreso
    pop eax ; Palabra a evaluar
    test eax, 1
    mov ebx, 0
    JNZ target
    jmp fin
target:
    mov ebx, 1
fin:
    push ebx
    push ecx
RET
checaParidad ENDP

;============================== Procedimiento para calcular el factorial de un número menor o igual a 18 ===============
factorial PROC
; Pasa parametros a través del stack de ejecución
; Receives: entero
; Returns: BL = resultado
; Requires: Nothing
;---------------------------------------------------------
pop ecx ;Dirección
pop ebx ;Parametro


mov contador, 1
mov primera, 1
mov segunda, 0
.WHILE contador <= ebx
    ;mov eax, segunda
    ;call WriteInt
    mov eax, primera
    ;call WriteInt
    mul contador
    mov primera, eax
    jc hayCarry
    jmp noHubo
hayCarry:
    mov eax, segunda
    mov auxiliar, edx
    mul contador
    add auxiliar, eax
    mov edx, auxiliar
    mov segunda, edx
noHubo:
    inc contador
.ENDW


push primera ; Regresamos respuesta
push segunda
push ecx ; Regresamos dirección de retorno
RET
factorial ENDP


; Termina el area de Ensamble
END main