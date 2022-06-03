;-------------------------------------------------------------------------------------------------------------------------------------------------------
.186 ;You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment											; data segment. Keyword db means define byte. You can also define word (dw)
		prompt db 'Please enter six 8-bit unsigned integers:',10,'$'
		outstr db 'The minimum value is: $'
		outstr2 db 'The maximum value is: $'
		iNum db 6 dup(?)	;Reserve space for input
		ten db 10			;For multiplication later
		iBuff db 4, 5 dup(?)	;Buffered string for user input
		max db 1 dup(?)			;store the max
		min db 1 dup(?)			;store the min
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
;****************** Write Code Here ******************	
	lea dx, prompt
	mov ah, 9
	int 21h	;print user prompt
	
	mov cx, 6	;set up loop to accept input
	mov bx, 0 	;index into iNum
loopstart:
	
	call get_int	;output in dl
	mov byte ptr iNum[bx], dl	;move number into data segment
	inc bx			;update index
	loop loopstart
	
	;All input gathered in array iNum
	
	;Start sorting
	mov bx, 4 		;loop counter
	mov al, iNum[4]	;first num in al
	mov ah, iNum[5]	;second num in ah
	
loop2:
	call sort	;larger number is in al after call
	mov max, al	;store larger in max
	mov ah, byte ptr iNum[bx-1]	;Move next number into ah for next comparison
	dec bx						;update counter
	jz	dloop2					;if bx = 0 then finish
	jmp loop2
dloop2:
	call sort	;larger number is in al after call
	mov max, al	;store larger in max
	
	mov bx, 4 		;loop counter
	mov al, iNum[4]	;first num in al
	mov ah, iNum[5]	;second num in ah
	
loop3:
	call sort					;smaller number is in ah after call
	mov min, ah					;store larger in max
	mov al, byte ptr iNum[bx-1]	;Move next number into al for next comparison
	dec bx						;update counter
	jz	dloop3					;if bx = 0 then finish
	jmp loop3
dloop3:
	
	call sort					;smaller number is in ah after call
	mov min, ah					;store larger in max

;Now max and min have been stored in data segment
	
	lea dx, outstr	;Print output string1
	mov ah, 9
	int 21h
	
	mov al, min		;Prepare minimum value for printing
	call print_int	;Print minimum value
	
	call newline	;Print new line
	
	lea dx, outstr2 	;Print output string2
	mov ah, 9
	int 21h
	
	mov al, max 	;Prepare max value for printing
	call print_int	;Print max value
	
	
	
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 		;Set up code to specify return to dos
        int 21h				;Interpt number 21 (Return control to dos prompt)

;----------------------------------------------------------
;Procedure that puts the larger number in al, smaller in ah
sort proc
;Input in al, ah
;Output in al, ah
	cmp al, ah
	jnc fin		;If no carry, al was bigger
	xchg al, ah	;Otherwise, swap al and ah
fin:	
	ret		
sort endp

;-----------------------------------------------------------		
newline proc
	;Procedure for printing a new line
	mov ah, 2
	mov dl, 10
	int 21h
	ret
newline endp

;procedure to read an integer 
;Input None:
;Output: dl
get_int	proc					
		push bx					;save bx
		push cx					;save cx
		
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
		mul ten					;Multiply by 10
		mov bl, al				;Store power of 10 back in bl
		dec si					;Decrement si
		loop gL1S				;Loop until cx == 0
			
		pop cx					;restore cx
		pop bx					;restore bx					
		ret
get_int	endp
;--------------------------------------------------------------------------------------------------------------------------------------------------		
;procedure that prints out an integer passed 
;Input (al): unsigned 8-bit number for output
print_int proc

		mov dx, '$'				;Set up end of string
		push dx					;Put on stack to indicate finished		
PLS1:			
		mov ah, 0				;Clear ah for division
		div ten					;Divide by 10
		mov dl, ah				;Store remainder in dl (putting in dl makes output easier below)
		push dx					;Store digit for output
		cmp al, 0				;Check to see if we are done looping
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
;*****************************************************		

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



