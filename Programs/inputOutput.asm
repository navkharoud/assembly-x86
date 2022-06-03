;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment							; data segment. Keyword db means define byte. You can also define word (dw)
		iNum	db  225			;Define variable called iNum (this variable is one byte)
		output1 db "Enter a string (max 20 chars.): ",13,10,'$' ;define output msg 1
		output2 db "The String you entered is: ",13,10,'$'		;define output msg 2
		inputBuf db 20,'?',20 dup('$')
data	ends

										; stack segment
stack1  segment	stack 		
		db	100 dup(?)      			; This is the stack of 100 bytes
stack1  ends


code    segment
        assume  cs:code, ds:data, ss:stack1

start: 
										;Perform initialization 
		mov ax, data					;Put the starting address of the data segment into the ax register (must do this first)
		mov ds, ax						;Put the starting address of the data segment into the ds register (where it belongs)
		
		mov ax, stack1					;Put the starting address of the stack into the ax register (must do this first)
		mov ss, ax						;Put the starting address of the stack segment into the ss register (where it belongs)
;-------------------------------------------------------------------------------------------------------------------------------------------------------		
;****************** Enter Assembly Code Below ******************
		lea dx,output1
		mov ah,9h 			;shows output1 on screen
		int 21h 

		mov ah,0ah 	
		lea dx, inputBuf	;loads the address of the string 
		int 21h
		
		lea dx,output2
		mov ah,09h			;output 2nd message
		int 21h

		lea dx,inputBuf
		mov ah,09h			;outputs entered string
		int 21h
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 					;Set up code to specify return to dos
        int 21h							;Interpt number 21 (Return control to dos prompt)

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



