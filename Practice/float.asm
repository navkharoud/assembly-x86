;-------------------------------------------------------------------------------------------------------------------------------------------------------
.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment						; data segment. 
		signbit db 1 dup (?)	;store sign	(+/-)
		E db 1 dup (?)			;Store E
		outp db 'This number is equal to $'	;string
		outp2 db '1.$'						;string
		outp3 db ' x 2^$'					;string
		TEN dw 10							;for mult/div
		ibuff db 17, 18 dup(?)				;Buffered string input (16-bit binary string)
		tstr db 'Enter a 16-bit normalized floating point binary number: $'	;string
		
		
data	ends

									; stack segment
stack1  segment	stack 		
		db	100 dup(?)     			; This is the stack of 100 bytes
stack1  ends


code    segment
        assume  cs:code, ds:data, ss:stack1

start: 
								;Perform initialization 
		mov ax, data			;Put the starting address of the data segment into the ax register (must do this first)
		mov ds, ax				;Put the starting address of the data segment into the ds register (where it belongs)
		mov ax, stack1			;Put the starting address of the stack into the ax register (must do this first)
		mov ss, ax				;Put the starting address of the stack segment into the ss register (where it belongs)
;-------------------------------------------------------------------------------------------------------------------------------------------------------		
;****************** Write Code Here ******************
	;16-bit FP with 7 exp bits and 8 frac bits
	;bias = 63
	
	call get_binary_int	;Accept 16-bit binary string from user
	
	test bx, 8000h		;Check if sign bit is 0
	jz zero				
	
	mov signbit, '-'	;If sign bit is 1, store negative sign in signbit
	jmp next

zero:
	mov signbit, '+'	;Otherwise, store '+'
next:
	
	and bh, 01111111b   ;bh = exp, bl = frac
	sub bh, 63			;bh = E (signed), bl holds frac
	mov E, bh

	mov ah, 9
	lea dx, outp		;Print outp string
	int 21h
	
	mov dl, signbit
	mov ah, 2			;Print sign bit
	int 21h
	
	lea dx, outp2		;Print outp2 string
	mov ah, 9
	int 21h
	
	mov cx,8			;8 loop counters	
	mov ah, 2			;prepare for printing frac
fracloop:
	rol bl, 1			;rotate bl by 1 bit
	test bl, 1			;test least significant bit for a 1
	jz zero2			
	mov dl, 31h			;If bit is a 1, print '1'
	int 21h				
	jmp next2
zero2:
	mov dl, 30h			;Otherwise, print '0'
	int 21h
next2:
	loop fracloop		;Loop over all 8 frac bits
	
	mov ah, 9
	lea dx, outp3		;Print string outp3
	int 21h
	
	mov dl, E			;E is a 8 bit signed integer
	test dl, 10000000b	;Test the sign bit
	jnz negexp			;If sign bit is nonzero, we have a negative exponent
	add dl, 30h			;Otherwise, treat as unsigned and print as normal
	mov ah, 2
	int 21h
	jmp done
negexp:
	mov bl, dl			;move to bl (negative 8-bit number)
	mov dl, '-'
	mov ah, 2			;Print '-'
	int 21h
	not bl 				;User shortcut conversion (flip all bits and add 1)
	inc bl				
	mov bh, 0			;Clear bh since print_int takes in 16-bit number
	call print_int		;Print exponent
done:

;-------------------------------------------------------------------------------------------------------------------------------------------------------										
	mov ah, 4ch 					;Set up code to specify return to dos
        int 21h						;Interrupt number 21 (Return control to dos prompt)

;procedure to get a binary 16-bit int from the user
;input: buffered string
;output: bx
get_binary_int	proc					
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
			
		mov dx, 0				;Clear al to create number
		mov bx, 1				;Stores power of 10
							
gL1S:								;get_int loop1 start
		mov al, [si]			;Get digit 									
			
		sub al, 30h				;Convert to number
		mov ah, 0
		push dx
		mul bx					;Multiply by power of 10
		pop dx
		add dx, ax				;Add to total
		shl bx,1				;Multiply bl by 2
		dec si					;Decrement si
		loop gL1S				;Loop until cx == 0
				
		mov bx, dx			;Store result in bx
							
		ret
get_binary_int	endp
		
;procedure that prints out an integer passed 
;Input (bx): unsigned 16-bit number for output
print_int proc

		mov dx, '$'				;Set up end of string
		push dx					;Put on stack to indicate finished
		mov ax, bx				;Prepare for 16-bit division. ax holds divisor
PLS1:			
		mov dx, 0				;Prepare for 16-bit division
		div ten					;Divide by 10 (dxax/10)
		;mov dl, ah				;Remainder = dx, quotient = ax
		push dx					;Store digit for output
		cmp ax, 0				;Check to see if we are done looping
		jne PLS1				
			
		mov ah, 2h				;Setup character output routine			
PLS2:					
		pop dx					;Get last character
		cmp dl, '$'				;Check to see if we are finished
		je pDone				;Exit loop if equal to $
		add dl, 30h				;Convert integer to character
		int 21h					;Call character output routine
		jmp PLS2				;Continue looping
			
pDone:
		ret
print_int endp		
		
code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------