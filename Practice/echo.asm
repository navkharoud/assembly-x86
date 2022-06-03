;-------------------------------------------------------------------------------------------------------------------------------------------------------
.186 ;You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment											; data segment. Keyword db means define byte. You can also define word (dw)
		buff db 11, 12 dup(?)	;Buffered string with 10 char input + carriage return
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
;This program echoes a buffered string entered by the user.

	lea dx, buff	;Accept user input for buffered string
	mov ah, 10
	int 21h
	
	lea si, buff	;Load address into si for indexing
	inc si			;Point si to count
	mov bl, [si]	;count is in bl
	mov bh, 0		;bh = 0, bx = count
	add si, bx		;si points to last char of buffered string
	inc si			;si points to carriage return
	mov byte ptr [si],'$'	;Overwrite byte with terminator
	
	;Now string is terminated properly, and we can print with subroutine 9
	
	mov ah, 2		;Print a new line with subroutine 2
	mov dl, 10
	int 21h
	
	
	lea dx, buff		;load address of buffered string
	add dx, 2			;point to first char to be printed
	mov ah, 9
	int 21h				;Print using subroutine 9
	
	
	;;;;;;;;;;;;;;;;;;;;;Exercises;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Try printing a specific character of the buffered string (4th char for example)
	;Try printing the buffered string in reverse
	
	;Advanced exercise
	;Try adding all number entries in the buffered string and output the result
	;For example: User enters 'aj5md3062b' --> output 5+3+0+6+2 = 16
	
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 		;Set up code to specify return to dos
        int 21h				;Interpt number 21 (Return control to dos prompt)
	
;*****************************************************		

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



