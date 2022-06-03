;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment							; data segment. Keyword db means define byte. You can also define word (dw)
		tStr db 'Please enter a number between [0-255].',10,'$'
		num	db 1 dup(?)					;Store user input here
		iBuff db 4, 5 dup(?)
		oStr db 'The binary equivalent is:',10,'$'
		TEN db 10
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
		;This program takes in a number (0-255) and outputs the binary equivalent
		
		call get_int	;Get user input and store in dl num variable
		
		mov ah, 9		;Print string
		lea dx, oStr
		int 21h

		mov al, [num]   ;Restore user input to al
		mov cx, 8		;want 8 loop iterations later

	loopstart:
	
		test al, 1 	;test LSB for 1
		jz zerobit
		mov dx, 31h ;if 1, push character '1' to stack
		push dx
		shr al, 1	;shift right for new LSB
		loop loopstart
		jmp end1
	zerobit:
		mov dx, 30h	;if 0, push character '0' to stack
		push dx
		shr al, 1
		loop loopstart
	end1:	
		mov cx, 8	;new loop counter for displaying
		mov ah, 2 ;Display subroutine
loopstart2:
		pop dx	;pop characters off stack
		int 21h	;print characters
		loop loopstart2
		
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 					;Set up code to specify return to dos
        int 21h							;Interpt number 21 (Return control to dos prompt)

get_int	proc					
		mov ah, 9				;Specify print string DOS service routine
		lea dx, tStr			;Load pointer to string
		int 21h 				;Call DOS service routine
			
		mov ah, 0ah				;Prepare to call buffered keyboard input
		lea dx, iBuff			;Load the address of the buffer into iBuff
		int 21h					;Request service from OS
		
		mov ah, 2				;Specify print string DOS service routine
		mov dl, 10				;Load new line feed into dl
		int 21h 				;Call DOS service routine				
			
		lea si, iBuff			;Point to start of buffer
		inc si					;Point to # of chars
			
		mov ch, 0				;Clear ch for loop
		mov cl, [si]			;Get the number of characters read
			
		add si, cx				;Point si to end of buffer
			
		mov dl, 0				;Clear al to create number
		mov bl, 1				;Stores power of 10
							
gL1S:								;get_int loop1 start
		mov al, [si]			;Get digit 									
			
		sub al, 30h				;Convert to number
		mul bl					;Multiply by power of 10
		add dl, al				;Add to total
		mov al, bl				;Initialize X10 multiplication
		mul TEN					;Multiply by 10
		mov bl, al				;Store power of 10 back in bl
		dec si					;Decrement si
		loop gL1S				;Loop until cx == 0
				
		mov num, dl			;Store result in memory
							
		ret
get_int	endp		

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



