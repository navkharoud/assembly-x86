;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment						; data segment. 
									;Keyword db means define byte. 
	myArray db 6 dup(?)				;You can also define word (dw)
	
data	ends

									; stack segment
stack1  segment	stack 		
		db	112 dup(?)     			; This is the stack of 100 bytes
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

;The following instructions takes in user input one char
;at a time, and stores them in the array of bytes, myArray

	mov bx, 0	;Initialize counter for loop
loopstart:
	mov ah, 1   ;Read char subroutine code
	int 21h		;Read char into al
	mov byte ptr [myArray+bx], al	;Compare al to the byte in myArray at index bx
	;Alternatively, use mov byte ptr myArray[bx], al
	
	inc bx		;update counter
	cmp bx, 6	;check exit condition (want 6 iterations)
jne loopstart	;if bx =/= 6, keep looping
				
				;otherwise we're done

;-------------------------------------------------------------------------------------------------------------------------------------------------------										
mov ah, 4ch 					;Set up code to specify return to dos
int 21h						;Interrupt number 21 (Return control to dos prompt)

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------