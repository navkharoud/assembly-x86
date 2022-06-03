;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment						; data segment. Keyword db means define byte. You can also define word (dw)
	db 3 dup(?)						;variables allocated/defined here
data	ends

									; stack segment
stack1  segment	stack 		
		db	100 dup(?)     			; This is the stack of 100 bytes
stack1  ends


code    segment
        assume  cs:code, ds:data, ss:stack1

start: 
									;Perform initialization 
		mov ax, data				;Put the starting address of the data segment into the ax register (must do this first)
		mov ds, ax					;Put the starting address of the data segment into the ds register (where it belongs)
		
		mov ax, stack1				;Put the starting address of the stack into the ax register (must do this first)
		mov ss, ax					;Put the starting address of the stack segment into the ss register (where it belongs)
;-------------------------------------------------------------------------------------------------------------------------------------------------------		
;****************** Write Code Here ******************

;This program takes in one char of input and echoes to the command line

mov	ah, 1h							; keyboard input subprogram
int	21h								; read character into al

mov bl, al							;Save char to bl, since int 21h will overwrite al

mov dl, 10							;Move line feed char to dl
mov ah, 2							;Print char subroutine
int 21h

mov dl, bl							;Copy char to dl to echo
int 21h								;Print char
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
	mov ah, 4ch 					;Set up code to specify return to dos
        int 21h						;Interrupt number 21 (Return control to dos prompt)

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------