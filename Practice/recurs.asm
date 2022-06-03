;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment						; data segment. 
									;Keyword db means define byte. 
		TEN db 10							;You can also define word (dw)
		input db 'Input a number between 1-5',10,'$'
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

	;This program takes in a number between 1-5 and calculates the factorial
	;1! = 1, 2! = 2, 3! = 6, 4! = 24, 5! = 120.
	;Output in register ax

	lea dx, input	;Print the input string
	mov ah,9		;Using subroutine 9
	int 21h
	
	mov ah, 1		;Char read subroutine code
	int 21h			;Char read
	sub al, 30h		;Char--> num
	mov cl, al		;Set up fact proc
	
	mov ah,2		;Print new line
	mov dl, 10
	int 21h

	mov al, cl		;Set up fact proc. Al=cl=input number
	push cx			;Save cx because fact will overwrite
	call fact		;Procedure that calculates factorial
					;Input in al AND cl
					;Output in al
	pop cx			;Restore cx
	

;-------------------------------------------------------------------------------------------------------------------------------------------------------										
	mov ah, 4ch 					;Set up code to specify return to dos
        int 21h						;Interrupt number 21 (Return control to dos prompt)

		
;procedure to calculate factorial (up to 5!)
;Input: (cl,al, al=cl)
;Output: (al)
fact	proc				
								;initial al = n
		dec cl					;cl = n-1
		cmp cl, 0				;Stop when we hit zero
		je end1
		mul cl					;al = n*(n-1)

		call fact
	end1:
		ret						;return to main program, ax contains result
fact	endp		
		
code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------