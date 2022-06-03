;-------------------------------------------------------------------------------------------------------------------------------------------------------
.186 ;You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment											; data segment. Keyword db means define byte. You can also define word (dw)
			
;DECLARE VARIABLES AND RESERVE MEMORY HERE
		msg1 db 10,13'Enter a String : $'
		msg3 10,13,'The Reversed string is: '
		inputBuff db 16, 16 dup(?)
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
;****************** Write Instructions Here ******************	
	
	lea dx,msg1
	mov ah,9h
	int 21h
	
	lea dx,msg2
	mov ah,9h
	int 21h
	
	
	
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 					;Set up code to specify return to dos
        int 21h							;Interpt number 21 (Return control to dos prompt)		
;*****************************************************		

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



